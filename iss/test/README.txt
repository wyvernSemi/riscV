This folder contains the means to compile and run tests from the riscv-tests/isa
suite---specifically the rv32i tests. It assumes that the following repositories
have been cloned to c:\git

    github.com/riscv/riscv-test-env
    github.com/riscv/riscv-tests

If located elsewhere, then the TESTSRCROOT variable in makefile should be
updated, either in makefile, or modified whan calling make. E.g.

    make TESTROOTDIR=<my repository location>

An individual test in the rv32ui sub-folder is selected by modifying the FNAME
makefile variable. E.g.

    make FNAME=addi.S

The tool chain is the gcc toolchain for target riscv64-unknown-elf. As of writing,
precompiled windows binaries can be found at:

    sysprogs.com/getfile/1107/risc-v-gcc10.1.0.exe

The make executable used was that from msys 1.0.

    downloads.sourceforge.net/mingw/MSYS-1.0.11.exe
    
Both the gcc toolchain and the msys bin/ folders need to be placed in the
search PATH environment variable.

For the model to run the tests successfully it needs to support some features in
advance of the RV32I spec. The model must be compiled with SUPPORT_RISCV_TESTS
defined to add these features, which are not included by default. This allows
the tests to be run with the test source code unmodified. After compilation
the test will appear in this folder as an .exe (e.g. addi.exe), and can be run
by the compiled model as:

    <path to model>\rv32.exe -t <executable>

This assumes the model has been compiled with the provided Visual Studio 2019
configuration (..\visualstudio\)

The batch file run32i_tests.bat will do a clean compile and run of all the
rv32ui tests, with PASS/FAIL messages printed at each test.
