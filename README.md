# riscV
An open source Verilog  Softcore and C++ Instruction Set Simulator and logic RISC-V 32 bit project. The project is meant to be an informative and educational exercise in the contruction of processor models and logic implementations, using the RISC-V open-source architecture as a base, as a modern, relevant, processor architecture.

The project, at this time, limits itself to the 32 bit specifications, but the implementations are architected to be an expandable implementation that can mix and match the various RISC-V expansion specifications (see HDL/doc/manual.pdf and iss/doc/iss_manual.pdf).

The Verilog Softcore has the following features

*	All RV32I instructions implemented
	*	Configurable for RV32E
	*	Single HART
*	Separate instruction and data memory interfaces (Harvard architecture)
*	5 deep pipeline architecture
*	1 cycle operations for all instructions except branch, jump and load
	*	Regfile update bypass feedback employed
*	Branch instructions take 1 cycle when not branching, 4 when branching
	*	‘never take’ branch prediction policy employed, with pipeline cancellation on branch
	*	Jump instruction takes 4 cycles
*	Load instructions take a minimum of 3 cycles, plus any additional wait states
*	Register file configurable between register or RAM based
	*	defaults to RAM based, using 2 × M10K RAM blocks
	*	Register based costs approximately 700ALMs (~1900 LEs)
*	Example simulation test bench provided
	*	Targets ModelSim
*	Example FPGA target platform using the terasIC DE10-nano development board (employing the Intel Cyclone V 5CSEBA6U23I7 FPGA).
	*	Targeting 100MHz clock operation
	*	< 1000 ALMs (~2600 LEs) when also employing Zicsr and RV32M extensions (RV32I implementation currently around 700 ALMs, ~1900 LEs).

The ISS has the following features:

*	RV32I ISA model
*	Support for RV32E via compile option
*	CSR instructions and registers
*	RV32G extensions
	*	RV32M
	*	RV32A
	*	RV32F
	*	RV32D
*	RV32C extensions	
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
*	Co-simulation support for connecting to a Verilog or mixed signal logic simulator
*	Remote gdb debug interface for connection to gdb/IDEs
