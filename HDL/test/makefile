###################################################################
# Makefile for rb32i_cpu testcode in Modelsim
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

#------------------------------------------------------
# BUILD RULES
#------------------------------------------------------

# Build is dependant on generating the auto-gen file and
# processing makefile in vproc
all: compile

#------------------------------------------------------
# EXECUTION RULES
#------------------------------------------------------

run: all
	@${VSIMEXE} -c -do sim.do ${VSIMARGS}

rungui: all
	@${VSIMEXE} -gui -do wave.do -do simg.do ${VSIMARGS}
    
runlog: all
	@awk -F" " '/add wave/{print "log " $$NF}' < wave.do > batch.do
	@${VSIMEXE} -c -do simlog.do ${VSIMARGS}

compile: ${COREVHDLTCLFILE} ${COREVLOGTCLFILE}
	@${VSIMEXE} -c -do compile.do -do quit

waves:
	@${VSIMEXE} -view vsim.wlf -do wave.do

gui: rungui

sim: run

log: runlog

help:
	@echo "make               Build code without running simulation"
	@echo "make compile       Build HDL code without running simulation"
	@echo "make run/sim       Build and run batch simulation"
	@echo "make rungui/gui    Build and run GUI simulation"
	@echo "make runlog/log    Build and run batch simulation with signal logging"
	@echo "make waves         Run wave view in free starter ModelSim (to view runlog/runfree signals)"
	@echo "make help          Display this message"

#------------------------------------------------------
# CLEANING RULES
#------------------------------------------------------

clean:
	@rm -rf "*wlf*"
	@rm -rf "work"
	@rm -rf batch.do
	@rm -rf transcript
	@rm -rf "*.log"
	@vsim -c -do cleanvlib.do -do quit
