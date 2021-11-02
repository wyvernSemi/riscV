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
    LOG2_REGFILE_ENTRIES       = 5,
    RESET_VECTOR               = 32'h00000000,
    USE_MEM                    = 1
)
(
   input                       clk,
   input                       reset_n,

   input       [4:0]           rs1_idx,
   input       [4:0]           rs2_idx,
   input       [4:0]           rd_idx,
   input      [31:0]           new_rd,
   input      [31:0]           new_pc,
   input                       update_pc,
   input                       stall,

   output     [31:0]           rs1,
   output     [31:0]           rs2,
   output     [31:0]           pc,
   output     [31:0]           last_pc
);

localparam REGFILE_ENTRIES     = (1 << LOG2_REGFILE_ENTRIES);

wire [31:0] rs1_int;
wire [31:0] rs2_int;

reg   [4:0] rs1_idx_dly;
reg   [4:0] rs2_idx_dly;
reg   [4:0] rd_idx_dly;
reg  [31:0] new_rd_dly;
reg  [31:0] pc_int;
reg  [31:0] last_pc_int;
reg   [1:0] start_up;

assign rs1                     = (|rs1_idx_dly && rs1_idx_dly == rd_idx)     ? new_rd     :
                                 (|rs1_idx_dly && rs1_idx_dly == rd_idx_dly) ? new_rd_dly :
                                                                               rs1_int;

assign rs2                     = (|rs2_idx_dly && rs2_idx_dly == rd_idx)     ? new_rd :
                                 (|rs2_idx_dly && rs2_idx_dly == rd_idx_dly) ? new_rd_dly :
                                                                               rs2_int;

wire [31:0] next_pc            = update_pc ? new_pc : pc_int;

// Export the PC values, but hold at reset vector until running after reset, to prefetch reset vector instruction.
assign      pc                 = start_up[1] ? RESET_VECTOR   : pc_int;
assign      last_pc            = |start_up   ? RESET_VECTOR   : last_pc_int;

// Process to update the program counter
always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    pc_int                     <= RESET_VECTOR;
    last_pc_int                <= RESET_VECTOR;
    start_up                   <= 2'b11;
  end
  else
  begin
    rs1_idx_dly                <= rs1_idx;
    rs2_idx_dly                <= rs2_idx;
    rd_idx_dly                 <= rd_idx;
    new_rd_dly                 <= new_rd;
    start_up                   <= {1'b0, start_up[1]};

    if (~stall | update_pc)
    begin
      // Because of pipeline delay reading instruction,
      // last PC for decoder is the address before current PC to align at ALU
      last_pc_int              <= next_pc - 32'h4;

      // Update PC
      pc_int                   <= next_pc + 32'h4;
    end
  end
end

//
// Generate to select between memory based or register based implementation
//
generate
  // -------------------------------------------------------
  // Use memory based register file implementation
  // -------------------------------------------------------
  if (USE_MEM == 1)
  begin : mem
    // Write to memory when RD index is not 0 zero, or write 0 to index 0 during reset.
    wire        wr_mem         = (rd_idx != 5'h0 | ~reset_n) ? 1'b1   : 1'b0;
    wire [31:0] wdata          = reset_n                     ? new_rd : 32'h00000000;

    // RAM for RS1 reads (writes common with RS2)
    dp_ram #(.DATA_WIDTH(32), .ADDR_WIDTH(5), .OP_REGISTERED("UNREGISTERED")) regfile1
    (
      .clock                   (clk),

      .wren                    (wr_mem),
      .byteena_a               (4'hf),
      .wraddress               (rd_idx),
      .data                    (wdata),

      .rdaddress               (rs1_idx),
      .q                       (rs1_int)
    );

    // RAM for RS2 reads (writes common with RS1)
    dp_ram #(.DATA_WIDTH(32), .ADDR_WIDTH(5), .OP_REGISTERED("UNREGISTERED")) regfile2
    (
      .clock                           (clk),

      .wren                    (wr_mem),
      .byteena_a               (4'hf),
      .wraddress               (rd_idx),
      .data                    (wdata),

      .rdaddress               (rs2_idx),
      .q                       (rs2_int)
    );

  end
  // -------------------------------------------------------
  // Use register based register file implementation
  // -------------------------------------------------------
  else
  begin : registers
    // Declare an array of registers (REGFILE_ENTRIES x 32)
    reg  [31:0] regfile [0:REGFILE_ENTRIES-1];

    // Registers for the returned RS1 and RS2 values
    reg  [31:0] rs1_reg;
    reg  [31:0] rs2_reg;

    // Export the registered RS1 and RS2 values to the output ports
    assign rs1_int             = rs1_reg;
    assign rs2_int             = rs2_reg;

    // Process for accessing the register file array
    always @(posedge clk)
    begin
      if (reset_n == 1'b0)
      begin
        regfile[0]             <= 32'h00000000;
        rs1_reg                <= 32'h00000000;
        rs2_reg                <= 32'h00000000;
      end
      else
      begin

        // Register the read values
        rs1_reg                <= regfile[rs1_idx];
        rs2_reg                <= regfile[rs2_idx];

        // Update rd if index is not x0 and not stalled
        if (rd_idx != 5'h0 && stall == 1'b0)
        begin
          regfile[rd_idx]      <= new_rd;
        end
      end
    end
  end
endgenerate

endmodule