###################################################################
#
# Copyright (c) 2021 Simon Southwell. All rights reserved.
#
# Date: 14th August 2021
#
# Make file compiling MSYS2/mingw64 library and MSVC batch build
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

PROJECT         = rv32

#
# MinGW library variables
#
VOBJDIR         = obj
SRCDIR          = src
VLIB            = lib${PROJECT}.a
EXEC            = ${PROJECT}.exe

ARCHFLAG        = -m64
OPTFLAGS        = -g

LIB_CPP_BASE    = rv32i_cpu_elf.cpp                     \
                  rv32_cpu_gdb.cpp                      \
                  rv32i_cpu.cpp                         \
                  rv32csr_cpu.cpp                       \
                  rv32m_cpu.cpp                         \
                  rv32a_cpu.cpp                         \
                  rv32f_cpu.cpp                         \
                  rv32d_cpu.cpp                         \
                  rv32c_cpu.cpp

EXEC_CPP_BASE   = cpurv32i.cpp                          \
                  uart.cpp

EXEC_C_BASE     = mem.c ini.c

VOBJS           = ${addprefix ${VOBJDIR}/, ${LIB_CPP_BASE:%.cpp=%.o}}
VOBJSEXEC       = ${addprefix ${VOBJDIR}/, ${EXEC_CPP_BASE:%.cpp=%.o} ${EXEC_C_BASE:%.c=%.o}}

CC              = gcc
C++             = g++
CFLAGS          = -fPIC                                 \
                  ${ARCHFLAG}                           \
                  ${OPTFLAGS}                           \
                  -I${SRCDIR}                           \
                  -D_REENTRANT

LDFLAGS         = -lWs2_32

#
# Visual Studio variables
#
MSVCDIR         = visualstudio
MSVCCFG         = Debug
MSVCPLATFORM    = x64

MSVCBUILD       = MSBuild.exe
MSVCARGS        = -nologo -v:q -p:Configuration="${MSVCCFG}" -p:Platform="${MSVCPLATFORM}"
MSVCSLN         = ${MSVCDIR}\\${PROJECT}i.sln
MSVCTGT         = ${MSVCDIR}\${MSVCPLATFORM}\${MSVCCFG}\${PROJECT}.exe

# -----------------------------------------------------------------

# Default to builing MinGW library only
all: ${VOBJDIR} ${EXEC}

# Recipe for object files
${VOBJDIR}/%.o: ${SRCDIR}/%.cpp ${SRCDIR}/*.h
	@${C++} -Wno-write-strings -c ${CFLAGS} $< -o $@

${VOBJDIR}/%.o: ${SRCDIR}/%.c ${SRCDIR}/*.h
	@${CC} -Wno-write-strings -c ${CFLAGS} $< -o $@

# Recipe for library archive file
${VLIB} : ${VOBJS} ${VOBJDIR}
	@ar cr ${VLIB} ${VOBJS}

${EXEC} : ${VOBJSEXEC} ${VLIB}
	@${C++} ${CFLAGS} $^ ${LDFLAGS} -o $@

# Recipe to make object files dependant on object folder
${VOBJS}: | ${VOBJDIR}

# Recipe to generate object folder
${VOBJDIR}:
	@mkdir ${VOBJDIR}

# Alias MSVC to target visual studio executable
MSVC: ${MSVCTGT}

# Recipe to use MSBuild to compile visual studio executable
.PHONY: ${MSVCTGT}
${MSVCTGT}:
	@${MSVCBUILD} ${MSVCSLN} ${MSVCARGS}

# Recipe to clean intermediate files
clean:
	@rm -rf ${EXEC}
	@rm -rf ${VOBJDIR}
	@rm -f ${VLIB}
	@${MSVCBUILD} ${MSVCSLN} ${MSVCARGS} -t:clean
