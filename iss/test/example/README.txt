This folder contains the following files:

    * README.txt        : this file
    * rv32.exe          : The rv32_cpu RISC-V Instruction Set Simulator (ISS)
    * rv_asm.bat        : A batch file for compiling RISC-V assembly code
    * rv_asm.sh         : A shell file for compiling RISC-V assembly code
    * example.s         : An example assembly source file
    * example_pseudo.s  : A refactored example using pseudo instructions
    * template.source   : A template for copying and constructing new test
                          source code
    * vcredist_x64.exe  : Redistribution (x64) library installer if not installed
                          to run ISS
    * vcredist_x86.exe  : Redistribution (x86) library installer if not installed
                          to run ISS

In order for the rv_asm.bat/rv_asm.sh script to work the RISC-V toolchain must be
installed. Pre-built windows binaries can be found at:

    https://sysprogs.com/getfile/1107/risc-v-gcc10.1.0.exe

This can be installed to a convenient directory (default is c:\SysGCC\riscv)
Run the install executable, and a GUI window will pop up. Tick the "Add binary
directory to %PATH%", so the setup will be complete after installation. Tick
"I Accept the terms of the license agreement" box and "Install".

To check the installation has worked, open a new console terminal (after
the toolchain has been installed). Type 'where riscv64-unknown-elf-as' and
should get (for example): c:\SysGCC\riscv\bin\riscv64-unknown-elf-as.exe.
If not installed correctly will see:

    INFO: Could not find files for the givenpattern(s).

If the toolchain has been installed correctly, compile the example.s code with:

    .\rv_asm.bat example.s

There should be no errors or warnings and three new files should have been
generated in the folder: test.o, test.list and test.exe.

To check that the ISS will run type:

    .\rv32.exe -t test.exe -rEx -m 8

The output should be:

    00000000: 0x00c00093    addi      ra, zero, 12
    00000004: 0x00000193    addi      gp, zero, 0
    00000008: 0x000011b7    lui       gp, 0x00000001
    0000000c: 0x0001a183    lw        gp, 0(gp)
    00000010: 0xfff1c193    xori      gp, gp, -1
    00000014: 0x00000213    addi      tp, zero, 0
    00000018: 0x00001237    lui       tp, 0x00000001
    0000001c: 0x00322223    sw        gp, 4(tp)
    00000020: 0x00000513    addi      a0, zero, 0
    00000024: 0x05d00893    addi      a7, zero, 93
    00000028: 0x00100073    ebreak
        *

    Register state:

      x0  = 0x00000000  x1  = 0x0000000c  x2  = 0x00000000  x3  = 0xedcba987
      x4  = 0x00001000  x5  = 0x00000000  x6  = 0x00000000  x7  = 0x00000000
      x8  = 0x00000000  x9  = 0x00000000  x10 = 0x00000000  x11 = 0x00000000
      x12 = 0x00000000  x13 = 0x00000000  x14 = 0x00000000  x15 = 0x00000000
      x16 = 0x00000000  x17 = 0x0000005d  x18 = 0x00000000  x19 = 0x00000000
      x20 = 0x00000000  x21 = 0x00000000  x22 = 0x00000000  x23 = 0x00000000
      x24 = 0x00000000  x25 = 0x00000000  x26 = 0x00000000  x27 = 0x00000000
      x28 = 0x00000000  x29 = 0x00000000  x30 = 0x00000000  x31 = 0x00000000


    MEM state:

      0x00001000 : 0x12345678
      0x00001004 : 0xedcba987
      0x00001008 : 0xcdcdcdcd
      0x0000100c : 0xcdcdcdcd
      0x00001010 : 0xcdcdcdcd
      0x00001014 : 0xcdcdcdcd
      0x00001018 : 0xcdcdcdcd
      0x0000101c : 0xcdcdcdcd


    PASS: exit code = 0x00000000
