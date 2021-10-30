// -----------------------------------------------------------------------------
//  Title      : CORE Block
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : core_csr_regs_auto.v
//  Author     : auto-generated
//  Created    : 2021-10-30
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
// This block is the core registers
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
//
// -----------------------------------------------------------------------------
// --------------------- AUTO-GENERATED FILE. DO NOT EDIT ----------------------
// -----------------------------------------------------------------------------

`timescale 1ns / 10ps

`include "core_auto.vh"

module core_csr_regs
  #(parameter
    ADDR_DECODE_WIDTH = 8
  )
  (
    // Clock and reset
    input                          clk,
    input                          rst_n,

    // auto-generated

    // Internal signal ports
    output                control_halt_on_addr,
    output                control_halt_on_unimp,
    output                control_halt_on_ecall,
    output      [31:0]    halt_addr,
    output                test_ext_sw_interrupt,
    output                control_clr_halt,
    output reg            test_timer_lo_pulse,
    output      [31:0]    test_timer_lo,
    input       [31:0]    test_timer_lo_in,
    output reg            test_timer_hi_pulse,
    output      [31:0]    test_timer_hi,
    input       [31:0]    test_timer_hi_in,
    output reg            test_time_cmp_lo_pulse,
    output      [31:0]    test_time_cmp_lo,
    input       [31:0]    test_time_cmp_lo_in,
    output reg            test_time_cmp_hi_pulse,
    output      [31:0]    test_time_cmp_hi,
    input       [31:0]    test_time_cmp_hi_in,
    input                 status_halted,
    input                 status_reset,
    input       [31:0]    gp,

    // end auto-generated

    // Slave bus port
    input  [ADDR_DECODE_WIDTH-1:0] avs_address,
    input                          avs_write,
    input  [31:0]                  avs_writedata,
    input                          avs_read,
    output [31:0]                  avs_readdata

  );


  reg [31:0] next_avs_readdata;
  reg [31:0] avs_readdata_reg;

  // auto-generated
  
  reg                control_halt_on_addr_reg;
  reg                control_halt_on_unimp_reg;
  reg                control_halt_on_ecall_reg;
  reg      [31:0]    halt_addr_reg;
  reg                test_ext_sw_interrupt_reg;
  reg                control_clr_halt_reg;
  reg                next_control_halt_on_addr;
  reg                next_control_halt_on_unimp;
  reg                next_control_halt_on_ecall;
  reg      [31:0]    next_halt_addr;
  reg                next_test_ext_sw_interrupt;
  reg                next_control_clr_halt;
  
  // end auto-generated
  
  
  // Export registers interface read data to output port
  assign avs_readdata = avs_readdata_reg;
  
  // auto-generated
  
  // Export internal write registers to output ports
  assign control_halt_on_addr            = control_halt_on_addr_reg;
  assign control_halt_on_unimp           = control_halt_on_unimp_reg;
  assign control_halt_on_ecall           = control_halt_on_ecall_reg;
  assign halt_addr                       = halt_addr_reg;
  assign test_ext_sw_interrupt           = test_ext_sw_interrupt_reg;
  assign control_clr_halt                = control_clr_halt_reg;

  // Export AVS write bus to write pulse register ports
  assign test_timer_lo                   = avs_writedata[31:0];
  assign test_timer_hi                   = avs_writedata[31:0];
  assign test_time_cmp_lo                = avs_writedata[31:0];
  assign test_time_cmp_hi                = avs_writedata[31:0];
  
  // end auto-generated

  // Process to calculate next state, generate output read/write pulses
  // and write pulse register output
  always @*
  begin
  
    // Default reads to 0. (Allows ORing of busses.)
    next_avs_readdata <= 0;
  
    // auto-generated
  
    // Default the internal write register next values to be current state
    next_control_halt_on_addr            <= control_halt_on_addr_reg;
    next_control_halt_on_unimp           <= control_halt_on_unimp_reg;
    next_control_halt_on_ecall           <= control_halt_on_ecall_reg;
    next_halt_addr                       <= halt_addr_reg;
    next_test_ext_sw_interrupt           <= test_ext_sw_interrupt_reg;
  
    // Default the write-clear register next values to 0
    next_control_clr_halt                <= 1'b0;
  
    // Default the read- and write-pulse register pulse outputs to 0
    test_timer_lo_pulse                  <= 1'b0;
    test_timer_hi_pulse                  <= 1'b0;
    test_time_cmp_lo_pulse               <= 1'b0;
    test_time_cmp_hi_pulse               <= 1'b0;
  
    // end auto-generated
  
    // Bus write active
    if (avs_write == 1'b1)
    begin
      case (avs_address)
  
        // auto-generated
  
        // Write (and write pulse) register case statements

        `CSR_CONTROL_ADDR :
        begin
          next_control_clr_halt          <= avs_writedata[0];
          next_control_halt_on_addr      <= avs_writedata[1];
          next_control_halt_on_ecall     <= avs_writedata[3];
          next_control_halt_on_unimp     <= avs_writedata[2];
        end

        `CSR_HALT_ADDR_ADDR :
        begin
          next_halt_addr                 <= avs_writedata[31:0];
        end

        `CSR_TEST_EXT_SW_INTERRUPT_ADDR :
        begin
          next_test_ext_sw_interrupt     <= avs_writedata[0];
        end

        `CSR_TEST_TIME_CMP_HI_ADDR :
        begin
          test_time_cmp_hi_pulse         <= 1'b1;
        end

        `CSR_TEST_TIME_CMP_LO_ADDR :
        begin
          test_time_cmp_lo_pulse         <= 1'b1;
        end

        `CSR_TEST_TIMER_HI_ADDR :
        begin
          test_timer_hi_pulse            <= 1'b1;
        end

        `CSR_TEST_TIMER_LO_ADDR :
        begin
          test_timer_lo_pulse            <= 1'b1;
        end
        
        default:
        begin
            next_avs_readdata <= 32'h0; // Added to make sure not an empty clause
        end
        // end auto-generated
  
      endcase
    end
  
    // Bus read active
    if (avs_read == 1'b1)
    begin
      // Default the next_avs_readdata to 0
      next_avs_readdata <= 32'h0;
  
      case (avs_address)
  
        // auto-generated
  
        // Write and read (incl. constant) case statements

        `CSR_CONTROL_ADDR :
        begin
          next_avs_readdata[1]                <= control_halt_on_addr_reg;
          next_avs_readdata[3]                <= control_halt_on_ecall_reg;
          next_avs_readdata[2]                <= control_halt_on_unimp_reg;
        end

        `CSR_GP_ADDR :
        begin
          next_avs_readdata[31:0]             <= gp;
        end

        `CSR_HALT_ADDR_ADDR :
        begin
          next_avs_readdata[31:0]             <= halt_addr_reg;
        end

        `CSR_STATUS_ADDR :
        begin
          next_avs_readdata[0]                <= status_halted;
          next_avs_readdata[1]                <= status_reset;
        end

        `CSR_TEST_EXT_SW_INTERRUPT_ADDR :
        begin
          next_avs_readdata[0]                <= test_ext_sw_interrupt_reg;
        end

        `CSR_TEST_TIME_CMP_HI_ADDR :
        begin
          next_avs_readdata[31:0]             <= test_time_cmp_hi_in;
        end

        `CSR_TEST_TIME_CMP_LO_ADDR :
        begin
          next_avs_readdata[31:0]             <= test_time_cmp_lo_in;
        end

        `CSR_TEST_TIMER_HI_ADDR :
        begin
          next_avs_readdata[31:0]             <= test_timer_hi_in;
        end

        `CSR_TEST_TIMER_LO_ADDR :
        begin
          next_avs_readdata[31:0]             <= test_timer_lo_in;
        end
        // end auto-generated
  
        // Default an active read on non-existent register
        default :
          next_avs_readdata <= 32'h0;
  
      endcase
    end
  end
  
  // Process to update internal state
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
    begin
  
      avs_readdata_reg                     <= 32'h0;
  
      // auto-generated
  
      // Reset internal write registers
      control_halt_on_addr_reg             <= 1'b0;
      control_halt_on_unimp_reg            <= 1'b0;
      control_halt_on_ecall_reg            <= 1'b0;
      halt_addr_reg                        <= 32'h00000040;
      test_ext_sw_interrupt_reg            <= 1'b0;
      control_clr_halt_reg                 <= 1'b0;
  
      // end auto-generated
    end
    else
    begin
      avs_readdata_reg                     <= next_avs_readdata;
  
      // auto-generated
  
      // Internal write register state updates
      control_halt_on_addr_reg             <= next_control_halt_on_addr;
      control_halt_on_unimp_reg            <= next_control_halt_on_unimp;
      control_halt_on_ecall_reg            <= next_control_halt_on_ecall;
      halt_addr_reg                        <= next_halt_addr;
      test_ext_sw_interrupt_reg            <= next_test_ext_sw_interrupt;
      control_clr_halt_reg                 <= next_control_clr_halt;
  
      // end auto-generated
  
    end
  end

endmodule

