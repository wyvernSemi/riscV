@echo off

set FNAME=test
set STARTADDR=0

set PREFIX=riscv64-unknown-elf-

%PREFIX%as.exe -fpic -march=rv32i -aghlms=%FNAME%.list -o %FNAME%.o %FNAME%.s
%PREFIX%ld.exe %FNAME%.o -Ttext %STARTADDR% -melf32lriscv -o %FNAME%.exe 
