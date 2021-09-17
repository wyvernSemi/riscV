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

`define RESET_PERIOD                   10
`define HALT_TIMEOUT_COUNT             2000
`define HALT_ADDR                      32'h00000040

`define RV32I_NOP                      32'h00000013
`define RV32I_UNIMP                    32'hc0001073

// ========================================================
// Test bench module
// ========================================================

module tb
#(parameter
  GUI_RUN                              = 0,
  HALT_ON_ADDR                         = 1,
  HALT_ON_UNIMP                        = 1,
  CLK_FREQ_MHZ                         = 100,
  RESET_ADDR                           = 32'h00000000,
  TRAP_ADDR                            = 32'h00000004,
  LOG2_REGFILE_ENTRIES                 = 5,               // 5 for RV32I, 4 for RV32E
  REGFILE_USE_MEM                      = 1,
  DMEM_ADDR_WIDTH                      = 16,
  IMEM_ADDR_WIDTH                      = 16,
  IMEM_INIT_FILE                       = "test.mif",
  ENABLE_ECALL                         = 0,               // **TEST ONLY**: 1 => enable ecall instruction, 0 => ecall is nop
  IMEM_SHADOW_WR                       = 1                // **TEST ONLY**: 1 => shadow dmem writes to imem, 0 => no shadow writes
)
(/* no ports */);

// --------------------------------------------------------
// Signals
// --------------------------------------------------------

// Clock and reset signals
reg            clk;
wire           reset_n;
integer        count;

// Instruction memory and interface signals
wire    [31:0] iaddress;
wire           iread;
wire           ireaddatavalid;
wire    [31:0] ireaddata;

wire    [31:0] avs_csr_address;
wire           avs_csr_write;
wire    [31:0] avs_csr_writedata;
wire           avs_csr_read;
wire    [31:0] avs_csr_readdata;

wire    [31:0] gp_reg = tb.uut.rv32i_cpu_core_inst.regfile.mem.regfile1.altsyncram_component.m_default.altsyncram_inst.mem_data[3];
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

always #(1000/CLK_FREQ_MHZ) clk        = ~clk;

// --------------------------------------------------------
// Simulation control process
// --------------------------------------------------------

always @(posedge clk)
begin
  // Maintain a count for test bench control
  count                                <= count + 1;

  // Stop or finish the simulation on reaching the HALT count or reading
  // an all zero (illegal) instruction.
  if (count == `HALT_TIMEOUT_COUNT ||
     (HALT_ON_UNIMP && ireaddatavalid == 1'b1 && (ireaddata == `RV32I_UNIMP)) ||
     (HALT_ON_ADDR  && iread                  && iaddress == `HALT_ADDR))
  begin
    if (count == `HALT_TIMEOUT_COUNT)
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
// Acccess imem read data bus for test bench control
// --------------------------------------------------------

assign iaddress                        = uut.imem_raddr;
assign ireaddatavalid                  = uut.imem_readdatavalid;
assign ireaddata                       = uut.imem_rdata;
assign iread                           = uut.imem_rd;

// --------------------------------------------------------
// Tie off CSR bus for now (program loaded directly to RAM)
// --------------------------------------------------------

assign avs_csr_read                    = 1'b0;
assign avs_csr_write                   = 1'b0;

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
    .RV32I_DMEM_INIT_FILE              (IMEM_INIT_FILE),
    .RV32I_ENABLE_ECALL                (ENABLE_ECALL),
    .RV32I_IMEM_SHADOW_WR              (IMEM_SHADOW_WR)
  )
  uut
  (
    .clk                               (clk),
    .reset_n                           (reset_n),

    .avs_csr_address                   (avs_csr_address[17:0]),
    .avs_csr_write                     (avs_csr_write),
    .avs_csr_writedata                 (avs_csr_writedata),
    .avs_csr_read                      (avs_csr_read),
    .avs_csr_readdata                  (avs_csr_readdata)
  );

endmodule