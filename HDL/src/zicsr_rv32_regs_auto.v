// -----------------------------------------------------------------------------
//  Title      : ZICSR Block
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : zicsr_rv32_regs_auto.v
//  Author     : auto-generated
//  Created    : 2021-11-01
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block is the registers for the Zicsr extensions
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

`include "zicsr_auto.vh"

module zicsr_rv32_regs
  #(parameter
    ADDR_DECODE_WIDTH = 8
  )
  (
    // Clock and reset
    input                          clk,
    input                          rst_n,

    // auto-generated

    // Internal signal ports
    output       [1:0]    mtvec_mode,
    output      [31:2]    mtvec_base,
    output                mcountinhibit_cy,
    output                mcountinhibit_ir,
    output      [31:0]    mscratch,
    output reg            mstatus_pulse,
    output                mstatus_mie,
    input                 mstatus_mie_in,
    output                mstatus_mpie,
    input                 mstatus_mpie_in,
    output     [12:11]    mstatus_mpp,
    input      [12:11]    mstatus_mpp_in,
    output reg            mie_pulse,
    output                mie_msie,
    input                 mie_msie_in,
    output                mie_mtie,
    input                 mie_mtie_in,
    output                mie_meie,
    input                 mie_meie_in,
    output reg            mepc_pulse,
    output      [31:0]    mepc,
    input       [31:0]    mepc_in,
    output reg            mcause_pulse,
    output       [3:0]    mcause_code,
    input        [3:0]    mcause_code_in,
    output                mcause_interrupt,
    input                 mcause_interrupt_in,
    output reg            mtval_pulse,
    output      [31:0]    mtval,
    input       [31:0]    mtval_in,
    output reg            mcycle_pulse,
    output      [31:0]    mcycle,
    input       [31:0]    mcycle_in,
    output reg            minstret_pulse,
    output      [31:0]    minstret,
    input       [31:0]    minstret_in,
    output reg            mcycleh_pulse,
    output      [31:0]    mcycleh,
    input       [31:0]    mcycleh_in,
    output reg            minstreth_pulse,
    output      [31:0]    minstreth,
    input       [31:0]    minstreth_in,
    input                 mip_msip,
    input                 mip_mtip,
    input                 mip_meip,
    input       [31:0]    ucycle,
    input       [31:0]    utime,
    input       [31:0]    uinstret,
    input       [31:0]    ucycleh,
    input       [31:0]    utimeh,
    input       [31:0]    uinstreth,

    // end auto-generated

    // Slave bus port
    input  [ADDR_DECODE_WIDTH-1:0] avs_waddress,
    input  [ADDR_DECODE_WIDTH-1:0] avs_raddress,
    input                          avs_write,
    input  [31:0]                  avs_writedata,
    input                          avs_read,
    output [31:0]                  avs_readdata,
    output [31:0]                  early_readdata

  );


  reg [31:0] next_avs_readdata;
  reg [31:0] avs_readdata_reg;

  // auto-generated
  
  reg       [1:0]    mtvec_mode_reg;
  reg      [31:2]    mtvec_base_reg;
  reg                mcountinhibit_cy_reg;
  reg                mcountinhibit_ir_reg;
  reg      [31:0]    mscratch_reg;
  reg       [1:0]    next_mtvec_mode;
  reg      [31:2]    next_mtvec_base;
  reg                next_mcountinhibit_cy;
  reg                next_mcountinhibit_ir;
  reg      [31:0]    next_mscratch;
  
  // end auto-generated
  
  
  // Export registers interface read data to output port
  assign avs_readdata   = avs_readdata_reg;
  assign early_readdata = next_avs_readdata;
  
  // auto-generated
  
  // Export internal write registers to output ports
  assign mtvec_mode                      = mtvec_mode_reg;
  assign mtvec_base                      = mtvec_base_reg;
  assign mcountinhibit_cy                = mcountinhibit_cy_reg;
  assign mcountinhibit_ir                = mcountinhibit_ir_reg;
  assign mscratch                        = mscratch_reg;

  // Export AVS write bus to write pulse register ports
  assign mstatus_mie                     = avs_writedata[3];
  assign mstatus_mpie                    = avs_writedata[7];
  assign mstatus_mpp                     = avs_writedata[12:11];
  assign mie_msie                        = avs_writedata[3];
  assign mie_mtie                        = avs_writedata[7];
  assign mie_meie                        = avs_writedata[11];
  assign mepc                            = avs_writedata[31:0];
  assign mcause_code                     = avs_writedata[3:0];
  assign mcause_interrupt                = avs_writedata[31];
  assign mtval                           = avs_writedata[31:0];
  assign mcycle                          = avs_writedata[31:0];
  assign minstret                        = avs_writedata[31:0];
  assign mcycleh                         = avs_writedata[31:0];
  assign minstreth                       = avs_writedata[31:0];
  
  // end auto-generated

  // Process to calculate next state, generate output read/write pulses
  // and write pulse register output
  always @*
  begin
  
    // Default reads to 0. (Allows ORing of busses.)
    next_avs_readdata <= 0;
  
    // auto-generated
  
    // Default the internal write register next values to be current state
    next_mtvec_mode                      <= mtvec_mode_reg;
    next_mtvec_base                      <= mtvec_base_reg;
    next_mcountinhibit_cy                <= mcountinhibit_cy_reg;
    next_mcountinhibit_ir                <= mcountinhibit_ir_reg;
    next_mscratch                        <= mscratch_reg;
  
    // Default the write-clear register next values to 0
  
    // Default the read- and write-pulse register pulse outputs to 0
    mstatus_pulse                        <= 1'b0;
    mie_pulse                            <= 1'b0;
    mepc_pulse                           <= 1'b0;
    mcause_pulse                         <= 1'b0;
    mtval_pulse                          <= 1'b0;
    mcycle_pulse                         <= 1'b0;
    minstret_pulse                       <= 1'b0;
    mcycleh_pulse                        <= 1'b0;
    minstreth_pulse                      <= 1'b0;
  
    // end auto-generated
  
    // Bus write active
    if (avs_write == 1'b1)
    begin
      case (avs_waddress)
  
        // auto-generated
  
        // Write (and write pulse) register case statements

        `RV32_MCAUSE_ADDR :
        begin
          mcause_pulse                   <= 1'b1;
        end

        `RV32_MCOUNTINHIBIT_ADDR :
        begin
          next_mcountinhibit_cy          <= avs_writedata[0];
          next_mcountinhibit_ir          <= avs_writedata[2];
        end

        `RV32_MCYCLE_ADDR :
        begin
          mcycle_pulse                   <= 1'b1;
        end

        `RV32_MCYCLEH_ADDR :
        begin
          mcycleh_pulse                  <= 1'b1;
        end

        `RV32_MEPC_ADDR :
        begin
          mepc_pulse                     <= 1'b1;
        end

        `RV32_MIE_ADDR :
        begin
          mie_pulse                      <= 1'b1;
        end

        `RV32_MINSTRET_ADDR :
        begin
          minstret_pulse                 <= 1'b1;
        end

        `RV32_MINSTRETH_ADDR :
        begin
          minstreth_pulse                <= 1'b1;
        end

        `RV32_MSCRATCH_ADDR :
        begin
          next_mscratch                  <= avs_writedata[31:0];
        end

        `RV32_MSTATUS_ADDR :
        begin
          mstatus_pulse                  <= 1'b1;
        end

        `RV32_MTVAL_ADDR :
        begin
          mtval_pulse                    <= 1'b1;
        end

        `RV32_MTVEC_ADDR :
        begin
          next_mtvec_base                <= avs_writedata[31:2];
          next_mtvec_mode                <= avs_writedata[1:0];
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
  
      case (avs_raddress)
  
        // auto-generated
  
        // Write and read (incl. constant) case statements

        `RV32_MARCHID_ADDR :
        begin
          next_avs_readdata[31:0]             <= 32'h0;
        end

        `RV32_MCAUSE_ADDR :
        begin
          next_avs_readdata[3:0]              <= mcause_code_in;
          next_avs_readdata[31]               <= mcause_interrupt_in;
        end

        `RV32_MCOUNTEREN_ADDR :
        begin
          next_avs_readdata[31:0]             <= 32'h0;
        end

        `RV32_MCOUNTINHIBIT_ADDR :
        begin
          next_avs_readdata[0]                <= mcountinhibit_cy_reg;
          next_avs_readdata[2]                <= mcountinhibit_ir_reg;
        end

        `RV32_MCYCLE_ADDR :
        begin
          next_avs_readdata[31:0]             <= mcycle_in;
        end

        `RV32_MCYCLEH_ADDR :
        begin
          next_avs_readdata[31:0]             <= mcycleh_in;
        end

        `RV32_MEPC_ADDR :
        begin
          next_avs_readdata[31:0]             <= mepc_in;
        end

        `RV32_MHARTID_ADDR :
        begin
          next_avs_readdata[31:0]             <= 32'h0;
        end

        `RV32_MIE_ADDR :
        begin
          next_avs_readdata[11]               <= mie_meie_in;
          next_avs_readdata[3]                <= mie_msie_in;
          next_avs_readdata[7]                <= mie_mtie_in;
          next_avs_readdata[9]                <= 1'b0;
          next_avs_readdata[1]                <= 1'b0;
          next_avs_readdata[5]                <= 1'b0;
          next_avs_readdata[8]                <= 1'b0;
          next_avs_readdata[0]                <= 1'b0;
          next_avs_readdata[4]                <= 1'b0;
        end

        `RV32_MIMPID_ADDR :
        begin
          next_avs_readdata[31:0]             <= 32'h0;
        end

        `RV32_MINSTRET_ADDR :
        begin
          next_avs_readdata[31:0]             <= minstret_in;
        end

        `RV32_MINSTRETH_ADDR :
        begin
          next_avs_readdata[31:0]             <= minstreth_in;
        end

        `RV32_MIP_ADDR :
        begin
          next_avs_readdata[11]               <= mip_meip;
          next_avs_readdata[3]                <= mip_msip;
          next_avs_readdata[7]                <= mip_mtip;
          next_avs_readdata[9]                <= 1'b0;
          next_avs_readdata[1]                <= 1'b0;
          next_avs_readdata[5]                <= 1'b0;
          next_avs_readdata[8]                <= 1'b0;
          next_avs_readdata[0]                <= 1'b0;
          next_avs_readdata[4]                <= 1'b0;
        end

        `RV32_MISA_ADDR :
        begin
          next_avs_readdata[25:0]             <= 26'h0000100;
          next_avs_readdata[31:30]            <= 2'h1;
        end

        `RV32_MSCRATCH_ADDR :
        begin
          next_avs_readdata[31:0]             <= mscratch_reg;
        end

        `RV32_MSTATUS_ADDR :
        begin
          next_avs_readdata[14:13]            <= 2'h0;
          next_avs_readdata[3]                <= mstatus_mie_in;
          next_avs_readdata[7]                <= mstatus_mpie_in;
          next_avs_readdata[12:11]            <= mstatus_mpp_in;
          next_avs_readdata[17]               <= 1'b0;
          next_avs_readdata[19]               <= 1'b0;
          next_avs_readdata[31]               <= 1'b0;
          next_avs_readdata[1]                <= 1'b0;
          next_avs_readdata[5]                <= 1'b0;
          next_avs_readdata[8]                <= 1'b0;
          next_avs_readdata[18]               <= 1'b0;
          next_avs_readdata[22]               <= 1'b0;
          next_avs_readdata[20]               <= 1'b0;
          next_avs_readdata[21]               <= 1'b0;
          next_avs_readdata[0]                <= 1'b0;
          next_avs_readdata[4]                <= 1'b0;
          next_avs_readdata[16:15]            <= 2'h0;
        end

        `RV32_MTVAL_ADDR :
        begin
          next_avs_readdata[31:0]             <= mtval_in;
        end

        `RV32_MTVEC_ADDR :
        begin
          next_avs_readdata[31:2]             <= mtvec_base_reg;
          next_avs_readdata[1:0]              <= mtvec_mode_reg;
        end

        `RV32_MVENDOR_ADDR :
        begin
          next_avs_readdata[31:0]             <= 32'h0;
        end

        `RV32_UCYCLE_ADDR :
        begin
          next_avs_readdata[31:0]             <= ucycle;
        end

        `RV32_UCYCLEH_ADDR :
        begin
          next_avs_readdata[31:0]             <= ucycleh;
        end

        `RV32_UINSTRET_ADDR :
        begin
          next_avs_readdata[31:0]             <= uinstret;
        end

        `RV32_UINSTRETH_ADDR :
        begin
          next_avs_readdata[31:0]             <= uinstreth;
        end

        `RV32_UTIME_ADDR :
        begin
          next_avs_readdata[31:0]             <= utime;
        end

        `RV32_UTIMEH_ADDR :
        begin
          next_avs_readdata[31:0]             <= utimeh;
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
      mtvec_mode_reg                       <= 2'h0;
      mtvec_base_reg                       <= 30'h00000001;
      mcountinhibit_cy_reg                 <= 1'b0;
      mcountinhibit_ir_reg                 <= 1'b0;
      mscratch_reg                         <= 32'h0;
  
      // end auto-generated
    end
    else
    begin
      avs_readdata_reg                     <= next_avs_readdata;
  
      // auto-generated
  
      // Internal write register state updates
      mtvec_mode_reg                       <= next_mtvec_mode;
      mtvec_base_reg                       <= next_mtvec_base;
      mcountinhibit_cy_reg                 <= next_mcountinhibit_cy;
      mcountinhibit_ir_reg                 <= next_mcountinhibit_ir;
      mscratch_reg                         <= next_mscratch;
  
      // end auto-generated
  
    end
  end

endmodule

