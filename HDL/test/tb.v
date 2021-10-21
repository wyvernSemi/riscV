// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32I ALU
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : tb.v
//  Author     : Simon Southwell
//  Created    : 2021-07-21
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//    This block defines top level test bench for the base (RV32I) RISC-V soft
//    processor.
// -----------------------------------------------------------------------------
//  Copyright (c) 2021 Simon Southwell
// -----------------------------------------------------------------------------
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  It is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this code. If not, see <http://www.gnu.org/licenses/>.
//
// -----------------------------------------------------------------------------

// --------------------------------------------------------
// Timescale
// --------------------------------------------------------

`timescale                             1ns / 10ps

// --------------------------------------------------------
// Definitions
// --------------------------------------------------------

// Define some timing points for simulation control
`define RESET_PERIOD                   10                   /* Reset period in clock cycles */
`define CORE_ENABLE_COUNT              (`RESET_PERIOD + 5)  /* Cycle to clear core halt status */
`define HALT_MONITOR_COUNT             (`RESET_PERIOD + 8)  /* Cycle to start monitoring for halt re-assertion */

// Core control register address and bits
`define CORE_CONTROL_ADDR              32'h00000000
`define CLR_HALT_BIT_MASK              32'h00000001
`define HALT_ON_ADDR_BIT_MASK          32'h00000002
`define HALT_ON_UNIMP_BIT_MASK         32'h00000004

// ========================================================
// Test bench module
// ========================================================

module tb
#(parameter
  // Test bench parameters
  GUI_RUN                              = 0,
  HALT_ON_ADDR                         = 1,
  HALT_ON_UNIMP                        = 1,
  CLK_FREQ_MHZ                         = 100,
  // UUT paramters
  RESET_ADDR                           = 32'h00000000,    // Default rv32i_cpu_core reset address
  TRAP_ADDR                            = 32'h00000004,    // Default rv32i_cpu_core trap vector address
  LOG2_REGFILE_ENTRIES                 = 5,               // 5 for RV32I, 4 for RV32E
  REGFILE_USE_MEM                      = 1,               // rv32i_cpu_core register file type. 1 => RAM based, 0 => logic based
  DMEM_ADDR_WIDTH                      = 16,              // rv32i_cpu_core data memory address width (i.e. 2^DMEM_ADDR_WIDTH = num words)
  IMEM_ADDR_WIDTH                      = 16,              // rv32i_cpu_core instruction memory address width (i.e. 2^IMEM_ADDR_WIDTH = num words)
  IMEM_INIT_FILE                       = "test.mif",      // IMEM initialisation file ("UNUSED" for no initialisation file)
  ZICSR_EN                             = 1,               // rv32i_cpu_core Enable/disable Zicsr extensions
  ENABLE_ECALL                         = 0,               // **TEST ONLY**: 1 => enable ecall instruction, 0 => ecall is nop
  IMEM_SHADOW_WR                       = 1,               // **TEST ONLY**: 1 => shadow dmem writes to imem, 0 => no shadow writes
  INCL_TEST_BLOCK                      = 1,               // **TEST ONLY**: 1 => include core test block logic, 0 => no test block
  TIMEOUT_COUNT                        = 10000
)
(/* no ports */);

// --------------------------------------------------------
// Signals
// --------------------------------------------------------

// Clock and reset signals
reg            clk;
wire           reset_n;
integer        count;

// Core test halt signal
wire           test_halt;

reg     [31:0] avs_csr_address;
reg            avs_csr_write;
reg     [31:0] avs_csr_writedata;
wire           avs_csr_read;
wire    [31:0] avs_csr_readdata;

wire    [31:0] gp_reg = tb.uut.test_gp;
wire    [31:0] pc     = tb.uut.rv32i_cpu_core_inst.regfile.pc;

// --------------------------------------------------------
// Initialisation
// --------------------------------------------------------
initial
begin
   count                               = 0;
   clk                                 = 1'b0;
end

// --------------------------------------------------------
// Generate a clock based on parameter
// --------------------------------------------------------

always #((1000/CLK_FREQ_MHZ)/2) clk    = ~clk;

// --------------------------------------------------------
// Simulation control process
// --------------------------------------------------------

always @(posedge clk)
begin
  // Maintain a count for test bench control
  count                                <= count + 1;

  // Stop or finish the simulation on reaching the HALT count or test_halt asserted
  if (count == TIMEOUT_COUNT || (test_halt == 1'b1 && count >= `HALT_MONITOR_COUNT))
  begin
    if (count == TIMEOUT_COUNT)
      $display("Test timed out : ***FAIL***");
    else if (gp_reg == 1)
      $display("Test exit code = %d : PASS (pc = 0x%08x)", gp_reg[31:1], pc);
    else
      $display("Test exit code = %d : ***FAIL***", gp_reg[31:1]);
    // In batch mode finish the simulation. In GUI mode stop it to allow inspection of signals.
    if (GUI_RUN == 0)
    begin
      $finish;
    end
    else
    begin
      $stop;
    end
  end
end

// --------------------------------------------------------
// Generate a reset signal using count
// --------------------------------------------------------

assign reset_n                         = (count >= `RESET_PERIOD) ? 1'b1 : 1'b0;

// --------------------------------------------------------
// Acccess test_halt signal from core
// --------------------------------------------------------

assign test_halt                       = uut.test_halt;

// --------------------------------------------------------
// Tie off CSR bus for now (program loaded directly to RAM)
// --------------------------------------------------------

assign avs_csr_read                    = 1'b0;

wire (pull1, pull0) irq_n              = 1'b1;

// Process to bring core out of reset shortly after reset_n released
// by writing to the core control register
always @(posedge clk)
begin
  avs_csr_write                        <= 1'b0;
  avs_csr_address                      <= `CORE_CONTROL_ADDR;
  avs_csr_writedata                    <= `CLR_HALT_BIT_MASK                                | 
                                          (HALT_ON_ADDR  ? `HALT_ON_ADDR_BIT_MASK  : 32'h0) | 
                                          (HALT_ON_UNIMP ? `HALT_ON_UNIMP_BIT_MASK : 32'h0);
  
  if (count == (`RESET_PERIOD + 5))
  begin
    avs_csr_write                      <= 1'b1;
  end
end

// --------------------------------------------------------
// UUT
// --------------------------------------------------------

  core
  #(.CLK_FREQ_MHZ                      (CLK_FREQ_MHZ),
    .RV32I_RESET_VECTOR                (RESET_ADDR),
    .RV32I_TRAP_VECTOR                 (TRAP_ADDR),
    .RV32I_LOG2_REGFILE_ENTRIES        (LOG2_REGFILE_ENTRIES),
    .RV32I_REGFILE_USE_MEM             (REGFILE_USE_MEM),
    .RV32I_DMEM_ADDR_WIDTH             (DMEM_ADDR_WIDTH),
    .RV32I_IMEM_ADDR_WIDTH             (IMEM_ADDR_WIDTH),
    .RV32I_IMEM_INIT_FILE              (IMEM_INIT_FILE),
    .RV32I_DMEM_INIT_FILE              (IMEM_INIT_FILE), // Load DMEM with same image as IMEM for fence_i test
    .RV32_ZICSR_EN                     (ZICSR_EN),
    .RV32I_ENABLE_ECALL                (ENABLE_ECALL),
    .RV32I_IMEM_SHADOW_WR              (IMEM_SHADOW_WR),
    .RV32I_INCL_TEST_BLOCK             (INCL_TEST_BLOCK)
  )
  uut
  (
    .clk                               (clk),
    .reset_n                           (reset_n),

    .avs_csr_address                   (avs_csr_address[17:0]),
    .avs_csr_write                     (avs_csr_write),
    .avs_csr_writedata                 (avs_csr_writedata),
    .avs_csr_read                      (avs_csr_read),
    .avs_csr_readdata                  (avs_csr_readdata),
    
    .gpio_in                           ({{71{1'bz}}, irq_n})
  );

endmodule