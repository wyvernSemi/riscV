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

`timescale                             1ns/10ps

// --------------------------------------------------------
// Definitions
// --------------------------------------------------------

`define RESET_PERIOD                   10
`define HALT_COUNT                     100
`define IMEM_SIZE_WORDS                2048
`define DMEM_SIZE_WORDS                2048

`define RV32I_NOP                      32'h00000013

// ========================================================
// Test bench module
// ========================================================

module tb
#(parameter
    GUI_RUN                          = 0,
    CLK_FREQ_MHZ                     = 100,
    RESET_ADDR                       = 0
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
reg     [31:0] imem [0:`IMEM_SIZE_WORDS-1];
wire    [31:0] iaddress;
wire           iread;
reg            ireaddatavalid;
reg     [31:0] ireaddata;

// Data memory and interface signals
reg      [7:0] dmem [0:3][0:`DMEM_SIZE_WORDS-1];
wire    [31:0] daddress;
wire           dread;
reg     [31:0] dreaddata;
wire           dwrite;
wire    [31:0] dwritedata;
wire     [3:0] dbyteenable;

// --------------------------------------------------------
// Initialisation
// --------------------------------------------------------
initial
begin
   // Load test program to memory
   $readmemh("test.hex", imem);

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
  if (count == `HALT_COUNT || (ireaddatavalid == 1'b1 && ireaddata == 32'h0))
  begin
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
// Emulate accesses to memory
// --------------------------------------------------------

always @(*)
begin

end

always @(posedge clk)
begin
  ireaddatavalid                       <= iread;
  ireaddata                            <= ireaddatavalid ? imem[iaddress[31:2] % `IMEM_SIZE_WORDS] : `RV32I_NOP;

  dreaddata                            <= {dmem[3][daddress[31:2] % `DMEM_SIZE_WORDS],
                                           dmem[2][daddress[31:2] % `DMEM_SIZE_WORDS],
                                           dmem[1][daddress[31:2] % `DMEM_SIZE_WORDS],
                                           dmem[0][daddress[31:2] % `DMEM_SIZE_WORDS]};
  
  if (dwrite)
  begin
    if (dbyteenable[0])
      dmem[0][daddress % `DMEM_SIZE_WORDS]  <= dwritedata[ 7:0];
    if (dbyteenable[1])
      dmem[1][daddress % `DMEM_SIZE_WORDS]  <= dwritedata[15:8];
    if (dbyteenable[2])
      dmem[2][daddress % `DMEM_SIZE_WORDS]  <= dwritedata[23:16];
    if (dbyteenable[3])
      dmem[3][daddress % `DMEM_SIZE_WORDS]  <= dwritedata[31:24];
  end
end

// --------------------------------------------------------
// UUT
// --------------------------------------------------------

  rv32i_cpu_core #(.RV32I_RESET_VECTOR(RESET_ADDR)) uut
  (
    .clk                               (clk),
    .reset_n                           (reset_n),
  
    .iaddress                          (iaddress),
    .iread                             (iread),
    .ireaddata                         (ireaddata),
    .iwaitrequest                      (~iread),
  
    .daddress                          (daddress),
    .dwrite                            (dwrite),
    .dwritedata                        (dwritedata),
    .dbyteenable                       (dbyteenable),
    .dread                             (dread),
    .dreaddata                         (dreaddata),
    .dwaitrequest                      (~dread),
    
    .irq                               (1'b0)
  );

endmodule