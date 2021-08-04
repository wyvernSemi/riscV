# Create clean libraries
do cleanvlib.do

# Compile the code into the appropriate libraries
do compile.do

# Run the tests. 
vsim -quiet -pli VProc.so -t 1ns tb
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
run -all

#Exit the simulations
quit
