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
vsim -quiet -gGUI_RUN=1 +nowarnTFMPC -L altera_mf_ver -L altera_mf -gui tb

set StdArithNoWarnings   1
set NumericStdNoWarnings 1
do wave.do
run -all
