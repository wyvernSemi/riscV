###################################################################
#
# Copyright (c) 2021 - 2024 Simon Southwell. All rights reserved.
#
# Date: 14th August 2021
#
# Make file compiling Linux, MSYS2/mingw64 library, and MSVC batch
# build (make still run under MSYS2/mingw64)
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
#
# To build 64-bit executable for Linux or for MSYS2/mingw64 use:
#       make
#
# To build 32-bit executable for Linux or for MSYS2/mingw64 use:
#       make ARCHFLAG=-m32
#
# To adjust optimisations (defaults to -g) use:
#       make OPTFLAGS=<opt flags> ...
#
# To build Visual C++ executable use (defaults to compiling x64 Debug):
#       make MSVC
#
# To adjust which Visual C++ target to build use:
#       make MSCFG=[Debug|Release] MSVCPLATFORM=[x64|x86] MSVC
#
# To build for all Visual C++ configurations and platforms use:
#       make ALLMSVC
#
###################################################################

# Get OS type
OSTYPE:=$(shell uname)

#
# Compilation variables
#
PROJECT         = rv32
VOBJDIR         = obj
SRCDIR          = src
VLIB            = lib$(PROJECT).a
ARCHFLAG        = -m64
OPTFLAGS        = -g

#
# List of source files for library
#
LIB_CPP_BASE    = rv32i_cpu_elf.cpp                     \
                  rv32_cpu_gdb.cpp                      \
                  rv32i_cpu.cpp                         \
                  rv32csr_cpu.cpp                       \
                  rv32m_cpu.cpp                         \
                  rv32a_cpu.cpp                         \
                  rv32f_cpu.cpp                         \
                  rv32d_cpu.cpp                         \
                  rv32c_cpu.cpp

# List of additional files for executable
EXEC_CPP_BASE   = cpurv32i.cpp                          \
                  uart.cpp
                  
EXEC_C_BASE     = mem.c                                 \
                  ini.c

#
# All source code with path
#
ALLSRC          = $(addprefix $(SRCDIR)/, $(LIB_CPP_BASE) $(EXEC_CPP_BASE) $(EXEC_C_BASE))

#
# List of source header files
#
HEADERS         = uart.h                                \
                  ini.h                                 \
                  mem.h                                 \
                  rv32i_cpu_elf.h                       \
                  rv32_cpu_gdb.h                        \
                  rv32i_cpu.h                           \
                  rv32csr_cpu.h                         \
                  rv32m_cpu.h                           \
                  rv32a_cpu.h                           \
                  rv32f_cpu.h                           \
                  rv32d_cpu.h                           \
                  rv32c_cpu.h                           \
                  rv32csr_cpu_hdr.h                     \
                  rv32i_cpu_hdr.h                       \
                  rv32_extensions.h                     \
                  rv32.h

#
# All source header files with path
#
ALLHDRS         = $(addprefix $(SRCDIR)/, $(HEADERS))

#
# List of object files to be compiled
#
VOBJS           = $(addprefix $(VOBJDIR)/, $(LIB_CPP_BASE:%.cpp=%.o))
VOBJSEXEC       = $(addprefix $(VOBJDIR)/, $(EXEC_CPP_BASE:%.cpp=%.o) $(EXEC_C_BASE:%.c=%.o))

#
# Compilation executables and flags
#
CC              = gcc
C++             = g++
CFLAGS          = -fPIC                                 \
                  $(ARCHFLAG)                           \
                  $(OPTFLAGS)                           \
                  $(USRFLAGS)                           \
                  -I$(SRCDIR)                           \
                  -D_REENTRANT

#
# Visual Studio variables
#
MSVCDIR         = visualstudio
MSVCCFG         = Debug
MSVCPLATFORM    = x64

#
# Visual studio compilation executable and flags
#
MSVCBUILD       = MSBuild.exe
MSVCCOMMARGS    = -nologo -v:q 
MSVCARGS        = $(MSVCCOMMARGS) -p:Configuration=$(MSVCCFG) -p:Platform=$(MSVCPLATFORM)
MSVCLOOPARGS    = $(MSVCCOMMARGS) -p:Configuration=$$cfg -p:Platform=$$platform
MSVCSLN         = $(MSVCDIR)/$(PROJECT)i.sln

#
# Set OS specific variables between Linux and Windows (MinGW)
#
ifeq ($(OSTYPE), Linux)
  EXEC          = $(PROJECT)
  LDFLAGS       =
else
  EXEC          = $(PROJECT).exe
  LDFLAGS       = -lWs2_32 
endif

#
# Target path, dependent on platform: x64 has own sub-directory
#
ifeq ($(MSVCPLATFORM), x64)
  MSVCTGT       = $(MSVCDIR)/$(MSVCPLATFORM)/$(MSVCCFG)/$(EXEC)
else
  MSVCTGT       = $(MSVCDIR)/$(MSVCCFG)/$(EXEC)
endif

# -----------------------------------------------------------------
# Build rules
# -----------------------------------------------------------------

# Default to builing MinGW library only
.PHONY: all
all: $(VOBJDIR) $(EXEC)

# Recipe for object files
$(VOBJDIR)/%.o: $(SRCDIR)/%.cpp $(ALLHDRS)
	@$(C++) -Wno-write-strings -c $(CFLAGS) $< -o $@

$(VOBJDIR)/%.o: $(SRCDIR)/%.c $(ALLHDRS)
	@$(CC) -Wno-write-strings -c $(CFLAGS) $< -o $@

# Recipe for library archive file
$(VLIB) : $(VOBJS) $(VOBJDIR)
	@ar cr $(VLIB) $(VOBJS)

$(EXEC) : $(VOBJSEXEC) $(VLIB)
	@$(C++) $(CFLAGS) $^ $(LDFLAGS) -o $@

# Recipe to make object files dependant on object folder
$(VOBJS): | $(VOBJDIR)

# Recipe to generate object folder
$(VOBJDIR):
	@mkdir $(VOBJDIR)

# Alias MSVC to target visual studio executable
.PHONY: $(MSVC)
MSVC: $(MSVCTGT)

# Recipe to use MSBuild to compile visual studio executable
$(MSVCTGT): $(ALLSRC) $(ALLHDRS)
	@$(MSVCBUILD) $(MSVCSLN) $(MSVCARGS)

# Compile for all configurations and platforms
.PHONY: ALLMSVC
ALLMSVC: 
	@for cfg in Debug Release ;                            \
    do                                                     \
      for platform in x86 x64 ;                            \
      do                                                   \
        $(MSVCBUILD) $(MSVCSLN) $(MSVCLOOPARGS) ;          \
      done ;                                               \
    done

# Recipe to clean Visual studio C++ intermediate files
.PHONY: cleanmsvc
cleanmsvc:
  ifneq ($(OSTYPE), Linux)
	@for cfg in Debug Release ;                            \
    do                                                     \
      for platform in x86 x64 ;                            \
      do                                                   \
        $(MSVCBUILD) $(MSVCSLN) $(MSVCLOOPARGS) -t:clean ; \
      done ;                                               \
    done 
  endif

# Recipe to clean intermediate files
.PHONY: clean
clean: cleanmsvc
	@rm -rf $(EXEC)
	@rm -rf $(VOBJDIR)
	@rm -rf $(VLIB)
