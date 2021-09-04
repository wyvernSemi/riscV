# Create clean libraries
do cleanvlib.do

# Compile the code into the appropriate libraries
do compile.do

# Get any command line argumens added to the .do file call
set vsimargs [lrange $argv 3 end]

# Run the tests. 
vsim -quiet +nowarnTFMPC -L altera_mf_ver -L altera_mf tb -l sim.log\
    [lindex $vsimargs 0] [lindex $vsimargs 1] [lindex $vsimargs 2] \
    [lindex $vsimargs 3] [lindex $vsimargs 4] [lindex $vsimargs 5] \
    [lindex $vsimargs 6] [lindex $vsimargs 7] [lindex $vsimargs 8]
do batch.do
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
run -all

#Exit the simulations
quit

