// -----------------------------------------------------------------------------
//  Title      : RISC-V RV32 Zicsr extensions
//  Project    : rv32_cpu_core
// -----------------------------------------------------------------------------
//  File       : rv32_zicsr.v
//  Author     : Simon Southwell
//  Created    : 2021-10-01
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block defines the Zicsr extensions for the RISC-V soft processor.
// -----------------------------------------------------------------------------
//  Copyright (c) 2021 Simon Southwell
// -----------------------------------------------------------------------------
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation either version 3 of the License or
//  (at your option) any later version.
//
//  It is distributed in the hope that it will be useful
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this code. If not see <http://www.gnu.org/licenses/>.
//
// -----------------------------------------------------------------------------

`timescale 1ns / 10ps

`define MACH_SW_INT_CODE               4'd0
`define MACH_TIMER_INT_CODE            4'd7
`define MACH_EXT_INT_CODE              4'd11
`define MACH_IADDR_ALIGN_CODE          4'd0
`define MACH_LADDR_ALIGN_CODE          4'd4
`define MACH_SADDR_ALIGN_CODE          4'd6

module rv32_zicsr
#(parameter                            CLK_FREQ_MHZ = 100
)
(
  input                                clk,
  input                                reset_n,

  input                                stall,

  // Values being written to regfile registers
  input       [4:0]                    regfile_rd_idx,
  input      [31:0]                    regfile_rd_val,

  // Exception inputs
  input                                irq,
  input                                exception,
  input      [31:0]                    exception_pc,
  input       [3:0]                    exception_type,
  input      [31:0]                    exception_addr,

  // Machine software interrupts comes from an external memory mapped control register
  input                                ext_sw_interrupt,

  // Machine return instruction
  input                                mret,

  // Zicsr instruction
  input       [1:0]                    zicsr,     // Flag for a Zicsr instruction, with type
  input      [31:0]                    a,         // uimm or rs1 value
  input      [11:0]                    index,     // CSR register index (from decode_b[11:0])
  input       [4:0]                    rd_in,     // zicsr_rd destination register index (0 if no read)
  input       [4:0]                    rs1_in,    // Index of RS1 for ZICSR instructions

  // Instruction retired pulse
  input                                instr_retired,

  // Memory mapped real-time counter access port
  input                                wr_mtime,
  input                                wr_mtimecmp,
  input                                wr_mtime_upper,
  input      [31:0]                    wr_mtime_val,

  // Update program counter port
  output reg                           zicsr_update_pc,
  output reg [31:0]                    zicsr_new_pc,

  // Update RD in register file
  output reg  [4:0]                    zicsr_rd,
  output     [31:0]                    zicsr_rd_val

);

// CSR access signals
reg         write;
reg  [11:0] waddr;
reg  [31:0] writedata;
wire [31:0] readdata;
wire [31:0] readdata_int;
reg  [31:0] readdata_reg;

// Vector base address signals
wire  [1:0] mtvec_mode;
wire [31:0] mtvec_base;

// Status signals
wire        mstatus_pulse;
wire        mstatus_mie_wval;
wire        mstatus_mpie_wval;
wire  [1:0] mstatus_mpp_wval;
reg         mstatus_mie_int;
reg         mstatus_mpie_int;
reg   [1:0] mstatus_mpp_int;

// Exception PC signals
wire        mepc_pulse;
wire [31:0] mepc_wval;
reg  [31:2] mepc_int;

// Trap cause signals
wire        mcause_pulse;
wire  [3:0] mcause_code_wval;
wire        mcause_interrupt_wval;
reg   [3:0] mcause_code_int;
reg         mcause_interrupt_int;
wire  [3:0] next_mcause_code_int;

// Counter inhibit signals
wire        mcountinhibit_cy;
wire        mcountinhibit_ir;

// Cycle count signals
wire        mcycle_pulse;
wire [31:0] mcycle_wval;
reg  [31:0] mcycle_int;
wire        mcycleh_pulse;
wire [31:0] mcycleh_wval;
reg  [31:0] mcycleh_int;

// Real-time timer (ticks at 1us intervals)
reg  [63:0] mtime_int;
reg  [63:0] mtimecmp_int;
reg  [11:0] usec_count;

// Instruction counter
wire        minstret_pulse;
wire [31:0] minstret_wval;
reg  [31:0] minstret_int;
wire        minstreth_pulse;
wire [31:0] minstreth_wval;
reg  [31:0] minstreth_int;

// Interrupt Enable signals
wire        mie_pulse;
wire        mie_msie;
wire        mie_mtie;
wire        mie_meie;
reg         mie_msie_int;
reg         mie_mtie_int;
reg         mie_meie_int;

// Interrupt pending signals
reg         mip_msip;
reg         mip_mtip;
reg         mip_meip;

// Trap value signals
wire        mtval_pulse;
wire [31:0] mtval_wval;
reg  [31:0] mtval_int;

// Interrupt signals
wire        ext_interrupt;
wire        timer_interrupt;
wire        sw_interrupt;
wire        interrupt;
wire        time_gt_cmp;

// Internal version of zicsr input
wire  [1:0] zicsr_int;

// RD bypass signalling
wire [31:0] a_int;

// -----------------------------------------------
// Combinatorial logic
// -----------------------------------------------

// Microsecond counter wrap value as a bit vector function of the clock frequency parameter.
// Note, only the bottom 12 bits are used in the comparison, limiting the supported range
// of the CLK_FREQ_MHZ parameter from 1 to 4096 MHz. Higher frequencies will just require
// more bits, whilst lower frequencies will mean reducing the timer granularity from 1us to
// a longer time period.
wire [31:0] usec_wrap_val              = CLK_FREQ_MHZ - 1;

// Trap vector base always aligned to 32 bits
assign mtvec_base[1:0]                 = 2'b00;

// Flag if timer value greater than comparison value
assign time_gt_cmp                     = (mtime_int >= mtimecmp_int) ? 1'b1 : 1'b0;

// Flag interrupts if enabled
assign ext_interrupt                   = mstatus_mie_int & (mip_meip & mie_meie);
assign timer_interrupt                 = mstatus_mie_int & (mip_mtip & mie_mtie);
assign sw_interrupt                    = mstatus_mie_int & (mip_msip & mie_msie);

// Combine sources of interrupts
assign interrupt                       = timer_interrupt | ext_interrupt | sw_interrupt;

// Select the trap code. Interrupts have priority (external first, then s/w, then timer---[2] sec 3.1.9), then synchronous traps.
assign next_mcause_code_int            = ext_interrupt   ? `MACH_EXT_INT_CODE   :
                                         sw_interrupt    ? `MACH_SW_INT_CODE    :
                                         timer_interrupt ? `MACH_TIMER_INT_CODE :
                                                           exception_type;

// Mask on CSR write data so bypass does not pick up on writes to unused or read only bits
wire [31:0] mask                       = (waddr == 12'h300) ? 32'h00000008 :
                                         (waddr == 12'h304) ? 32'h00000888 :
                                         (waddr == 12'h341) ? 32'hfffffffc :
                                                              32'hffffffff;

// The internal CSR register read data is bypassed if writing to the same location as being read
assign readdata_int                    = (write == 1'b1 && index == waddr) ? (writedata & mask) : readdata;

// Export the registered read data (i.e. the CSR register's old value) to the Zicsr's regfile update data port
assign zicsr_rd_val                    = readdata_reg;

// Bypass A input if destination is being written
assign a_int                           = (|regfile_rd_idx == 1'b1 && regfile_rd_idx == rs1_in) ? regfile_rd_val : a;

// Mask zicsr instruction input when stalled
assign zicsr_int                       = stall ? 2'b00 : zicsr;

// -----------------------------------------------
// Synchronous logic
// -----------------------------------------------
always @(posedge clk)
begin
  if (reset_n == 1'b0)
  begin
    mstatus_mie_int                    <=  1'b0;
    mstatus_mpie_int                   <=  1'b0;
    mstatus_mpp_int                    <=  2'h0;
    mepc_int                           <= 30'h0;
    mcause_code_int                    <=  4'h0;
    mcause_interrupt_int               <=  1'b0;
    mcycle_int                         <= 32'h0;
    mcycleh_int                        <= 32'h0;
    mip_msip                           <=  1'b0;
    mip_mtip                           <=  1'b0;
    mip_meip                           <=  1'b0;
    mie_msie_int                       <=  1'b0;
    mie_mtie_int                       <=  1'b0;
    mie_meie_int                       <=  1'b0;
    usec_count                         <= 12'h0;
    mtime_int                          <= 64'h0;
    mtimecmp_int                       <= {64{1'b1}};  // Set comparaator to maximum time to avoid unintentional interrupts until set
    minstret_int                       <= 32'h0;
    minstreth_int                      <= 32'h0;
    zicsr_update_pc                    <=  1'b0;
    zicsr_rd                           <=  5'h0;
    write                              <=  1'b0;
  end
  else
  begin

    // Default zicsr_update_pc to 0 so it is a pulse when set
    zicsr_update_pc                    <= 1'b0;

    // Manage reads/writes of CSR registers
    write                              <= (|zicsr_int && |rs1_in) ? 1'b1 : 1'b0;
    waddr                              <= index;

    // The CSR register update data is a function of the A input (imm or RS1) and the register's current value (if not CSRRW)
    writedata                          <= (zicsr_int == 2'b01) ?                 a_int :  // CSRRW
                                          (zicsr_int == 2'b10) ? readdata_int |  a_int :  // CSRRS
                                                                 readdata_int & ~a_int;   // CSRRC

    // The registered Zicsr destination register index is the instruction RD index, if a Zicsr instructoin flagged.
    zicsr_rd                           <= {5{|zicsr_int}} & rd_in;

    // The destination register (RD) value is just the old CSR register value
    readdata_reg                       <= readdata_int;

    // Manage timer and counters
    mcycle_int                         <= mcycle_int  + {31'h0, ~mcountinhibit_cy};
    mcycleh_int                        <= mcycleh_int + {31'h0, &mcycle_int};
    usec_count                         <= (usec_count == usec_wrap_val[11:0]) ? 12'h0 : usec_count + 12'h1;
    mtime_int                          <= mtime_int + {63'h0, ~|usec_count};
    minstret_int                       <= minstret_int  + {31'h0, instr_retired & ~mcountinhibit_ir};
    minstreth_int                      <= minstreth_int + {31'h0, &minstret_int};


    // Manage exceptions, updating relvant CSR registers, and jumping to trap vector
    if (interrupt | exception)
    begin
      mcause_interrupt_int             <= interrupt;
      mcause_code_int                  <= next_mcause_code_int;
      mstatus_mpie_int                 <= 1'b1;
      mstatus_mie_int                  <= 1'b0;
      mepc_int                         <= exception_pc[31:2];

      mtval_int                        <= exception_addr;

      zicsr_update_pc                  <= 1'b1;
      zicsr_new_pc                     <= mtvec_base + {26'h0, (next_mcause_code_int & {4{mtvec_mode[0]}}), 2'b00};
    end

    // Set interrupt pending flags
    mip_mtip                           <= time_gt_cmp;
    mip_meip                           <= irq;
    mip_msip                           <= ext_sw_interrupt;

    // Process mret instruction. updating relevant CSR registers, and jumping to mepc address
    if (mret)
    begin
      mstatus_mie_int                  <= mstatus_mpie_int;
      mstatus_mpp_int                  <= 2'b00;
      mstatus_mpie_int                 <= 1'b0;

      zicsr_update_pc                  <= 1'b1;
      zicsr_new_pc                     <= {mepc_pulse ? mepc_wval[31:2] : mepc_int, 2'b00};
    end

    // Update external registers if written to over zicsr_rv32_regs's bus (via CSRxxx instructions)
    if (mstatus_pulse)
    begin
      mstatus_mie_int                  <= mstatus_mie_wval;
    end

    if (mtval_pulse)
    begin
      mtval_int                        <= mtval_wval;
    end

    if (mie_pulse)
    begin
      mie_msie_int                     <= mie_msie;
      mie_mtie_int                     <= mie_mtie;
      mie_meie_int                     <= mie_meie;
    end

    if (mepc_pulse)
    begin
      mepc_int                         <= mepc_wval[31:2];
    end

    if (mcause_pulse)
    begin
      mcause_code_int                  <= mcause_code_wval;
      mcause_interrupt_int             <= mcause_interrupt_wval;
    end

    if (mcycle_pulse)
    begin
      mcycle_int                       <= mcycle_wval;
    end

    if (mcycleh_pulse)
    begin
      mcycleh_int                      <= mcycleh_wval;
    end

    if (minstret_pulse)
    begin
      minstret_int                     <= minstret_wval;
    end

    if (minstreth_pulse)
    begin
      minstreth_int                    <= minstreth_wval;
    end

    // Update mtime/mtimecmp
    if (wr_mtime)
    begin
      if (wr_mtime_upper)
      begin
        mtime_int[63:32]               <= wr_mtime_val;
      end
      else
      begin
        mtime_int[31:0]                <= wr_mtime_val;
      end
    end

    if (wr_mtimecmp)
    begin
      if (wr_mtime_upper)
      begin
        mtimecmp_int[63:32]            <= wr_mtime_val;
      end
      else
      begin
        mtimecmp_int[31:0]             <= wr_mtime_val;
      end
    end

  end
end

  // -----------------------------------------------
  // Instantiate the auto-generated register block
  // -----------------------------------------------

  zicsr_rv32_regs  #(.ADDR_DECODE_WIDTH(12)) regs
  (
    .clk                               (clk),
    .rst_n                             (reset_n),

    .mie_pulse                         (mie_pulse),
    .mie_msie                          (mie_msie),
    .mie_mtie                          (mie_mtie),
    .mie_meie                          (mie_meie),
    .mie_msie_in                       (mie_msie_int),
    .mie_mtie_in                       (mie_mtie_int),
    .mie_meie_in                       (mie_meie_int),

    .mtvec_mode                        (mtvec_mode),
    .mtvec_base                        (mtvec_base[31:2]),

    .mstatus_pulse                     (mstatus_pulse),
    .mstatus_mie                       (mstatus_mie_wval),
    .mstatus_mie_in                    (mstatus_mie_int),
    .mstatus_mpie                      (mstatus_mpie_wval),
    .mstatus_mpie_in                   (mstatus_mpie_int),
    .mstatus_mpp                       (mstatus_mpp_wval),
    .mstatus_mpp_in                    (mstatus_mpp_int),

    .mepc_pulse                        (mepc_pulse),
    .mepc                              (mepc_wval),
    .mepc_in                           ({mepc_int, 2'b00}),

    .mcause_pulse                      (mcause_pulse),
    .mcause_code                       (mcause_code_wval),
    .mcause_code_in                    (mcause_code_int),
    .mcause_interrupt                  (mcause_interrupt_wval),
    .mcause_interrupt_in               (mcause_interrupt_int),

    .mtval_pulse                       (mtval_pulse),
    .mtval                             (mtval_wval),
    .mtval_in                          (mtval_int),

    .mcountinhibit_cy                  (mcountinhibit_cy),
    .mcountinhibit_ir                  (mcountinhibit_ir),

    .mcycle_pulse                      (mcycle_pulse),
    .mcycle                            (mcycle_wval),
    .mcycle_in                         (mcycle_int),
    .mcycleh_pulse                     (mcycleh_pulse),
    .mcycleh                           (mcycleh_wval),
    .mcycleh_in                        (mcycleh_int),

    .minstret_pulse                    (minstret_pulse),
    .minstret                          (minstret_wval),
    .minstret_in                       (minstret_int),
    .minstreth_pulse                   (minstreth_pulse),
    .minstreth                         (minstreth_wval),
    .minstreth_in                      (minstreth_int),

    .ucycle                            (mcycle_int),
    .utime                             (mtime_int[31:0]),
    .uinstret                          (minstret_int),
    .ucycleh                           (mcycleh_int),
    .utimeh                            (mtime_int[63:32]),
    .uinstreth                         (minstreth_int),

    .mip_msip                          (mip_msip),
    .mip_mtip                          (mip_mtip),
    .mip_meip                          (mip_meip),

    .avs_waddress                      (waddr),
    .avs_write                         (write),
    .avs_writedata                     (writedata),
    .avs_raddress                      (index),
    .avs_read                          (1'b1),
    .early_readdata                    (readdata)
  );

endmodule