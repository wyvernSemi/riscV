//=============================================================
// 
// Copyright (c) 2017 Simon Southwell
//
// Date: 13th September 2021
//
//
// This file is part of the rv32_cpu instruction set simulator.
//
// This is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// It is is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#include <stdio.h>

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <stdint.h>
#include <string.h>

#include "rv32i_cpu_elf.h"

// -------------------------------------------------------------------------
// STATIC VARIABLES
// -------------------------------------------------------------------------

static int      byte_count = 0;
static uint32_t last_addr  = -1;
static bool     hdr_op     = false;

// -------------------------------------------------------------------------
// output_verilog_hex()
// -------------------------------------------------------------------------

static void output_verilog_mif (const uint32_t byte_addr, const uint32_t word, FILE* op_fp)
{
    // If first byte, output a header
    if (!hdr_op)
    {
        fprintf(op_fp, "DEPTH = 4096;\n");
        fprintf(op_fp, "WIDTH = 32;\n");
        fprintf(op_fp, "ADDRESS_RADIX = HEX;\n");
        fprintf(op_fp, "DATA_RADIX = HEX;\n");
        fprintf(op_fp, "CONTENT\nBEGIN\n");
        
        hdr_op = true;
        byte_count = 0;
    }
    
    // Remember the last address output
    last_addr = byte_addr;
    
    // Print out the word as a series of 4 bytes (little endian)
    fprintf(op_fp, "%03x : %02X%02X%02X%02X ", byte_addr>>2, (word >> 24) & 0xff, (word >> 16) & 0xff, (word >> 8) & 0xff, (word >> 0) & 0xff);
    
    // Keep track of the number of bytes in the present row
    byte_count += 4;
    
    // If 4 bytes output, output a new line and reset the row byte count,
    // otherwise output a space seperator.
    if (byte_count == 4)
    {
        fprintf(op_fp, ";\n");
        byte_count = 0;
    }
    else
    {
        fprintf(op_fp, " ");
    }
}

// -------------------------------------------------------------------------
// elf2vhex()
// -------------------------------------------------------------------------

static void elf2vhex (const char * const filename, const char * const opfilename)
{
    int         i, c;
    uint32_t    pcount, bytecount = 0;
    uint32_t    word;
    pElf32_Ehdr h;
    pElf32_Phdr h2[ELF_MAX_NUM_PHDR];
    char        buf[sizeof(Elf32_Ehdr)];
    char        buf2[sizeof(Elf32_Phdr)*ELF_MAX_NUM_PHDR];
    const char* ptr;
    FILE*       elf_fp;
    FILE*       op_fp;


    // Open program file ready for loading
    if ((elf_fp = fopen(filename, "rb")) == NULL)
    {
        fprintf(stderr, "*** ReadElf(): Unable to open file %s for reading\n", filename); 
        exit(1);                                                            
    }

    // Open output file ready for writing, unless opfilename is "stdout"
    if (strcmp("stdout", opfilename))
    {
        // Open output file ready for writing
        if ((op_fp = fopen(opfilename, "wb")) == NULL)
        {
            fprintf(stderr, "*** ReadElf(): Unable to open file %s for writing\n", opfilename); 
            exit(1);                                                            
        }
    }
    else
    {
        op_fp = stdout;
    }

    // Read elf header
    h = (pElf32_Ehdr) buf;
    for (i = 0; i < sizeof(Elf32_Ehdr); i++)
    {
        buf[i] = fgetc(elf_fp);
        bytecount++;
        if (buf[i] == EOF) 
        {
            fprintf(stderr, "*** ReadElf(): unexpected EOF\n");
            exit(1);
        } 
    }

    // Check some things
    ptr= ELF_IDENT;
    for (i = 0; i < 4; i++) 
    {
        if (h->e_ident[i] != ptr[i])
        {
            fprintf(stderr, "*** ReadElf(): not an ELF file\n");
            exit(1);
        }
    }

    if (h->e_type != ET_EXEC)
    {
        fprintf(stderr, "*** ReadElf(): not an executable ELF file\n");
        exit(1);
    }

    if (h->e_machine != EM_RISCV)
    {
        fprintf(stderr, "*** ReadElf(): not a RISC-V ELF file (e_machine=0x%03x)\n", h->e_machine);
        exit(1);
    }

    if (h->e_phnum > ELF_MAX_NUM_PHDR)
    {
        fprintf(stderr, "*** ReadElf(): Number of Phdr (%d) exceeds maximum supported (%d)\n", h->e_phnum, ELF_MAX_NUM_PHDR);
        exit(1);
    }

    // Read program headers
    for (pcount=0 ; pcount < h->e_phnum; pcount++)
    {
        for (i = 0; i < sizeof(Elf32_Phdr); i++)
        {
            c = fgetc(elf_fp);
            if (c == EOF)
            {
                fprintf(stderr, "*** ReadElf(): unexpected EOF\n");
                exit(1);
            } 
            buf2[i+(pcount * sizeof(Elf32_Phdr))] = c;
            bytecount++;
        }
    }

    // Load text/data segments
    for (pcount=0 ; pcount < h->e_phnum; pcount++)
    {
        h2[pcount] = (pElf32_Phdr) &buf2[pcount * sizeof(Elf32_Phdr)];

        // Gobble bytes until section start
        for (; bytecount < h2[pcount]->p_offset; bytecount++)
        {
            c = fgetc(elf_fp);
            if (c == EOF) {
                fprintf(stderr, "*** ReadElf(): unexpected EOF\n");
                exit(1);
            }
        }

        // For p_filesz bytes ...
        i = 0;
        word = 0;
        for (; bytecount < (h2[pcount]->p_offset + h2[pcount]->p_filesz); bytecount++)
        {
            if ((c = fgetc(elf_fp)) == EOF)
            {
                fprintf(stderr, "*** ReadElf(): unexpected EOF\n");
                exit(1);
            }

            // Little endian
            word |= (c << ((bytecount&3) * 8));

            if ((bytecount&3) == 3)
            {
                output_verilog_mif(h2[pcount]->p_vaddr + i, word, op_fp);
                i+=4;
                word = 0;
            }
        }

        if (byte_count)
        {
            fprintf(op_fp, "\n");
        }
        
    }
    fprintf(op_fp, "END;\n");
}

// -------------------------------------------------------------------------
// main()
// -------------------------------------------------------------------------

int main(int argc, char** argv)
{
    // Set some default filenames
    char *ipfname = (char *)"test.elf";
    char *opfname = (char *)"stdout";
   
    // If there is at least 1 arguments, set the first argument as the 
    // input filename
    if (argc > 1)
    {
        ipfname = argv[1];
    }

    // If there is at least 2 arguments, set the second argument as the 
    // output filename
    if (argc > 2)
    {
        opfname = argv[2];
    }

    // Read the ELF file and output verilog hex
    elf2vhex(ipfname, opfname);
}


