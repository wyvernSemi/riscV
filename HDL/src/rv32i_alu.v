// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32I ALU
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : rv32i_alu.v
//  Author     : Simon Southwell
//  Created    : 2021-07-21
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the ALU for the base (RV32I) RISC-V soft processor.
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


module rv32i_alu
(
  input                        clk,
  input                        reset_n,

  input  [31:0]                a_decode,         // rs1
  input  [31:0]                b_decode,         // rs2 or imm
  input  [31:0]                offset_decode,    // imm_b or imm_j  or imm_s or imm_i

  input   [4:0]                a_rs_idx,
  input   [4:0]                b_rs_idx,

  // Pipeline control
  input  [31:0]                pc_in,
  input   [4:0]                rd_in,            // 0 if no writeback
  input                        branch_in,        // a is pc, b is imm
  input                        jump_in,          // a is pc, b is imm
  input                        system_in,        // a is 0, b is trap vector
  input                        load_in,          // a is rs1, b is imm
  input                        store_in,         // a is rs1, b is rs2
  input   [1:0]                ld_store_width,   // 0 = byte, 1 = hword, 2 = word

  // Add/sub control
  input                        add_nsub,
  input                        arith,

  // Comparator control
  input                        cmp_unsigned,
  input                        cmp_is_lt,
  input                        cmp_is_ge,
  input                        cmp_is_eq,
  input                        cmp_is_ne,

  // Bitwise control
  input                        bit_is_and,
  input                        bit_is_or,
  input                        bit_is_xor,

  // Shift control
  input                        shift_arith,
  input                        shift_left,
  input                        shift_right,

  // Pipeline control
  output reg  [4:0]            rd,
  output reg                   update_pc,
  output reg                   load,
  output reg                   store,

  // Writeback data
  output reg [31:0]            pc,
  output reg [31:0]            c,

  // Memory access
  output reg [31:0]            addr,
  output reg  [3:0]            st_be,
  input      [31:0]            ld_data
);

reg                update_rd;

// The A and B inputs to the ALU logic come from the ALU output if the source register
// matches the destination register. Otherwise the regfile value (via decode) is
// used.
wire        [31:0] a            = (update_rd == 1'b1 && a_rs_idx == rd) ? c : a_decode;
wire        [31:0] b            = (update_rd == 1'b1 && b_rs_idx == rd) ? c : b_decode;

// The immediate value is always on the B input
wire        [31:0] imm          = b;

// ADD/SUB
wire        [31:0] add          = a + b;
wire        [31:0] sub          = a - b;
wire        [31:0] add_sub      = add_nsub ? add : sub;

// Signed values of A and B
wire signed [31:0] a_signed     = a;
wire signed [31:0] b_signed     = b;

// Comparison
wire               lt_unsigned  = (a        <  b);
wire               ge           = (a_signed >= b_signed);
wire               ge_unsigned  = (a        >= b);
wire               eq           = (a_signed == b_signed);
wire        [31:0] cmp          = {31'h0, (cmp_is_eq & eq) | (cmp_is_ne & ~eq) |
                                          (cmp_is_ge & ~cmp_unsigned &  ge)    | (cmp_is_ge & cmp_unsigned & ge_unsigned) |
                                          (cmp_is_lt & ~cmp_unsigned & ~ge)    | (cmp_is_lt & cmp_unsigned & lt_unsigned)};

// Bit operations
wire        [31:0] andop        = a & b;
wire        [31:0] orop         = a | b;
wire        [31:0] xorop        = a ^ b;

// Logic muxing of the logic functions
wire        [31:0] bitop        = ({32{bit_is_and}} & andop) | ({32{bit_is_or}} & orop) | ({32{bit_is_xor}} & xorop);

// Shift (if inefficient, design a shift module). Could combine
// into a single more generic shifter if area too large (will be slower).
wire        [31:0] sll          = a        <<  b[4:0];
wire        [31:0] srl          = a        >>  b[4:0];
wire        [31:0] sra          = a_signed >>> b[4:0];

// Logic muxing of shift functions
wire        [31:0] shift        = ({32{shift_left}}                 & sll) |
                                  ({32{shift_right & ~shift_arith}} & srl) |
                                  ({32{shift_right &  shift_arith}} & sra);

// Flag if a branch is taken. Could make aware if taken but still PC + 4, but more costly in logic.
// Fetch logic might be a better place to detect this.
wire               branch_taken = branch_in & cmp[0];

// PC is result of addition if jump or trap, and PC + offset if branch taken
wire        [31:0] next_pc      = (jump_in | system_in) ? add :
                                                          pc_in + offset_decode;

wire        [31:0] next_addr    = a + offset_decode;

always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    rd                          <=  4'h0;
    load                        <=  1'b0;
    store                       <=  1'b0;
    update_pc                   <=  1'b0;
  end
  else
  begin

    // Update C output based on active operation
    if (arith)
    begin
      c                         <= add_sub;
    end
    else if (bit_is_and | bit_is_or | bit_is_xor)
    begin
      c                         <= bitop;
    end
    else if (cmp_is_lt | cmp_is_ge | cmp_is_eq | cmp_is_ne)
    begin
      c                         <= cmp;
    end
    else if (shift_left | shift_right)
    begin
      c                         <= shift;
    end
    else if (load_in)
    begin
      c                         <= ld_data;
    end
    else if (jump_in)
    begin
      c                         <= pc_in + 4;
    end
    else if (store_in)
    begin
      c                         <= b << {next_addr[1:0], 3'b000};
    end

    // For load store, address is result of ALU's addition
    if (load_in | store_in)
    begin
      addr                      <= {next_addr[31:2], 2'b00};
    end

    rd                          <=  ~update_pc     ? rd_in : 5'h0;
    update_rd                   <= (rd_in != 5'h0) ? 1'b1  : 1'b0;

    pc                          <= next_pc;
    update_pc                   <= jump_in | system_in | branch_taken;

    load                        <= load_in  & ~update_pc;
    store                       <= store_in & ~update_pc;

    st_be                       <=  ld_store_width[1] ? 4'b1111 :
                                   (ld_store_width[0] ? 4'b0011 :
                                                        4'b0001) << next_addr[1:0];
  end
end

endmodule