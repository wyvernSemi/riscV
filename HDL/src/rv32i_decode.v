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
   RV32I_TRAP_VECTOR                   = 32'h00000004,
   RV32_ZICSR_EN                       = 1
)
(
  input                                clk,
  input                                reset_n,

  // Fetch instruction (phase 1)
  input      [31:0]                    instr,

  // PC value, aligned with instr_reg
  input      [31:0]                    pc_in,

  // ALU flag to indicate PC is being updated
  input                                update_pc,

  // ALU misaligned load/store flags and address
  input                                misaligned_load,
  input                                misaligned_store,
  input      [31:0]                    misaligned_addr,

  // External stall input
  input                                stall,

  // GP register read ports
  output      [4:0]                    rs1_prefetch,
  output      [4:0]                    rs2_prefetch,
  input      [31:0]                    rs1_rtn,
  input      [31:0]                    rs2_rtn,

  // Regfile writes, fed back
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
  output reg  [2:0]                    ld_st_width,  // 0 = byte, 1 = hword, 2 = word
  output reg  [1:0]                    zicsr,
  output reg  [4:0]                    zicsr_rd,
  output reg                           mret,

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
  output reg                           shift_right,

  // Zicsr interface
  output reg                           cancelled,
  output                               exception,
  output reg [31:0]                    exception_pc,
  output reg  [3:0]                    exception_type,
  output reg [31:0]                    exception_addr
);

// Define the synchronous exception codes
localparam IADDR_ALIGN_CODE            = 4'd0;
localparam ILLEGAL_INSTR               = 4'd2;
localparam LOAD_ALIGN_CODE             = 4'd4;
localparam STORE_ALIGN_CODE            = 4'd6;
localparam BREAKPOINT                  = 4'd3;
localparam ECALL                       = 4'd11;

localparam NOP_INSTR                   = 32'h00000013;

// Task to clear the common output state between reset, and when updating PC and 'deleting' instructions
task clr_state;
begin
  rd                                   <=  5'h0;
  branch                               <=  1'b0;
  jump                                 <=  1'b0;
  system                               <=  1'b0;
  load                                 <=  1'b0;
  store                                <=  1'b0;
  zicsr                                <=  2'h0;
  zicsr_rd                             <=  5'h0;
  mret                                 <=  1'b0;
  arith                                <=  1'b0;
  add_nsub                             <=  1'b0;
  cmp_unsigned                         <=  1'b0;
  cmp_is_eq                            <=  1'b0;
  cmp_is_ne                            <=  1'b0;
  cmp_is_ge                            <=  1'b0;
  cmp_is_lt                            <=  1'b0;
  bit_is_and                           <=  1'b0;
  bit_is_or                            <=  1'b0;
  bit_is_xor                           <=  1'b0;
  shift_arith                          <=  1'b0;
  shift_left                           <=  1'b0;
  shift_right                          <=  1'b0;
end
endtask

reg         update_pc_dly;

// Registered instr (phase 1) input value, to place in phase 2
reg  [31:0] instr_reg;

// RS prefetch held values, for use when stalled
reg   [4:0] rs1_pf_held;
reg   [4:0] rs2_pf_held;

// Exception (trap) and return registers
reg         exception_int;
reg   [1:0] exception_dly;
reg   [1:0] mret_dly;

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

// Export RS prefetch indexes to register file. From input instruction directly if not stalled, or the held value.
assign      rs1_prefetch               = stall ? rs1_pf_held : instr[19:15];
assign      rs2_prefetch               = stall ? rs2_pf_held : instr[24:20];

// Flag if a shift instruction of either direction
wire        is_shift_instr             = &{opcode_32[2:0] ~^ 3'b100} & ~opcode_32[4] & ((funct3 == 3'b001 ? 1'b1 : 1'b0) | (funct3 == 3'b101 ? 1'b1: 1'b0));

// Not a 32 bit instruction (16 bits if low two bits not both set),
// or 48 bits and greater if first 5 bits set)
wire        invalid_instr              = (~&opcode[1:0] | &opcode[4:0]) | (is_shift_instr & instr_reg[25]);

// Decode major categories from opcode (less bottom two bits)
wire        alu_instr                  = ~invalid_instr & &{opcode_32[2:0] ~^ 3'b100} & ~opcode_32[4];
wire        ld_st_instr                = ~invalid_instr & &{opcode_32[2:0] ~^ 3'b000} & ~opcode_32[4];
wire        st_instr                   = ~invalid_instr & ld_st_instr &  opcode_32[3];
wire        ui_instr                   = ~invalid_instr & ~opcode_32[4] & &{opcode_32[2:0] ~^ 3'b101};
wire        branch_instr               = ~invalid_instr & &{opcode_32      ~^ 5'b11000};
wire        jmp_instr                  = ~invalid_instr & &{opcode_32[4:2] ~^ 3'b110} & &{opcode_32[0]};
wire        fence_instr                = ~invalid_instr & &{opcode_32      ~^ 5'b00011};
wire        system_instr               = ~invalid_instr & &{opcode_32      ~^ 5'b11100} & ~|funct3 & ~instr_reg[21];
wire        sys_instr_nozicsr          = system_instr & ~RV32_ZICSR_EN[0];
wire        zicsr_instr                = ~invalid_instr & &{opcode_32      ~^ 5'b11100} &  |funct3 &  RV32_ZICSR_EN[0];
wire        mret_instr                 = ~invalid_instr & &{opcode_32      ~^ 5'b11100} & ~|funct3 &  instr_reg[21] & instr_reg[29] & RV32_ZICSR_EN[0];

wire        zicsr_imm_instr            = zicsr_instr & funct3[2];

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
wire        no_writeback               = st_instr | branch_instr | sys_instr_nozicsr | invalid_instr | fence_instr | zicsr_instr;

// Updating PC after a jump/branch executed in ALU, an exception_int, misaligned
// memory access or a return from exception_int
wire        updating_pc                = update_pc       | update_pc_dly    |
                                         exception       | |exception_dly   |
                                         misaligned_load | misaligned_store |
                                         mret            | |mret_dly;


// Export synchronous exception, but mask if just taking a branch, as following (possibly invalid) instructions are not executed
assign      exception                  = exception_int & ~(update_pc | update_pc_dly);

always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    // Clear common state
    clr_state;

    update_pc_dly                      <=  1'b0;
    cancelled                          <=  1'b0;
    exception_int                      <=  1'b0;
    exception_dly                      <=  2'b00;
    mret_dly                           <=  2'h0;

    // Start off in the phase 2 stage with a NOP
    instr_reg                          <= NOP_INSTR;
  end
  else
  begin
    // Phase 2 version of instruction (held if stalled)
    instr_reg                          <= stall ? instr_reg : instr;

    // Delay the PC altering signals for use in 'deleting' upstream instructions read before PC changes
    update_pc_dly                      <= update_pc;
    mret_dly                           <= {mret, mret_dly[1]};
    exception_dly                      <= {exception, exception_dly[1]};

    // Default the cancelled and exception state to 0, so they pulse when set
    cancelled                          <= 1'b0;
    exception_int                      <= 1'b0;

    // Export to Zicsr block (when present) the PC of an exception. If a misaligned [I|D]ADDR,
    // then use pc, as the exception was caused by the last instruction
    exception_pc                       <= (|pc_in[1:0] | misaligned_store | misaligned_load) ? pc : pc_in;

    // Set the synchronous exception type based on instruction type, or alignment
    exception_type                     <= |pc_in[1:0]      ? IADDR_ALIGN_CODE :
                                          misaligned_load  ? LOAD_ALIGN_CODE  :
                                          misaligned_store ? STORE_ALIGN_CODE :
                                          invalid_instr    ? ILLEGAL_INSTR    :
                                          system_instr     ? (instr_reg[20] ? BREAKPOINT : ECALL) :
                                                             4'h0;

    // Exception address for load/store misalignments and illegal instructions
    exception_addr                     <= (misaligned_load | misaligned_store) ? misaligned_addr : 32'h0;

    // Export the PC to the ALU, aligned to other outputs to ALU (phase 3)
    pc                                 <= pc_in;

    // When PC is updating, cancel the next instructions to clear pipeline
    if (updating_pc == 1'b1)
    begin
      // Clear common state
      clr_state;

      // Flag to ALU that the instruction's cancelled, for use in counting retired instructions
      cancelled                        <=  1'b1;
    end
    else
    begin

      // Hold RS prefetch indexes when stalled
      rs1_pf_held                      <= stall ? rs1_pf_held : rs1_prefetch;
      rs2_pf_held                      <= stall ? rs2_pf_held : rs2_prefetch;

      // When not stalled, process the phase 2 instruction and generate the outputs for the ALU and extensions
      if (~stall)
      begin

        // A synchrounous exception occurs when a system instruction is read, when an invalid instruction occurs,
        // a misaligned IADDR, or a misaligned load/store address
        exception_int                  <= system_instr | invalid_instr | |pc_in[1:0] | misaligned_load | misaligned_store;

        // Next stage ALU control outputs
        rd                             <= no_writeback ? 5'h0 : rd_idx;                                 // if no writeback, rd = x0, else feedfoward rd_idx
        branch                         <= branch_instr;
        jump                           <= jmp_instr;
        system                         <= sys_instr_nozicsr;
        load                           <= ld_st_instr & ~opcode_32[3];
        store                          <= ld_st_instr &  opcode_32[3];
        ld_st_width                    <= funct3;

        // Zicsr signals
        zicsr_rd                       <= rd_idx;
        zicsr                          <= funct3[1:0] & {2{zicsr_instr}};
        mret                           <= mret_instr;

        // ALU inputs A and B
        a                              <= ((ui_instr &  opcode_32[3]) | sys_instr_nozicsr)          ? 32'h0   :    // LUI and system, A = 0
                                          ((jmp_instr & opcode_32[1]) | (ui_instr & ~opcode_32[3])) ? pc_in   :    // AUIPC, JAL, A = PC
                                          zicsr_imm_instr                                           ? rs1_idx :    // Zicsr imm, A = RS1 index bits
                                                                                                      rs1;         // all others, A = rs1 value

        b                              <= ((alu_instr & ~alu_imm) | st_instr | branch_instr) ? rs2 :               // ALU, store and branch, B = rs2 value
                                           sys_instr_nozicsr                                 ? RV32I_TRAP_VECTOR : // system, B = trap vector (when no Zicsr extensions)
                                                                                               imm;                // all others, B = immediate value
        // Offset for store and branch instructions
        offset                         <= imm;

        // Pass forward the RS indexes for A and B if active, else 0
        a_rs_idx                       <= ~((jmp_instr & opcode_32[1]) | sys_instr_nozicsr | ui_instr) ? rs1_idx : 5'h0; // JAL, system or ui instructions have no rs fields
        b_rs_idx                       <= ((alu_instr & ~alu_imm)| st_instr | branch_instr)            ? rs2_idx : 5'h0;

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

        shift_arith                    <= instr_reg[30];                                                // A shift is arithmetic if instr_reg[30] set
        shift_left                     <= alu_instr & funct3 == 3'b001;                                 // ALU shift left if funct3 == 1
        shift_right                    <= alu_instr & funct3 == 3'b101;                                 // ALU shift right if funct3 == 5
      end
    end
  end
end

endmodule