/* ################################################################################################# */
/* # << NEORV32 - crt0.S Start-Up Code >>                                                          # */
/* # ********************************************************************************************* # */
/* # BSD 3-Clause License                                                                          # */
/* #                                                                                               # */
/* # Copyright (c) 2023, Stephan Nolting. All rights reserved.                                     # */
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

// Modified by Simon Southwell for RV32 project July 2023

.file "crt0.S"
.section .text.crt0
.balign 4
.global _start

_start:

.cfi_startproc

// --------------------------------------------------------------
// We need to ensure interrupts are completely disabled at start.
// This is required if this code is part of a program uploaded by
// the on-chip debugger (potentionally taking control from the
// bootloader). We setup a new stack pointer here and WE DO NOT
// WANT TO trap to an outdated trap handler with a modified stack
// pointer.
// --------------------------------------------------------------

  csrrwi zero, mstatus, 0 // Clear mstatus; disable machine-level interrupts

// --------------------------------------------------------------
// Setup CPU core CSRs
// --------------------------------------------------------------

  csrw mie,   zero                // Disable all interrupt sources
  la   x1,    __crt0_trap_handler // Configure early-boot trap handler
  csrw mtvec, x1


// --------------------------------------------------------------
// Initialize integer register file
// --------------------------------------------------------------

  .option push
  .option norelax
  
  // Setup pointers using rv32.ld linker script symbols
  la sp, __crt0_stack_begin // Stack pointer
  la gp, __global_pointer$  // Global pointer
  
  .option pop

//addi  x0, x0, 0 // Hardwired to zero
  addi  x1, x0, 0
//addi  x2, x0, 0 // Stack pointer sp
//addi  x3, x0, 0 // Global pointer gp
  addi  x4, x0, 0
  addi  x5, x0, 0
  addi  x6, x0, 0
  addi  x7, x0, 0
  addi  x8, x0, 0
  addi  x9, x0, 0
  addi x10, x0, 0
  addi x11, x0, 0
  addi x12, x0, 0
  addi x13, x0, 0
  addi x14, x0, 0
  addi x15, x0, 0
#ifndef __riscv_32e // Initialize upper half (if E extension is not implemented)
  addi x16, x0, 0
  addi x17, x0, 0
  addi x18, x0, 0
  addi x19, x0, 0
  addi x20, x0, 0
  addi x21, x0, 0
  addi x22, x0, 0
  addi x23, x0, 0
  addi x24, x0, 0
  addi x25, x0, 0
  addi x26, x0, 0
  addi x27, x0, 0
  addi x28, x0, 0
  addi x29, x0, 0
  addi x30, x0, 0
  addi x31, x0, 0
#endif


// --------------------------------------------------------------
// Copy initialized .data section from ROM to RAM (word-wise,
// section begins and ends on word boundary)
//
// Simon Southwell :  Only do this if loading a binary image.
// If loading ELF in ISS, data is loaded directly to location
// --------------------------------------------------------------

#ifndef RV32_ISS
  la   x11, __crt0_copy_data_src_begin     // Start of data area (copy source)
  la   x12, __crt0_copy_data_dst_begin     // Start of data area (copy destination)
  la   x13, __crt0_copy_data_dst_end       // Last address of destination data area
  beq  x11, x12, __crt0_copy_data_loop_end // Nothing to do if source and destination address are the same

__crt0_copy_data_loop:
  bge  x12, x13,  __crt0_copy_data_loop_end
  lw   x14, 0(x11)
  sw   x14, 0(x12)
  addi x11, x11, 4
  addi x12, x12, 4
  j    __crt0_copy_data_loop

__crt0_copy_data_loop_end:

// --------------------------------------------------------------
// Call constructors
// --------------------------------------------------------------
  la   x8,  __init_array_start
  la   x9,  __init_array_end

__crt0_call_constructors_loop:
  bge  x8, x9, __crt0_call_constructors_loop_end
  lw   x1, 0(x8)
  jalr x1, 0(x1)
  addi x8, x8, 4
  j    __crt0_call_constructors_loop

__crt0_call_constructors_loop_end:


// --------------------------------------------------------------
// Call destructors
// --------------------------------------------------------------

  la   x8, __fini_array_start
  la   x9, __fini_array_end

__crt0_call_destructors_loop:
  bge  x8, x9, __crt0_call_destructors_loop_end
  lw   x1, 0(x8)
  jalr x1, 0(x1)
  addi x8, x8, 4
  j    __crt0_call_destructors_loop

__crt0_call_destructors_loop_end:

#endif

// --------------------------------------------------------------
// Clear .bss section (word-wise, section begins and ends on
// word boundary)
// --------------------------------------------------------------

  la   x14,  __crt0_bss_start
  la   x15,  __crt0_bss_end

__crt0_clear_bss_loop:
  bge  x14,  x15, __crt0_clear_bss_loop_end
  sw   zero, 0(x14)
  addi x14,  x14, 4
  j    __crt0_clear_bss_loop

__crt0_clear_bss_loop_end:

// --------------------------------------------------------------
// Setup arguments and call main function
// --------------------------------------------------------------

  addi x10, zero, 0 // x10 = a0 = argc = 0
  addi x11, zero, 0 // x11 = a1 = argv = 0
  jal  x1,  main    // Call actual app's main function

__crt0_main_exit:   // Main's "return" and "exit" will arrive here
  csrw mie, zero    // Disable all interrupt sources
  csrw mscratch, a0 // Backup main's return code to mscratch (for debugger)
  
  // Simon Southwell : Set PASS exit values and break
  li   x10,       0
  li   x17,      93
  ebreak

// --------------------------------------------------------------
// Dummy trap handler (for all traps during very early boot stage)
// - does nothing but trying to move on to the next instruction
// --------------------------------------------------------------

.balign 4                                   // The trap handler has to be 32-bit aligned
__crt0_trap_handler:

  addi  sp,   sp, -8
  sw    x8,   0(sp)
  sw    x9,   4(sp)

  csrr  x8,   mcause
  blt   x8,   zero, __crt0_trap_handler_end // Skip mepc modification if interrupt

// update mepc
  csrr  x8,   mepc
  lh    x9,   0(x8)                         // Get compressed instruction or lower 16 bits of uncompressed instruction that caused exception
  andi  x9,   x9, 3                         // Mask: isolate lowest 2 opcode bits (= 11 for uncompressed instructions)

  addi  x8,   x8, +2                        // mepc +2 only for compressed instructions
  csrw  mepc, x8                            // Set new return address

  addi  x8,   zero, 3
  bne   x8,   x9, __crt0_trap_handler_end   // Done if compressed instruction

  csrr  x8,   mepc
  addi  x8,   x8, +2                        // Add another +2 to mepc (making +4) for uncompressed instructions
  csrw  mepc, x8

__crt0_trap_handler_end:
  lw    x8,   0(sp)
  lw    x9,   4(sp)
  addi  sp,   sp, +8

  mret

.cfi_endproc
.end
