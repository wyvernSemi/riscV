###################################################################
# 
# Copyright (c) 2021 Simon Southwell. All rights reserved.
#
# Date: 9th July 2021
#
# Make file for test assembly code
#
# This file is part of the base RISC-V instruction set simulator
# (rv32i_cpu).
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

FNAME         = add.S
START_ADDR    = 0
ARCHCHAIN     = riscv64-unknown-elf-

TESTSRCROOT   = c:/git

TESTDIR       = ${TESTSRCROOT}/riscv-tests
TESTENVDIR    = ${TESTSRCROOT}/riscv-test-env

SUBDIR        = rv32ui

DIR32UI       = ${TESTDIR}/isa/${SUBDIR}


CC            = ${ARCHCHAIN}gcc
LD            = ${ARCHCHAIN}ld

INCLPATHS     = -I.                                     \
                -I${TESTENVDIR}/p                       \
                -I${TESTDIR}/isa/macros/scalar
                
ARCHSPEC      = rv32g

COPTS         = -c -g -fpic -march=${ARCHSPEC} -mabi=ilp32 ${INCLPATHS}
LDOPTS        = -melf32lriscv -Ttext ${START_ADDR}

OBJDIR        = obj

OBJS          = ${OBJDIR}/${FNAME:%.S=%.o}
EXEC          = ${FNAME:%.S=%.exe}

# -----------------------------------------------------------------

.PHONY: all
all: ${OBJDIR} ${EXEC}

${EXEC}: ${OBJS}
${OBJS}: ${DIR32UI}/${FNAME} ${TESTENVDIR}/p/riscv_test.h ${TESTENVDIR}/encoding.h ${TESTDIR}/isa/macros/scalar/test_macros.h

${OBJDIR}:
	@mkdir ${OBJDIR}

%.exe: ${OBJDIR}/%.o
	@${LD} $< ${LDOPTS} -o $@
    
${OBJDIR}/%.o : ${DIR32UI}/%.S
	@${CC} ${COPTS} -o $@ $<

clean:
	@rm -rf ${OBJS} ${EXEC}
