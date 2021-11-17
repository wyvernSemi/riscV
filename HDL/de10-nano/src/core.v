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

module core
#(parameter CLK_FREQ_MHZ               = 100,
            RV32I_RESET_VECTOR         = 32'h00000000,
            RV32I_TRAP_VECTOR          = 32'h00000004,
            RV32I_LOG2_REGFILE_ENTRIES = 5,
            RV32I_REGFILE_USE_MEM      = 1,
            RV32I_IMEM_ADDR_WIDTH      = 12,
            RV32I_DMEM_ADDR_WIDTH      = 12,
            RV32I_IMEM_INIT_FILE       = "UNUSED",
            RV32I_DMEM_INIT_FILE       = "UNUSED",
            RV32_ZICSR_EN              = 1,
            RV32_DISABLE_TIMER         = 0,
            RV32_DISABLE_INSTRET       = 0,
            RV32_M_EN                  = 1,
            RV32M_FIXED_TIMING         = 0,
            RV32M_MUL_INFERRED         = 1,
            // Next parameters altered strictly for test purposes only
            RV32I_IMEM_SHADOW_WR       = 0,
            RV32I_INCL_TEST_BLOCK      = 0
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

wire         core_rstn;
wire  [31:0] test_gp;

wire         halt_on_addr;
wire         halt_on_unimp;
wire         halt_on_ecall;
wire  [31:0] halt_addr;

// Memory register access signals
wire         imem_read_csr;
wire         imem_write_csr;
wire         dmem_read_csr;


// Memory signals
wire         imem_rd;
wire  [31:0] imem_waddr;
wire  [31:0] imem_raddr;
wire  [31:0] imem_wdata;
wire  [31:0] imem_rdata;

wire         dmem_write;
wire         dmem_wr;
wire         dmem_rd;
wire  [31:0] dmem_waddr;
wire  [31:0] dmem_addr;
wire  [31:0] dmem_wdata;
wire  [31:0] dmem_wdata_core;
wire  [31:0] dmem_rdata;
wire   [3:0] dmem_be;
wire   [3:0] dmem_be_core;
reg          dmem_rd_delay;
wire         dmem_waitreq;

wire         imem_write;
wire   [3:0] imem_be;
wire  [31:0] imem_readdata;
wire         imem_waitrequest;

// Test block signals
wire   [4:0] test_rd_idx;
wire  [31:0] test_rd_val;
wire         test_halt;
wire         test_clr_halt;

wire         test_timer_lo_pulse;
wire         test_timer_hi_pulse;
wire         test_time_cmp_lo_pulse;
wire         test_time_cmp_hi_pulse;
wire         test_ext_sw_interrupt;

// Signals for timer update interface
wire         wr_mtime;
wire         wr_mtimecmp;
wire         wr_mtime_upper;
wire  [31:0] wr_mtime_val;

// Asynchronous external Interrupt clock synchronising registers
reg    [1:0] irq_sync;

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

assign gpio_out                        = 72'h0;
assign gpio_oe                         = 72'h0;

assign debug_out                       = 32'h0;

// ---------------------------------------------------------
// Combinatorial Logic
// ---------------------------------------------------------

// Flash the LEDs to visually check programming
assign led                             = {6'h0, ~count[26], count[26]};

// Register controlled core reset
assign core_rstn                       = ~test_halt & reset_n;

// Memory control
assign dmem_waitreq                    = dmem_rd & ~dmem_rd_delay;

// When RV32I_IMEM_SHADOW_WR = 1, write to IMEM when DMEM written
assign imem_write                      = imem_write_csr | (RV32I_IMEM_SHADOW_WR[0] & dmem_wr);
assign imem_wdata                      = ~(RV32I_IMEM_SHADOW_WR[0] & dmem_wr) ? avs_csr_writedata : dmem_wdata_core;
assign imem_be                         = {4{imem_write_csr}} | (dmem_be_core & {4{RV32I_IMEM_SHADOW_WR[0]}});
assign imem_waddr                      = ~(RV32I_IMEM_SHADOW_WR[0] & dmem_wr) ? {avs_csr_address, 2'b00} : dmem_addr ; // Byte address
assign imem_readdata                   = imem_rdata;
assign imem_waitrequest                = 1'b0;

// When RV32I_IMEM_SHADOW_WR = 1, write to DMEM when IMEM written
assign dmem_write                      = dmem_wr | (imem_write_csr & RV32I_IMEM_SHADOW_WR[0]);
assign dmem_wdata                      = ~(imem_write_csr & RV32I_IMEM_SHADOW_WR[0]) ? dmem_wdata_core : avs_csr_writedata;
assign dmem_be                         = dmem_be_core | {4{imem_write_csr & RV32I_IMEM_SHADOW_WR[0]}};
assign dmem_waddr                      = ~(imem_write_csr & RV32I_IMEM_SHADOW_WR[0]) ? dmem_addr : {avs_csr_address, 2'b00};

assign wr_mtime                        = test_timer_lo_pulse    | test_timer_hi_pulse;
assign wr_mtimecmp                     = test_time_cmp_lo_pulse | test_time_cmp_hi_pulse;
assign wr_mtime_upper                  = test_timer_hi_pulse    | test_time_cmp_hi_pulse;
assign wr_mtime_val                    = avs_csr_writedata;

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
  end
  else
  begin
    count                              <= count + 27'd1;
    dmem_rd_delay                      <= dmem_rd;
    irq_sync                           <= {~gpio_in[0], irq_sync[1]};
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

    .imem_write                        (imem_write_csr),
    .imem_read                         (imem_read_csr),
    .imem_readdata                     (32'h0),

    .dmem_write                        (),  // Unused at present
    .dmem_read                         (dmem_read_csr),
    .dmem_readdata                     (32'h0)
  );

// ---------------------------------------------------------
// Local control and status registers
// ---------------------------------------------------------

  core_csr_regs #(5) core_csr_regs_inst
  (
    .clk                               (clk),
    .rst_n                             (reset_n),

    .control_halt_on_addr              (halt_on_addr),
    .control_halt_on_unimp             (halt_on_unimp),
    .control_halt_on_ecall             (halt_on_ecall),
    .control_clr_halt                  (test_clr_halt),
    .halt_addr                         (halt_addr),
    .status_halted                     (test_halt),
    .status_reset                      (core_rstn),
    .gp                                (test_gp),

    .test_timer_lo_pulse               (test_timer_lo_pulse),
    .test_timer_lo_in                  (32'h0),
    .test_timer_hi_pulse               (test_timer_hi_pulse),
    .test_timer_hi_in                  (32'h0),
    .test_time_cmp_lo_pulse            (test_time_cmp_lo_pulse),
    .test_time_cmp_lo_in               (32'h0),
    .test_time_cmp_hi_pulse            (test_time_cmp_hi_pulse),
    .test_time_cmp_hi_in               (32'h0),
    .test_ext_sw_interrupt             (test_ext_sw_interrupt),

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

    .daddress                          (dmem_addr),
    .dwrite                            (dmem_wr),
    .dwritedata                        (dmem_wdata_core),
    .dbyteenable                       (dmem_be_core),
    .dread                             (dmem_rd),
    .dreaddata                         (dmem_rdata),
    .dwaitrequest                      (dmem_waitreq),

    .irq                               (irq_sync[0]),
    .ext_sw_interrupt                  (test_ext_sw_interrupt),

    // Interface to update real-time clock externally
    .wr_mtime                          (wr_mtime),
    .wr_mtimecmp                       (wr_mtimecmp),
    .wr_mtime_upper                    (wr_mtime_upper),
    .wr_mtime_val                      (wr_mtime_val),

    .test_rd_idx                       (test_rd_idx),
    .test_rd_val                       (test_rd_val)
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

    .rdaddress                         (dmem_addr[RV32I_DMEM_ADDR_WIDTH+1:2]),
    .q                                 (dmem_rdata)
  );

// ---------------------------------------------------------
// Test module
// ---------------------------------------------------------

generate

  if (RV32I_INCL_TEST_BLOCK == 1)
  begin : test_blk

    core_test test
    (
      .clk                             (clk),
      .reset_n                         (reset_n),

      .iaddr                           (imem_raddr),
      .irdata                          (imem_rdata),
      .iread                           (imem_rd),
      .iwaitreq                        (imem_waitrequest),

      .halt_on_unimp                   (halt_on_unimp),
      .halt_on_ecall                   (halt_on_ecall),
      .halt_on_addr                    (halt_on_addr),
      .halt_addr                       (halt_addr),
      .clr_halt                        (test_clr_halt),

      .rd_idx                          (test_rd_idx),
      .rd_val                          (test_rd_val),

      .halt                            (test_halt),
      .gp                              (test_gp)
    );

  end
  else
  begin : no_test_blk

    assign test_halt                   = 1'b0;
    assign test_gp                     = 32'h00000000;

  end
endgenerate

endmodule