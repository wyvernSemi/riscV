
@echo off

REM ##################################################################
REM  Simulation regression test batch script
REM 
REM  Copyright (c) 2021 Simon Southwell
REM 
REM  This code is free software: you can redistribute it and/or modify
REM  it under the terms of the GNU General Public License as published by
REM  the Free Software Foundation, either version 3 of the License, or
REM  (at your option) any later version.
REM 
REM  The code is distributed in the hope that it will be useful,
REM  but WITHOUT ANY WARRANTY; without even the implied warranty of
REM  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
REM  GNU General Public License for more details.
REM 
REM  You should have received a copy of the GNU General Public License
REM  along with this code. If not, see <http://www.gnu.org/licenses/>.
REM 
REM ##################################################################

REM Remove key directories anf file to ensure a clean build and run

rm -rf obj
rm -f test.log

REM Run all the rv32ui tests

 for %%i in (^
   simple^
   add^
   addi^
   and^
   andi^
   auipc^
   beq^
   bge^
   bgeu^
   blt^
   bltu^
   bne^
   fence_i^
   jal^
   jalr^
   lb^
   lbu^
   lh^
   lhu^
   lui^
   lw^
   or^
   ori^
   sb^
   sh^
   sll^
   slli^
   slt^
   slti^
   sltiu^
   sltu^
   sra^
   srai^
   srl^
   srli^
   sub^
   sw^
   xor^
   xori^
  ) do (
     echo.
     echo.
     echo Running test for %%i test...
     rm -f %%i.exe
     make -f makefile.test SUBDIR=rv32ui FNAME=%%i.S
     make log
     grep "Test" sim.log >> test.log
  )

REM Run the rv32mi tests, except scall which need different parameters

 for %%i in (^
    csr^
    mcsr^
    sbreak^
    illegal^
    ma_fetch^
    ma_addr^
    shamt^
  ) do (
    echo.
    echo.
    echo Running test for %%i test...
    rm -f %%i.exe
    make -f makefile.test SUBDIR=rv32mi FNAME=%%i.S
    make log
    grep "Test" sim.log >> test.log
  )

REM Run the rv32mi scall test

 for %%i in (^
   scall^
 ) do (
   echo.
   echo.
   echo Running test for %%i test...
   rm -f %%i.exe
   make -f makefile.test SUBDIR=rv32mi FNAME=%%i.S
   make VSIMARGS="-gHALT_ON_ADDR=1 -gHALT_ON_ECALL=0" log
   grep "Test" sim.log >> test.log
 )

REM RV32M tests for default (non-inferred multiplication, fixed timing) configuration

 for %%i in (^
   mul^
   mulh^
   mulhsu^
   mulhu^
   div^
   divu^
   rem^
   remu^
 ) do (
   echo.
   echo.
   echo Running test for %%i test...
   rm -f %%i.exe
   make -f makefile.test SUBDIR=rv32um FNAME=%%i.S
   make log
   grep "Test" sim.log >> test.log
 )

REM repeat RV32M tests for no fixed timing and inferred (DSP) multiplication logic configuration

 for %%i in (^
   mul^
   mulh^
   mulhsu^
   mulhu^
   div^
   divu^
   rem^
   remu^
 ) do (
   echo.
   echo.
   echo Running test for %%i test...
   rm -f %%i.exe
   make -f makefile.test SUBDIR=rv32um FNAME=%%i.S
   make VSIMARGS="-gM_MUL_INFERRED=1 -gM_FIXED_TIMING=0" log
   grep "Test" sim.log >> test.log
 )

REM display the test log

 cat test.log