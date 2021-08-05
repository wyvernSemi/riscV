// -----------------------------------------------------------------------------
//  Title      : RISC-V virtual processor wrapper in verilog
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : riscVsim.v
//  Author     : Simon Southwell
//  Created    : 2021-08-01
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the top level for verilog wrapper around the rv32_cpu ISS
//  Using VProc
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

`timescale 1ns / 1ps

module riscVsim
 #(parameter          BE_ADDR = 32'hAFFFFFF0,
   parameter          NODE    = 0)
 (
    input             clk,

    // Memory mapped master interface
    output     [31:0] address,
    output reg        write,
    output     [31:0] writedata,
    output reg  [3:0] byteenable,
    output            read,
    input      [31:0] readdata,
    input             readdatavalid,
    
    input             irq
);

reg         irqDly;
reg         UpdateResponse;
wire        Update;
wire        WE;
wire [31:0] nodenum = NODE;

initial
begin
  irqDly          <= 1'b0;

  UpdateResponse  <= 1'b1;
  byteenable      <= 4'hf;
end


  VProc vp (
            .Clk                     (clk),
            .Addr                    (address),
            .WE                      (WE),
            .RD                      (read),
            .DataOut                 (writedata),
            .DataIn                  (readdata),
            .WRAck                   (WE),
            .RDAck                   (readdatavalid),
            .Interrupt               (3'b000),
            .Update                  (Update),
            .UpdateResponse          (UpdateResponse),
            .Node                    (nodenum[3:0])
           );


always @(Update)
begin
  if (WE == 1'b1 && address == BE_ADDR)
  begin
    byteenable         <= writedata[3:0];
    write              <= 1'b0;
  end
  else
  begin
    write              <= WE;
  end
  
  irqDly               <= irq;
  
  // When the irq state changes, call the user function with the updated value
  if (irq != irqDly)
  begin
     $vprocuser(nodenum, irq);
  end
  
  UpdateResponse = ~UpdateResponse;
end


endmodule