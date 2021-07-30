//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 28th June 2021
//
// Top level for the RISC-V ISS
//
// This file is part of the base RISC-V instruction set simulator
// (rv32i_cpu).
//
// This code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

// ------------------------------------------------
// INCLUDES
// ------------------------------------------------

#include <stdlib.h>

#if !defined _WIN32 && !defined _WIN64
#include <unistd.h>
#else 
extern "C" {
    extern int getopt(int nargc, char** nargv, const char* ostr);
    extern char* optarg;
}
#endif

#include "rv32.h"

// ------------------------------------------------
// DEFINES
// ------------------------------------------------

#define RV32I_GETOPT_ARG_STR               "hHdbrt:n:a:D:A:"
#define MEM_SIZE                           (1024*1024)
#define MEM_OFFSET                         0

// ------------------------------------------------
// LOCAL VARIABLES
// ------------------------------------------------

static uint8_t mem[MEM_SIZE+4];

// ------------------------------------------------
// TYPE DEFINITIONS
// ------------------------------------------------

// ------------------------------------------------
// FUNCTIONS
// ------------------------------------------------

// -------------------------------
// Parse command line arguments
//
int parse_args(int argc, char** argv, rv32i_cfg_s &cfg)
{
    int    option;

    int error = 0;


    // Parse the command line arguments and/or configuration file
    // Process the command line options *only* for the INI filename, as we
    // want the command line options to override the INI options
    while ((option = getopt(argc, argv, RV32I_GETOPT_ARG_STR)) != EOF)
    {
        switch (option)
        {
        case 't':
            cfg.exec_fname = optarg;
            break;
        case 'n':
            cfg.num_instr = atoi(optarg);
            break;
        case 'b':
            cfg.en_brk_on_addr = true;
            break;
        case 'A':
            cfg.brk_addr = strtol(optarg, NULL, 0);
            break;
        case 'r':
            cfg.rt_dis = true;
            break;
        case 'd':
            cfg.dis_en = true;
            break;
        case 'H':
            cfg.hlt_on_inst_err = true;
            break;
        case 'D':
            if ((cfg.dbg_fp = fopen(optarg, "wb")) == NULL)
            {
                fprintf(stderr, "**ERROR: unable to open specified debug file (%s) for writing.\n", optarg);
                error = 1;
            }
            break;
        case 'a':
            cfg.start_addr = atoi(optarg);
            break;
        case 'h':
        default:
            fprintf(stderr, "Usage: %s -t <test executable> [-hHbdrv][-n <num instructions>]\n      [-a <start addr>][-A <brk addr>][-D <debug o/p filename>]\n", argv[0]);
            fprintf(stderr, "   -t specify test executable (default test.exe)\n");
            fprintf(stderr, "   -n specify number of instructions to run (default 0, i.e. run until unimp)\n");
            fprintf(stderr, "   -a specify  address to start executing (default 0x00000000)\n");
            fprintf(stderr, "   -d Enable disassemble mode (default off)\n");
            fprintf(stderr, "   -r Enable run-time disassemble mode (default off. Overridden by -d)\n");
            fprintf(stderr, "   -H Halt on unimplemented instructions (default trap)\n");
            fprintf(stderr, "   -b Halt at a specific address (default off)\n");
            fprintf(stderr, "   -A Specify halt address if -b active (default 0x00000040)\n");
            fprintf(stderr, "   -D Specify file for debug output (default stdout)\n");
            fprintf(stderr, "   -h display this help message\n");
            error = 1;
            break;
        }
    }

    return error;
}

// -------------------------------
// External memory map access
// callback function
//
int ext_mem_access(const uint32_t byte_addr, uint32_t& data, const int type, const rv32i_time_t time)
{
    int processed = RV32I_EXT_MEM_NOT_PROCESSED;

    // If in bounds, access memory
    if (byte_addr >= MEM_OFFSET && byte_addr < (MEM_OFFSET + MEM_SIZE))
    {
        uint32_t addr = (byte_addr - MEM_OFFSET) % (MEM_SIZE);
        processed = 1;

        switch (type & MEM_NOT_DBG_MASK)
        {
        case MEM_RD_ACCESS_BYTE:
            data = mem[addr];
            break;
        case MEM_RD_ACCESS_HWORD:
            data = (mem[addr + 0] << 0) | (mem[addr + 1] << 8);
            break;
        case MEM_RD_ACCESS_INSTR:
        case MEM_RD_ACCESS_WORD:
            data = (mem[addr + 0] << 0) | (mem[addr + 1] << 8) | (mem[addr + 2] << 16) | (mem[addr + 3] << 24);
            break;
        case MEM_WR_ACCESS_BYTE:
            mem[addr]     = data;
            break;
        case MEM_WR_ACCESS_HWORD:
            mem[addr + 0] = (data >> 0);
            mem[addr + 1] = (data >> 8);
            break;
        case MEM_WR_ACCESS_INSTR:
        case MEM_WR_ACCESS_WORD:
            mem[addr + 0] = (data >>  0);
            mem[addr + 1] = (data >>  8);
            mem[addr + 2] = (data >> 16);
            mem[addr + 3] = (data >> 24);
            break;
        default:
            processed = RV32I_EXT_MEM_NOT_PROCESSED;
            break;
        }
    }

    return processed;
}

// -------------------------------
// MAIN
//
int main(int argc, char** argv)
{
    int         error = 0;

    rv32*         pCpu;
    rv32i_cfg_s   cfg;
    
    // Process command line arguments
    if (!(error = parse_args(argc, argv, cfg)))
    {
        // Create and configure the top level cpu object
        pCpu = new rv32(cfg.dbg_fp);

        // Register external memory callback function
        pCpu->register_ext_mem_callback(ext_mem_access);

        // Load an executable
        pCpu->read_elf(cfg.exec_fname);

        // Run processor
        pCpu->run(cfg);

#ifdef RV32_DEBUG
        for (int idx = 0; idx < RV32I_NUM_OF_REGISTERS; idx++)
        {
            printf("%sx%d=0x%08x\n", (idx <10) ? " " : "", idx, pCpu->regi_val(idx));
        }

        printf(" pc=0x%08x\n", pCpu->pc_val());
#endif

        // Print result
        if (pCpu->regi_val(10) || pCpu->regi_val(17) != 93)
        {
            printf("\n*FAIL*: exit code = 0x%08x finish code = 0x%08x\n", pCpu->regi_val(10) >> 1, pCpu->regi_val(17));
        }
        else
        {
            printf("\nPASS: exit code = 0x%08x\n", pCpu->regi_val(10));
        }

        // Clean up
        if (cfg.dbg_fp != stdout)
        {
            fclose(cfg.dbg_fp);
        }
        delete pCpu;
    }

    return error;
}
