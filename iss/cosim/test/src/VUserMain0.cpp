/**************************************************************/
/* VUserMain0.cpp                            Date: 2021/08/02 */
/*                                                            */
/* Copyright (c) 2021 Simon Southwell. All rights reserved.   */
/*                                                            */
/**************************************************************/

#include <stdio.h>
#include <stdlib.h>

#include "VUserMain0.h"
#include "mem_vproc_api.h"
#include "rv32.h"

// I'm node 0
int node = 0;

static bool     vproc_interrupt_seen = false;

static uint32_t irq_state            = 0;

// ---------------------------------------------
// External memory map access
// callback function
// ---------------------------------------------

int ext_mem_access(const uint32_t addr, uint32_t& data, const int type, const rv32i_time_t time)
{
    int processed = 2;

    switch (type & MEM_NOT_DBG_MASK)
    {
    case MEM_RD_ACCESS_BYTE:
        data = read_byte(addr);
        break;
    case MEM_RD_ACCESS_HWORD:
        data = read_hword(addr);
        break;
    case MEM_RD_ACCESS_INSTR:
    case MEM_RD_ACCESS_WORD:
        data = read_word(addr);
        break;
    case MEM_WR_ACCESS_BYTE:
        write_byte(addr, data);
        break;
    case MEM_WR_ACCESS_HWORD:
        write_hword(addr, data);
        break;
    case MEM_WR_ACCESS_INSTR:
        // For instruction loads, write directly to memory
        WriteRamWord(addr, data, MEM_MODEL_DEFAULT_ENDIAN, MEM_MODEL_DEFAULT_NODE);
        break;
    case MEM_WR_ACCESS_WORD:
        write_word(addr, data);
        break;
    default:
        processed = RV32I_EXT_MEM_NOT_PROCESSED;
        break;
    }

    return processed;
}

// ---------------------------------------------
// Parse configuration file arguments
// ---------------------------------------------

int parseArgs(int argcIn, char** argvIn, rv32i_cfg_s &cfg, const int node)
{
    int    error = 0;
    int    c;
    int    argc = 0;
    char*  argvBuf[MAXARGS];
    char** argv = NULL;

    char*  argstr = NULL;
    size_t len = 0;
    char   delim[2];
    char   vusermainname[16];
    FILE*  fp;

    int returnVal  = 0;

    if (argcIn > 1)
    {
        argc = argcIn;
        argv = argvIn;
    }
    else
    {
        fp = fopen(CFGFILENAME, "r");
        if (fp == NULL)
        {
            printf("parseArgs: failed to open file %s\n", CFGFILENAME);
            returnVal = 1;
        }

        strcpy(delim, " ");
        sprintf(vusermainname, "vusermain%c", '0' + node);

        while (getline(&argstr, &len, fp) != -1)
        {
            char* name = strtok(argstr, delim);

            if (strcmp(name, vusermainname) == 0)
            {
                argvBuf[argc++] = name;
                break;
            }
        }

        fclose(fp);

        while((argvBuf[argc] = strtok(NULL, " ")) != NULL && argc < MAXARGS)
        {
            argc++;
        }

        argv = argvBuf;
    }

    // Parse the command line arguments and/or configuration file
    // Process the command line options *only* for the INI filename, as we
    // want the command line options to override the INI options
    while ((c = getopt(argc, argv, RV32I_GETOPT_ARG_STR)) != EOF)
    {
        switch (c)
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

// ---------------------------------------------
// Interrupt callback functions
// ---------------------------------------------

// Note: the VProc CB function can only be active when the main thread
// is stalled on a read, write or tick, so it is safe to modify shared
// variables. Also, it is not valid to make further VProc calls from
// this CB, but updating state here should instigate required functionality
// in the main program flow.
int vproc_user_callback(int val)
{
    vproc_interrupt_seen = val ? true : false;
}

// The ISS interrupt callback will return an interrupt when vproc_interrupt_seen
// is true, else it returns 0. The wakeup time in this model is always the next
// cycle. 
uint32_t iss_int_callback(const rv32i_time_t time, rv32i_time_t *wakeup_time)
{
    *wakeup_time = time + 1;
    
    return vproc_interrupt_seen ? 1 : 0;
}

// ---------------------------------------------
// Main entry point for node 0 VPRoc
// ---------------------------------------------

extern "C" void VUserMain0()
{
    rv32*         pCpu;
    rv32i_cfg_s   cfg;

    VPrint("\n*****************************\n");
    VPrint(  "*   Wyvern Semiconductors   *\n");
    VPrint(  "*  rv32_cpu ISS (on VProc)  *\n");
    VPrint(  "*     Copyright (c) 2021    *\n");
    VPrint(  "*****************************\n\n");

    VTick(20, node);

    // Parse arguments. As no argc and argv, pass in these as null, and it will look for
    // vusermain.cfg, which should have a single line with the command line options. If this
    // doesn't exist, no parsing is done.
    if (parseArgs(0, NULL, cfg, node))
    {
        VPrint("Error in parsing args\n");
    }
    else
    {

        // Create and configure the top level cpu object
        pCpu = new rv32(cfg.dbg_fp);

        // Register external memory callback function
        pCpu->register_ext_mem_callback(ext_mem_access);

        // Register ISS interrupt callback
        pCpu->register_int_callback(iss_int_callback);

        // Register VProc user callback, used to update irq status
        VRegUser(vproc_user_callback, node);

        // Load an executable
        if (!pCpu->read_elf(cfg.exec_fname))
        {
            // Run processor
            pCpu->run(cfg);

            if (pCpu->regi_val(10) || pCpu->regi_val(17) != 93)
            {
                VPrint("*FAIL*: exit code = 0x%08x finish code = 0x%08x running %s\n", pCpu->regi_val(10) >> 1, pCpu->regi_val(17), cfg.exec_fname);
            }
            else
            {
                VPrint("PASS: exit code = 0x%08x running %s\n", pCpu->regi_val(10), cfg.exec_fname);
            }
        }

        // Clean up
        if (cfg.dbg_fp != stdout)
        {
            fclose(cfg.dbg_fp);
        }
        delete pCpu;
    }

    VTick(20, node);

    // Halt simulation
    write_word(HALT_ADDR, 0);

    SLEEP_FOREVER;
}

