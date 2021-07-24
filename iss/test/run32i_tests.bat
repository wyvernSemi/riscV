@echo off

rm -rf obj

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
  fence_i^
 ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    make FNAME=%%i.S
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
 )
 
 for %%i in (^
  csr^
  illegal^
  ma_addr^
  ma_fetch^
  mcsr^
  sbreak^
  shamt^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    make SUBDIR=rv32mi FNAME=%%i.S
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )
  
   for %%i in (^
  mul^
  mulh^
  mulhsu^
  mulhu^
  div^
  divu^
  rem^
  remu^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    make SUBDIR=rv32um FNAME=%%i.S
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )
