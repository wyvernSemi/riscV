// -----------------------------------------------------------------------------
//  Title      : Core test module (optionally instantiated_
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : core_test.v
//  Author     : Simon Southwell
//  Created    : 2021-09-25
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block is used (if instantiated) to control the running of the 
//  rv32i_cpu_core, and extraction of pass/fail data
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

`timescale                     1ns / 10ps
`include                       "rv32.vh"

`define GP_IDX                 5'd3
`define UNIMP_INSTR            32'hC0001073
`define UNIMP_INSTR_ALT        32'h00000000
`define ECALL_INSTR            32'h00000073

module core_test
(
  input             clk,
  input             reset_n,
  
  input      [31:0] iaddr,
  input      [31:0] irdata,
  input             iread,
  input             iwaitreq,
  
  input             halt_on_unimp,
  input             halt_on_ecall,
  input             halt_on_addr,
  input      [31:0] halt_addr,
  input             clr_halt,
  
  input       [4:0] rd_idx,
  input      [31:0] rd_val,
  
  output reg        halt,
  output reg [31:0] gp
);

always @(posedge clk `RESET)
begin
  if (reset_n == 1'b0)
  begin
    halt                       <= 1'b1;
  end
  else
  begin
    if ((halt_on_unimp == 1'b1 && (iread == 1'b1 && iwaitreq == 1'b0 && (irdata == `UNIMP_INSTR || irdata == `UNIMP_INSTR_ALT))) ||
        (halt_on_ecall == 1'b1 && (iread == 1'b1 && iwaitreq == 1'b0 &&  irdata == `ECALL_INSTR)) ||
        (halt_on_addr  == 1'b1 && (iread == 1'b1 && iaddr == halt_addr)))
    begin
      halt                     <= 1'b1;
    end
    
    if (clr_halt == 1'b1)
    begin
      halt                     <= 1'b0;
    end
    
    if (rd_idx == `GP_IDX)
    begin
      gp                       <= rd_val;
    end
 
  end
  
end

endmodule