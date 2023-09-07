// -----------------------------------------------------------------------------
//  Title      : UART
//  Project    : RISC-V softcore
// -----------------------------------------------------------------------------
//  File       : core.v
//  Author     : Simon Southwell
//  Created    : 2023-08-23
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block is the top level wrapper for the QSYS generated RS232 UART
// -----------------------------------------------------------------------------
//  Copyright (c) 2023 Simon Southwell
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

module uart
#(parameter CLK_FREQ_MHZ  = 100,
            BAUD_RATE     = 115200
)
(
  // Clock and reset
  input            clk,
  input            reset_n,

  // Serial interface
  input            rx,
  output           tx,

  // Bus interface
  input            address,
  input            read,
  input            write,
  input  [31:0]    writedata,
  output [31:0]    readdata
);

localparam BAUD_TICK_COUNT         = (CLK_FREQ_MHZ*1000000)/BAUD_RATE;
localparam HALF_BAUD_TICK_COUNT    = BAUD_TICK_COUNT/2;

localparam TDW                     = 10;                      // Total data width
localparam DW                      = 8;                       // Data width
localparam ODD_PARITY              = 1'b0;
localparam CW                      = $clog2(BAUD_TICK_COUNT); // Baud counter width


  uart_rs232 #(
     .CW                             (CW),
     .BAUD_TICK_COUNT                (BAUD_TICK_COUNT),
     .HALF_BAUD_TICK_COUNT           (HALF_BAUD_TICK_COUNT),
     .TDW                            (TDW),
     .DW                             (DW),
     .ODD_PARITY                     (ODD_PARITY)
     ) uart_rs232_0_i
     (
     .clk                            (clk),
     .reset                          (~reset_n),

     .address                        (address),
     .chipselect                     (read | write),
     .byteenable                     (4'b1111),
     .read                           (read),
     .write                          (write),
     .writedata                      (writedata),
     .readdata                       (readdata),

     .UART_RXD                       (rx),
     .UART_TXD                       (tx),

     .irq                            ()

  );

endmodule