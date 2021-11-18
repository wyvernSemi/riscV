// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32M divider-multiplier
//  Project    : rv32_cpu
// -----------------------------------------------------------------------------
//  File       : rv32_m.v
//  Author     : Simon Southwell
//  Created    : 2021-10-31
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the RVM extension divider for the (RV32I) RISC-V
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

`timescale                     1ns / 10ps

`define DIV_WORD_WIDTH         32
`define DIV_COUNT_RESET        (`DIV_WORD_WIDTH-1)

module rv32_m
#(parameter
   RV32M_FIXED_TIMING          = 0,      // Set non-zero if timing must be fixed for all calculations (removed optimisation logic)
   RV32M_MUL_INFERRED          = 1       // Set non-zero if do not want inferred multiplication
)
(
  input                        clk,
  input                        reset_n,

  input      [31:0]            A,
  input      [31:0]            B,
  input       [4:0]            a_rs_idx,
  input       [4:0]            b_rs_idx,
  input       [2:0]            funct,
  input       [4:0]            rd_idx,
  input                        start,
  input                        terminate,

  input       [4:0]            regfile_rd_idx,
  input      [31:0]            regfile_rd_val,

  output     [31:0]            result,
  output      [4:0]            rd,
  output                       update_rd,
  output reg                   done,
  output reg                   done_int
);

reg   [4:0] count;
reg  [31:0] A_saved;
reg  [31:0] B_saved;
reg  [31:0] B_reg;
reg         signed_a_saved;
reg         signed_b_saved;
reg         mod_saved;
reg         mulh_saved;
reg         div_not_mul_saved;
reg         result_valid;
reg  [63:0] a_shift;
reg  [31:0] b_shift;
reg         change_op_sign;
reg [31:0]  div_mull; // Divide or mul (low) result
reg [31:0]  mod_mulh; // mod_mulh or mulh result
reg  [4:0]  rd_saved;
reg         inferred_mul_done;

// Local decode of function
wire        div_not_mul        = funct[2];
wire        mulh               = |funct[1:0];
wire        mod                = funct[1];
wire        signed_a           = (~div_not_mul & (funct[1] ^ funct[0])) | (div_not_mul & ~funct[0]);
wire        signed_b           = (~div_not_mul & ~funct[1] & funct[0])  | (div_not_mul & ~funct[0]);

wire [31:0] a_fb               = (|regfile_rd_idx == 1'b1 && regfile_rd_idx == a_rs_idx) ? regfile_rd_val : A;
wire [31:0] b_fb               = (|regfile_rd_idx == 1'b1 && regfile_rd_idx == b_rs_idx) ? regfile_rd_val : B;

// Flag if there is a valid result, and inputs match last inputs,
// in which case the previous outputs can be used. This allows
// both a division and remainder result to be extracted with only
// one calculation. It will also skip if the inputs happen to be
// the same as the last completed calculation.
wire        use_last_result    = result_valid &
                                 a_fb == A_saved &
                                 b_fb == B_saved &
                                 signed_a == signed_a_saved &
                                 signed_b == signed_b_saved &
                                 div_not_mul == div_not_mul_saved &
                                 RV32M_FIXED_TIMING == 0;

// Inputs are negative if a signed division and sign bit set
wire        A_negative         = signed_a & a_fb[31];
wire        B_negative         = signed_b & b_fb[31];

// Internal a_fb and b_fb are made positive if negative inputs
// (Is there a better way to handle signed division?)
wire [31:0] A_int              = A_negative ? (~a_fb + 32'h1) : a_fb;
wire [31:0] B_int              = B_negative ? (~b_fb + 32'h1) : b_fb;

// Stop when count reached zero, or being terminated externally
wire        stop               = ~|count | terminate;

// Modulus value left shifted, and filled with division top bit
wire [32:0] shifted            = {b_shift, a_shift[31]};

// Shifted value minus the (positive) b_fb input
wire [32:0] sub                = shifted - {1'b0, B_reg};

// Adjust multiply result sign
wire [63:0] mul_adjusted       = change_op_sign ? (~{mod_mulh, div_mull} + 64'h1) : {mod_mulh, div_mull};

// Next multiplication value, equals current value plus shifted a_fb, when using logic multiplier,
// or latched |a_fb| * |b_fb| value, when inferring a DSP multiplier.
wire [63:0] next_mul           = (RV32M_MUL_INFERRED == 0) ? {mod_mulh, div_mull} + a_shift : 
                                                             (a_shift[31:0] * b_shift);

// Selection flag for result 32 bits, either high or low
wire        result_high_bits   = (div_not_mul_saved & mod_saved) | (~div_not_mul_saved & mulh_saved);

// Mux the selected division result, either modulus (high) or divsion (low)
wire [31:0] next_div_result    = result_high_bits ? (change_op_sign ? (~b_shift       +32'h1) : b_shift) :
                                                    (change_op_sign ? (~a_shift[31:0] +32'h1) : a_shift[31:0]);

// Mux the selected multiplication high or low bits of result
wire [31:0] next_mul_result    = result_high_bits ? mul_adjusted[63:32] : mul_adjusted[31:0];

// NOTE: the following RD update output assignments are still in the execution phase 3.
// They are routed to the ALU for registering for the phase 4 write back over the same
// signals as the ALU. This relieves timing on the muxing of RD results from different
// sources, as the RD update bypass feedback to RS1/RS2 of the ALU is the critial path.

// Select between multiplication or divsion result
assign      result             = div_not_mul_saved ? next_div_result : next_mul_result;

// Flag when updating RD
assign      update_rd          = ~done & done_int;

// Only make RD index active (non-zero) when flagged an update
assign      rd                 = update_rd ? rd_saved : 5'h00;

// Synchronous process
always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    count                      <= `DIV_COUNT_RESET;
    done_int                   <= 1'b1;
    done                       <= 1'b1;
    result_valid               <= 1'b0;
    inferred_mul_done      <= 1'b0;
  end
  else
  begin
  
    inferred_mul_done      <= 1'b0;

    // Done output a cycle delayed of internal done_int, to allow for output sign change.
    done                       <= done_int;

    // If idle (done set) and start asserted, then load initial state---but not
    // if same inputs as last completed calculation, as the division is skipped
    if (done & start)
    begin

      // Save the RD index, whether using last result or not as the destination registering
      // might still change, even of the last result can be reused.
      rd_saved                 <= rd_idx;

      if (~use_last_result)
      begin
        // Save off inputs
        A_saved                <= a_fb;
        B_saved                <= b_fb;
        signed_a_saved         <= signed_a;
        signed_b_saved         <= signed_b;
        div_not_mul_saved      <= div_not_mul;
        mulh_saved             <= mulh;
        mod_saved              <= mod;

        // Change the output sign if inputs differ in sign
        change_op_sign         <= (div_not_mul & mod) ? A_negative : (A_negative ^ B_negative);

        // Initialise the calculation state
        B_reg                  <= B_int;
        a_shift                <= {32'h0, A_int};
        b_shift                <= div_not_mul ? 32'h00000000 : B_int;
        div_mull               <= 32'h0;
        mod_mulh               <= 32'h0;
        
        // Clear the idle state
        done_int               <= 1'b0;
        done                   <= 1'b0;
      end
      else
      begin
        done                   <= 1'b0;
      end
    end

    // Whilst not done_int, update state
    if (~done_int)
    begin
      // Divide
      if (div_not_mul_saved)
      begin
        // If signed inputs and overflow, set results as per Vol 1. sec 7.2, table 7.1,
        // and flag as done
        if (signed_a_saved & signed_b_saved & A_saved == 32'h80000000 & B_saved == 32'hffffffff)
        begin
          mod_mulh             <= 32'h00000000;
          div_mull             <= 32'h80000000;
          done                 <= 1'b1;
          done_int             <= 1'b1;
        end
        // If divide by zero, set results as per Vol 1. sec 7.2, table 7.1,
        // and flag as done
        else if (~|B_reg)
        begin
          mod_mulh             <= A_saved;
          div_mull             <= 32'hffffffff;
          done                 <= 1'b1;
          done_int             <= 1'b1;
        end
        // When no division exception, update division state
        else
        begin
          b_shift              <= sub[32] ? shifted[31:0] : sub[31:0];
          a_shift[31:0]        <= {a_shift[30:0], ~sub[32]};
          
          // Decrement calculation shift count
          count                <= count - 5'h01;
          
          // Flag calculation complete when stopped (count == 0, or terminated)
          done_int             <= stop;
        end
      end
      // Multiply
      else
      begin
        // If not inferred multiplication, then update the shift and add logic
        if (RV32M_MUL_INFERRED == 0)
        begin
          if (b_shift[0])
          begin
            div_mull           <= next_mul[31:0];
            mod_mulh           <= next_mul[63:32];
          end
          a_shift              <= {a_shift[62:0], 1'b0};
          b_shift              <= {1'b0, b_shift[31:1]};
          
          // Decrement calculation shift count
          count                <= count - 5'h01;
          
          // Flag calculation complete when stopped (count == 0, or terminated)
          done_int             <= stop;
        end
        // If inferred multiplication, then update the state with the DSP outputs
        // and flag done immediately.
        else
        begin
          div_mull             <= next_mul[31:0];
          mod_mulh             <= next_mul[63:32];
          done_int             <= 1'b1;
          inferred_mul_done    <= 1'b1;
        end
      end
    end
    else
    begin
      count                    <= `DIV_COUNT_RESET;
    end

    // There are valid results if the count reaches 1, or an inferred multiplication completes (which doesn't use the count)
    // If a calculation is terminated then the results become invalid.
    result_valid               <= (result_valid | (count == 5'h1) | inferred_mul_done) & ~(terminate & ~done);

  end
end

endmodule