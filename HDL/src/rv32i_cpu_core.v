// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32I ALU
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : rv32i_cpu_core.v
//  Author     : Simon Southwell
//  Created    : 2021-07-21
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the top level for the base (RV32I) RISC-V soft processor.
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

 `timescale 1ns / 10ps

`define RV32I_NOP                32'h00000013

module rv32i_cpu_core
#(parameter
   CLK_FREQ_MHZ                = 100,
   RV32I_RESET_VECTOR          = 32'h00000000,
   RV32I_TRAP_VECTOR           = 32'h00000004,
   RV32I_LOG2_REGFILE_ENTRIES  = 5,
   RV32I_REGFILE_USE_MEM       = 1,
   RV32_ZICSR_EN               = 1
)
(
  input                        clk,
  input                        reset_n,

  output [31:0]                iaddress,         // Byte address (32 bit aligned)
  output                       iread,
  input  [31:0]                ireaddata,
  input                        iwaitrequest,

  output [31:0]                daddress,         // Byte address (32 bit aligned)
  output                       dwrite,
  output [31:0]                dwritedata,
  output  [3:0]                dbyteenable,      // BE active on writes
  output                       dread,
  input  [31:0]                dreaddata,
  input                        dwaitrequest,

  input                        irq,

  output  [4:0]                test_rd_idx,
  output [31:0]                test_rd_val
);

// Decode pipeline outputs
wire  [4:0] decode_rd;
wire  [4:0] decode_zicsr_rd;
wire        decode_branch;
wire        decode_jump;
wire        decode_system;
wire        decode_load;
wire        decode_store;
wire  [2:0] decode_ld_st_width;
wire [31:0] decode_pc;

// ALU inputs from decoder
wire [31:0] decode_a;
wire [31:0] decode_b;
wire [31:0] decode_offset;
wire  [4:0] decode_a_rs_idx;
wire  [4:0] decode_b_rs_idx;

// ALU control
wire        decode_add_nsub;
wire        decode_arith;
wire        decode_cmp_unsigned;
wire        decode_cmp_is_lt;
wire        decode_cmp_is_ge;
wire        decode_cmp_is_eq;
wire        decode_cmp_is_ne;
wire        decode_bit_is_and;
wire        decode_bit_is_or;
wire        decode_bit_is_xor;
wire        decode_shift_arith;
wire        decode_shift_left;
wire        decode_shift_right;
wire        decode_cancelled;
wire  [1:0] decode_zicsr;
wire        decode_mret;

// ALU writeback signals
wire [31:0] alu_c;
wire [31:0] alu_pc;
wire  [4:0] alu_rd;
wire        alu_update_pc;

// Decoder RS prefetch indexes
wire  [4:0] decode_rs2_prefetch;
wire  [4:0] decode_rs1_prefetch;

// Reg file outputs
wire [31:0] regfile_rs1;
wire [31:0] regfile_rs2;
wire [31:0] regfile_pc;
wire [31:0] regfile_last_pc;
wire  [4:0] regfile_rd;
wire [31:0] regfile_rd_val;

// Signals for minstret counter
wire        retired_instr;

// zicsr exception PC signals
wire        zicsr_update_pc;
wire [31:0] zicsr_new_pc;
wire  [4:0] zicsr_rd;
wire [31:0] zicsr_rd_val;

// Synchronous exception signals
wire        exception;
wire [31:0] exception_pc;
wire  [3:0] exception_type;

// Stall conditions
wire        stall              = (dread & dwaitrequest);
wire        stall_regfile      = stall | (decode_load & ~dread);
wire        stall_decode       = dread;
wire        stall_alu          = dread;
wire        clr_load_op        = dread & ~dwaitrequest;

wire        update_pc          = alu_update_pc | zicsr_update_pc;
wire [31:0] new_pc             = zicsr_update_pc ? zicsr_new_pc : alu_pc;

// Fetch instructions from the current PC address
assign iaddress                = ~update_pc ? regfile_pc : new_pc;
assign iread                   = reset_n & ~(dread & dwaitrequest);

// DMEM write data always comes from ALU's C output
assign dwritedata              = alu_c;

// Mux the sources of RD updates to the register file
assign regfile_rd              = alu_rd | zicsr_rd;
assign regfile_rd_val          = |zicsr_rd ? zicsr_rd_val : alu_c;

// Export writes to register file for test/debug purposes
assign test_rd_idx             = regfile_rd;
assign test_rd_val             = regfile_rd_val;

  // ---------------------------------------------------------
  // Decoder
  // ---------------------------------------------------------

  rv32i_decode #(
    .RV32I_TRAP_VECTOR         (RV32I_TRAP_VECTOR),
    .RV32_ZICSR_EN             (RV32_ZICSR_EN)
  ) decode
  (
    .clk                       (clk),
    .reset_n                   (reset_n),

    .stall                     (stall_decode),

    .instr                     (ireaddata),

    .pc_in                     (regfile_last_pc),
    .update_pc                 (alu_update_pc),

    .rs1_prefetch              (decode_rs1_prefetch),
    .rs2_prefetch              (decode_rs2_prefetch),
    .rs1_rtn                   (regfile_rs1),
    .rs2_rtn                   (regfile_rs2),

    .rd                        (decode_rd),
    .zicsr_rd                  (decode_zicsr_rd),
    .branch                    (decode_branch),
    .jump                      (decode_jump),
    .system                    (decode_system),
    .load                      (decode_load),
    .store                     (decode_store),
    .ld_st_width               (decode_ld_st_width),
    .zicsr                     (decode_zicsr),
    .mret                      (decode_mret),

    .cancelled                 (decode_cancelled),

    .fb_rd                     (regfile_rd),
    .fb_rd_val                 (regfile_rd_val),

    .a                         (decode_a),
    .b                         (decode_b),
    .offset                    (decode_offset),
    .pc                        (decode_pc),

    .a_rs_idx                  (decode_a_rs_idx),
    .b_rs_idx                  (decode_b_rs_idx),

    .add_nsub                  (decode_add_nsub),
    .arith                     (decode_arith),

    .cmp_unsigned              (decode_cmp_unsigned),
    .cmp_is_lt                 (decode_cmp_is_lt),
    .cmp_is_ge                 (decode_cmp_is_ge),
    .cmp_is_eq                 (decode_cmp_is_eq),
    .cmp_is_ne                 (decode_cmp_is_ne),

    .bit_is_and                (decode_bit_is_and),
    .bit_is_or                 (decode_bit_is_or),
    .bit_is_xor                (decode_bit_is_xor),

    .shift_arith               (decode_shift_arith),
    .shift_left                (decode_shift_left),
    .shift_right               (decode_shift_right),

    .exception                 (exception),
    .exception_pc              (exception_pc),
    .exception_type            (exception_type)
  );

  // ---------------------------------------------------------
  // Register file
  // ---------------------------------------------------------

  rv32i_regfile #(
    .RESET_VECTOR              (RV32I_RESET_VECTOR),
    .LOG2_REGFILE_ENTRIES      (RV32I_LOG2_REGFILE_ENTRIES),
    .USE_MEM                   (RV32I_REGFILE_USE_MEM)
  ) regfile
  (
     .clk                      (clk),
     .reset_n                  (reset_n),

     .rs1_idx                  (decode_rs1_prefetch),
     .rs2_idx                  (decode_rs2_prefetch),
     .rd_idx                   (regfile_rd),
     .new_rd                   (regfile_rd_val),
     .new_pc                   (new_pc),
     .update_pc                (update_pc),
     .stall                    (stall_regfile),

     .rs1                      (regfile_rs1),
     .rs2                      (regfile_rs2),
     .pc                       (regfile_pc),
     .last_pc                  (regfile_last_pc)
  );

  // ---------------------------------------------------------
  // Arithmetic Logic Unit
  // ---------------------------------------------------------

  rv32i_alu alu
  (
    .clk                       (clk),
    .reset_n                   (reset_n),
    .stall                     (stall_alu),

    .a_decode                  (decode_a),
    .b_decode                  (decode_b),
    .offset_decode             (decode_offset),

    .a_rs_idx                  (decode_a_rs_idx),
    .b_rs_idx                  (decode_b_rs_idx),
    
    .regfile_rd_idx            (regfile_rd),
    .regfile_rd_val            (regfile_rd_val),

    .pc_in                     (decode_pc),
    .rd_in                     (decode_rd),
    .branch_in                 (decode_branch),
    .jump_in                   (decode_jump),
    .system_in                 (decode_system),
    .load_in                   (decode_load),
    .store_in                  (decode_store),
    .ld_store_width            (decode_ld_st_width),
    .clr_load_op               (clr_load_op),

    .add_nsub                  (decode_add_nsub),
    .arith                     (decode_arith),

    .cmp_unsigned              (decode_cmp_unsigned),
    .cmp_is_lt                 (decode_cmp_is_lt),
    .cmp_is_ge                 (decode_cmp_is_ge),
    .cmp_is_eq                 (decode_cmp_is_eq),
    .cmp_is_ne                 (decode_cmp_is_ne),

    .bit_is_and                (decode_bit_is_and),
    .bit_is_or                 (decode_bit_is_or),
    .bit_is_xor                (decode_bit_is_xor),

    .shift_arith               (decode_shift_arith),
    .shift_left                (decode_shift_left),
    .shift_right               (decode_shift_right),

    .cancelled                 (decode_cancelled),
    .retired_instr             (retired_instr),

    .c                         (alu_c),
    .rd                        (alu_rd),
    .pc                        (alu_pc),
    .update_pc                 (alu_update_pc),
    .load                      (dread),
    .store                     (dwrite),
    .addr                      (daddress),
    .st_be                     (dbyteenable),
    .ld_data                   (dreaddata)
    
  );

  // ---------------------------------------------------------
  // zicsr Extension module
  // ---------------------------------------------------------

generate

  if (RV32_ZICSR_EN == 1)
  begin : zicsr
    rv32_zicsr #(.CLK_FREQ_MHZ  (CLK_FREQ_MHZ)) rv32_zicsr
      (
        .clk                   (clk),
        .reset_n               (reset_n),
        
        .stall                 (stall_decode),

        .irq                   (irq),
        .exception             (exception),
        .exception_pc          (exception_pc),
        .exception_type        (exception_type),

        .ext_sw_interrupt      (1'b0),

        .mret                  (decode_mret),

        .instr_retired         (retired_instr),

        .zicsr                 (decode_zicsr),
        .a                     (decode_a),
        .index                 (decode_b[11:0]),
        .rd_in                 (decode_zicsr_rd),
        .rs1_in                (decode_a_rs_idx),
        
        .regfile_rd_val        (regfile_rd_val),
        .regfile_rd_idx        (regfile_rd),

        .wr_mtime              (1'b0),
        .wr_mtimecmp           (1'b0),
        .wr_mtime_upper        (1'b0),
        .wr_mtime_val          (32'h0),

        .zicsr_update_pc       (zicsr_update_pc),
        .zicsr_new_pc          (zicsr_new_pc),
        .zicsr_rd              (zicsr_rd),
        .zicsr_rd_val          (zicsr_rd_val)
      );
  end
  else
  begin : nozicsr
    assign zicsr_update_pc      = 1'b0;
    assign zicsr_rd             = 5'h0;
  end

endgenerate

endmodule
