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

  output      [4:0]                    rs1,
  output      [4:0]                    rs2,
  output      [4:0]                    rd,
  output reg [31:0]                    instr,
  output                               instr_valid

);

wire  [1:0] opcode                     = cmp_instr[1:0];
wire  [2:0] funct3                     = cmp_instr[15:13];
wire        funct4                     = cmp_instr[12];

assign      rd                         = (opcode == 2'b00) ? {2'b01, cmp_instr[4:2]} :
                                         (opcode == 2'b01) ? {2'b01, cmp_instr[9:7]} :
                                                                     cmp_instr[11:7] ;

assign      rs1                        = (opcode == 2'b00) ? {2'b01, cmp_instr[9:7]} :
                                         (opcode == 2'b01) ? {2'b01, cmp_instr[9:7]} :
                                                                     cmp_instr[11:7] ;

assign      rs2                        = (opcode == 2'b00) ? {2'b01, cmp_instr[4:2]} :
                                         (opcode == 2'b01) ? {2'b01, cmp_instr[4:2]} :
                                                                     cmp_instr[6:2]  ;

wire       instr_partial_zeros         = ~|cmp_instr[12:2];

assign     instr_valid                 = ~&cmp_instr[1:0];


wire [11:0] nzuimm                     = {2'b00, cmp_instr[10:7], cmp_instr[12:11], cmp_instr[5], cmp_instr[6], 2'b00};
wire [11:0] uimm_fld                   = {3'b000, cmp_instr[6:5], cmp_instr[12:10], 3'b000};
wire [11:0] uimm_lq                    = {3'b000, cmp_instr[10],  cmp_instr[6:5], cmp_instr[12:11], 4'b0000};
wire [11:0] uimm_lw                    = {5'b00000, cmp_instr[5],   cmp_instr[12:10], cmp_instr[6], 2'b00};
wire [11:0] nzimm                      = {{7{cmp_instr[12]}}, cmp_instr[6:2]};
wire [20:0] jalimm                     = {{1{cmp_instr[12]}}, cmp_instr[8], cmp_instr[10:9], cmp_instr[6], cmp_instr[7], 
                                           cmp_instr[2], cmp_instr[11], cmp_instr[4:3]};
wire [11:0] spimm                      = {{4{cmp_instr[12]}}, cmp_instr[4:3], cmp_instr[5], cmp_instr[6], 4'b0000};
wire [19:0] luiimm                     = {{15{cmp_instr[12]}}, cmp_instr[6:2]};
wire [11:0] shnzuimm                   = {6'b000000, cmp_instr[6:2], cmp_instr[12]};
wire [12:0] bimm                       = {{5{cmp_instr[12]}}, cmp_instr[6:5], cmp_instr[2], cmp_instr[11:10], cmp_instr[4:3], 1'b0};

always @(*)
begin

  // Default instruction output to an illegal instruction
  instr                                <= 32'h00000000;
  
  case (opcode)

    // Quadrant 0
    2'b00:
    begin
      case(funct3)
       // c.addi4spm => addi rd, x2, nzuimm[9:2]
      3'b000:
      begin
        // If the other bits of instruction that aren't opcode and funct3 are not zero
        // process the instruction. If all are zero, leave output as illegal.
        if (~instr_partial_zeros)
        begin
          instr[6:0]                   <= `ADDI_OPCODE;
          instr[11:7]                  <= rd;
          instr[19:15]                 <= `SP_REG_IDX; // stack pointer for RS1
          instr[31:20]                 <= nzuimm;
        end
      end
      // c.fld => fld rd, imm*8(rs1+8)
      3'b001:
      begin
        instr[6:0]                     <= `FLD_OPCODE;
        instr[11:7]                    <= rd;
        instr[14:12]                   <= `FWIDTH_DBL;
        instr[19:15]                   <= rs1;
        instr[31:20]                   <= uimm_fld;
      end

      // c.lw => lw rd, offset[6:2](rs1)
      3'b010:
      begin
        instr[6:0]                     <= `LW_OPCODE;
        instr[11:7]                    <= rd;
        instr[14:12]                   <= `WIDTH_WORD;
        instr[19:15]                   <= rs1;
        instr[31:20]                   <= uimm_lw;
      end

      // c.flw => flw rd, imm*4(rs1+8)
      3'b011:
      begin
        instr[6:0]                     <= `FLD_OPCODE;
        instr[11:7]                    <= rd;
        instr[14:12]                   <= `FWIDTH_SGL;
        instr[19:15]                   <= rs1;
        instr[31:20]                   <= uimm_lw;
      end

      // c.fsd => fsd rs2, offset[7:3](rs1)
      3'b101:
      begin
        instr[6:0]                     <= `FSD_OPCODE;
        instr[11:7]                    <= uimm_fld[4:0];
        instr[14:12]                   <= `FWIDTH_DBL;
        instr[19:15]                   <= rs1;
        instr[24:20]                   <= rs2;
        instr[31:25]                   <= uimm_fld[11:5];
      end

      // c.sw => sw rs2, offset[6:2](rs1)
      3'b110:
      begin
        instr[6:0]                     <= `SW_OPCODE;
        instr[11:7]                    <= uimm_lw[4:0];
        instr[14:12]                   <= `FWIDTH_SGL;
        instr[19:15]                   <= rs1;
        instr[24:20]                   <= rs2;
        instr[31:25]                   <= uimm_lw[11:5];
      end

      // c.fsw => fsw rs2, offset[6:2](rs1)
      3'b111:
      begin
        instr[6:0]                     <= `FSW_OPCODE;
        instr[11:7]                    <= uimm_lw[4:0];
        instr[14:12]                   <= `FWIDTH_SGL;
        instr[19:15]                   <= rs1;
        instr[24:20]                   <= rs2;
        instr[31:25]                   <= uimm_lw[11:5];
      end

      // Reserved
      default:
      begin
      end
      
      endcase
    end

    // Quadrant 1
    2'b01:
    begin
      case(funct3)
      // c.addi => addi rd, rd, imm
      3'b000:
      begin
        instr[6:0]                     <= `ADDI_OPCODE;
        instr[11:7]                    <= rd;
        instr[19:15]                   <= rs1;
        instr[31:20]                   <= nzimm;
      end

      // c.jal => jal ra, rs1, 0
      3'b001:
      begin
        instr[6:0]                     <= `J_OPCODE;
        instr[11:7]                    <= 5'h1;             // x1 is return address
        instr[19:12]                   <= jalimm[19:12];
        instr[20]                      <= jalimm[11];
        instr[30:21]                   <= jalimm[10:1];
        instr[31]                      <= jalimm[20];
      end

      // li => addi rd, x0, imm
      3'b010:
      begin
        instr[6:0]                     <= `ADDI_OPCODE;
        instr[11:7]                    <= rd;
        instr[19:15]                   <= 5'h0;
        instr[31:20]                   <= nzimm;
      end

      // lui/addi16sp
      3'b011:
      begin
        // addi16sp
        if (cmp_instr[11:7] == 5'h2)
        begin
          instr[6:0]                     <= `ADDI_OPCODE;
          instr[11:7]                    <= 5'h2;
          instr[19:15]                   <= 5'h2;
          instr[31:20]                   <= spimm;
        end
        // LUI
        else
        begin
          instr[6:0]                     <= `LUI_OPCODE;
          instr[11:7]                    <= rd;
          instr[31:12]                   <= luiimm;
        end
      end

      // MISC-ALU
      3'b100:
      begin

        // c.srli
        if (cmp_instr[11:10] == 2'b00)
        begin
          instr[6:0]                 <= `ADD_OPCODE;
          instr[11:7]                <= rd;
          instr[14:12]               <= 3'h5;
          instr[19:15]               <= rs1;
          instr[31:20]               <= shnzuimm;
        end
        // c.srai
        else if (cmp_instr[11:10] == 2'b01)
        begin
          instr[6:0]                 <= `ADD_OPCODE;
          instr[11:7]                <= rd;
          instr[14:12]               <= 3'h5;
          instr[19:15]               <= rs1;
          instr[31:20]               <= shnzuimm;
          instr[30]                  <= 1'b1;
        end
        // c.andi
        else if (cmp_instr[11:10] == 2'b10)
        begin
          instr[6:0]                 <= `ADD_OPCODE;
          instr[11:7]                <= rd;
          instr[14:12]               <= 3'h7;
          instr[19:15]               <= rs1;
          instr[31:20]               <= nzimm;
        end
        else
        begin
          // If not RV64/RV128 or reserved...
          if (cmp_instr[12] == 1'b0)
          begin
            instr[6:0]                 <= `ADD_OPCODE;
            instr[11:7]                <= rd;
            instr[19:15]               <= rs1;
            instr[24:20]               <= rs2;
            // c.sub
            if (cmp_instr[6:5] == 2'b00)
            begin
              instr[30]                <= 1'b1;
            end
            // c.xor
            else if (cmp_instr[6:5] == 2'b01)
            begin
              instr[14:12]             <= 3'h4;
            end
            // c.or
            else if (cmp_instr[6:5] == 2'b10)
            begin
              instr[14:12]             <= 3'h6;
            end
            // c.and
            else
            begin
              instr[14:12]             <= 3'h7;
            end
          end
        end
      end

      // c.j => jal ra, imm
      3'b101:
      begin
        instr[6:0]                     <= `J_OPCODE;
        instr[11:7]                    <= 5'h0;
        instr[19:12]                   <= jalimm[19:12];
        instr[20]                      <= jalimm[11];
        instr[30:21]                   <= jalimm[10:1];
        instr[31]                      <= jalimm[20];
      end

      // c.beqz
      3'b110:
      begin
        instr[6:0]                     <= `BRANCH_OPCODE;
        instr[7]                       <= bimm[11];
        instr[11:8]                    <= bimm[4:1];
        instr[14:12]                   <= 3'b000;
        instr[19:15]                   <= rs1;
        instr[24:20]                   <= 5'h0;
        instr[30:25]                   <= bimm[10:5];
        instr[31]                      <= bimm[12];
      end

      // c.bnez
      3'b111:
      begin
        instr[6:0]                     <= `BRANCH_OPCODE;
        instr[7]                       <= bimm[11];
        instr[11:8]                    <= bimm[4:1];
        instr[14:12]                   <= 3'b001;
        instr[19:15]                   <= rs1;
        instr[24:20]                   <= 5'h0;
        instr[30:25]                   <= bimm[10:5];
        instr[31]                      <= bimm[12];
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