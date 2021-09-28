onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb -radix unsigned /tb/clk
add wave -noupdate -expand -group tb /tb/count
add wave -noupdate -expand -group tb /tb/reset_n
add wave -noupdate -expand -group tb /tb/test_halt
add wave -noupdate -expand -group tb -radix hexadecimal /tb/avs_csr_address
add wave -noupdate -expand -group tb /tb/avs_csr_read
add wave -noupdate -expand -group tb -radix hexadecimal /tb/avs_csr_readdata
add wave -noupdate -expand -group tb /tb/avs_csr_write
add wave -noupdate -expand -group tb -radix hexadecimal /tb/avs_csr_writedata
add wave -noupdate -expand -group tb -radix hexadecimal -childformat {{{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} -radix hexadecimal} {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} -radix hexadecimal}} -subitemconfig {{/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[0]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[1]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[2]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[3]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[4]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[5]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[6]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[7]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[8]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[9]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[10]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[11]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[12]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[13]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[14]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[15]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[16]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[17]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[18]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[19]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[20]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[21]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[22]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[23]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[24]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[25]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[26]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[27]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[28]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[29]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[30]} {-height 15 -radix hexadecimal} {/tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data[31]} {-height 15 -radix hexadecimal}} /tb/uut/rv32i_cpu_core_inst/regfile/mem/regfile1/altsyncram_component/m_default/altsyncram_inst/mem_data
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
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/instr
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/instr_reg
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/a
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/a_rs_idx
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/add_nsub
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/alu_imm
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/alu_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/arith
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/b
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/b_rs_idx
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/bit_is_and
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/bit_is_or
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/bit_is_xor
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/branch
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/branch_instr
add wave -noupdate -group decode -radix unsigned /tb/uut/rv32i_cpu_core_inst/decode/rs1_prefetch
add wave -noupdate -group decode -radix unsigned /tb/uut/rv32i_cpu_core_inst/decode/rs2_prefetch
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs1_rtn
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs2_rtn
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/stall
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs1_idx
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs2_idx
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs1
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/rs2
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/clk
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_eq
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_ge
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_lt
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_is_ne
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/cmp_unsigned
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/fb_rd
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/fb_rd_val
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/fence_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/funct3
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_b
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_i
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_j
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_s
add wave -noupdate -group decode -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/decode/imm_u
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/invalid_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/jmp_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/jump
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/ld_st_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/ld_st_width
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/load
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/no_writeback
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/offset
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/opcode
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/opcode_32
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/pc
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/pc_in
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/rd
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/rd_idx
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/reset_n
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs1_pf_held
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/rs2_pf_held
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/RV32I_TRAP_VECTOR
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/shift_arith
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/shift_left
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/shift_right
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/st_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/store
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/system
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/system_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/ui_instr
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/update_pc
add wave -noupdate -group decode /tb/uut/rv32i_cpu_core_inst/decode/update_pc_dly
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/a
add wave -noupdate -group alu -radix unsigned /tb/uut/rv32i_cpu_core_inst/alu/a_rs_idx
add wave -noupdate -group alu -radix unsigned /tb/uut/rv32i_cpu_core_inst/alu/rd
add wave -noupdate -group alu -radix hexadecimal /tb/uut/rv32i_cpu_core_inst/alu/b
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
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/jump_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_data
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_data_shift
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_store_width
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/ld_width
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/load
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/load_in
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/lt_unsigned
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/next_addr
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/next_pc
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/offset_decode
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/orop
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/pc
add wave -noupdate -group alu /tb/uut/rv32i_cpu_core_inst/alu/pc_in
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1168800145 ps} 0} {{Cursor 2} {767987 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {3895500 ps}
