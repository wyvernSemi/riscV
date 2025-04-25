#!/bin/bash
###################################################################
#
# Copyright (c) 2021-2025 Simon Southwell. All rights reserved.
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
TSTROOT=$HOME/git
ARCHPREFIX=riscv64-unknown-elf-

OS=`uname`
if [ "$OS" == "Linux" ]
then
  EXE=../rv32
else
  EXE=../rv32.exe
fi

echo
echo "Building $EXE executable..."

make --no-print-directory -C ../ clean
make --no-print-directory -C ../ OPTFLAGS="-O3"

# ------------------------------------------------------------------

MAKE_ARGS="TESTSRCROOT=$TSTROOT ARCHCHAIN=$ARCHPREFIX"

#
# Always build tests  from clean
#
rm -rf obj/* *.exe

#
# RV32I tests
#
for tst in simple add addi and andi auipc beq bge  \
  bgeu blt bltu bne jal jalr lb lbu lh lhu lui lw  \
  ld_st or ori sb sh st_ld sll slli slt slti sltiu \
  sltu sra srai srl srli sub sw xor xori fence_i
do
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS FNAME=$tst.S
    $EXE -b -t $tst.exe
done

#
# RVZcsr tests
#
for tst in csr ma_addr ma_fetch mcsr sbreak shamt  \
  lh-misaligned lw-misaligned sh-misaligned        \
  sw-misaligned zicntr
do
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS SUBDIR=rv32mi FNAME=$tst.S
    $EXE -b -t $tst.exe
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
    $EXE -b -t $tst.exe
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
    $EXE -b -t $tst.exe
done

#
# RV32F tests
#
for tst in fadd fclass fcmp fcvt fcvt_w fdiv fmadd fmin ldst move recoding
do
    echo
    echo
    echo "Running test for $tst (single) instruction..."
    make $MAKE_ARGS SUBDIR=rv32uf FNAME=$tst.S
    $EXE -b -t $tst.exe
done

#
# RV32D tests
#
for tst in fadd fclass fcmp fcvt fcvt_w fdiv fmadd fmin ldst recoding
do
    echo
    echo
    echo "Running test for $tst (double) instruction..."
    rm -rf obj/$tst.o
    make $MAKE_ARGS SUBDIR=rv32ud FNAME=$tst.S
    $EXE -b -t $tst.exe
done

#
# RV32C tests
#
for tst in rvc
do
    echo
    echo
    echo "Running test for $tst instruction..."
    rm -rf obj/$tst.o
    make $MAKE_ARGS SUBDIR=rv32uc FNAME=$tst.S ARCHSPEC=rv32gc
    $EXE -b -A0x36 -t $tst.exe
done

#
# RV32ZBA tests
#

for tst in sh1add sh2add sh3add
do
    echo
    echo
    echo "Running test for $tst instruction..."
    rm -rf obj/$tst.o
    make $MAKE_ARGS SUBDIR=rv32uzba FNAME=$tst.S ARCHSPEC=rv32g_zba
    $EXE -b -t $tst.exe
done

# RV32ZBB tests

for tst in andn orn xnor clz cpop ctz max maxu min minu \
  sext_b sext_h zext_h rol ror rori orc_b rev8  
do
    echo
    echo
    echo Running test for $tst instruction...
    make $MAKE_ARGS SUBDIR=rv32uzbb FNAME=$tst.S ARCHSPEC=rv32g_zbb
    $EXE -b -t $tst.exe
done

#
# RV32ZBS tests
#

for tst in bset bseti bclr bclri bext bexti binv binvi
do
    echo
    echo
    echo "Running test for $tst instruction..."
    rm -rf obj/$tst.o
    make $MAKE_ARGS SUBDIR=rv32uzbs FNAME=$tst.S ARCHSPEC=rv32g_zbs
    $EXE -b -t $tst.exe
done


#
# RV32ZBC tests
#

for tst in clmul clmulh clmulr
do
    echo
    echo
    echo "Running test for $tst instruction..."
    rm -rf obj/$tst.o
    make $MAKE_ARGS SUBDIR=rv32uzbc FNAME=$tst.S ARCHSPEC=rv32g_zbc
    $EXE -b -t $tst.exe
done

