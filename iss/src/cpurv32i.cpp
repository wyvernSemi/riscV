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
# undef   UNICODE
# define  WIN32_LEAN_AND_MEAN

# include <windows.h>
# include <winsock2.h>
# include <ws2tcpip.h>

extern "C" {

    extern int getopt(int nargc, char** nargv, const char* ostr);
    extern char* optarg;
}
#endif

extern "C" {
#include "mem.h"
}

#include "rv32.h"
#include "rv32i_cpu.h"
#include "rv32_cpu_gdb.h"
#include "uart.h"

// ------------------------------------------------
// DEFINES
// ------------------------------------------------

#define RV32I_GETOPT_ARG_STR               "hHgdbert:n:D:A:p:S:xm:M:"

#define INT_ADDR                           0xaffffffc
#define UART0_BASE_ADDR                    0x80000000

// ------------------------------------------------
// LOCAL VARIABLES
// ------------------------------------------------

static uint32_t swirq = 0;

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
            cfg.user_fname = true;
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
            cfg.dis_en          = true;
            cfg.hlt_on_inst_err = true;
            break;
        case 'H':
            cfg.hlt_on_inst_err = true;
            break;
        case 'e':
            cfg.hlt_on_ecall = true;
            break;
        case 'D':
            if ((cfg.dbg_fp = fopen(optarg, "wb")) == NULL)
            {
                fprintf(stderr, "**ERROR: unable to open specified debug file (%s) for writing.\n", optarg);
                error = 1;
            }
            break;
        case 'x':
            cfg.dump_regs = true;
            break;
        case 'm':
            cfg.num_mem_dump_words = atoi(optarg);
            break;
        case 'M':
            cfg.mem_dump_start = atoi(optarg);
            break;
        case 'g':
            cfg.gdb_mode = true;
            break;
        case 'p':
            cfg.gdb_ip_portnum = strtol(optarg, NULL, 0);
            break;
        case 'S':
            cfg.update_rst_vec = true;
            cfg.new_rst_vec    = strtol(optarg, NULL, 0);
            break;
        case 'h':
        default:
            fprintf(stderr, "Usage: %s [-hHebdrgx][-t <test executable>][-n <num instructions>]\n", argv[0]);
            fprintf(stderr, "      [-S <start addr>][-A <brk addr>][-D <debug o / p filename>][-p <port num>][-m <num words>][-M <addr>]\n");
            fprintf(stderr, "   -t specify test executable (default test.exe)\n");
            fprintf(stderr, "   -n specify number of instructions to run (default 0, i.e. run until unimp)\n");
            fprintf(stderr, "   -d Enable disassemble mode (default off)\n");
            fprintf(stderr, "   -r Enable run-time disassemble mode (default off. Overridden by -d)\n");
            fprintf(stderr, "   -H Halt on unimplemented instructions (default trap)\n");
            fprintf(stderr, "   -e Halt on ecall/ebreak instruction (default trap)\n");
            fprintf(stderr, "   -b Halt at a specific address (default off)\n");
            fprintf(stderr, "   -A Specify halt address if -b active (default 0x00000040)\n");
            fprintf(stderr, "   -D Specify file for debug output (default stdout)\n");
            fprintf(stderr, "   -x Dump x0 to x31 on exit (default no dump)\n");
            fprintf(stderr, "   -m Dump specified number of 32 bit words from data memory on exit (default 0)\n");
            fprintf(stderr, "   -M Start byte address of memory dump (default 0x1000)\n");
            fprintf(stderr, "   -g Enable remote gdb mode (default disabled)\n");
            fprintf(stderr, "   -p Specify remote GDB port number (default 49152)\n");
            fprintf(stderr, "   -S Specify start address (default 0)\n");
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
    // By default, the processed variable indicates that this callback did not
    // process the access (a negatiave value). Otherwise it is the additional
    // access wait states (0 upwards). In this model, writes have no wait states,
    // whilst reads have 2 wait states.
    int processed = RV32I_EXT_MEM_NOT_PROCESSED;

    // If accessing the UART addresses then process here
    if ((byte_addr & UART_REG_ADDR_MASK) == UART0_BASE_ADDR)
    {
        processed = 0;
        // If writing to the UART registers, call the model's write function
        if (type == MEM_WR_ACCESS_BYTE || type == MEM_WR_ACCESS_HWORD || type == MEM_WR_ACCESS_WORD)
        {
            uart_write(byte_addr & 0x3, data & 0xff);
        }
        else if (type == MEM_RD_ACCESS_BYTE || type == MEM_RD_ACCESS_HWORD || type == MEM_RD_ACCESS_WORD)
        {
            uint32_t rxdata;
            uart_read(byte_addr & 0x3, &rxdata);
            data = rxdata;
        }
    }
    // If not interrupt address, access memory model
    else if (byte_addr != INT_ADDR)
    {
        uint32_t addr = byte_addr;
        processed = 0;

        switch (type & MEM_NOT_DBG_MASK)
        {
        case MEM_RD_ACCESS_BYTE:
            data = ReadRamByte(addr, 0);
            processed = 2;
            break;
        case MEM_RD_ACCESS_HWORD:
            data = ReadRamHWord(addr, true, 0);
            processed = 2;
            break;
        case MEM_RD_ACCESS_WORD:
            processed = 2;
        case MEM_RD_ACCESS_INSTR:
            data = ReadRamWord(addr, true, 0);
            break;
        case MEM_WR_ACCESS_BYTE:
            WriteRamByte(addr, data, 0);
            break;
        case MEM_WR_ACCESS_HWORD:
            WriteRamHWord(addr, data, true, 0);
            break;
        case MEM_WR_ACCESS_INSTR:
        case MEM_WR_ACCESS_WORD:
            WriteRamWord(addr, data, true, 0);
            break;
        default:
            processed = RV32I_EXT_MEM_NOT_PROCESSED;
            break;
        }
    }
    else if ((type & MEM_NOT_DBG_MASK) == MEM_WR_ACCESS_WORD && byte_addr == INT_ADDR)
    {
        swirq       = data & 0x1;
        processed = 0;
    }

    return processed;
}

// ------------------------------
// Interrupt callback function
//
uint32_t interrupt_callback(const rv32i_time_t time, rv32i_time_t *wakeup_time)
{
    bool terminate;

    *wakeup_time = time + 1;
    
    bool uart_irq = uart_tick(time, terminate, true);

    return swirq | (uart_irq ? 1 : 0);
}

// -------------------------------
// Dump registers
//

void reg_dump(rv32* pCpu, FILE* dfp)
{
    fprintf(dfp, "\nRegister state:\n\n  ");
    for (int idx = 0; idx < RV32I_NUM_OF_REGISTERS; idx++)
    {
        uint32_t rval = pCpu->regi_val(idx);
        fprintf(dfp, "x%d%s = 0x%08x  ", idx, (idx < 10) ? " " : "", rval);
        if ((idx % 4) == 3)
        {
            fprintf(dfp, "\n  ");
        }
    }
    fprintf(dfp, "\n");
}

// -------------------------------
// Dump memory
//

void mem_dump(uint32_t num, uint32_t start, rv32* pCpu, FILE* dfp)
{
    bool fault;

    fprintf(dfp, "\nMEM state:\n\n");
    for (uint32_t idx = start; idx < ((start & 0xfffffffc) + num*4); idx+=4)
    {
        uint32_t rval = pCpu->read_mem(idx, MEM_RD_ACCESS_WORD, fault);
        fprintf(dfp, "  0x%08x : 0x%08x\n", idx, rval);
    }
    fprintf(dfp, "\n");
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

        // Register interrupt callback function
        pCpu->register_int_callback(interrupt_callback);

        // If GDB mode, pass execution to the remote GDB interface
        if (cfg.gdb_mode)
        {
            // Load an executable if specified on the command line
            if (cfg.user_fname)
            {
                if (pCpu->read_elf(cfg.exec_fname))
                {
                    error = 1;
                }
            }

            if (!error)
            {
                // Start procssing commands from GDB
                if (rv32gdb_process_gdb(pCpu, cfg.gdb_ip_portnum, cfg))
                {
                    fprintf(stderr, "***ERROR in opening PTY\n");
                    return PTY_ERROR;
                }
            }
        }
        else
        {
            // Load an executable
            if (pCpu->read_elf(cfg.exec_fname))
            {
                error = 1;
            }
            else
            {
                // Run processor
                pCpu->run(cfg);

#ifdef RV32_DEBUG
                for (int idx = 0; idx < RV32I_NUM_OF_REGISTERS; idx++)
                {
                    printf("%sx%d=0x%08x\n", (idx < 10) ? " " : "", idx, pCpu->regi_val(idx));
                }

                printf(" pc=0x%08x\n", pCpu->pc_val());
#endif
                // If enabled, dump the registers
                if (cfg.dump_regs)
                {
                    reg_dump(pCpu, cfg.dbg_fp);
                }

                // If specified dump the numbr of DMEM words
                if (cfg.num_mem_dump_words)
                {
                    mem_dump(cfg.num_mem_dump_words, cfg.mem_dump_start, pCpu, cfg.dbg_fp);
                }

                // Print result
                if (!cfg.dis_en)
                {
                    if (pCpu->regi_val(10) || pCpu->regi_val(17) != 93)
                    {
                        printf("\n*FAIL*: exit code = 0x%08x finish code = 0x%08x\n", pCpu->regi_val(10) >> 1, pCpu->regi_val(17));
                    }
                    else
                    {
                        printf("\nPASS: exit code = 0x%08x\n", pCpu->regi_val(10));
                    }
                }
            }
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
