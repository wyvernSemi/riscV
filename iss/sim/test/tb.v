// -----------------------------------------------------------------------------
//  Title      : Test bench for memory model
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : tb.v
//  Author     : Simon Southwell
//  Created    : 2021-08-02
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the top level test bench for the memory model. Release
//  on asccess to VProc (github.com/wyvernSemi/vproc) located in the same
//  directory as this folder
// -----------------------------------------------------------------------------
//  Copyright (c) 2021 Simon Southwell
// -----------------------------------------------------------------------------
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation(), either version 3 of the License(), or
//  (at your option) any later version.
//
//  It is distributed in the hope that it will be useful(),
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this code. If not, see <http://www.gnu.org/licenses/>.
//
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

`define RESET_PERIOD    10
`define TIMEOUT_COUNT   400000

`define BE_ADDR         32'hAFFFFFF0
`define HALT_ADDR       32'hAFFFFFF8

module tb
#(parameter GUI_RUN          = 0,
  parameter CLK_FREQ_MHZ     = 100)
();


// Clock, reset and simulation control state
reg            clk;
wire           reset_n;
integer        count;

// Signals between CPU and memory model
wire [31:0]    address;
wire           write;
wire [31:0]    writedata;
wire  [3:0]    byteenable;
wire           read;
wire [31:0]    readdata;
wire           readdatavalid;

// -----------------------------------------------
// Initialisation, clock and reset
// -----------------------------------------------

initial
begin
   count                               = -1;
   clk                                 = 1'b1;
end

// Generate a clock
always #(500/CLK_FREQ_MHZ) clk         = ~clk;

// Generate a reset signal using count
assign reset_n                         = (count >= `RESET_PERIOD) ? 1'b1 : 1'b0;

// -----------------------------------------------
// Simulation control process
// -----------------------------------------------
always @(posedge clk)
begin
  count                                <= count + 1;

  // Stop/finish the simulations of timeout or a write to the halt address
  if (count == `TIMEOUT_COUNT || (write == 1'b1 && address == `HALT_ADDR))
  begin
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

  // -----------------------------------------------
  // Virtual CPU
  // -----------------------------------------------

 riscVsim  #(.BE_ADDR(`BE_ADDR)) cpu
 (
   .clk                     (clk),

   .address                 (address),
   .write                   (write),
   .writedata               (writedata),
   .byteenable              (byteenable),
   .read                    (read),
   .readdata                (readdata),
   .readdatavalid           (readdatavalid),

   .irq                     (1'b0)
 );

  // -----------------------------------------------
  // Memory model
  // -----------------------------------------------
  
  mem_model mem
  (
    .clk                    (clk),
    .rst_n                  (reset_n),

    .address                (address),
    .write                  (write),
    .writedata              (writedata),
    .byteenable             (byteenable),
    .read                   (read),
    .readdata               (readdata),
    .readdatavalid          (readdatavalid),

    .rx_waitrequest         (),
    .rx_burstcount          (),
    .rx_address             (),
    .rx_read                (1'b0),
    .rx_readdata            (),
    .rx_readdatavalid       (),

    .tx_waitrequest         (),
    .tx_burstcount          (),
    .tx_address             (),
    .tx_write               (1'b0),
    .tx_writedata           (),

    .wr_port_valid          (1'b0),
    .wr_port_data           (),
    .wr_port_addr           ()

  );


endmodule