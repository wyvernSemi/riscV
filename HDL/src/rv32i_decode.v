// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32I decoder
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : rv32i_decode.v
//  Author     : Simon Southwell
//  Created    : 2021-07-06
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the instruction decoder for the base (RV32I) RISC-V
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

module rv32i_decode
#(parameter
   RV32I_TRAP_VECTOR                   = 32'h00000040,
   RV32I_ENABLE_ECALL                  = 1
)
(
  input                                clk,
  input                                reset_n,

  input      [31:0]                    instr,
  input      [31:0]                    pc_in,       // From fetch unit
  input                                update_pc,
  input                                stall,

  // GP register read ports
  output      [4:0]                    rs1_prefetch,
  output      [4:0]                    rs2_prefetch,
  input      [31:0]                    rs1_rtn,
  input      [31:0]                    rs2_rtn,

  input       [4:0]                    fb_rd,
  input      [31:0]                    fb_rd_val,

  // ALU data
  output reg  [4:0]                    rd,           // 0 if no writeback
  output reg [31:0]                    a,
  output reg [31:0]                    b,
  output reg [31:0]                    offset,
  output reg [31:0]                    pc,

  // A and B source indexes for ALU rd feedback control
  output reg  [4:0]                    a_rs_idx,
  output reg  [4:0]                    b_rs_idx,
  
  // ALU control
  output reg                           branch,       // a is pc, b is imm
  output reg                           jump,         // a is pc/0, b is imm
  output reg                           system,       // a is 0, b is trap vector
  output reg                           load,         // a is rs1, b is imm
  output reg                           store,        // a is rs1, b is imm
  output reg  [1:0]                    ld_st_width,  // 0 = byte, 1 = hword, 2 = word

  // Add/sub control
  output reg                           add_nsub,
  output reg                           arith,

  // Comparison control
  output reg                           cmp_unsigned,
  output reg                           cmp_is_lt,
  output reg                           cmp_is_ge,
  output reg                           cmp_is_eq,
  output reg                           cmp_is_ne,

  // Bitwise control
  output reg                           bit_is_and,
  output reg                           bit_is_or,
  output reg                           bit_is_xor,

  // Shift control
  output reg                           shift_arith,
  output reg                           shift_left,
  output reg                           shift_right
);

reg         update_pc_dly;
reg  [31:0] instr_reg;
reg   [4:0] rs1_pf_held;
reg   [4:0] rs2_pf_held;

// Extract all the possible immediate value (sign extended as appropriate
wire [31:0] imm_i                      = {{20{instr_reg[31]}}, instr_reg[31:20]};
wire [31:0] imm_u                      = {instr_reg[31:12], 12'h0};
wire [31:0] imm_s                      = {{20{instr_reg[31]}},  instr_reg[31:25], instr_reg[11:7]};
wire [31:0] imm_b                      = {{19{instr_reg[31]}}, {instr_reg[31], instr_reg[7],     instr_reg[30:25], instr_reg[11:8]},  1'b0};
wire [31:0] imm_j                      = {{11{instr_reg[31]}}, {instr_reg[31], instr_reg[19:12], instr_reg[20],    instr_reg[30:21]}, 1'b0};

// Extract instruction decode fields from instruction (just wiring)
wire  [6:0] opcode                     = instr_reg[6:0];
wire  [4:0] opcode_32                  = opcode[6:2];
wire  [2:0] funct3                     = instr_reg[14:12];
wire  [4:0] rd_idx                     = instr_reg[11:7];
wire  [4:0] rs1_idx                    = instr_reg[19:15];
wire  [4:0] rs2_idx                    = instr_reg[24:20];

assign      rs1_prefetch               = stall ? rs1_pf_held : instr[19:15];
assign      rs2_prefetch               = stall ? rs2_pf_held : instr[24:20];

// Not a 32 bit instruction (16 bits if low two bits not both set),
// or 48 bits and greater if first 5 bits set)
wire        invalid_instr              = ~&opcode[1:0] | &opcode[4:0];

// Decode major categories from opcode (less bottom two bits)
wire        alu_instr                  = ~invalid_instr & &{opcode_32[2:0] ~^ 3'b100} & ~opcode_32[4];
wire        ld_st_instr                = ~invalid_instr & &{opcode_32[2:0] ~^ 3'b000} & ~opcode_32[4];
wire        st_instr                   = ~invalid_instr & ld_st_instr &  opcode_32[3];
wire        ui_instr                   = ~invalid_instr & ~opcode_32[4] & &{opcode_32[2:0] ~^ 3'b101};
wire        branch_instr               = ~invalid_instr & &{opcode_32      ~^ 5'b11000};
wire        jmp_instr                  = ~invalid_instr & &{opcode_32[4:2] ~^ 3'b110} & &{opcode_32[0]};
wire        system_instr               = ~invalid_instr & &{opcode_32      ~^ 5'b11100} & ~|funct3 & ~instr_reg[21] & (RV32I_ENABLE_ECALL | instr_reg[21]);
wire        fence_instr                = ~invalid_instr & &{opcode_32      ~^ 5'b00011};

// Flag indication that an ALU instruction is I-type
wire        alu_imm                    = ~opcode[5];

// Select which version of the immediate value would be used
// (default to imm_i---the most common)
wire [31:0] imm                        = ui_instr                     ? imm_u :
                                         branch_instr                 ? imm_b :
                                         (jmp_instr   & opcode_32[1]) ? imm_j :
                                         st_instr                     ? imm_s :
                                                                        imm_i;
                                                                        

// RS1 and RS2 values to use come from the regfile return values, unless
// the feedback index matches the register being written in this cycle 
// (unless x0), in which case the feedback value is used.
wire [31:0] rs1                        = (|fb_rd && fb_rd == rs1_idx) ? fb_rd_val : rs1_rtn;
wire [31:0] rs2                        = (|fb_rd && fb_rd == rs2_idx) ? fb_rd_val : rs2_rtn;

// No register writeback for store, branch, system and invalid instructions
wire no_writeback                      = st_instr | branch_instr | system_instr | invalid_instr | fence_instr;

always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    rd                                 <=  5'h0;
    branch                             <=  1'b0;
    jump                               <=  1'b0;
    system                             <=  1'b0;
    load                               <=  1'b0;
    store                              <=  1'b0;
    arith                              <=  1'b1;
    add_nsub                           <=  1'b0;
    cmp_unsigned                       <=  1'b0;
    cmp_is_eq                          <=  1'b0;
    cmp_is_ne                          <=  1'b0;
    cmp_is_ge                          <=  1'b0;
    cmp_is_lt                          <=  1'b0;
    bit_is_and                         <=  1'b0;
    bit_is_or                          <=  1'b0;
    bit_is_xor                         <=  1'b0;
    shift_arith                        <=  1'b0;
    shift_left                         <=  1'b0;
    shift_right                        <=  1'b0;
    update_pc_dly                      <=  1'b0;
    
    instr_reg                          <= 32'h00000013;
  end
  else
  begin
    instr_reg                          <= stall ? instr_reg : instr;
    update_pc_dly                      <= update_pc;
  
    if (update_pc == 1'b1 || update_pc_dly == 1'b1)
    begin
      a                                <= 32'h0;
      b                                <= 32'h0;
      offset                           <= 32'h0;

      rd                               <=  5'h0;
      branch                           <=  1'b0;
      jump                             <=  1'b0;
      system                           <=  1'b0;
      load                             <=  1'b0;
      store                            <=  1'b0;
      arith                            <=  1'b1;
      add_nsub                         <=  1'b0;
      cmp_unsigned                     <=  1'b0;
      cmp_is_eq                        <=  1'b0;
      cmp_is_ne                        <=  1'b0;
      cmp_is_ge                        <=  1'b0;
      cmp_is_lt                        <=  1'b0;
      bit_is_and                       <=  1'b0;
      bit_is_or                        <=  1'b0;
      bit_is_xor                       <=  1'b0;
      shift_arith                      <=  1'b0;
      shift_left                       <=  1'b0;
      shift_right                      <=  1'b0;
    end
    else
    begin
    
      rs1_pf_held                      <= stall ? rs1_pf_held : rs1_prefetch;
      rs2_pf_held                      <= stall ? rs2_pf_held : rs2_prefetch;
    
      if (~stall)
      begin
    
        // Next stage ALU control outputs
        rd                             <= no_writeback ? 5'h0 : rd_idx;                                 // if no writeback, rd = x0, else feedfoward rd_idx
        branch                         <= branch_instr;
        jump                           <= jmp_instr;
        system                         <= system_instr;
        load                           <= ld_st_instr & ~opcode_32[3];
        store                          <= ld_st_instr &  opcode_32[3];
        ld_st_width                    <= funct3[1:0];
        pc                             <= pc_in;
        
        // ALU inputs A and B
        a                              <= ((ui_instr &  opcode_32[3]) | system_instr)               ? 32'h0 :      // LUI and system, A = 0
                                          ((ui_instr & ~opcode_32[3]) | (jmp_instr & opcode_32[1])) ? pc_in :      // AUIPC and JAL, A = PC
                                                                                                      rs1;         // all others, A = rs1 value 
        
        b                              <= ((alu_instr & ~alu_imm) | st_instr | branch_instr) ? rs2 :               // ALU, store and branch, B = rs2 value 
                                           system_instr                                      ? RV32I_TRAP_VECTOR : // system, B = trap vector
                                                                                               imm;                // all others, B = immediate value
        // Offset for store and branch instructions
        offset                         <= imm;
        
        // Pass forward the RS indexes for A and B if active, else 0
        a_rs_idx                       <= ~((jmp_instr & opcode_32[1]) | system_instr)      ? rs1_idx : 5'h0; // JAL or system instructions have no rs fields
        b_rs_idx                       <= ((alu_instr & ~alu_imm)| st_instr | branch_instr) ? rs2_idx : 5'h0;
        
        // ALU operation control outputs
        arith                          <= (alu_instr & ~|funct3) | ui_instr;                            // ADD (or SUB) with alu instr_reg. and funct3 = 0, or for LUI/AUIPC
        add_nsub                       <= ~(instr_reg[30] & ~alu_imm) | ~alu_instr;                     // SUB (low) only for non-immediate ALU and instr_reg bit 30 set.
        
        cmp_unsigned                   <= (branch_instr &  funct3[1]) | (alu_instr & funct3[0]);        // a compare unsigned for BLTU/BGEU or SLTU/SLTIU
        cmp_is_eq                      <= branch_instr  & ~funct3[2] & ~funct3[0];                      // compare == for BEQ
        cmp_is_ne                      <= branch_instr  & ~funct3[2] &  funct3[0];                      // compare != for BNE
        cmp_is_ge                      <= branch_instr  &  funct3[2] &  funct3[0];                      // compare >= for BGE/BGEU
        cmp_is_lt                      <= (branch_instr &  funct3[2] & ~funct3[0]) |                    // compare < for BLT/BLTU, or SLT/SLTU/SLTI/SLTIU
                                          (alu_instr    & ~funct3[2] & funct3[1]);
        
        bit_is_and                     <= alu_instr & funct3 == 3'b111;                                 // ALU bit op is AND when funct3 == 7
        bit_is_or                      <= alu_instr & funct3 == 3'b110;                                 // ALU bit op is OR  when funct3 == 6
        bit_is_xor                     <= alu_instr & funct3 == 3'b100;                                 // ALU bit op is XOR when funct3 == 5
        
        shift_arith                    <= instr_reg[30];                                                    // A shift is arithmetic if instr_reg[30] set
        shift_left                     <= alu_instr & funct3 == 3'b001;                                 // ALU shift left if funct3 == 1
        shift_right                    <= alu_instr & funct3 == 3'b101;                                 // ALU shift right if funct3 == 5
      end
    end
  end
end

endmodule