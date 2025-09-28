# _rv32_ RISC-V Instruction Set Simulator

| Revision  |  Change Summary | 
------------|----------- 
| 1.2.10    | Minor corrections to rv32cfg.py layout |
| 1.2.9     | Bug fixes |
| 1.2.8     | Minor changes |
| 1.2.7     | .ini config update |
| 1.2.6     | New command line options |
| 1.2.5     | Loading a binary program |
| 1.2.4     | Support for handling more ELF headers |
| 1.2.3     | Regression script improvements |
| 1.2.2     | Adding Zbc extension support |
| 1.2.1     | Minor Changes |
| 1.2.0     | Adding B extension support |
| 1.1.6     | Fix to sNaN functionality | 
| 1.1.5     | Fixes to parent class method calls |
| 1.1.4     | gdb run fixes |
| 1.1.3     | Added performance measurements |
| 1.1.2     | Fix to loading ELF with unaligned EOF |
| 1.1.1     | Added timing model configurability |
| 1.0.0     | First official release |

## 1.2.10 28th September 2025
* Minor corrections to rv32cfg.py layout 

## 1.2.9  3rd June 2025
* Bug fixes for configuration of loading binary file

## 1.2.8  2nd June 2025
* Changes to scle output if displaying number of executed instructions

## 1.2.7  2nd June 2025
* Added the configuring of a binary file load in .ini file

## 1.2.6  30th May 2025
* Added ability to load binary file in place of an ELF
* Updated command line options to specify a binary load and at what address

## 1.2.5  24th May 2025
* Added a `read_binary()` method to `rv32i_cpu_elf.cpp` for loading a binary program image
  to a specified base address

## 1.2.4  22nd May 2025
* Increased the `ELF_MAX_NUM_PHDR` macro from 4 to 16 in `rv32_i_cpu_elf.h` to cope with
  executables that have more headers then previously encountered

## 1.2.3  26th April 2025
* Improvements to the `rv32i_tests.sh` scrit to make run the same for both Linux and MSYS/mingw64 (Windows)
* Will do a clean build before running the tests

## 1.2.2  24th April 2025
* Added Zbc standard extension support for carry-less multiplication
* Updated `rv32cfg.py` Python script to allow Zbc extension to be configured in or out
 
## 1.2.1  22nd April 2025
* Updated `makefile` to include RV322B extension files.

## 1.2.0  18th April 2025
* Added support for B bit manipulation extensions
* Consists of extensions Zba, Zbc and Zbs&mdash;Each of which have their own class
* Updated `rv32cfg.py` Python script to allow each sub-extension to be configured in or out

## 1.1.6  15th April 2025
* Fix to value of signalled not-a-number value (sNaN), highlighted by latest RISC-V International's
  unit tests.

## 1.1.5  14th April 2025
* Fix to `rv32csr_cpu::reset()` method's call to parent `reset()` method to take care of
  configuration of extensions
* Fix to `rv32csr_cpu::run()` method's call to parent `run()` method to take care of
  configuration extensions
* Fix in initialisation of PC state for each HART
* Fix to only report to console an illegal instruction if run-time disassble enabled.
* Removed redundant `access_csr()` and `csr_wr_mask()` place holder virtual methods from `rv32i_cpu` class

## 1.1.4  27th November 2024
* Fix to correct the running of a fixed number of instructions  when run from gdb interface

## 1.1.3  25th November 2024
* Update to print the instruction exection rate, in MIPS, at end of execution if configured to run
  for a given number of instructions.
* Updates to extenal interrupt vector bit assignments to add a software interrupt at bit 2
* Updates to inspect for external timer interrupt if a configuration flag has enabled this.

## 1.1.2  6th November 2024
* Fixed loading of ELF program when the end-of-file is not aligned on a 32-bit boundary due
  to the presence of compressed instructions.

## 1.1.1  28th October 2024
* Added configurability of timing model via external `rv32i_cpu` class `update_timing()` method.
* Fix to load and store instructions adding extra cycles to cycle_count.

## 1.0.0 18th July 2024
* First major release of model. Contains the following features:
  * RV32I ISA model
    * Support for RV32E via compile option
  * Standard extensions support
    * Zicsr extensions, with CSR instructions and registers
    * RV32G extensions (configurable)
      * RV32M (multiply/divide)
      * RV32A (atomic)
      * RV32F (floating point)
      * RV32D (double precision floating point)
    * RV32C compression extensions (configurable)
  * Single HART
  * Machine (M) privilege mode supported
  * Trap handling (with Zicsr extension)
  * Internal timer model using cycle count or real-time clock
  * Instructions retired count
  * Interrupt handling (with Zicsr extension)
    * External interrupts
    * Timer interrupts
  * Internal memory model (1MBytes)
  * User registerable external callback functions
    * For memory accesses
    * For interrupts
    * For unimplemented instructions
  * Disassembler, both run-time and static
  * Loading of ELF programs to memory
  * Debugging interface for gdb remote target
  * Co-simulation support

## Copyright and License
Copyright (C) 2021-2025 by Simon Southwell  

This file is part of riscV.

riscV is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

riscV is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with VProc. If not, see [http://www.gnu.org/licenses](http://www.gnu.org/licenses).