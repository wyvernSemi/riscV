# Create clean libraries
foreach lib [list work] {
  file delete -force -- $lib
  vlib $lib
}

# Compile the code into the appropriate libraries
do compile.do

# Run the tests
# Get any command line argumens added to the .do file call
set vsimargs [lrange $argv 3 end]

# Run the tests
vsim -quiet -gGUI_RUN=1 +nowarnTFMPC -L altera_mf_ver -L altera_mf -gui tb \
    [lindex $vsimargs 0] [lindex $vsimargs 1] [lindex $vsimargs 2] \
    [lindex $vsimargs 3] [lindex $vsimargs 4] [lindex $vsimargs 5] \
    [lindex $vsimargs 6] [lindex $vsimargs 7] [lindex $vsimargs 8]

set StdArithNoWarnings   1
set NumericStdNoWarnings 1
do wave.do
run -all
