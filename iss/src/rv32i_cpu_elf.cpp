//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 5th July 2021
//
// ELF executable reader method of rv32i_cpu
//
// This file is part of the RISC-V instruction set simulator
// (rv32i_cpu)
//
// This code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <cstdio>
#include <cstdint>

#include "rv32i_cpu_elf.h"
#include "rv32i_cpu.h"

// ----------------------------------
// read_elf()
//
// Read ELF formatted executable from
// filename, and load to memory
//
int rv32i_cpu::read_elf (const char * const filename)
{
    unsigned    i;
    int         c;
    uint32_t    pcount, bytecount = 0;
    uint32_t    word;
    pElf32_Ehdr h;
    pElf32_Phdr h2[ELF_MAX_NUM_PHDR];
    char        buf[sizeof(Elf32_Ehdr)];
    char        buf2[sizeof(Elf32_Phdr)*ELF_MAX_NUM_PHDR];
    const char* ptr;
    FILE*       elf_fp;
    bool        access_fault = false;


    // Open program file ready for loading
    if ((elf_fp = fopen(filename, "rb")) == NULL)
    {
        fprintf(stderr, "*** ReadElf(): Unable to open file %s for reading\n", filename); //LCOV_EXCL_LINE
        return USER_ERROR;                                                           //LCOV_EXCL_LINE
    }

    // Read elf header
    h = (pElf32_Ehdr) buf;
    for (i = 0; i < sizeof(Elf32_Ehdr); i++)
    {
        buf[i] = fgetc(elf_fp);
        bytecount++;
        if (buf[i] == EOF) 
        {
            fprintf(stderr, "*** ReadElf(): unexpected EOF\n");                           //LCOV_EXCL_LINE
           return USER_ERROR;                                                       //LCOV_EXCL_LINE
        } 
    }

    //LCOV_EXCL_START
    // Check some things
    ptr= ELF_IDENT;
    for (i = 0; i < 4; i++) 
    {
        if (h->e_ident[i] != ptr[i])
        {
            fprintf(stderr, "*** ReadElf(): not an ELF file\n");
            return USER_ERROR;
        }
    }

    if (h->e_type != ET_EXEC)
    {
        fprintf(stderr, "*** ReadElf(): not an executable ELF file\n");
        return USER_ERROR;
    }

    if (h->e_machine != EM_RISCV)
    {
        fprintf(stderr, "*** ReadElf(): not a RISC-V ELF file (e_machine=0x%03x)\n", h->e_machine);
        return USER_ERROR;
    }

    if (h->e_phnum > ELF_MAX_NUM_PHDR)
    {
        fprintf(stderr, "*** ReadElf(): Number of Phdr (%d) exceeds maximum supported (%d)\n", h->e_phnum, ELF_MAX_NUM_PHDR);
        return USER_ERROR;
    }
    //LCOV_EXCL_STOP

    // Read program headers
    for (pcount=0 ; pcount < h->e_phnum; pcount++)
    {
        for (i = 0; i < sizeof(Elf32_Phdr); i++)
        {
            c = fgetc(elf_fp);
            if (c == EOF)
            {
                fprintf(stderr, "*** ReadElf(): unexpected EOF\n");                         //LCOV_EXCL_LINE
                return USER_ERROR;                                                     //LCOV_EXCL_LINE
            } 
            buf2[i+(pcount * sizeof(Elf32_Phdr))] = c;
            bytecount++;
        }
    }

    // Load text/data segments
    for (pcount=0 ; pcount < h->e_phnum; pcount++)
    {
        h2[pcount] = (pElf32_Phdr) &buf2[pcount * sizeof(Elf32_Phdr)];
        
        if (h2[pcount]->p_type != PT_LOAD)
            continue;

        // Gobble bytes until section start
        for (; bytecount < h2[pcount]->p_offset; bytecount++)
        {
            c = fgetc(elf_fp);
            if (c == EOF) {
                fprintf(stderr, "*** ReadElf(): unexpected EOF\n");                         //LCOV_EXCL_LINE
                return USER_ERROR;                                                      //LCOV_EXCL_LINE
            }
        }

        // Check we can load the segment to memory
        if ((h2[pcount]->p_vaddr + h2[pcount]->p_memsz) >= (1ULL << MEM_SIZE_BITS))
        {
            fprintf(stderr, "*** ReadElf(): segment memory footprint outside of internal memory range\n"); //LCOV_EXCL_LINE
            return USER_ERROR;                                                                        //LCOV_EXCL_LINE
        }

        // For p_filesz bytes ...
        i = (bytecount - h2[pcount]->p_offset);
        word = 0;
        for (; bytecount < h2[pcount]->p_offset + h2[pcount]->p_filesz; bytecount++)
        {
            if ((c = fgetc(elf_fp)) == EOF)
            {
                fprintf(stderr, "*** ReadElf(): unexpected EOF\n");                          //LCOV_EXCL_LINE
                return USER_ERROR;                                                      //LCOV_EXCL_LINE
            }

            // Little endian
            word |= (c << ((bytecount & 3) * 8));

            if ((bytecount&3) == 3)
            {
                write_mem(h2[pcount]->p_vaddr + i, word, MEM_WR_ACCESS_INSTR, access_fault);
                i+=4;
                word = 0;

                if (access_fault)
                {
                    fprintf(stderr, "*** ReadElf(): memory access fault loading program\n");
                    return USER_ERROR;
                }
            }
        }
    }

    return 0;
}

