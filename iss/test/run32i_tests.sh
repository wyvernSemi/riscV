#!/bin/bash
###################################################################
# 
# Copyright (c) 2021 Simon Southwell. All rights reserved.
#
# Date: 28th July 2021
#
# Test run script for BASH
#
# This file is part of the base RISC-V instruction set simulator
# (rv32_cpu).
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this code. If not, see <http://www.gnu.org/licenses/>.
#
###################################################################

#
# Modify these variables to customise to local conditions
#
TSTROOT=$HOME/winhome/git
ARCHPREFIX=/opt/riscv/bin/riscv32-unknown-elf-
EXE_DIR=../eclipse/Debug

# ------------------------------------------------------------------

MAKE_ARGS="TESTSRCROOT=$TSTROOT ARCHCHAIN=$ARCHPREFIX"

#
# Always build tests  from clean
#
rm -rf obj/* *.exe

#
# RV32I tests
#
for tst in simple add addi and andi auipc beq bge \
  bgeu blt bltu bne jal jalr lb lbu lh lhu lui lw \
  or ori sb sh sll slli slt slti sltiu sltu sra   \
  srai srl srli sub sw xor xori fence_i 
do
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS FNAME=$tst.S
    $EXE_DIR/rv32 -b -t $tst.exe
done

#
# RVZcsr tests
#
for tst in csr illegal ma_addr ma_fetch mcsr sbreak shamt
do 
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS SUBDIR=rv32mi FNAME=$tst.S
    $EXE_DIR/rv32 -b -t $tst.exe
done
  
#
# RV32M tests
#
for tst in mul mulh mulhsu mulhu div divu rem remu
do 
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS SUBDIR=rv32um FNAME=$tst.S
    $EXE_DIR/rv32 -b -t $tst.exe
done
  
#
# RV32A tests
#
for tst in amoadd_w amoand_w amomax_w amomaxu_w amomin_w amominu_w amoor_w amoswap_w amoxor_w lrsc
do
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS SUBDIR=rv32ua FNAME=$tst.S
    $EXE_DIR/rv32 -b -t $tst.exe
done

#
# RV32F tests
#
for tst in fadd fclass fcmp fcvt fcvt_w fdiv fmadd fmin ldst move recoding
do
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS SUBDIR=rv32uf FNAME=$tst.S
    $EXE_DIR/rv32 -b -t $tst.exe
done 
