// -----------------------------------------------------------------------------
//  Title      : CORE Block
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : core_csr_decode_auto.v
//  Author     : auto-generated
//  Created    : 2021-10-23
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

module core_csr_decode 
  #(parameter
    ADDR_DECODE_HI_BIT = 17,
    ADDR_DECODE_LO_BIT = 15
  )
  (
  
    // auto-generated
    
    // Decoded read/write strobes and returned read data
    output reg        local_write,
    output reg        local_read,
    input      [31:0] local_readdata,
    output reg        imem_write,
    output reg        imem_read,
    input      [31:0] imem_readdata,
    output reg        dmem_write,
    output reg        dmem_read,
    input      [31:0] dmem_readdata,
    
    // end auto-generated
    
    // Avalon CSR slave interface
    input      [ADDR_DECODE_HI_BIT:ADDR_DECODE_LO_BIT] avs_address,
    input                                              avs_write,
    input                                              avs_read,
    output     [31:0]                                  avs_readdata
    
  );

  // auto-generated
  assign avs_readdata = local_readdata | imem_readdata | dmem_readdata;
  // end auto-generated

  always @* 
  begin
    // auto-generated
    
    local_write                    <= 1'b0;
    local_read                     <= 1'b0;
    imem_write                     <= 1'b0;
    imem_read                      <= 1'b0;
    dmem_write                     <= 1'b0;
    dmem_read                      <= 1'b0;

    case (avs_address)
    
    3'd0 :
    begin
        local_write                <= avs_write;
        local_read                 <= avs_read;
    end

    3'd1 :
    begin
        imem_write                 <= avs_write;
        imem_read                  <= avs_read;
    end

    3'd2 :
    begin
        dmem_write                 <= avs_write;
        dmem_read                  <= avs_read;
    end


    endcase
    
    // end auto-generated
  end
  
endmodule