/**************************************************************/
/* VUserMain0.cpp                            Date: 2021/08/02 */
/*                                                            */
/* Copyright (c) 2021 - 2025 Simon Southwell.                 */
/* All rights reserved.                                       */
/*                                                            */
/**************************************************************/

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "VUserMain0.h"
#include "mem_vproc_api.h"
#include "rv32.h"
#include "rv32i_cpu.h"
#include "rv32_cpu_gdb.h"

int                    node           = -1;

static const int       strbufsize     = 256;

static uint32_t        sw_irq_addr    = 0xafffffff;
static uint32_t        irq_state      = 0;
static uint32_t        swirq          = 0;
static bool            load_binary    = false;
static uint32_t        bin_load_addr  = 0x00000000;

static char            argstr[strbufsize];
static char            execstr[strbufsize];

// For windows, defined getopt externals
#if defined _WIN32 || defined _WIN64
extern "C" {
    extern int getopt(int nargc, char** nargv, const char* ostr);
    extern char* optarg;
}
#endif

// ---------------------------------------------
// External memory map access
// callback function
// ---------------------------------------------

int ext_mem_access(const uint32_t addr, uint32_t& data, const int type, const rv32i_time_t time)
{
    int       processed             = 2; // default to two cycles for an access
    const int write_wait_cycle      = 0;

    // Accessing the software interrupt
    if (addr == sw_irq_addr)
    {
        swirq     = (data & 0x1) << 2;
        processed = write_wait_cycle;
    }
    else
    {
        switch (type & MEM_NOT_DBG_MASK)
        {
        case MEM_RD_ACCESS_BYTE:
            data = read_byte(addr);
            break;
        case MEM_RD_ACCESS_HWORD:
            data = read_hword(addr);
            break;
        case MEM_RD_ACCESS_INSTR:
            data = read_instr(addr);
            break;
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

    char   argstr[strbufsize];
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

        while (fgets(argstr, strbufsize, fp) != NULL)
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
            unsigned lastchar = argvBuf[argc][strlen(argvBuf[argc])-1];

            // If last character is CR or LF, delete it
            if (lastchar == '\r' || lastchar == '\n')
            {
                argvBuf[argc][strlen(argvBuf[argc])-1] = 0;
            }

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
            strncpy(execstr, optarg, strbufsize);
            cfg.exec_fname             = execstr;
            cfg.user_fname             = true;
            break;
        case 'B':
            load_binary                = true;
            break;
        case 'L':
            bin_load_addr              = strtol(optarg, NULL, 0);
            break;
        case 'n':
            cfg.num_instr              = atoi(optarg);
            break;
        case 'b':
            cfg.en_brk_on_addr         = true;
            break;
        case 'A':
            cfg.brk_addr               = strtol(optarg, NULL, 0);
            break;
        case 'r':
            cfg.rt_dis                 = true;
            break;
        case 'd':
            cfg.dis_en                 = true;
            break;
        case 'H':
            cfg.hlt_on_inst_err        = true;
            break;
        case 'e':
            cfg.hlt_on_ecall           = true;
            break;
        case 'E':
            cfg.hlt_on_ebreak          = true;
            break;
        case 'D':
            if ((cfg.dbg_fp = fopen(optarg, "wb")) == NULL)
            {
                fprintf(stderr, "**ERROR: unable to open specified debug file (%s) for writing.\n", optarg);
                error = 1;
            }
            break;
        case 'g':
            cfg.gdb_mode = true;
            break;
        case 'p':
            cfg.gdb_ip_portnum         = strtol(optarg, NULL, 0);
            break;
        case 'S':
            cfg.update_rst_vec         = true;
            cfg.new_rst_vec            = strtol(optarg, NULL, 0);
            break;
        case 'C':
            cfg.use_cycles_for_mtime   = true;
            break;
        case 'a':
            cfg.abi_en = true;
            break;
        case 'T':
            cfg.use_external_timer     = true;
            break;
        case 'R':
            cfg.dump_regs              = true;
            break;
        case 'c':
            cfg.dump_csrs              = true;
            break;
        case 's':
            sw_irq_addr                = strtol(optarg, NULL, 0);
            break;
        case 'h':
        default:
            fprintf(stderr, "Usage: %s -t <test executable> [-hHeEbdrgcRTaCB][-n <num instructions>]\n      [-L <load addr>][-S <start addr>][-A <brk addr>][-D <debug o/p filename>][-p <port num>][-s <addr>]\n", argv[0]);
            fprintf(stderr, "   -t specify test executable (default test.exe)\n");
            fprintf(stderr, "   -B specify to load a raw binary file (default load ELF executable)\n");
            fprintf(stderr, "   -L specify address to load binary, if -B specified (default 0x00000000)\n");
            fprintf(stderr, "   -n specify number of instructions to run (default 0, i.e. run until unimp)\n");
            fprintf(stderr, "   -d Enable disassemble mode (default off)\n");
            fprintf(stderr, "   -r Enable run-time disassemble mode (default off. Overridden by -d)\n");
            fprintf(stderr, "   -C Use cycle count for internal mtime timer (default real-time)\n");
            fprintf(stderr, "   -a display ABI register names when disassembling (default x names)\n");
            fprintf(stderr, "   -T Use external memory mapped timer model (default internal)\n");
            fprintf(stderr, "   -H Halt on unimplemented instructions (default trap)\n");
            fprintf(stderr, "   -e Halt on ecall instruction (default trap)\n");
            fprintf(stderr, "   -E Halt on ebreak instruction (default trap)\n");
            fprintf(stderr, "   -b Halt at a specific address (default off)\n");
            fprintf(stderr, "   -A Specify halt address if -b active (default 0x00000040)\n");
            fprintf(stderr, "   -D Specify file for debug output (default stdout)\n");
            fprintf(stderr, "   -s Specify a software interrupt address (default = 0xafffffff)\n");
            fprintf(stderr, "   -R Dump x0 to x31 on exit (default no dump)\n");
            fprintf(stderr, "   -c Dump CSR registers on exit (default no dump)\n");
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

// ---------------------------------------------
// Interrupt callback functions
// ---------------------------------------------

// Note: the VProc CB function can only be active when the main thread
// is stalled on a read, write or tick, so it is safe to modify shared
// variables. Also, it is not valid to make further VProc calls from
// this CB, but updating state here should instigate required functionality
// in the main program flow.
int vproc_irq_callback(int val)
{
    irq_state = val;

    return 0;
}

// The ISS interrupt callback will return an interrupt when irq_state
// is non-zero. The wakeup time in this model is always the next
// cycle.
uint32_t iss_int_callback(const rv32i_time_t time, rv32i_time_t *wakeup_time)
{
    // Sample the swirq state
    uint32_t sw_interrupt = swirq;

    // Clear the pending swirq
    swirq                 = 0;

    *wakeup_time          = time + 1;


    return irq_state | sw_interrupt;
}

// ---------------------------------------------
// Main entry point for node 0 VPRoc
// ---------------------------------------------

extern "C" void VUserMain0 (uint32_t nodenum)
{
    rv32*         pCpu;
    rv32i_cfg_s   cfg;
    int           error = 0;

    VPrint("\n*****************************\n");
    VPrint(  "*   Wyvern Semiconductors   *\n");
    VPrint(  "*  rv32_cpu ISS (on VProc)  *\n");
    VPrint(  "*     Copyright (c) 2025    *\n");
    VPrint(  "*****************************\n\n");
    
    node = nodenum;

    // Initialise memory mode with node number
    init_mem(node);

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

        // Register VProc user callback, used to update IRQ state
        VRegIrq(vproc_irq_callback, node);
        

        // If GDB mode, pass execution to the remote GDB interface
        if (cfg.gdb_mode)
        {
#ifdef __WIN32__
            WORD versionWanted = MAKEWORD(1, 1);
            WSADATA wsaData;
            WSAStartup(versionWanted, &wsaData);
#endif

            // Load an executable if specified on the command line
            if (cfg.user_fname)
            {
                // Load the specified ELF file to memory
                if (!load_binary)
                {
                    if (pCpu->read_elf(cfg.exec_fname))
                    {
                        error++;
                    }
                }
                else
                {
                    // Load the specified binary to memory
                    if (pCpu->read_binary(cfg.exec_fname, bin_load_addr))
                    {
                        error++;
                    }
                }
            }

            if (!error)
            {
                // Start processing commands from GDB
                if (rv32gdb_process_gdb(pCpu, cfg.gdb_ip_portnum, cfg))
                {
                    fprintf(stderr, "***ERROR in opening PTY\n");
                }
            }

#ifdef __WIN32__
            WSACleanup;
#endif
        }
        else
        {
            // Load an executable
            if (!load_binary)
            {
                // Load an ELF file to memory
                if (pCpu->read_elf(cfg.exec_fname))
                {
                    error++;
                }
            }
            else
            {
                // Load a binary to memory
                if (pCpu->read_binary(cfg.exec_fname, bin_load_addr))
                {
                    error++;
                }
            }

            // Run the model
            if (!error)
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

