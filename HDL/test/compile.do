# Compile the code into the appropriate libraries
file delete -force -- work
vlib work
vlog -quiet +incdir+../src -f files_core_auto.tcl      -work work
vlog -quiet                -f files.tcl                -work work
