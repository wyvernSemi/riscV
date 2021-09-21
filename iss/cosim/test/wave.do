onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb /tb/CLK_FREQ_MHZ
add wave -noupdate -group tb /tb/GUI_RUN
add wave -noupdate -group tb /tb/clk
add wave -noupdate -group tb /tb/reset_n
add wave -noupdate -group tb /tb/count
add wave -noupdate -group tb -radix hexadecimal /tb/address
add wave -noupdate -group tb /tb/byteenable
add wave -noupdate -group tb /tb/read
add wave -noupdate -group tb -radix hexadecimal /tb/readdata
add wave -noupdate -group tb /tb/readdatavalid
add wave -noupdate -group tb /tb/write
add wave -noupdate -group tb -radix hexadecimal /tb/writedata
add wave -noupdate -group tb /tb/iread
add wave -noupdate -group tb -radix hexadecimal /tb/iaddress
add wave -noupdate -expand -group cpu /tb/cpu/BE_ADDR
add wave -noupdate -expand -group cpu /tb/cpu/clk
add wave -noupdate -expand -group cpu /tb/cpu/iaddress
add wave -noupdate -expand -group cpu /tb/cpu/instr_access
add wave -noupdate -expand -group cpu /tb/cpu/iread
add wave -noupdate -expand -group cpu /tb/cpu/ireaddata
add wave -noupdate -expand -group cpu /tb/cpu/irq
add wave -noupdate -expand -group cpu /tb/cpu/irqDly
add wave -noupdate -expand -group cpu /tb/cpu/NODE
add wave -noupdate -expand -group cpu /tb/cpu/nodenum
add wave -noupdate -expand -group cpu /tb/cpu/rd_data
add wave -noupdate -expand -group cpu /tb/cpu/RDAck
add wave -noupdate -expand -group cpu /tb/cpu/read_int
add wave -noupdate -expand -group cpu /tb/cpu/Update
add wave -noupdate -expand -group cpu /tb/cpu/UpdateResponse
add wave -noupdate -expand -group cpu /tb/cpu/USE_HARVARD
add wave -noupdate -expand -group cpu /tb/cpu/WE
add wave -noupdate /tb/irq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {980200 ps} 0}
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
WaveRestoreZoom {4004300 ps} {4241900 ps}
