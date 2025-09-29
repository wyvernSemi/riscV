
# Run the tests
vsim -gGUI_RUN=1 -pli ./VProc.so -t 100ps -gui tb
set StdArithNoWarnings   1
set NumericStdNoWarnings 1
do wave.do
run -all
