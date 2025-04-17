
![announce](https://github.com/user-attachments/assets/c709202e-d11f-4168-9cfb-725e6ff294ab)
# rv32 RISC-V 32-bit Instruction Set Simulator

The rv32 instruction set simulator (ISS) is a configurable and extensible C++ model of a 32-bit
RISC-V core capable of running at speeds of >10MIPS (executing a test program with
concurrent processes on FreeRTOS, running on an i5-8400 core @2.80GHz). A summary of
the model's main features is shown below.

* RV32I ISA model
  * Support for RV32E via compile option
* Zicsr extensions, with CSR instructions and registers
* RV32G extensions (configurable)
  * RV32M (multiply/divide)
  * RV32A (atomic)
  * RV32F (floating point)
  * RV32D (double precision floating point)
* RV32C compression extensions (configurable)
* RV32B (bit manipulation)
  * RVZBA
  * RVZBB
  * RVZBS
* Single HART
* Only Machine (M) privilege currently mode supported
* Trap handling (with Zicsr extension)
* Cycle count and real-time clock models
* Interrupt handling (with Zicsr extension)
  * External interrupts
  * Timer interrupts
  * Software interrupts
* Basic internal memory model (1MBytes)
* User registerable external callback functions
  * For memory accesses
  * For interrupts
  * For unimplemented instructions
* Disassembler, both run-time and static
* Loading of ELF programs to memory
* Debugging interface for gdb remote target
* Co-simulation support

The model can be configured to enable/disable the instruction extensions via a python GUI.
