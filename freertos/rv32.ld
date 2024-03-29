/* ################################################################################################# */
/* # << NEORV32 - RISC-V GCC Linker Script >>                                                      # */
/* # ********************************************************************************************* # */
/* # BSD 3-Clause License                                                                          # */
/* #                                                                                               # */
/* # Copyright (c) 2022, Stephan Nolting. All rights reserved.                                     # */
/* #                                                                                               # */
/* # Redistribution and use in source and binary forms, with or without modification, are          # */
/* # permitted provided that the following conditions are met:                                     # */
/* #                                                                                               # */
/* # 1. Redistributions of source code must retain the above copyright notice, this list of        # */
/* #    conditions and the following disclaimer.                                                   # */
/* #                                                                                               # */
/* # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     # */
/* #    conditions and the following disclaimer in the documentation and/or other materials        # */
/* #    provided with the distribution.                                                            # */
/* #                                                                                               # */
/* # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  # */
/* #    endorse or promote products derived from this software without specific prior written      # */
/* #    permission.                                                                                # */
/* #                                                                                               # */
/* # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   # */
/* # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               # */
/* # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    # */
/* # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     # */
/* # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE # */
/* # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    # */
/* # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     # */
/* # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  # */
/* # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            # */
/* # ********************************************************************************************* # */
/* # The NEORV32 Processor - https://github.com/stnolting/neorv32              (c) Stephan Nolting # */
/* ################################################################################################# */

/* Default linker script, for normal executables .
 * Copyright (C) 2014-2020 Free Software Foundation, Inc.
 * Copying and distribution of this script, with or without modification,
 * are permitted in any medium without royalty provided the copyright
 * notice and this notice are preserved.
 * Modified for the NEORV32 processor by Stephan Nolting. */

/* Modified for rv32 by Simon Southwell July 2023 */

OUTPUT_FORMAT("elf32-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

rom_size  = 56K;
ram_size  = 8K;
rom_base  = 0x00000000;
ram_base  = 0x00080000;

MEMORY
{
  rom   (rx) : ORIGIN = rom_base, LENGTH = rom_size
  ram  (rwx) : ORIGIN = ram_base, LENGTH = ram_size
}

/* ************************************************************************************************* */
SECTIONS
{
  .text : ALIGN(4)
  {

    KEEP(*(.text.crt0));

    *(.text*)

  } > rom

  .rodata : ALIGN(4)
  {
    *(.rodata*)

  } > rom

  .data : ALIGN(4)
  {
    *(.data* .sdata*)
    
    *(.srodata*)
    
    __global_pointer$ = . + 0x800;
  } > ram

  .bss : ALIGN(4)
  {
    PROVIDE(__crt0_bss_start           = .);
    *(.bss* .sbss*)

    PROVIDE(__crt0_bss_end             = .);
  } > ram
  

  PROVIDE(__crt0_stack_begin         = (ORIGIN(ram) + LENGTH(ram)) - 4);

}
