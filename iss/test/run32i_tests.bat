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
  
  for %%i in (^
  amoadd_w^
  amoand_w^
  amomax_w^
  amomaxu_w^
  amomin_w^
  amominu_w^
  amoor_w^
  amoswap_w^
  amoxor_w^
  lrsc^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    make SUBDIR=rv32ua FNAME=%%i.S
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  ) 

  for %%i in (^
  fadd^
  fclass^
  fcmp^
  fcvt^
  fcvt_w^
  fdiv^
  fmadd^
  fmin^
  ldst^
  move^
  recoding^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    make SUBDIR=rv32uf FNAME=%%i.S
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  ) 