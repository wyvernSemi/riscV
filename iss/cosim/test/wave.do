onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /tb/CLK_FREQ_MHZ
add wave -noupdate -expand -group tb /tb/GUI_RUN
add wave -noupdate -expand -group tb /tb/clk
add wave -noupdate -expand -group tb /tb/reset_n
add wave -noupdate -expand -group tb /tb/count
add wave -noupdate -expand -group tb -radix hexadecimal /tb/address
add wave -noupdate -expand -group tb /tb/byteenable
add wave -noupdate -expand -group tb /tb/read
add wave -noupdate -expand -group tb -radix hexadecimal /tb/readdata
add wave -noupdate -expand -group tb /tb/readdatavalid
add wave -noupdate -expand -group tb /tb/write
add wave -noupdate -expand -group tb -radix hexadecimal /tb/writedata
add wave -noupdate /tb/irq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2948200 ps} 0}
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
WaveRestoreZoom {2798400 ps} {3166900 ps}
