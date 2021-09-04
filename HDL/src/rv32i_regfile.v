// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32I register file
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : rv32i_regfile.v
//  Author     : Simon Southwell
//  Created    : 2021-07-22
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines a single HART register file for the base (RV32I) RISC-V
//  soft processor.
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

 `timescale 1ns / 10ps

module rv32i_regfile
#(parameter
    REGFILE_ENTRIES           = 32,
    RESET_VECTOR              = 32'h00000000
)
(
   input                      clk,
   input                      reset_n,
   
   input       [4:0]          rs1_idx,
   input       [4:0]          rs2_idx,
   input       [4:0]          rd_idx,
   input      [31:0]          new_rd,
   input      [31:0]          new_pc,
   input                      update_pc,
   input                      stall,
   
   output     [31:0]          rs1,
   output     [31:0]          rs2,
   output reg [31:0]          pc,
   output reg [31:0]          last_pc
);

reg [31:0] regfile [0:REGFILE_ENTRIES-1];

assign rs1                    = regfile[rs1_idx];
assign rs2                    = regfile[rs2_idx];

always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    pc                        <= RESET_VECTOR;
    regfile[0]                <= 32'h00000000;
  end
  else
  begin
    if (~stall)
    begin
      // Update PC
      last_pc                 <= pc;
      
      if (update_pc)
      begin
        pc                    <= new_pc + 32'h4;
      end
      else
      begin
        pc                    <= pc + 32'h4;
      end
      
      // Update rd if not x0
      if (rd_idx != 5'h0)
      begin
        regfile[rd_idx]       <= new_rd;
      end
    end
  end
end

endmodule