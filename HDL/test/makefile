###################################################################
# Makefile for rv32i_cpu testcode in Modelsim
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


# Set up Variables for tools
MODELSIMDIR        = c:\altera\ver\modelsim_ase

VSIMEXE            = ${MODELSIMDIR}\\win32aloem\\vsim
VSIMARGS           =

# Location for core files
COREDIR            = ../de10-nano/src
COREHWTCLFILE      = ${COREDIR}/core_hw.tcl

# Name of auto-generated list of core source files
COREVLOGTCLFILE    = files_core_auto.tcl

CMDSHELL           = cmd

#------------------------------------------------------
# BUILD RULES
#------------------------------------------------------

# Build is dependant on generating the auto-gen file and
# processing makefile in vproc
all: compile

${COREVLOGTCLFILE}: ${COREHWTCLFILE}
	@awk '/^#/{next}/VERILOG/{print "${COREDIR}/" $$5}' $< > $@

compile: ${COREVLOGTCLFILE}
	@${VSIMEXE} -c -do compile.do -do quit

#------------------------------------------------------
# EXECUTION RULES
#------------------------------------------------------

run: all
	@${VSIMEXE} -c -do sim.do ${VSIMARGS}

rungui: all
	@${VSIMEXE} -gui -do simg.do ${VSIMARGS}

runlog: all
	@awk -F" " '/add wave/{print "log " $$NF}' < wave.do > batch.do
	@${VSIMEXE} -c -do simlog.do ${VSIMARGS}

waves:
	@${VSIMEXE} -view vsim.wlf -do wave.do
    
regression: 
	@${CMDSHELL} "/c run32i_tests.bat"

gui: rungui

sim: run

log: runlog

help:
	@echo "make               Build code without running simulation"
	@echo "make compile       Build HDL code without running simulation (same as make)"
	@echo "make run/sim       Build and run batch simulation"
	@echo "make rungui/gui    Build and run GUI simulation"
	@echo "make runlog/log    Build and run batch simulation with signal logging"
	@echo "make waves         Run wave viewer in ModelSim (to view runlog signals)"
	@echo "make regression    Run the regression test"
	@echo "make clean         clean previous build artefacts"
	@echo "make help          Display this message"

#------------------------------------------------------
# CLEANING RULES
#------------------------------------------------------

clean:
	@vsim -c -do cleanvlib.do -do quit
	@rm -rf vsim.wlf
	@rm -rf batch.do
	@rm -rf transcript
	@rm -rf *.log
	@rm -rf transcript
	@rm -rf ${COREVLOGTCLFILE}
	@make -f makefile.test clean
