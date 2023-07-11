###################################################################
#
# Copyright (c) 2023 Simon Southwell. All rights reserved.
#
# Date: 29th June 2023
#
# Make file compiling FreeRTOS for rv32 project
#
# This file is part of the base RISC-V instruction set simulator
# (rv32).
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

SRCDIR          = rv32
DEMODIR         = demo
FREERTOSDIR     = ../../FreeRTOS/FreeRTOS
USRFLAGS        = -DRV32_ISS

RV32SRC         = $(wildcard ${DEMODIR}/*.c)                                                \
                  $(wildcard ${SRCDIR}/*.c)                                        \
                  $(wildcard ${SRCDIR}/*.S)

FREERTOSSRC     = $(wildcard ${FREERTOSDIR}/Source/portable/GCC/RISC-V/*.c)        \
                  $(wildcard ${FREERTOSDIR}/Source/*.c)                            \
                  ${FREERTOSDIR}/Source/portable/MemMang/heap_4.c                  \
                  ${FREERTOSDIR}/Source/portable/GCC/RISC-V/portASM.S

CFLAGS          = -march=rv32i -mabi=ilp32                                         \
                  -Wall -nostartfiles                                              \
                  -g -Wl,--gc-section                                              \
                  -DportasmHANDLE_INTERRUPT=interrupt_handler                      \
                  -I ${SRCDIR}                                                     \
                  -I ${FREERTOSDIR}/Source/portable/GCC/RISC-V                     \
                  -I ${FREERTOSDIR}/Source/include                                 \
                  ${USRFLAGS}

LDFLAGS         = 

TOOLPREFIX      = riscv64-unknown-elf-

CC              = ${TOOLPREFIX}gcc
C++             = ${TOOLPREFIX}g++
LD              = ${TOOLPREFIX}ld

TARGET          = main.exe

ALLSRC          = ${FREERTOSSRC} ${RV32SRC}
CBASE           = $(filter %c,   ${ALLSRC})
CPPBASE         = $(filter %cpp, ${ALLSRC})
ASMBASE         = $(filter %S,   ${ALLSRC})

OBJS            = ${CBASE:%.c=%.o} ${CPPBASE:%.cpp=%.o} ${ASMBASE:%.S=%.o}

LDSCRIPT        = rv32.ld

# ---------------------------------------------------------------------
# BUILD RULES
# ---------------------------------------------------------------------

%.o: %.S
	@${CC} -c ${CFLAGS} $< -o $@


%.o: %.c
	@${CC} -c ${CFLAGS} $< -o $@


%.o: %.cpp
	@${C++} -c ${CFLAGS} $< -o $@

${TARGET}: ${OBJS} ${LDSCRIPT}
	@${CC} ${CFLAGS} ${LDFLAGS} -T ${LDSCRIPT} ${OBJS}  -o $@

clean:
	@rm -rf ${OBJS} ${TARGET}