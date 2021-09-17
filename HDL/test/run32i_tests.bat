@echo off

rm -rf obj
rm -f test.log

for %%i in (^
  simple^
  add^
  addi^
  and^
  andi^
  auipc^
  beq^
  bge^
  bgeu^
  blt^
  bltu^
  bne^
  fence_i^
  jal^
  jalr^
  lb^
  lbu^
  lh^
  lhu^
  lui^
  lw^
  or^
  ori^
  sb^
  sh^
  sll^
  slli^
  slt^
  slti^
  sltiu^
  sltu^
  sra^
  srai^
  srl^
  srli^
  sub^
  sw^
  xor^
  xori^
 ) do (
    echo.
    echo.
    echo Running test for %%i test...
    rm -f %%i.exe
    make -f makefile.test SUBDIR=rv32ui FNAME=%%i.S
    make log
    grep "Test" sim.log >> test.log
 )
 
 cat test.log