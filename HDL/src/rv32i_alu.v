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

  input                        stall,

  // Main ALU value inputs A and B
  input  [31:0]                a_decode,         // rs1
  input  [31:0]                b_decode,         // rs2 or imm

  // Offset for PC calculations
  input  [31:0]                offset_decode,    // imm_b or imm_j  or imm_s or imm_i

  // RS indexes for the A and B inputs (when relevant)
  input   [4:0]                a_rs_idx,
  input   [4:0]                b_rs_idx,

  // RD values being written to register file for feedback bypass
  input   [4:0]                regfile_rd_idx,
  input  [31:0]                regfile_rd_val,

  // Pipeline control
  input  [31:0]                pc_in,
  input   [4:0]                rd_in,            // 0 if no writeback
  input                        branch_in,        // a is pc, b is imm
  input                        jump_in,          // a is pc, b is imm
  input                        system_in,        // a is 0, b is trap vector
  input                        load_in,          // a is rs1, b is imm
  input                        store_in,         // a is rs1, b is rs2
  input   [2:0]                ld_store_width,   // 0 = byte, 1 = hword, 2 = word
  input                        cancelled,

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
  input                        clr_load_op,
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
  input      [31:0]            ld_data,

  // Retired instruction flag for Zicsr (if fitted)
  output reg                   retired_instr
);

// Width (Word, half-word, byte) of a load instruction
reg           [2:0]            ld_width;

// Low bits of a load access address
reg           [1:0]            addr_lo;

// The A and B inputs to the ALU logic come from the ALU output if the source register
// matches the destination register. Otherwise the regfile value (via decode) is
// used.
wire        [31:0] a            = (a_rs_idx == regfile_rd_idx && regfile_rd_idx != 5'h0) ? regfile_rd_val : a_decode;
wire        [31:0] b            = (b_rs_idx == regfile_rd_idx && regfile_rd_idx != 5'h0) ? regfile_rd_val : b_decode;

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

// Next memory address is the A input plus the offset from the decoder
wire        [31:0] next_addr    = a + offset_decode;

// The returned load data is shifted dependant of the address low bits
wire        [31:0] ld_data_shift = ld_data >> {addr_lo, 3'b000};

always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    rd                          <=  4'h0;
    load                        <=  1'b0;
    store                       <=  1'b0;
    update_pc                   <=  1'b0;
    ld_width                    <=  3'b000;
    retired_instr               <=  1'b0;
  end
  else
  begin

    // Flag each completed instruction for retired instruction counter
    retired_instr               <= ~stall & ~cancelled;

    // Update C output based on active operation
    if (load)
    begin
      // Clear the unused bits of the shifted load data, based on load width (byte, hword, word)
      c                         <= (ld_data_shift & {{16{ld_width[1]}}, {8{|ld_width[1:0]}}, 8'hff}) |
                                   {{16{~ld_width[2] & ~ld_width[1] &  ld_width[0] & ld_data_shift[15]}}, 16'h0} |
                                   {{24{~ld_width[2] & ~ld_width[1] & ~ld_width[0] & ld_data_shift[7]}},   8'h0};
    end
    else if (arith)
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
    else if (jump_in)
    begin
      // When jumping, the RD value is the jump instruction's address + 4
      c                         <= pc_in + 32'h4;
    end
    else if (store_in)
    begin
      // The C output for stores is the B value from the decoder, shifted by the address low bits (masked dependant on width)
      c                         <= b << {next_addr[1:0] & {~ld_store_width[1], ~ld_store_width[0]}, 3'b000};
    end

    // For load store, address is result of ALU's addition
    if (load_in | store_in)
    begin
      addr                      <= stall ? addr       : {next_addr[31:2], 2'b00};
      addr_lo                   <= stall ? addr [1:0] : next_addr[1:0];
    end

    // Te RD register is updated (i.e. not 0) when the PC isn't being updated (and instructions 'deleted') and not a misaligned instruction read
    rd                          <= stall ? rd : ((~update_pc & ~((jump_in | branch_taken) & |next_pc[1:0])) ? rd_in : 5'h0);

    // Update PC when a system, jump or taken branch instruction
    pc                          <= stall ? pc : next_pc;
    update_pc                   <= stall ? update_pc : ((jump_in | system_in | branch_taken) & ~update_pc);

    // Load/store outputs
    load                        <= (stall ? load : (load_in  & ~update_pc)) & ~clr_load_op;
    store                       <= store_in & ~update_pc;

    // Store byte enables a function of width (word, half-word, byte) and the address low bits
    // When word, all set. When half-word, either upper two bits when next_addr[1], else lower two.
    // When byte, only one bit set, as indexed by next_addr[1:0].
    st_be                       <= ld_store_width[1] ? 4'b1111 :
                                   ld_store_width[0] ? (4'b0011 << {next_addr[1], 1'b0}):
                                                       (4'b0001 <<  next_addr[1:0]);

    // Registered value of load/store width, for use on load instructions
    ld_width                    <= stall ? ld_width : ld_store_width;
  end
end

endmodule