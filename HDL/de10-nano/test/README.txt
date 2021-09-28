This folder contains the source files to compile a Linux ARM program to run 
riscv-tests/rv32ui tests on the DE10-nano platform.

A makefile exists to build the test program. On a windows host, it assumes
that the following tool chain is installed at the given location:

    c:\Tools\gcc-linaro-4.9.4-2017.01-i686-mingw32_arm-linux-gnueabihf
    
If a toolchain is installed elsewhere, then the TOOLPATH variable should
be modified, either on the command line, or the makefile updated. If no 
toolchain is available, a compiled version of the code is available in this
folder (make.exe). Alternatively, if the Linux running on the DE10-Nano has
the GNU gcc toolchain installed, it may be compiled on platform.

This executable should be copied to a suitable folder on the DE10-Nano.
When run on the platform, it expects a RISC-V executable called test.exe,
which it will load to the internal memory and then execute. When the internal
test block has halted, it will extract the state and print a PASS or FAIL
message.

A script (run_tests.sh) is also provided to run the riscv-tests/rv32ui tests as
a regression. A test/ folder should be located in the same folder as main.exe
and the script, and contain all the compiled rv32ui tests. The script will
run each executable in turn. and log the output in test.log. When complete
the PASS/FAIL messages are dumped to the screen for inspection.