// -----------------------------------------------------------------------------
//  Title      : Top level of core logic
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : core.v
//  Author     : Simon Southwell
//  Created    : 2021-09-10
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the project specific core logic top level, as instantiated
//  in QSYS.
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

`define RV32I_NOP                       32'h00000013

module core
#(parameter CLK_FREQ_MHZ               = 100,
            RV32I_RESET_VECTOR         = 32'h00000000,
            RV32I_TRAP_VECTOR          = 32'h00000004,
            RV32I_LOG2_REGFILE_ENTRIES = 5,
            RV32I_REGFILE_USE_MEM      = 1,
            RV32I_IMEM_ADDR_WIDTH      = 12,
            RV32I_DMEM_ADDR_WIDTH      = 12,
            RV32I_IMEM_INIT_FILE       = "UNUSED",
            RV32I_DMEM_INIT_FILE       = "UNUSED"
)
(
    input            clk,
    input            clk_x2,
    input            clk_div2,
    input            reset_n,

    // ADC
    output           adc_convst,
    output           adc_sck,
    output           adc_sdi,
    input            adc_sdo,

    // ARDUINO
    output [15:0]    arduino_io_out,
    output [15:0]    arduino_io_oe,
    input  [15:0]    arduino_io_in,
    input            arduino_reset_n,

    // HDMI
    input            hdmi_i2c_sda_in,
    output           hdmi_i2c_sda_out,
    output           hdmi_i2c_sda_oe,
    output           hdmi_i2c_scl,
    output           hdmi_i2s,
    output           hdmi_lrclk,
    output           hdmi_mclk,
    output           hdmi_sclk,
    output           hdmi_tx_clk,
    output [23:0]    hdmi_tx_d,
    output           hdmi_tx_de,
    output           hdmi_tx_hs,
    output           hdmi_tx_vs,
    input            hdmi_tx_int,

    // GPIO
    input  [71:0]    gpio_in,
    output [71:0]    gpio_out,
    output [71:0]    gpio_oe,

    // Key
    input   [1:0]    key,

    // LED
    output  [7:0]    led,

    // Switch
    input   [3:0]    sw,

    // Avalon CSR slave interface
    input  [17:0]    avs_csr_address,
    input            avs_csr_write,
    input  [31:0]    avs_csr_writedata,
    input            avs_csr_read,
    output [31:0]    avs_csr_readdata,

    // Avalon Master burst read interface for FPGA configuration block
    input            avm_rx_waitrequest,
    output [11:0]    avm_rx_burstcount,
    output [31:0]    avm_rx_address,
    output           avm_rx_read,
    input  [31:0]    avm_rx_readdata,
    input            avm_rx_readdatavalid,

    // Avalon Master burst write interface for FPGA configuration block
    input            avm_tx_waitrequest,
    output [11:0]    avm_tx_burstcount,
    output [31:0]    avm_tx_address,
    output           avm_tx_write,
    output [31:0]    avm_tx_writedata,

    output [31:0]    debug_out
);
// ---------------------------------------------------------
// Local parameters
// ---------------------------------------------------------

localparam MEM_BIT_WIDTH               = 32;

// ---------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------

reg   [26:0] count;

// Register access signals
wire         local_write;
wire         local_read;
wire  [31:0] local_readdata;

wire  [31:0] scratch;
wire         core_rstn;

// Memory signals
wire         imem_rd;
wire  [31:0] imem_waddr;
wire  [31:0] imem_raddr;
wire  [31:0] imem_wdata;
wire  [31:0] imem_rdata;

wire         dmem_wr;
wire         dmem_rd;
wire  [31:0] dmem_addr;
wire  [31:0] dmem_wdata;
wire  [31:0] dmem_rdata;
wire   [3:0] dmem_be;
reg          dmem_rd_delay;
wire         dmem_waitreq;

wire         imem_read;
wire         imem_write;
wire  [31:0] imem_readdata;
reg          imem_readdatavalid;

wire         dmem_read;
wire         dmem_write;

// ---------------------------------------------------------
// Tie off unused signals
// ---------------------------------------------------------

assign avm_rx_burstcount               = 12'h0;
assign avm_rx_address                  = 32'h0;
assign avm_rx_read                     =  1'b0;

assign avm_tx_burstcount               = 12'h0;
assign avm_tx_address                  = 32'h0;
assign avm_tx_write                    =  1'b0;
assign avm_tx_writedata                = 32'h0;

assign adc_convst                      =  1'b0;
assign adc_sck                         =  1'b0;
assign adc_sdi                         =  1'b0;

assign arduino_io_out                  = 16'h0;
assign arduino_io_oe                   = 16'h0;

assign hdmi_i2c_sda_out                =  1'b0;
assign hdmi_i2c_sda_oe                 =  1'b0;
assign hdmi_i2c_scl                    =  1'b0;
assign hdmi_i2s                        =  1'b0;
assign hdmi_lrclk                      =  1'b0;
assign hdmi_mclk                       =  1'b0;
assign hdmi_sclk                       =  1'b0;
assign hdmi_tx_clk                     =  1'b0;
assign hdmi_tx_d                       = 23'h0;
assign hdmi_tx_de                      =  1'b0;
assign hdmi_tx_hs                      =  1'b0;
assign hdmi_tx_vs                      =  1'b0;

assign gpio_out                        = 72'h0;
assign gpio_oe                         = 72'h0;

assign debug_out                       = 32'h0;

// ---------------------------------------------------------
// Combinatorial Logic
// ---------------------------------------------------------

assign led                             = {6'h0, ~count[26], count[26]};

// Register controlled core reset
assign core_rstn                       = scratch[0] & reset_n;

// Memory control
assign dmem_waitreq                    = dmem_rd & ~dmem_rd_delay;
assign imem_wdata                      = avs_csr_writedata;
assign imem_waddr                      = avs_csr_address;
assign imem_readdata                   = imem_readdatavalid ? imem_rdata : `RV32I_NOP;

// ---------------------------------------------------------
// Local Synchronous Logic
// ---------------------------------------------------------

always @ (posedge clk)
begin
  if (~reset_n)
  begin
    count                              <= 0;
    imem_readdatavalid                 <= 1'b0;
    dmem_rd_delay                      <= 1'b0;
  end
  else
  begin
    count                              <= count + 27'd1;
    imem_readdatavalid                 <= imem_rd;
    dmem_rd_delay                      <= dmem_rd;
  end
end

// ---------------------------------------------------------
// Address decode
// ---------------------------------------------------------

  core_csr_decode #(17, 15) core_csr_decode_inst
  (
    .avs_address                       (avs_csr_address[17:15]),
    .avs_write                         (avs_csr_write),
    .avs_read                          (avs_csr_read),
    .avs_readdata                      (avs_csr_readdata),

    .local_write                       (local_write),
    .local_read                        (local_read),
    .local_readdata                    (local_readdata),

    .imem_write                        (imem_write),
    .imem_read                         (imem_read),
    .imem_readdata                     (imem_rdata),

    .dmem_write                        (dmem_write),
    .dmem_read                         (dmem_read),
    .dmem_readdata                     (32'h0)
  );

// ---------------------------------------------------------
// Local control and status registers
// ---------------------------------------------------------

  core_csr_regs #(5) core_csr_regs_inst
  (
    .clk                               (clk),
    .rst_n                             (reset_n),

    .scratch                           (scratch),

    .avs_address                       (avs_csr_address[4:0]),
    .avs_write                         (local_write),
    .avs_writedata                     (avs_csr_writedata),
    .avs_read                          (local_read),
    .avs_readdata                      (local_readdata)
  );

// ---------------------------------------------------------
// RV32I RISC-V softcore
// ---------------------------------------------------------

  rv32i_cpu_core #(
   .RV32I_RESET_VECTOR                 (RV32I_RESET_VECTOR),
   .RV32I_TRAP_VECTOR                  (RV32I_TRAP_VECTOR),
   .RV32I_LOG2_REGFILE_ENTRIES         (RV32I_LOG2_REGFILE_ENTRIES),
   .RV32I_REGFILE_USE_MEM              (RV32I_REGFILE_USE_MEM)
 
  )
  rv32i_cpu_core_inst
  (
    .clk                               (clk),
    .reset_n                           (core_rstn),

    .iaddress                          (imem_raddr),
    .iread                             (imem_rd),
    .ireaddata                         (imem_readdata),

    .daddress                          (dmem_addr),
    .dwrite                            (dmem_wr),
    .dwritedata                        (dmem_wdata),
    .dbyteenable                       (dmem_be),
    .dread                             (dmem_rd),
    .dreaddata                         (dmem_rdata),
    .dwaitrequest                      (dmem_waitreq),

    .irq                               (1'b0)
  );

// ---------------------------------------------------------
// Memories
// ---------------------------------------------------------

  dp_ram #(
    .DATA_WIDTH                        (MEM_BIT_WIDTH),
    .ADDR_WIDTH                        (RV32I_IMEM_ADDR_WIDTH),
    .OP_REGISTERED                     ("UNREGISTERED"),
    .INIT_FILE                         (RV32I_IMEM_INIT_FILE)
  ) imem
  (
    .clock                             (clk),

    .wren                              (imem_write),
    .byteena_a                         (4'b1111),
    .wraddress                         (imem_waddr[RV32I_IMEM_ADDR_WIDTH-1:0]),
    .data                              (imem_wdata),

    .rdaddress                         (imem_raddr[RV32I_IMEM_ADDR_WIDTH-1:0]),
    .q                                 (imem_rdata)
  );

  dp_ram #(
    .DATA_WIDTH                        (MEM_BIT_WIDTH),
    .ADDR_WIDTH                        (RV32I_DMEM_ADDR_WIDTH),
    .OP_REGISTERED                     ("UNREGISTERED"),
    .INIT_FILE                         (RV32I_DMEM_INIT_FILE)
  ) dmem
  (
    .clock                             (clk),

    .wren                              (dmem_wr),
    .byteena_a                         (dmem_be),
    .wraddress                         (dmem_addr[RV32I_DMEM_ADDR_WIDTH-1:0]),
    .data                              (dmem_wdata),

    .rdaddress                         (dmem_addr[RV32I_DMEM_ADDR_WIDTH-1:0]),
    .q                                 (dmem_rdata)
  );

endmodule