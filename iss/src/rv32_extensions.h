//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 12th July 2021
//
// Contains the definitions for the class inheritance structure
// of the target compilation to add the required extensions
//
// This file is part of the Zicsr extended RISC-V instruction
// set simulator (rv32csr_cpu).
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

#ifndef _RSV32_EXTENSIONS_H_
#define _RSV32_EXTENSIONS_H_

// Define the inheritance chain for adding new extensions.
// Currently this is setup to add Zicsr, M, A, F, and D
// in that order. If an extension were to be skipped,
// then the subsequent definition just uses the last
// active class to inherit from in place of the skipped
// class. Note, since the FENCE instruction is a NOP
// in this model, Zifencei is implicit in the rv32i_cpu
// base class.

#define RV32_I_INHERITANCE_CLASS
#define RV32_ZIFENCEI_INHERITANCE_CLASS
#define RV32_ZICSR_INHERITANCE_CLASS     rv32i_cpu
#define RV32_M_INHERITANCE_CLASS         rv32csr_cpu
#define RV32_A_INHERITANCE_CLASS         rv32m_cpu
#define RV32_F_INHERITANCE_CLASS         rv32a_cpu
#define RV32_D_INHERITANCE_CLASS         rv32f_cpu

// Inheritance for a G spec processor should have all the above
// classes inherited, without skips
#define RV32_G_INHERITANCE_CLASS         rv32d_cpu

// Uncomment the following to compile for RV32E base class,
// or define it when compiling rv32i_cpu.cpp
// 
//#define RV32E_EXTENSION

// Define the extension spec for the target model. Chose the
// highest order class that's needed. Currently Zicsr extensions.
#define RV32_TARGET_INHERITANCE_CLASS    rv32a_cpu

// Define the class include file definitions used here. I.e. those needed
// for the target spec. Each one defines its predecessor, as including
// headers for later derived classes causes a compile error---even when
// using forward references (needs a completed class reference).

#define RV32CSR_INCLUDE                 "rv32i_cpu.h"
#define RV32M_INCLUDE                   "rv32csr_cpu.h"
#define RV32A_INCLUDE                   "rv32m_cpu.h"
#define RV32F_INCLUDE                   "rv32a_cpu.h"
#define RV32D_INCLUDE                   "rv32d_cpu.h"
#define RV32_TARGET_INCLUDE             "rv32a_cpu.h"

#endif