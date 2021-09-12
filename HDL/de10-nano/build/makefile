###################################################################
# Makefile for DE10-nano logic synthesis
#
# Copyright (c) 2021 Simon Southwell
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this code. If not, see <http://www.gnu.org/licenses/>.
#
###################################################################

TOPNAME    = top
SYSTOPNAME = ${TOPNAME}_system
HPSNAME    = hps_0

OPFILEDIR  = output_files
QPFFILE    = ${TOPNAME}.qpf
QSYSFILE   = ${SYSTOPNAME}.qsys
SOPCINFO   = ${SYSTOPNAME}.sopcinfo

FPGATYPE   = "Cyclone V"
FPGAPART   = 5CSEBA6U23I7

MAKE_EXE   = make

all: hps synth check_timing

${SOPCINFO}:
	@qsys-generate ${QSYSFILE} --synthesis=VERILOG --output-directory=${SYSTOPNAME} --family=${FPGATYPE} --part=${FPGAPART}

${HPSNAME}.h: ${SOPCINFO}
	@bash -c "sopc-create-header-files $< --single ${HPSNAME}.h --module ${HPSNAME}"

synth: ${SOPCINFO}
	@quartus_sh --flow compile ${QPFFILE}

check_timing: synth
	@echo "Check for timing violations. Any found will be shown below:"
	@bash -c "grep \"Info\" ${OPFILEDIR}/${TOPNAME}.sta.rpt | grep \"Worst.*slack is -\" || true"

qsys: ${SOPCINFO}
hps: ${HPSNAME}.h

clean:
	@rm -rf .qsys_edit               \
            db                       \
            hps_isw_handoff          \
            incremental_db           \
            ${SYSTOPNAME}            \
            c5_pin_model_dump.txt    \
            hps_sdram_p0_summary.csv \
            ${TOPNAME}.qws           \
            ${SYSTOPNAME}.sopcinfo   \
            output_files             \
            ${HPSNAME}.h