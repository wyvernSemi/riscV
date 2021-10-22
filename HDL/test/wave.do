onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb -radix unsigned /tb/clk
add wave -noupdate -group tb /tb/count
add wave -noupdate -group tb /tb/reset_n
add wave -noupdate -group tb /tb/test_halt
add wave -noupdate -group tb -radix hexadecimal /tb/avs_csr_address
add wave -noupdate -group tb /tb/avs_csr_read
add wave -noupdate -group tb -radix hexadecimal /tb/avs_csr_readdata
add wave -noupdate -group tb /tb/avs_csr_write
add wave -noupdate -group tb -radix hexadecimal /tb/avs_csr_writedata
add wave -noupdate -group tb -radix hexadecimal -childformat {{{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} -radix hexadecimal}} -subitemconfig {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} {-height 15 -radix hexadecimal}} /tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data
add wave -noupdate -group core /tb/uut/MEM_BIT_WIDTH
add wave -noupdate -group core /tb/uut/RV32I_DMEM_ADDR_WIDTH
add wave -noupdate -group core /tb/uut/RV32I_IMEM_ADDR_WIDTH
add wave -noupdate -group core -radix ascii /tb/uut/RV32I_IMEM_INIT_FILE
add wave -noupdate -group core /tb/uut/RV32I_LOG2_REGFILE_ENTRIES
add wave -noupdate -group core /tb/uut/RV32I_REGFILE_USE_MEM
add wave -noupdate -group core -radix hexadecimal /tb/uut/RV32I_RESET_VECTOR
add wave -noupdate -group core -radix hexadecimal /tb/uut/RV32I_TRAP_VECTOR
add wave -noupdate -group core /tb/uut/CLK_FREQ_MHZ
add wave -noupdate -group core /tb/uut/clk
add wave -noupdate -group core /tb/uut/reset_n
add wave -noupdate -group core /tb/uut/core_rstn
add wave -noupdate -group core /tb/uut/test_halt
add wave -noupdate -group core /tb/uut/count
add wave -noupdate -group core -radix hexadecimal /tb/uut/avs_csr_address
add wave -noupdate -group core /tb/uut/avs_csr_read
add wave -noupdate -group core -radix hexadecimal /tb/uut/avs_csr_readdata
add wave -noupdate -group core /tb/uut/avs_csr_write
add wave -noupdate -group core -radix hexadecimal /tb/uut/avs_csr_writedata
add wave -noupdate -group core -radix hexadecimal /tb/uut/dmem_addr
add wave -noupdate -group core /tb/uut/dmem_be
add wave -noupdate -group core /tb/uut/dmem_rd
add wave -noupdate -group core /tb/uut/dmem_rd_delay
add wave -noupdate -group core -radix hexadecimal /tb/uut/dmem_rdata
add wave -noupdate -group core /tb/uut/dmem_waitreq
add wave -noupdate -group core -radix hexadecimal /tb/uut/dmem_wdata
add wave -noupdate -group core /tb/uut/dmem_wr
add wave -noupdate -group core -radix hexadecimal /tb/uut/imem_raddr
add wave -noupdate -group core /tb/uut/imem_rd
add wave -noupdate -group core -radix hexadecimal /tb/uut/imem_rdata
add wave -noupdate -group core -radix hexadecimal /tb/uut/imem_readdata
add wave -noupdate -group core /tb/uut/imem_readdatavalid
add wave -noupdate -group core -radix hexadecimal /tb/uut/imem_waddr
add wave -noupdate -group core -radix hexadecimal /tb/uut/imem_wdata
add wave -noupdate -group core /tb/uut/imem_write
add wave -noupdate -group core /tb/uut/imem_be
add wave -noupdate -group core /tb/uut/led
add wave -noupdate -group core /tb/uut/halt_addr
add wave -noupdate -group core -radix hexadecimal /tb/uut/halt_on_addr
add wave -noupdate -group core /tb/uut/halt_on_unimp
add wave -noupdate -group core /tb/uut/local_read
add wave -noupdate -group core /tb/uut/local_readdata
add wave -noupdate -group core /tb/uut/local_write
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/RV32I_ENABLE_ECALL
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/RV32I_LOG2_REGFILE_ENTRIES
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/RV32I_REGFILE_USE_MEM
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/RV32I_RESET_VECTOR
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/RV32I_TRAP_VECTOR
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/alu_c
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/alu_pc
add wave -noupdate -group rv32i_cpu_core -radix unsigned /tb/uut/rv32i_cpu_core_inst/alu_rd
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/alu_update_pc
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/clk
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/clr_load_op
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/daddress
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/dbyteenable
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_a
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_a_rs_idx
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_add_nsub
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_arith
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_b
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_b_rs_idx
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_bit_is_and
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_bit_is_or
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_bit_is_xor
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_branch
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_cancelled
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_cmp_is_eq
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_cmp_is_ge
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_cmp_is_lt
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_cmp_is_ne
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_cmp_unsigned
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_jump
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_ld_st_width
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_load
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_offset
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_pc
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_rd
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_rs1_prefetch
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_rs2_prefetch
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_shift_arith
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_shift_left
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_shift_right
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_store
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/decode_system
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/dread
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/dreaddata
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/dwaitrequest
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/dwrite
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/dwritedata
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/iaddress
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/iread
add wave -noupdate -group rv32i_cpu_core -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/ireaddata
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/irq
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/iwaitrequest
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/regfile_last_pc
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/regfile_pc
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/regfile_rs1
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/regfile_rs2
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/reset_n
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/retired_instr
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/stall
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/stall_alu
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/stall_decode
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/stall_regfile
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/test_rd_idx
add wave -noupdate -group rv32i_cpu_core /tb/uut/rv32i_cpu_core_inst/test_rd_val
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/instr
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/pc_in
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/pc
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/jmp_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/jump
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/instr_reg
add wave -noupdate -expand -group decode -radix unsigned /tb/uut/rv32i_cpu_core_inst/decode/a_rs_idx
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/add_nsub
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/alu_imm
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/alu_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/arith
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/b_rs_idx
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/bit_is_and
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/bit_is_or
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/bit_is_xor
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/branch
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/a
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/b
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/branch_instr
add wave -noupdate -expand -group decode -radix unsigned /tb/uut/rv32i_cpu_core_inst/decode/rs1_prefetch
add wave -noupdate -expand -group decode -radix unsigned /tb/uut/rv32i_cpu_core_inst/decode/rs2_prefetch
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs1_rtn
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs2_rtn
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/stall
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs1_idx
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs2_idx
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs1
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs2
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/clk
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_eq
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_ge
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_lt
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_ne
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_unsigned
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/fb_rd
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/fb_rd_val
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/fence_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/funct3
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_b
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_i
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_j
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_s
add wave -noupdate -expand -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_u
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/invalid_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/ld_st_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/ld_st_width
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/load
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/no_writeback
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/offset
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/opcode
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/opcode_32
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/pc
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/pc_in
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/rd
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/rd_idx
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/reset_n
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs1_pf_held
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs2_pf_held
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/RV32I_TRAP_VECTOR
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/shift_arith
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/shift_left
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/shift_right
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/st_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/store
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/system
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/system_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/ui_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/update_pc
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/update_pc_dly
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/zicsr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/zicsr_imm_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/zicsr_instr
add wave -noupdate -expand -group decode /tb/uut/rv32i_cpu_core_inst/decode/zicsr_rs1_instr
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cancelled
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/a
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/b
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/jump_in
add wave -noupdate -group alu -radix unsigned /tb/uut/rv32i_cpu_core_inst/alu/a_rs_idx
add wave -noupdate -group alu -radix unsigned /tb/uut/rv32i_cpu_core_inst/alu/rd
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/update_rd
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/stall
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/c
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/a_decode
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/a_signed
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/b_signed
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/add
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/add_nsub
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/add_sub
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/addr
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/addr_lo
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/andop
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/arith
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/b_decode
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/b_rs_idx
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/bit_is_and
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/bit_is_or
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/bit_is_xor
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/bitop
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/branch_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/branch_taken
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/clk
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/clr_load_op
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cmp
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cmp_is_eq
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cmp_is_ge
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cmp_is_lt
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cmp_is_ne
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/cmp_unsigned
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/eq
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ge
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ge_unsigned
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_data
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_data_shift
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_store_width
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_width
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/load
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/load_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/lt_unsigned
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/next_addr
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/next_pc
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/offset_decode
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/orop
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/pc
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/pc_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/rd_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/reset_n
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/shift
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/shift_arith
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/shift_left
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/shift_right
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/sll
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/sra
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/srl
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/st_be
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/stall
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/store
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/store_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/sub
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/system_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/update_pc
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/c
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/pc
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/update_rd
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/xorop
add wave -noupdate -group regfile /tb/uut/rv32i_cpu_core_inst/regfile/clk
add wave -noupdate -group regfile /tb/uut/rv32i_cpu_core_inst/regfile/reset_n
add wave -noupdate -group regfile -radix unsigned /tb/uut/rv32i_cpu_core_inst/regfile/rs1_idx
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/regfile/rs1
add wave -noupdate -group regfile -radix unsigned /tb/uut/rv32i_cpu_core_inst/regfile/rs2_idx
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/regfile/rs2
add wave -noupdate -group regfile -radix unsigned /tb/uut/rv32i_cpu_core_inst/regfile/rd_idx
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/regfile/new_rd
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/regfile/new_pc
add wave -noupdate -group regfile /tb/uut/rv32i_cpu_core_inst/regfile/update_pc
add wave -noupdate -group regfile /tb/uut/rv32i_cpu_core_inst/regfile/stall
add wave -noupdate -group regfile -radix hexadecimal -childformat {{{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} -radix hexadecimal}} -subitemconfig {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} {-height 15 -radix hexadecimal}} /tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data
add wave -noupdate -group regfile /tb/uut/rv32i_cpu_core_inst/regfile/pc
add wave -noupdate -group regfile /tb/uut/rv32i_cpu_core_inst/regfile/last_pc
add wave -noupdate -group test /tb/uut/test_blk/test/clk
add wave -noupdate -group test /tb/uut/test_blk/test/clr_halt
add wave -noupdate -group test /tb/uut/test_blk/test/gp
add wave -noupdate -group test /tb/uut/test_blk/test/halt
add wave -noupdate -group test -radix hexadecimal /tb/uut/test_blk/test/halt_addr
add wave -noupdate -group test /tb/uut/test_blk/test/halt_on_addr
add wave -noupdate -group test /tb/uut/test_blk/test/halt_on_unimp
add wave -noupdate -group test -radix hexadecimal /tb/uut/test_blk/test/iaddr
add wave -noupdate -group test -radix hexadecimal /tb/uut/test_blk/test/irdata
add wave -noupdate -group test /tb/uut/test_blk/test/iread
add wave -noupdate -group test /tb/uut/test_blk/test/iwaitreq
add wave -noupdate -group test -radix hexadecimal /tb/uut/test_blk/test/rd_idx
add wave -noupdate -group test -radix hexadecimal /tb/uut/test_blk/test/rd_val
add wave -noupdate -group test /tb/uut/test_blk/test/reset_n
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/CLK_FREQ_MHZ
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/clk
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/exception
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/exception_pc
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/exception_type
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/ext_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/ext_sw_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/index
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/instr_retired
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/irq
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_code_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_code_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_interrupt_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_interrupt_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcountinhibit_cy
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcountinhibit_ir
add wave -noupdate -group rv32_zicsr -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycle_int
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycleh_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycle_pulse
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycle_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycleh_pulse
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycleh_wval
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mepc_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mepc_pulse
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mepc_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_meie
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_meie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_msie
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_msie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_mtie
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_mtie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstret_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstreth_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstret_pulse
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstret_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstreth_pulse
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstreth_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mip_meip
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mip_msip
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mip_mtip
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mret
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mscratch
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mie_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpie_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpp_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpp_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_pulse
add wave -noupdate -group rv32_zicsr -radix decimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtime_int
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtimecmp_int
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtvec_base
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtvec_mode
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/next_mcause_code_int
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/readdata
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/reset_n
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/sw_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/time_gt_cmp
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/timer_interrupt
add wave -noupdate -group rv32_zicsr -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/usec_count
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/usec_wrap_val
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtime
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtime_upper
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtime_val
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtimecmp
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/write
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/writedata
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/CLK_FREQ_MHZ
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/clk
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/exception
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/exception_pc
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/exception_type
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/ext_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/ext_sw_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/instr_retired
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/irq
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_code_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_code_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_interrupt_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_interrupt_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcause_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcountinhibit_cy
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcountinhibit_ir
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycle_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycle_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycle_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycleh_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycleh_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mcycleh_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mepc_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mepc_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mepc_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_meie
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_meie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_msie
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_msie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_mtie
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_mtie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mie_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstret_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstret_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstret_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstreth_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstreth_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/minstreth_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mip_meip
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mip_msip
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mip_mtip
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mret
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mie_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpie_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpie_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpp_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_mpp_wval
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mstatus_pulse
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtime_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtimecmp_int
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtvec_base
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/mtvec_mode
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/next_mcause_code_int
add wave -noupdate -group rv32_zicsr -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/rd_in
add wave -noupdate -group rv32_zicsr -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/rs1_in
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/rs1_idx
add wave -noupdate -group rv32_zicsr -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regfile_rd_idx
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regfile_rd_val
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/reset_n
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/sw_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/time_gt_cmp
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/timer_interrupt
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/usec_count
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/usec_wrap_val
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtime
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtime_upper
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtime_val
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/wr_mtimecmp
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mscratch
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/a
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/write
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/writedata
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/waddr
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/index
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/readdata
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_new_pc
add wave -noupdate -group rv32_zicsr -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_rd
add wave -noupdate -group rv32_zicsr -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_rd_val
add wave -noupdate -group rv32_zicsr /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_update_pc
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/ADDR_DECODE_WIDTH
add wave -noupdate -group regs -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mscratch
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/avs_read
add wave -noupdate -group regs -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/next_avs_readdata
add wave -noupdate -group regs -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/avs_readdata
add wave -noupdate -group regs -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/avs_readdata_reg
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/avs_write
add wave -noupdate -group regs -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/avs_writedata
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/clk
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcause_code
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcause_code_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcause_interrupt
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcause_interrupt_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcause_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcountinhibit_cy
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcountinhibit_cy_reg
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcountinhibit_ir
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcountinhibit_ir_reg
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcycle
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcycle_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcycle_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcycleh
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcycleh_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mcycleh_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mepc
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mepc_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mepc_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_meie
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_meie_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_msie
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_msie_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_mtie
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_mtie_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mie_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/minstret
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/minstret_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/minstret_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/minstreth
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/minstreth_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/minstreth_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mip_meip
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mip_msip
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mip_mtip
add wave -noupdate -group regs -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mscratch_reg
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_mie
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_mie_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_mpie
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_mpie_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_mpp
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_mpp_in
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mstatus_pulse
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mtvec_base
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mtvec_base_reg
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mtvec_mode
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/mtvec_mode_reg
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/next_mcountinhibit_cy
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/next_mcountinhibit_ir
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/next_mscratch
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/next_mtvec_base
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/next_mtvec_mode
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/rst_n
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/ucycle
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/ucycleh
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/uinstret
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/uinstreth
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/utime
add wave -noupdate -group regs /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/utimeh
add wave -noupdate /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/a
add wave -noupdate -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/rd_in
add wave -noupdate -radix unsigned /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_rd
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_rd_val
add wave -noupdate /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/write
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/waddr
add wave -noupdate /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/zicsr_reg
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/index
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/readdata
add wave -noupdate /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/readdata_int
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/regs/avs_readdata
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/a_reg
add wave -noupdate -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/zicsr/rv32_zicsr/writedata
add wave -noupdate -radix hexadecimal -childformat {{{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} -radix hexadecimal}} -expand -subitemconfig {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} {-height 15 -radix hexadecimal}} /tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {184992 ps} 0} {{Cursor 2} {1105000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 183
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1063397 ps} {1198575 ps}
