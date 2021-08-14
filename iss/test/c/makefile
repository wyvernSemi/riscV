###################################################################
#
# Copyright (c) 2021 Simon Southwell. All rights reserved.
#
# Date: 14th August 2021
#
# Make file for test C code
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

# Prefix of main C file to compile
FNAME          = test

# All sources to conmpile
SRC            = ${FNAME}.c printf.c

# List of include files
INCL           = printf.h

# Target compiled executable
TGT            = ${FNAME}.exe

# RISC-V toolchain prefix
PREFIX         = riscv64-unknown-elf-

# Relative path to ISS executable
ISSEXE         = ../../visualstudio/x64/Debug/rv32.exe

# Temporary scratch file
TMPFILE        = tmp

# -----------------------------------------------------------------

# Default target
.PHONY: all
all: ${TGT} start_addr

# Recipe for compiling target executable and saving off address of _start symbol
${TGT}: ${SRC} ${INCL}
	@${PREFIX}gcc -g -march=rv32im -mabi=ilp32 ${SRC} -o $@
	@${PREFIX}nm $@ | awk '/\y_start\y/{print $$1}' > ${TMPFILE}

# Recipe to display value of _start symbol
.PHONY: start_addr
start_addr: ${TGT}
	@echo _start = 0x$(shell cat ${TMPFILE})

# Recipe to run target executable on the ISS
run: ${TGT}
	@$(eval START=$(shell cat ${TMPFILE}))
	@${ISSEXE} -beH -S 0x${START} -t $<

# Recipe to clean intermediate files
clean:
	@rm -rf ${TGT} ${TMPFILE}
