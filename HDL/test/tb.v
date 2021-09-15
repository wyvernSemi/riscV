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
`define HALT_TIMEOUT_COUNT             10000
`define HALT_ADDR                      32'h00000040

`define RV32I_NOP                      32'h00000013
`define RV32I_UNIMP                    32'hc0001073

// ========================================================
// Test bench module
// ========================================================

module tb
#(parameter
    GUI_RUN                          = 0,
    HALT_ON_ADDR                     = 0,
    CLK_FREQ_MHZ                     = 100,
    RESET_ADDR                       = 32'h00000000,
    TRAP_ADDR                        = 32'h00000004,
    LOG2_REGFILE_ENTRIES             = 5,               // 5 for RV32I, 4 for RV32E
    REGFILE_USE_MEM                  = 1
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
reg            ireaddatavalid;
wire    [31:0] ireaddata;
wire    [31:0] irdata;

// Data memory and interface signals
wire    [31:0] daddress;
wire           dread;
wire    [31:0] dreaddata;
wire           dwrite;
wire    [31:0] dwritedata;
wire     [3:0] dbyteenable;
wire           dwaitreq;
reg            dread_dly;

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
     (ireaddatavalid == 1'b1 && (ireaddata == 32'h00000000 || ireaddata == `RV32I_UNIMP)) ||
     (HALT_ON_ADDR && iread && iaddress == `HALT_ADDR))
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

always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    ireaddatavalid                     <= 1'b0;
    dread_dly                          <= 1'b0;
  end
  else
  begin
    ireaddatavalid                     <= iread;
    dread_dly                          <= dread & ~dread_dly;
  end
end

assign ireaddata                       = ireaddatavalid ? irdata : `RV32I_NOP;

assign dwaitreq                        = dread & ~dread_dly;

// ---------------------------------------------------------
// Memories
// ---------------------------------------------------------

  // IMEM
  dp_ram #(
    .DATA_WIDTH                        (32),
    .ADDR_WIDTH                        (12),
    .OP_REGISTERED                     ("UNREGISTERED"),
    .INIT_FILE                         ("test.mif")
  ) imem
  (
    .clock                             (clk),

    .wren                              (1'b0),
    .byteena_a                         (4'b1111),
    .wraddress                         (12'h0),
    .data                              (32'h0),

    .rdaddress                         (iaddress[11:0]),
    .q                                 (irdata)
  );

  // DMEM
  dp_ram #(
    .DATA_WIDTH                        (32),
    .ADDR_WIDTH                        (12),
    .OP_REGISTERED                     ("UNREGISTERED"),
    .INIT_FILE                         ("UNUSED")
  ) dmem
  (
    .clock                             (clk),

    .wren                              (dwrite),
    .byteena_a                         (dbyteenable),
    .wraddress                         (daddress[11:0]),
    .data                              (dwritedata),

    .rdaddress                         (daddress[11:0]),
    .q                                 (dreaddata)
  );

// --------------------------------------------------------
// UUT
// --------------------------------------------------------

  rv32i_cpu_core #(
    .RV32I_RESET_VECTOR                (RESET_ADDR),   
    .RV32I_TRAP_VECTOR                 (TRAP_ADDR),         
    .RV32I_LOG2_REGFILE_ENTRIES        (LOG2_REGFILE_ENTRIES),
    .RV32I_REGFILE_USE_MEM             (REGFILE_USE_MEM)
    
  ) uut
  (
    .clk                               (clk),
    .reset_n                           (reset_n),
  
    .iaddress                          (iaddress),
    .iread                             (iread),
    .ireaddata                         (ireaddata),
  
    .daddress                          (daddress),
    .dwrite                            (dwrite),
    .dwritedata                        (dwritedata),
    .dbyteenable                       (dbyteenable),
    .dread                             (dread),
    .dreaddata                         (dreaddata),
    .dwaitrequest                      (dwaitreq),
    
    .irq                               (1'b0)
  );

endmodule