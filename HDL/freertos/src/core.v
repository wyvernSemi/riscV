// -----------------------------------------------------------------------------
//  Title      : Top level of core logic
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : core.v
//  Author     : Simon Southwell
//  Created    : 2023-08-23
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the project specific core logic top level, as instantiated
//  in QSYS.
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

module core
#(parameter CLK_FREQ_MHZ               = 100,
            RV32I_RESET_VECTOR         = 32'h00000000,
            RV32I_TRAP_VECTOR          = 32'h00000004,
            RV32I_LOG2_REGFILE_ENTRIES = 5,
            RV32I_REGFILE_USE_MEM      = 1,
            RV32I_IMEM_ADDR_WIDTH      = 14,
            RV32I_DMEM_ADDR_WIDTH      = 11,
            RV32I_IMEM_INIT_FILE       = "UNUSED",
            RV32I_DMEM_INIT_FILE       = "UNUSED",
            RV32_ZICSR_EN              = 1,
            RV32_DISABLE_TIMER         = 0,
            RV32_DISABLE_INSTRET       = 0,
            RV32_M_EN                  = 1,
            RV32M_FIXED_TIMING         = 1,
            RV32M_MUL_INFERRED         = 0,
            UART_BAUD_RATE             = 115200
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

// Memory register access signals
wire         imem_write_csr;
wire         dmem_write_csr;


// Memory signals
wire         imem_rd;
wire  [31:0] imem_waddr;
wire  [31:0] imem_raddr;
wire  [31:0] imem_wdata;
wire  [31:0] imem_rdata;

wire         dmem_write;
wire         dmem_wr;
wire         dmem_rd;
wire         dmem_rd_core;
wire  [31:0] dmem_waddr;
wire  [31:0] dmem_raddr;
wire  [31:0] dmem_addr_core;
wire  [31:0] dmem_wdata;
wire  [31:0] dmem_wdata_core;
wire  [31:0] dmem_rdata;
wire  [31:0] dmem_readdata;
wire   [3:0] dmem_be;
wire   [3:0] dmem_be_core;
reg          dmem_rd_delay;
wire         dmem_waitreq;

wire         imem_write;
wire   [3:0] imem_be;
wire  [31:0] imem_readdata;
wire         imem_waitrequest;

// Signals for timer update interface
wire         wr_mtime;
wire         wr_mtimecmp;
wire         wr_mtime_upper;
wire  [31:0] wr_mtime_val;
wire         rd_mtime;
wire         rd_mtimecmp;
wire  [31:0] rd_mtime_val;

// UART RISC-V signalling
wire         uart_read;
wire         uart_write;
wire  [31:0] uart_readdata;

wire         core_rstn;
wire         local_write_csr;
wire         test_ext_sw_interrupt;

// UART
wire         uart_rx;
wire         uart_tx;


// Asynchronous external Interrupt clock synchronising registers
reg    [1:0] irq_sync;

reg          cpu_reset;

// ---------------------------------------------------------
// Tie off unused signals and ports
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

assign gpio_out[71:1]                  = 71'h0;
assign gpio_oe[71:1]                   = 71'h0;

assign debug_out                       = 32'h0;

assign test_ext_sw_interrupt           = 1'b0;


// ---------------------------------------------------------
// Combinatorial Logic
// ---------------------------------------------------------

// Flash the LEDs to visually check programming
assign led                             = {4'h0, uart_tx, cpu_reset, ~count[26], count[26]};

assign gpio_oe[0]                      = 1'b1;
assign gpio_out[0]                     = uart_tx;
assign uart_rx                         = gpio_in[1];

// Register controlled core reset
assign core_rstn                       = reset_n & ~cpu_reset;

// Memory control
assign dmem_waitreq                    = dmem_rd_core & ~dmem_rd_delay;

wire [19:0] csr_byte_addr              = {avs_csr_address, 2'b00};

// Address decode (system)
wire   csr_sel_imem                    = ~csr_byte_addr[19];
wire   csr_sel_dmem                    =  csr_byte_addr[19] & ~csr_byte_addr[18];
wire   csr_sel_local                   =  csr_byte_addr[19] &  csr_byte_addr[18];

assign imem_write_csr                  = avs_csr_write & csr_sel_imem;
assign dmem_write_csr                  = avs_csr_write & csr_sel_dmem;
assign local_write_csr                 = avs_csr_write & csr_sel_local;

// Address decode RISC-V
wire   sel_mem                         = (dmem_addr_core[31:28] == 4'h0);
wire   sel_uart                        = (dmem_addr_core[31:28] == 4'h8);
wire   sel_mtime                       = (dmem_addr_core[31:28] == 4'ha);

assign imem_write                      = imem_write_csr;
assign imem_wdata                      = avs_csr_writedata;
assign imem_be                         = 4'b1111;
assign imem_waddr                      = csr_byte_addr;
assign imem_readdata                   = imem_rdata;
assign imem_waitrequest                = 1'b0;

assign dmem_write                      = (dmem_wr & sel_mem) | dmem_write_csr;
assign dmem_wdata                      = ~dmem_write_csr ? dmem_wdata_core : avs_csr_writedata;
assign dmem_be                         = dmem_be_core | {4{dmem_write_csr}};
assign dmem_waddr                      = ~dmem_write_csr ? dmem_addr_core : csr_byte_addr;

assign dmem_rd                         = dmem_rd_core | (avs_csr_read & csr_sel_dmem);
assign dmem_raddr                      = dmem_rd_core ? dmem_addr_core : csr_byte_addr;

assign uart_read                       = dmem_rd & sel_uart;
assign uart_write                      = dmem_wr & sel_uart;
assign dmem_readdata                   = sel_uart  ? uart_readdata :
                                         sel_mtime ? rd_mtime_val  :
                                                     dmem_rdata;

assign wr_mtime                        = dmem_wr & sel_mtime & ~dmem_addr_core[3];
assign wr_mtimecmp                     = dmem_wr & sel_mtime &  dmem_addr_core[3];
assign wr_mtime_upper                  = dmem_addr_core[2];
assign wr_mtime_val                    = dmem_wdata_core;
assign rd_mtime                        = dmem_rd & sel_mtime & ~dmem_addr_core[3];
assign rd_mtimecmp                     = dmem_rd & sel_mtime &  dmem_addr_core[3];


assign avs_csr_readdata                = dmem_rdata;

// ---------------------------------------------------------
// Local Synchronous Logic
// ---------------------------------------------------------

always @ (posedge clk)
begin
  if (~reset_n)
  begin
    count                              <= 0;
    dmem_rd_delay                      <= 1'b0;
    irq_sync                           <= 2'b00;
    cpu_reset                          <= 1'b1;
  end
  else
  begin
    count                              <= count + 27'd1;
    dmem_rd_delay                      <= dmem_rd_core;
    //irq_sync                           <= {~gpio_in[0], irq_sync[1]};
    irq_sync                           <= {1'b0, irq_sync[1]};
    cpu_reset                          <= local_write_csr ? avs_csr_writedata[0] : cpu_reset;
  end
end


// ---------------------------------------------------------
// RV32I RISC-V softcore
// ---------------------------------------------------------

  rv32i_cpu_core #(
   .CLK_FREQ_MHZ                       (CLK_FREQ_MHZ),
   .RV32I_RESET_VECTOR                 (RV32I_RESET_VECTOR),
   .RV32I_TRAP_VECTOR                  (RV32I_TRAP_VECTOR),
   .RV32I_LOG2_REGFILE_ENTRIES         (RV32I_LOG2_REGFILE_ENTRIES),
   .RV32I_REGFILE_USE_MEM              (RV32I_REGFILE_USE_MEM),
   .RV32_ZICSR_EN                      (RV32_ZICSR_EN),
   .RV32_DISABLE_TIMER                 (RV32_DISABLE_TIMER),
   .RV32_DISABLE_INSTRET               (RV32_DISABLE_INSTRET),
   .RV32_M_EN                          (RV32_M_EN),
   .RV32M_FIXED_TIMING                 (RV32M_FIXED_TIMING),
   .RV32M_MUL_INFERRED                 (RV32M_MUL_INFERRED)

  )
  rv32i_cpu_core_inst
  (
    .clk                               (clk),
    .reset_n                           (core_rstn),

    .iaddress                          (imem_raddr),
    .iread                             (imem_rd),
    .ireaddata                         (imem_readdata),
    .iwaitrequest                      (imem_waitrequest),

    .daddress                          (dmem_addr_core),
    .dwrite                            (dmem_wr),
    .dwritedata                        (dmem_wdata_core),
    .dbyteenable                       (dmem_be_core),
    .dread                             (dmem_rd_core),
    .dreaddata                         (dmem_readdata),
    .dwaitrequest                      (dmem_waitreq),

    .irq                               (irq_sync[0]),
    .ext_sw_interrupt                  (test_ext_sw_interrupt),

    // Interface to access real-time clock externally
    .wr_mtime                          (wr_mtime),
    .wr_mtimecmp                       (wr_mtimecmp),
    .wr_mtime_upper                    (wr_mtime_upper),
    .wr_mtime_val                      (wr_mtime_val),
    .rd_mtime                          (rd_mtime),
    .rd_mtimecmp                       (rd_mtimecmp),
    .rd_mtime_val                      (rd_mtime_val),

    .test_rd_idx                       (),
    .test_rd_val                       ()
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
    .byteena_a                         (imem_be),
    .wraddress                         (imem_waddr[RV32I_IMEM_ADDR_WIDTH+1:2]),
    .data                              (imem_wdata),

    .rdaddress                         (imem_raddr[RV32I_IMEM_ADDR_WIDTH+1:2]),
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

    .wren                              (dmem_write),
    .byteena_a                         (dmem_be),
    .wraddress                         (dmem_waddr[RV32I_DMEM_ADDR_WIDTH+1:2]),
    .data                              (dmem_wdata),

    .rdaddress                         (dmem_raddr[RV32I_DMEM_ADDR_WIDTH+1:2]),
    .q                                 (dmem_rdata)
  );

// ---------------------------------------------------------
// UART
// ---------------------------------------------------------

  uart #(
   .CLK_FREQ_MHZ                       (CLK_FREQ_MHZ),
   .BAUD_RATE                          (UART_BAUD_RATE)
  )
  uart_i
  (
    // Clock and reset
    .clk                               (clk),
    .reset_n                           (reset_n),

    // Serial interface
    .rx                                (uart_rx),
    .tx                                (uart_tx),

    // Bus interface
    .address                           (dmem_addr_core[2]),
    .read                              (uart_read),
    .write                             (uart_write),
    .writedata                         (dmem_wdata),
    .readdata                          (uart_readdata)
  );

endmodule