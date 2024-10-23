#!/usr/bin/bash

FNAME=$1
ONAME=test
STARTADDR=0
DATAADDR=1000
TESTDIR=.

PREFIX=riscv64-unknown-elf-

${PREFIX}as.exe -fpic -march=rv32i -aghlms=$TESTDIR/$NAME.list -o $TESTDIR/$ONAME.o $TESTDIR/$FNAME
${PREFIX}ld.exe $TESTDIR/$ONAME.o -Ttext $STARTADDR -Tdata $DATAADDR -melf32lriscv -o $ONAME.exe
