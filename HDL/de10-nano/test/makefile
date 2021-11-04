###################################################################
#
# Copyright (c) 2021 Simon Southwell. All rights reserved.
#
# Date: 27th September 2021
#
# Make file for building DE10-Nano ARM test code
#
# This file is part of the base RISC-V FPGA softcore IP
# (rv32i_cpu_core).
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
# Set variables for paths to ARM compilation toolchain
#
TOOLPATH  = c:\Tools\gcc-linaro-4.9.4-2017.01-i686-mingw32_arm-linux-gnueabihf
ARCH      = arm-linux-gnueabihf-
C++       = ${TOOLPATH}\bin\${ARCH}g++.exe

#
# Additional utility source code
#
UTILS_SRC = elf.cpp

INCLUDES  = fpga_support.h core.h CCoreAuto.h

#
# Output ARM test program
#
EXEC      = main.exe

CFLAGS    = -std=c++11 -I .

#------------------------------------------------------
# BUILD RULES
#------------------------------------------------------

.PHONY: all
all: ${EXEC}

${EXEC} : ${EXEC:%.exe=%.cpp} ${EXEC:%.exe=%.h} ${UTILS_SRC} ${UTILS_SRC:%.cpp=%.h} ${INCLUDES}
	@${C++} ${CFLAGS} ${UTILS_SRC} $< -o $@

clean:
	@rm -rf ${EXEC}