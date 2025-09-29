
# Run the tests. 
vsim -quiet -pli ./VProc.so -t 100ps tb
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
run -all

#Exit the simulations
quit
