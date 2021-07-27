//=============================================================
// 
// Copyright (c) 2021 Simon Southwell. All rights reserved.
//
// Date: 26th July 2021
//
// Contains the instruction execution methods for the
// rv32f_cpu derived class
//
// This file is part of the base RISC-V instruction set simulator
// (rv32f_cpu).
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

#include "rv32f_cpu.h"

// -----------------------------------------------------------
// Constructor
// -----------------------------------------------------------

rv32f_cpu::rv32f_cpu(FILE* dbgfp) : RV32_F_INHERITANCE_CLASS(dbgfp)
{

    int idx;

    // Quarternary tables for floating point, decoded in funct3.
    // For OP-FP instructions not using 'rm' field in funct3 place.

    // Initialise quarternary table sto reserved instruction method
    for (int i = 0; i < RV32I_NUM_SECONDARY_OPCODES; i++)
    {
        fsgnjs_tbl[i]   = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fminmaxs_tbl[i] = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fmv_tbl[i]      = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
        fcmp_tbl[i]     = {false, reserved_str, RV32I_INSTR_ILLEGAL, &rv32i_cpu::reserved};
    }

    idx = 0;
    fsgnjs_tbl[idx++]   = { false, fsgnjs_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsgnjs };
    fsgnjs_tbl[idx++]   = { false, fsgnjns_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsgnjns };
    fsgnjs_tbl[idx++]   = { false, fsgnjxs_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsgnjxs };

    idx = 0;
    fminmaxs_tbl[idx++] = { false, fmins_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmins };
    fminmaxs_tbl[idx++] = { false, fmaxs_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmaxs };

    idx = 0;
    fmv_tbl[idx++]      = { false, fmvxw_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmvxw };
    fmv_tbl[idx++]      = { false, fclasss_str, RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fclasss };

    idx = 0;
    fcmp_tbl[idx++]     = { false, fles_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fles };
    fcmp_tbl[idx++]     = { false, flts_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::flts };
    fcmp_tbl[idx++]     = { false, feqs_str,    RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::feqs };

    // Tertiary table for OP-FP
    fs_tbl[0x00]        = { false, fadds_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fadds };
    fs_tbl[0x04]        = { false, fsubs_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsubs };
    fs_tbl[0x08]        = { false, fmuls_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmuls };
    fs_tbl[0x0c]        = { false, fdivs_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fdivs };
    fs_tbl[0x2c]        = { false, fsqrts_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fsqrts };
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x10], fsgnjs_tbl);
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x14], fminmaxs_tbl);
    fs_tbl[0x60]        = { false, fcvtws_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fcvtws };  // FCVT.W.S and FCVT.WU.S
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x70], fmv_tbl);
    INIT_TBL_WITH_SUBTBL(fs_tbl[0x40], fcmp_tbl);
    fs_tbl[0x61]        = { false, fcvtsw_str,  RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fcvtsw };  // FCVT.S.W and FCVT.S.WU
    fs_tbl[0x71]        = { false, fmvwx_str,   RV32I_INSTR_FMT_R, (pFunc_t)&rv32f_cpu::fmvwx };

    // For all combinations of funct3, point to the tertiary fsop_tbl. 
    // Will decode funct3 locally in instruction methods. Avoids large
    // and complex tables initialiation on all combinations of rm.
    // This effectively pushes funct3 decode to a quarternary decode
    // from secondary.
    for (int i = 0; i < RV32I_NUM_SECONDARY_OPCODES; i++)
    {
        INIT_TBL_WITH_SUBTBL(fsop_tbl[i], fs_tbl);
    }

    primary_tbl[0x01]  = {false, flw_str,          RV32I_INSTR_FMT_I, (pFunc_t)&rv32f_cpu::flw};      /*LOAD-FP*/
    primary_tbl[0x09]  = {false, fsw_str,          RV32I_INSTR_FMT_S, (pFunc_t)&rv32f_cpu::fsw};      /*STORE-FP*/

    idx = 0x10;
    primary_tbl[idx++] = {false, fmadds_str,       RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fmadds};  /*MADD*/
    primary_tbl[idx++] = {false, fmsubs_str,       RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fmsubs};  /*MSUB*/
    primary_tbl[idx++] = {false, fnmsubs_str,      RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fnmsubs}; /*NMSUB*/
    primary_tbl[idx++] = {false, fnmadds_str,      RV32I_INSTR_FMT_R4, (pFunc_t)&rv32f_cpu::fnmadds}; /*NMADD*/

    INIT_TBL_WITH_SUBTBL(primary_tbl[idx], fsop_tbl); idx++;
}

// -----------------------------------------------------------
// RV32F instruction methods
// -----------------------------------------------------------

void rv32f_cpu::flw    (const p_rv32i_decode_t d){};
void rv32f_cpu::fsw    (const p_rv32i_decode_t d){};
void rv32f_cpu::fmadds (const p_rv32i_decode_t d){};
void rv32f_cpu::fmsubs (const p_rv32i_decode_t d){};
void rv32f_cpu::fnmsubs(const p_rv32i_decode_t d){};
void rv32f_cpu::fnmadds(const p_rv32i_decode_t d){};
void rv32f_cpu::fadds  (const p_rv32i_decode_t d){};
void rv32f_cpu::fsubs  (const p_rv32i_decode_t d){};
void rv32f_cpu::fmuls  (const p_rv32i_decode_t d){}; 
void rv32f_cpu::fdivs  (const p_rv32i_decode_t d){};
void rv32f_cpu::fsqrts (const p_rv32i_decode_t d){};
void rv32f_cpu::fsgnjs (const p_rv32i_decode_t d){};
void rv32f_cpu::fsgnjns(const p_rv32i_decode_t d){};
void rv32f_cpu::fsgnjxs(const p_rv32i_decode_t d){};
void rv32f_cpu::fmins  (const p_rv32i_decode_t d){};
void rv32f_cpu::fmaxs  (const p_rv32i_decode_t d){};
void rv32f_cpu::fcvtws (const p_rv32i_decode_t d){};
void rv32f_cpu::fmvxw  (const p_rv32i_decode_t d){};
void rv32f_cpu::feqs   (const p_rv32i_decode_t d){}; 
void rv32f_cpu::flts   (const p_rv32i_decode_t d){};
void rv32f_cpu::fles   (const p_rv32i_decode_t d){};
void rv32f_cpu::fclasss(const p_rv32i_decode_t d){};
void rv32f_cpu::fcvtsw (const p_rv32i_decode_t d){}; 
void rv32f_cpu::fmvwx  (const p_rv32i_decode_t d){};
