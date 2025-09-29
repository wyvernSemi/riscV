###################################################################
# Makefile for rv32 co-simulation with VProc virtual processor
#
# Copyright (c) 2021 - 2025 Simon Southwell.
#
# This file is part of rv32.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file. If not, see <http://www.gnu.org/licenses/>.
#
###################################################################

# Get OS type
OSTYPE:=$(shell uname)

# User files to build, passed into vproc makefile build
USERCODE           = VUserMain0.cpp mem_vproc_api.cpp
MEMCSRC            = mem.c mem_model.c

# Set up Variables for tools
MAKE_EXE           = make
VSIMEXE            = vsim
VSIMARGS           =

# Directories
MEMMODELDIR        = $(CURDIR)/../../../../mem_model
ISSDIR             = $(CURDIR)/../../
RV32LIBDIR         = $(CURDIR)/../../
VPROCDIR           = $(CURDIR)/../../../../vproc

# RV32 ISS library to build
RV32LIB            = $(RV32LIBDIR)/librv32.a

# C flags for user code
USRCFLAGS          = "-I$(MEMMODELDIR)/src             \
                      -I$(ISSDIR)/src                  \
                      -DINCL_VLOG_MEM_MODEL            \
                      -DMEM_MODEL_DEFAULT_ENDIAN=1"

# Shared object link flags
SIMFLAGSSO         = -L$(MODEL_TECH) -lmtipli -L$(ISSDIR) -lrv32

# For windows the Ws2 library must be tagged on the end of the link command
ifneq ($(OSTYPE), Linux)
  POSTVPROCSOFLAGS = -lws2_32
endif

# Command to compile verilog
HDLCMD             = vlog +define+VPROC_BURST_IF       \
                          +define+VPROC_BYTE_INTERFACE \
                          +incdir+$(VPROCDIR)          \
                          -f files_vlog.tcl            \
                          -work work

#------------------------------------------------------
# MODEL_TECH path

# If run from a place where MODEL_TECH is not defined, construct from path to PLI library
ifeq ("$(MODEL_TECH)", "")
  ifeq ($(OSTYPE), Linux)
    PLILIB         = libmtipli.so
  else
    PLILIB         = mtipli.dll
  endif

  VSIMPATH         = $(shell which vsim)
  SIMROOT          = $(shell dirname $(VSIMPATH))/..
  PLILIBPATH       = $(shell find $(SIMROOT) -name "$(PLILIB)")
  MODEL_TECH       = $(shell dirname $(PLILIBPATH))
endif

#------------------------------------------------------
# BUILD RULES
#------------------------------------------------------

.PHONY : vproc, all, hdl, run, rungui, runlog, compile, waves, gui, sim, log, help, clean

# Build is dependent on processing makefile in vproc and riscV/iss
all: $(RV32LIB) vproc hdl

$(RV32LIB):
	@$(MAKE_EXE) --no-print-directory -C $(RV32LIBDIR)

# Call the vproc make file for it to determine if anything
# needs building.
vproc:
	@$(MAKE_EXE) $(CURDIR)/VProc.so                    \
	             --no-print-directory                  \
	             -C $(VPROCDIR)/test                   \
	             USRFLAGS=$(USRCFLAGS)                 \
	             USRCDIR=$(CURDIR)/src                 \
	             USER_C="$(USERCODE)"                  \
	             MEMMODELDIR=$(MEMMODELDIR)/src        \
	             MEM_C="$(MEMCSRC)"                    \
	             TESTDIR=$(CURDIR)                     \
	             SIMFLAGSSO="$(SIMFLAGSSO)"            \
	             POSTVPROCSOFLAGS=$(POSTVPROCSOFLAGS)  \
	             MODELSIMDIR="$(MODEL_TECH)\.."

hdl:
	@if [ ! -d "./work" ]; then                        \
	      vlib work;                                   \
	fi
	@$(HDLCMD)

#------------------------------------------------------
# EXECUTION RULES
#------------------------------------------------------

run: all
	@$(VSIMEXE) -c -do sim.do $(VSIMARGS)

rungui: all
	@$(VSIMEXE) -gui -do wave.do -do simg.do $(VSIMARGS)

runlog: all
	@awk -F" " '/add wave/(print "log " $$NF)' < wave.do > batch.do
	@$(VSIMEXE) -c -do simlog.do $(VSIMARGS)


compile:
	@$(VSIMEXE) -c -do compile.do -do quit

waves:
	@$(VSIMEXE) -view vsim.wlf -do wave.do

gui: rungui

sim: run

log: runlog

help:
	@echo "make help          Display this message"
	@echo "make               Build C/C++ code without running simulation"
	@echo "make compile       Build HDL code without running simulation"
	@echo "make run/sim       Build and run batch simulation"
	@echo "make rungui/gui    Build and run GUI simulation"
	@echo "make runlog/log    Build and run batch simulation with signal logging"
	@echo "make waves         Run wave view in free starter ModelSim (to view runlog signals)"
	@echo "make clean         clean previous build artefacts"

#------------------------------------------------------
# CLEANING RULES
#------------------------------------------------------

clean:
	@$(MAKE_EXE) --no-print-directory -C $(VPROCDIR)/test USER_C="$(USERCODE)" TESTDIR="$(CURDIR)" clean
	@$(MAKE_EXE) --no-print-directory -C $(RV32LIBDIR) clean
	@vsim -c -do cleanvlib.do -do quit
	@rm -rf vsim.wlf
	@rm -rf work
	@rm -rf transcript
