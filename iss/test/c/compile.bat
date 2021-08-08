@echo off

set FNAME=test
set PREFIX=riscv64-unknown-elf-
 
%PREFIX%gcc -g -march=rv32im -mabi=ilp32 %FNAME%.c -o %FNAME%.exe

%PREFIX%nm %FNAME%.exe | grep "T _start"