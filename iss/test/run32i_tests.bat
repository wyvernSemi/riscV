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
  ld_st^
  st_ld^
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
  ma_addr^
  ma_fetch^
  mcsr^
  sbreak^
  shamt^
  lh-misaligned^
  lw-misaligned^
  sh-misaligned^
  sw-misaligned^
  zicntr^
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
  recoding^
  ) do (
    echo.
    echo.
    echo Running test for %%id instruction...
    rm -f obj\%%i.o
    make SUBDIR=rv32ud FNAME=%%i.S
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )

  for %%i in (^
  rvc^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    rm -f obj\%%i.o
    make SUBDIR=rv32uc FNAME=%%i.S ARCHSPEC=rv32gc
    ..\visualstudio\x64\Debug\rv32.exe -b -A0x36 -t %%i.exe
  )

  for %%i in (^
  sh1add^
  sh2add^
  sh3add^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    rm -f obj\%%i.o
    make SUBDIR=rv32uzba FNAME=%%i.S ARCHSPEC=rv32g_zba
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )

  for %%i in (^
  andn^
  orn^
  xnor^
  clz^
  cpop^
  ctz^
  max^
  maxu^
  min^
  minu^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    rm -f obj\%%i.o
    make SUBDIR=rv32uzbb FNAME=%%i.S ARCHSPEC=rv32g_zbb
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )

  for %%i in (^
  bset^
  bseti^
  bclr^
  bclri^
  bext^
  bexti^
  binv^
  binvi^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    rm -f obj\%%i.o
    make SUBDIR=rv32uzbs FNAME=%%i.S ARCHSPEC=rv32g_zbs
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )

  for %%i in (^
  clmul^
  clmulh^
  clmulr^
  ) do (
    echo.
    echo.
    echo Running test for %%i instruction...
    rm -f obj\%%i.o
    make SUBDIR=rv32uzbc FNAME=%%i.S ARCHSPEC=rv32g_zbc
    ..\visualstudio\x64\Debug\rv32.exe -b -t %%i.exe
  )