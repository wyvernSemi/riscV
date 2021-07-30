# riscV
An open source C++ Instruction Set Simulator and logic RISC-V 32 bit project. Currently the repository is for just the ISS (see iss/doc), but with plans for an FPGA targetted open-source softcore. The project is meant to be an informative and educational exercise in the contruction of processor models and logic implementations, using the RISC-V open-source architecture as a base, as a modern, relevant, processor architecture.

The project, at this time, limits itself to the 32 bit specifications, but the ISS is architected to be an expandable implementation that can mix and match the various RIC-V expansion specifications (see iss/doc/iss_manual.pdf).

The ISS has the following features:

*	RV32I ISA model
*	Support for RV32E via compile option
*	CSR instructions and registers
*	RV32M extensions
*	RV32A extensions
*	RV32F extensions
*	Single HART
*	Only Machine (M) privilege currently mode supported
*	Trap handling
*	Cycle count and real-time clock
*	Interrupt handling
*	External interrupts
*	Timer interrupts
*	Software interrupts
*	Basic internal memory model (16KBytes)
*	External memory callback feature
*	External interrupt callback feature
*	Disassembler, both run-time and static
*	Loading of ELF programs to memory
