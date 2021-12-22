// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32C compressed instruction decoder
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : rv32_c.v
//  Author     : Simon Southwell
//  Created    : 2021-11-24
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the RVC extension decoder for the (RV32I) RISC-V
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

`timescale                             1ns / 10ps

`define ADDI_OPCODE                    7'h13
`define FLD_OPCODE                     7'h07
`define FLW_OPCODE                     7'h07
`define FSD_OPCODE                     7'h27
`define FSW_OPCODE                     7'h27
`define LW_OPCODE                      7'h03
`define SW_OPCODE                      7'h23
`define J_OPCODE                       7'h6f
`define LUI_OPCODE                     7'h37
`define ADD_OPCODE                     7'h33
`define BRANCH_OPCODE                  7'h63
`define EBREAK_OPCODE                  7'h73
`define JALR_OPCODE                    7'h67

`define FWIDTH_SGL                     3'h2
`define FWIDTH_DBL                     3'h3
`define WIDTH_WORD                     3'h2

`define SP_REG_IDX                     5'h02
`define RA_REH_IDX                     5'h03

module rv32_c
(
  input                                clk,
  input                                reset_n,

  input      [15:0]                    cmp_instr,

  output      [4:0]                    rs1;
  output      [4:0]                    rs2;
  output      [4:0]                    rd;
  output     [31:0]                    instr,
  output                               instr_valid

);

wire  [1:0] opcode                     = cmp_instr[1:0];
wire  [2:0] funct3                     = cmp_instr[15:13];
wire        funct4                     = cmp_instr[12];

assign      rd                         = (opcode == 2'b00) ? {2'b01, cmp_instr[4:2]} :
                                         (opcode == 2'b01) ? {2'b01, cmp_instr[9:7]} :
                                                             {2'b01, cmp_instr[9:7]} ;

assign      rs1                        = (opcode == 2'b00) ? {2'b01, cmp_instr[9:7]} :
                                         (opcode == 2'b01) ? {2'b01, cmp_instr[9:7]} :
                                                             {2'b01, cmp_instr[9:7]} ;

assign      rs2                        = (opcode == 2'b00) ? {2'b01, cmp_instr[4:2]} :
                                         (opcode == 2'b01) ? {2'b01, cmp_instr[4:2]} :
                                                             {2'b01, cmp_instr[4:2]} ;

wire       instr_partial_zeros         = ~|cmp_instr[12:2];

assign     instr_valid                 = ~&cmp_instr[1:0];


wire  [7:0] nzuimm                     = {cmp_instr[10:7], cmp_instr[12:11], cmp_instr[5], cmp_instr[6]};
wire  [4:0] uimm_fld                   = {cmp_instr[6:5], cmp_instr[12:10]};
wire  [4:0] uimm_lq                    = {cmp_instr[10],  cmp_instr[6:5], cmp_instr[12:11]};
wire  [4:0] uimm_lw                    = {cmp_instr[5],   cmp_instr[12:10], cmp_instr[6]};

always @(*)
begin

  case (opcode)

    // Default instruction output to an illegal instruction
    instr                              <= 32'h00000000;

    // Quadrant 0
    2'b00:
    begin
      case(funct3)
       // c.addi4spm => addi rd, x2, nzuimm[9:2]
      3'b000:
      begin
        // If the other bits of instruction that aren't opcode and funct3, are not zero
        // process the instruction. If all are zero, leave output as illegal.
        if (~instr_partial_zeros)
        begin
          instr[6:0]                   <= `ADDI_OPCODE;
          instr[11:7]                  <= rd;
          instr[19:15]                 <= `SP_REG_IDX; // stack pointer for RS1
          instr[27:20]                 <= nzuimm;
        end
      end
      // c.fld => fld rd, imm*8(rs1+8)
      3'b001:
      begin
        instr[6:0]                     <= `FLD_OPCODE;
        instr[11:7]                    <= rd;
        instr[14:12]                   <= `FWIDTH_DBL;
        instr[19:15]                   <= rs1;
        instr[25:20]                   <= uimm_fld;
      end

      // c.lw => lw rd, offset[6:2](rs1)
      3'b010:
      begin
        instr[6:0]                     <= `LW_OPCODE;
        instr[11:7]                    <= rd;
        instr[14:12]                   <= `WIDTH_WORD;
        instr[19:15]                   <= rs1;
        instr[25:20]                   <= uimm_lw;
      end

      3'b011:
      begin
      end

      3'b101:
      begin
      end

      3'b110:
      begin
      end

      3'b111:
      begin
      end
      endcase

      // Reserved
      default:
      begin
      end
    end

    // Quadrant 1
    2'b01:
    begin
      case(funct3)
      3'b000:
      begin
      end

      3'b001:
      begin
      end

      3'b010:
      begin
      end

      3'b011:
      begin
      end

      3'b100:
      begin
      end

      3'b101:
      begin
      end

      3'b110:
      begin
      end

      3'b111:
      begin
      end
      endcase
    end

    // Quadrant 2
    default:
    begin
      case(funct3)
      3'b000:
      begin
      end

      3'b001:
      begin
      end

      3'b010:
      begin
      end

      3'b011:
      begin
      end

      3'b100:
      begin
      end

      3'b101:
      begin
      end

      3'b110:
      begin
      end

      3'b111:
      begin
      end
      endcase
    end

  endcase

end

endmodule