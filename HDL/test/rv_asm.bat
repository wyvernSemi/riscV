@echo off

set FNAME=%1
set ONAME=test
set STARTADDR=0
set TESTDIR=.\test_cases

set PREFIX=riscv64-unknown-elf-

%PREFIX%as.exe -fpic -march=rv32i -aghlms=%TESTDIR%\%ONAME%.list -o %TESTDIR%\%ONAME%.o %TESTDIR%\%FNAME%
%PREFIX%ld.exe %TESTDIR%\%ONAME%.o -Ttext %STARTADDR% -melf32lriscv -o %ONAME%.exe
elf2vhex.exe %ONAME%.exe > test.hex
elf2vmif.exe %ONAME%.exe > test.mif
