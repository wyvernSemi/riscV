# Compile the code into the appropriate libraries
file delete -force -- work
vlib work
vlog -quiet -f files.tcl      -work work
