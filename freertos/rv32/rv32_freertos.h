//=============================================================
// 
// Copyright (c) 2023 Simon Southwell. All rights reserved.
//
// Date: 29th April 2023
//
// This file is part of the rv32 instruction set simulator.
//
// The code is free software: you can redistribute it and/or modify
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

// Machine Trap Setup
#define CSR_MSTATUS                           0x300
#define CSR_MISA                              0x301
#define CSR_MEDELEG                           0x302
#define CSR_MIDELEG                           0x303
#define CSR_MIE                               0x304
#define CSR_MTVEC                             0x305
#define CSR_MCOUNTEREN                        0x306

// Machine Trap Handling
#define CSR_MSCRATCH                          0x340
#define CSR_MEPC                              0x341
#define CSR_MCAUSE                            0x342
#define CSR_MTVAL                             0x343
#define CSR_MIP                               0x344

// Machine information
#define CSR_MVENDORID                         0xf11
#define CSR_MARCHID                           0xf12
#define CSR_MIMPID                            0xf13
#define CSR_MHARTID                           0xf14


inline void __attribute__ ((always_inline)) csr_write(const int idx, uint32_t data) {
  asm volatile (
      "csrw %[CSRIDX], %[WDATA]"
      : /* No Outputs */
      : [CSRIDX] "i" (idx),
        [WDATA]  "r" (data)
      );
}

inline void __attribute__ ((always_inline)) csr_read(const int idx, uint32_t *data) {
  uint32_t rdata;
  asm volatile (
      "csrr %[RDATA], %[CSRIDX]"
      : [RDATA]  "=r" (rdata)
      : [CSRIDX] "i"  (idx)
      );
  *data = rdata;
}

int printf_(const char* format, ...);
int sprintf_(char* buffer, const char* format, ...);