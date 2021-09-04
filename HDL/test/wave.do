onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb -radix unsigned /tb/clk
add wave -noupdate -expand -group tb /tb/count
add wave -noupdate -expand -group tb /tb/reset_n
add wave -noupdate -expand -group tb -radix hexadecimal /tb/iaddress
add wave -noupdate -expand -group tb /tb/iread
add wave -noupdate -expand -group tb /tb/ireaddatavalid
add wave -noupdate -expand -group tb -radix hexadecimal /tb/ireaddata
add wave -noupdate -expand -group tb /tb/dwrite
add wave -noupdate -expand -group tb -radix hexadecimal /tb/daddress
add wave -noupdate -expand -group tb /tb/dbyteenable
add wave -noupdate -expand -group tb -radix hexadecimal /tb/dwritedata
add wave -noupdate -expand -group tb /tb/dread
add wave -noupdate -expand -group tb -radix hexadecimal /tb/dreaddata
add wave -noupdate -expand -group tb -radix hexadecimal {/tb/dmem[0][32]}
add wave -noupdate -expand -group tb -radix hexadecimal {/tb/dmem[1][32]}
add wave -noupdate -expand -group tb -radix hexadecimal {/tb/dmem[2][32]}
add wave -noupdate -expand -group tb -radix hexadecimal {/tb/dmem[3][32]}
add wave -noupdate -group uut /tb/uut/clk
add wave -noupdate -group uut /tb/uut/reset_n
add wave -noupdate -group uut /tb/uut/RV32I_RESET_VECTOR
add wave -noupdate -group uut /tb/uut/RV32I_TRAP_VECTOR
add wave -noupdate -group uut -radix hexadecimal /tb/uut/alu_c
add wave -noupdate -group uut -radix hexadecimal /tb/uut/alu_pc
add wave -noupdate -group uut -radix hexadecimal /tb/uut/alu_rd
add wave -noupdate -group uut /tb/uut/alu_update_pc
add wave -noupdate -group uut -radix hexadecimal /tb/uut/daddress
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_a
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_a_rs_idx
add wave -noupdate -group uut /tb/uut/decode_add_nsub
add wave -noupdate -group uut /tb/uut/decode_arith
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_b
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_b_rs_idx
add wave -noupdate -group uut /tb/uut/decode_bit_is_and
add wave -noupdate -group uut /tb/uut/decode_bit_is_or
add wave -noupdate -group uut /tb/uut/decode_bit_is_xor
add wave -noupdate -group uut /tb/uut/decode_branch
add wave -noupdate -group uut /tb/uut/decode_cmp_is_eq
add wave -noupdate -group uut /tb/uut/decode_cmp_is_ge
add wave -noupdate -group uut /tb/uut/decode_cmp_is_lt
add wave -noupdate -group uut /tb/uut/decode_cmp_is_ne
add wave -noupdate -group uut /tb/uut/decode_cmp_unsigned
add wave -noupdate -group uut /tb/uut/decode_jump
add wave -noupdate -group uut /tb/uut/decode_load
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_pc
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_offset
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_rd
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_rs1_idx
add wave -noupdate -group uut -radix hexadecimal /tb/uut/decode_rs2_idx
add wave -noupdate -group uut /tb/uut/decode_shift_arith
add wave -noupdate -group uut /tb/uut/decode_shift_left
add wave -noupdate -group uut /tb/uut/decode_shift_right
add wave -noupdate -group uut /tb/uut/decode_store
add wave -noupdate -group uut /tb/uut/decode_system
add wave -noupdate -group uut /tb/uut/dread
add wave -noupdate -group uut -radix hexadecimal /tb/uut/dreaddata
add wave -noupdate -group uut /tb/uut/dwrite
add wave -noupdate -group uut -radix hexadecimal /tb/uut/dwritedata
add wave -noupdate -group uut -radix hexadecimal /tb/uut/iaddress
add wave -noupdate -group uut /tb/uut/iread
add wave -noupdate -group uut -radix hexadecimal /tb/uut/ireaddata
add wave -noupdate -group uut /tb/uut/irq
add wave -noupdate -group uut -radix hexadecimal /tb/uut/regfile_last_pc
add wave -noupdate -group uut -radix hexadecimal /tb/uut/regfile_pc
add wave -noupdate -group uut -radix hexadecimal /tb/uut/regfile_rs1
add wave -noupdate -group uut -radix hexadecimal /tb/uut/regfile_rs2
add wave -noupdate -group uut /tb/uut/stall
add wave -noupdate -group uut /tb/uut/RV32I_REGFILE_ENTRIES
add wave -noupdate -group decode /tb/uut/decode/clk
add wave -noupdate -group decode /tb/uut/decode/reset_n
add wave -noupdate -group decode /tb/uut/decode/update_pc
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/instr
add wave -noupdate -group decode /tb/uut/decode/ui_instr
add wave -noupdate -group decode /tb/uut/decode/jmp_instr
add wave -noupdate -group decode /tb/uut/decode/branch_instr
add wave -noupdate -group decode /tb/uut/decode/alu_instr
add wave -noupdate -group decode /tb/uut/decode/ld_st_instr
add wave -noupdate -group decode /tb/uut/decode/st_instr
add wave -noupdate -group decode /tb/uut/decode/fence_instr
add wave -noupdate -group decode /tb/uut/decode/system_instr
add wave -noupdate -group decode /tb/uut/decode/invalid_instr
add wave -noupdate -group decode /tb/uut/decode/alu_imm
add wave -noupdate -group decode /tb/uut/decode/arith
add wave -noupdate -group decode /tb/uut/decode/add_nsub
add wave -noupdate -group decode /tb/uut/decode/cmp_is_eq
add wave -noupdate -group decode /tb/uut/decode/cmp_is_ge
add wave -noupdate -group decode /tb/uut/decode/cmp_is_lt
add wave -noupdate -group decode /tb/uut/decode/cmp_is_ne
add wave -noupdate -group decode /tb/uut/decode/cmp_unsigned
add wave -noupdate -group decode /tb/uut/decode/bit_is_xor
add wave -noupdate -group decode /tb/uut/decode/bit_is_or
add wave -noupdate -group decode /tb/uut/decode/bit_is_and
add wave -noupdate -group decode /tb/uut/decode/shift_left
add wave -noupdate -group decode /tb/uut/decode/shift_right
add wave -noupdate -group decode /tb/uut/decode/shift_arith
add wave -noupdate -group decode -radix unsigned /tb/uut/decode/a_rs_idx
add wave -noupdate -group decode -radix unsigned /tb/uut/decode/b_rs_idx
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/fb_rd
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/fb_rd_val
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/a
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/b
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/offset
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/rd
add wave -noupdate -group decode /tb/uut/decode/branch
add wave -noupdate -group decode /tb/uut/decode/jump
add wave -noupdate -group decode /tb/uut/decode/system
add wave -noupdate -group decode /tb/uut/decode/load
add wave -noupdate -group decode /tb/uut/decode/store
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/funct12
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/funct3
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/funct7
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm_i
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm_b
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm_iu
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm_j
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm_s
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/imm_u
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/opcode
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/opcode_32
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/pc
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/pc_in
add wave -noupdate -group decode /tb/uut/decode/rd_idx
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/rs1_idx
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/rs1_rtn
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/rs2_idx
add wave -noupdate -group decode -radix hexadecimal /tb/uut/decode/rs2_rtn
add wave -noupdate -group alu /tb/uut/alu/arith
add wave -noupdate -group alu /tb/uut/alu/add_nsub
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/a
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/b
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/c
add wave -noupdate -group alu /tb/uut/alu/st_be
add wave -noupdate -group alu /tb/uut/alu/store
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/addr
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/a_decode
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/b_decode
add wave -noupdate -group alu /tb/uut/alu/a_rs_idx
add wave -noupdate -group alu /tb/uut/alu/b_rs_idx
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/rd
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/pc
add wave -noupdate -group alu /tb/uut/alu/update_pc
add wave -noupdate -group alu /tb/uut/alu/update_rd
add wave -noupdate -group alu /tb/uut/alu/branch_taken
add wave -noupdate -group alu -radix unsigned /tb/uut/alu/rd
add wave -noupdate -group alu -radix unsigned /tb/uut/alu/pc_in
add wave -noupdate -group alu -radix unsigned /tb/uut/alu/offset_decode
add wave -noupdate -group alu /tb/uut/alu/a_signed
add wave -noupdate -group alu /tb/uut/alu/add
add wave -noupdate -group alu /tb/uut/alu/add_sub
add wave -noupdate -group alu /tb/uut/alu/andop
add wave -noupdate -group alu /tb/uut/alu/b_signed
add wave -noupdate -group alu /tb/uut/alu/bit_is_and
add wave -noupdate -group alu /tb/uut/alu/bit_is_or
add wave -noupdate -group alu /tb/uut/alu/bit_is_xor
add wave -noupdate -group alu /tb/uut/alu/bitop
add wave -noupdate -group alu /tb/uut/alu/branch_in
add wave -noupdate -group alu /tb/uut/alu/clk
add wave -noupdate -group alu -radix hexadecimal /tb/uut/alu/cmp
add wave -noupdate -group alu /tb/uut/alu/cmp_unsigned
add wave -noupdate -group alu /tb/uut/alu/cmp_is_lt
add wave -noupdate -group alu /tb/uut/alu/lt_unsigned
add wave -noupdate -group alu /tb/uut/alu/cmp_is_eq
add wave -noupdate -group alu /tb/uut/alu/cmp_is_ge
add wave -noupdate -group alu /tb/uut/alu/cmp_is_ne
add wave -noupdate -group alu /tb/uut/alu/eq
add wave -noupdate -group alu /tb/uut/alu/ge
add wave -noupdate -group alu /tb/uut/alu/jump_in
add wave -noupdate -group alu /tb/uut/alu/load
add wave -noupdate -group alu /tb/uut/alu/load_in
add wave -noupdate -group alu /tb/uut/alu/next_pc
add wave -noupdate -group alu /tb/uut/alu/orop
add wave -noupdate -group alu /tb/uut/alu/rd_in
add wave -noupdate -group alu /tb/uut/alu/reset_n
add wave -noupdate -group alu /tb/uut/alu/shift
add wave -noupdate -group alu /tb/uut/alu/shift_arith
add wave -noupdate -group alu /tb/uut/alu/shift_left
add wave -noupdate -group alu /tb/uut/alu/shift_right
add wave -noupdate -group alu /tb/uut/alu/sll
add wave -noupdate -group alu /tb/uut/alu/sra
add wave -noupdate -group alu /tb/uut/alu/srl
add wave -noupdate -group alu /tb/uut/alu/store_in
add wave -noupdate -group alu /tb/uut/alu/sub
add wave -noupdate -group alu /tb/uut/alu/system_in
add wave -noupdate -group alu /tb/uut/alu/xorop
add wave -noupdate -group regfile /tb/uut/regfile/REGFILE_ENTRIES
add wave -noupdate -group regfile /tb/uut/regfile/RESET_VECTOR
add wave -noupdate -group regfile /tb/uut/regfile/clk
add wave -noupdate -group regfile /tb/uut/regfile/last_pc
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/regfile/new_pc
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/regfile/new_rd
add wave -noupdate -group regfile -radix hexadecimal /tb/uut/regfile/pc
add wave -noupdate -group regfile -radix unsigned /tb/uut/regfile/rd_idx
add wave -noupdate -group regfile -radix hexadecimal -childformat {{{/tb/uut/regfile/regfile[0]} -radix hexadecimal} {{/tb/uut/regfile/regfile[1]} -radix hexadecimal} {{/tb/uut/regfile/regfile[2]} -radix hexadecimal} {{/tb/uut/regfile/regfile[3]} -radix hexadecimal} {{/tb/uut/regfile/regfile[4]} -radix hexadecimal} {{/tb/uut/regfile/regfile[5]} -radix hexadecimal} {{/tb/uut/regfile/regfile[6]} -radix hexadecimal} {{/tb/uut/regfile/regfile[7]} -radix hexadecimal} {{/tb/uut/regfile/regfile[8]} -radix hexadecimal} {{/tb/uut/regfile/regfile[9]} -radix hexadecimal} {{/tb/uut/regfile/regfile[10]} -radix hexadecimal} {{/tb/uut/regfile/regfile[11]} -radix hexadecimal} {{/tb/uut/regfile/regfile[12]} -radix hexadecimal} {{/tb/uut/regfile/regfile[13]} -radix hexadecimal} {{/tb/uut/regfile/regfile[14]} -radix hexadecimal} {{/tb/uut/regfile/regfile[15]} -radix hexadecimal} {{/tb/uut/regfile/regfile[16]} -radix hexadecimal} {{/tb/uut/regfile/regfile[17]} -radix hexadecimal} {{/tb/uut/regfile/regfile[18]} -radix hexadecimal} {{/tb/uut/regfile/regfile[19]} -radix hexadecimal} {{/tb/uut/regfile/regfile[20]} -radix hexadecimal} {{/tb/uut/regfile/regfile[21]} -radix hexadecimal} {{/tb/uut/regfile/regfile[22]} -radix hexadecimal} {{/tb/uut/regfile/regfile[23]} -radix hexadecimal} {{/tb/uut/regfile/regfile[24]} -radix hexadecimal} {{/tb/uut/regfile/regfile[25]} -radix hexadecimal} {{/tb/uut/regfile/regfile[26]} -radix hexadecimal} {{/tb/uut/regfile/regfile[27]} -radix hexadecimal} {{/tb/uut/regfile/regfile[28]} -radix hexadecimal} {{/tb/uut/regfile/regfile[29]} -radix hexadecimal} {{/tb/uut/regfile/regfile[30]} -radix hexadecimal} {{/tb/uut/regfile/regfile[31]} -radix hexadecimal}} -expand -subitemconfig {{/tb/uut/regfile/regfile[0]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[1]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[2]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[3]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[4]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[5]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[6]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[7]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[8]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[9]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[10]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[11]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[12]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[13]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[14]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[15]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[16]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[17]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[18]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[19]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[20]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[21]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[22]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[23]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[24]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[25]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[26]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[27]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[28]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[29]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[30]} {-height 15 -radix hexadecimal} {/tb/uut/regfile/regfile[31]} {-height 15 -radix hexadecimal}} /tb/uut/regfile/regfile
add wave -noupdate -group regfile /tb/uut/regfile/reset_n
add wave -noupdate -group regfile /tb/uut/regfile/rs1
add wave -noupdate -group regfile /tb/uut/regfile/rs1_idx
add wave -noupdate -group regfile /tb/uut/regfile/rs2
add wave -noupdate -group regfile /tb/uut/regfile/rs2_idx
add wave -noupdate -group regfile /tb/uut/regfile/stall
add wave -noupdate -group regfile /tb/uut/regfile/update_pc
add wave -noupdate -group rv32i_cpu -radix hexadecimal /tb/uut/alu_c
add wave -noupdate -group rv32i_cpu /tb/uut/alu_rd
add wave -noupdate -group rv32i_cpu /tb/uut/clk
add wave -noupdate -group rv32i_cpu /tb/uut/daddress
add wave -noupdate -group rv32i_cpu /tb/uut/decode_branch
add wave -noupdate -group rv32i_cpu /tb/uut/decode_jump
add wave -noupdate -group rv32i_cpu /tb/uut/decode_load
add wave -noupdate -group rv32i_cpu /tb/uut/decode_pc
add wave -noupdate -group rv32i_cpu /tb/uut/decode_rd
add wave -noupdate -group rv32i_cpu /tb/uut/decode_rs1_idx
add wave -noupdate -group rv32i_cpu /tb/uut/decode_rs2_idx
add wave -noupdate -group rv32i_cpu /tb/uut/decode_store
add wave -noupdate -group rv32i_cpu /tb/uut/decode_system
add wave -noupdate -group rv32i_cpu /tb/uut/dread
add wave -noupdate -group rv32i_cpu /tb/uut/dreaddata
add wave -noupdate -group rv32i_cpu /tb/uut/dwrite
add wave -noupdate -group rv32i_cpu /tb/uut/dwritedata
add wave -noupdate -group rv32i_cpu /tb/uut/iaddress
add wave -noupdate -group rv32i_cpu /tb/uut/iread
add wave -noupdate -group rv32i_cpu /tb/uut/ireaddata
add wave -noupdate -group rv32i_cpu /tb/uut/regfile_last_pc
add wave -noupdate -group rv32i_cpu /tb/uut/regfile_pc
add wave -noupdate -group rv32i_cpu /tb/uut/regfile_rs1
add wave -noupdate -group rv32i_cpu /tb/uut/regfile_rs2
add wave -noupdate -group rv32i_cpu /tb/uut/reset_n
add wave -noupdate -group rv32i_cpu /tb/uut/stall
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300420 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {388500 ps}
