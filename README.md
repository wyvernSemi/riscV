# riscV
An open source Verilog  Softcore and C++ Instruction Set Simulator and logic RISC-V 32 bit project. The project is meant to be an informative and educational exercise in the contruction of processor models and logic implementations, using the RISC-V open-source architecture as a base, as a modern, relevant, processor architecture.

The project, at this time, limits itself to the 32 bit specifications, but the implementations are architected to be an expandable implementation that can mix and match the various RISC-V expansion specifications (see HDL/doc/manual.pdf and iss/doc/iss_manual.pdf).

## HDL

<p align="center">
<img src="https://github.com/wyvernSemi/riscV/assets/21970031/2f990f74-3681-44f7-aab2-d425e8599b4d" width=600>
</p>

The Verilog Softcore has the following features

*	All RV32I instructions implemented
	*	Configurable for RV32E
	*	Single HART
*	Configurable Zicsr extensions
	* csrrw, csrrs, csrrc, csrrwi, csrrsi, csrrci, mret instructions implemented
	* Sub-set of all possible machine registers implemented (see manual)
	* cycle counts, timer and retired insructions counts readable via unprivileged registers
	* Timer and retired instruction counts removable via parameters to save area
*	Configurable RV32M extension functionality
	* mul, mulh, mulhu, mulhsu, div, divu, rem and remu instructions implemented
    * Configuarble for implied DSP multiplier inference and for repated operand optimisations
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

## ISS
<p align="center">
<img src="https://github.com/wyvernSemi/riscV/assets/21970031/61eb37df-3997-43bc-aaf7-9a63da63149c" width=600>
</p>

The ISS has the following features:

* RV32I ISA model
	* Support for RV32E via compile option
* Standard extension support
	* Zicsr extension with CSR instructions and registers
	* RV32G extensions
		* RV32M, RV32A, RV32F and RV32D
	* RV32C extension
	* RV32B extensions
		* RV32ZBA, RV32ZBB and RV32ZBS	
	* RV32Zbc extension
* Single HART
* Machine (M) privilege mode supported
* Trap handling
* Configurable instruction timing model
* Internal timer model using cycle count or real-time clock
* Instructions retired count
* Interrupt handling
	* External interrupts
	* Timer interrupts
	* Software interrupts
* Internal memory model (1MBytes)
* User registerable extenal callback functions
	* External memory callback 
	* External interrupt callback
 	* Unimplemented instructions callback 
* Disassembler, both run-time and static
* Loading of ELF programs to memory
* Remote gdb debug interface for connection to gdb/IDEs
* Co-simulation support for connecting to a logic simulator
