###################################################################
# Platform regression test script
#
# Copyright (c) 2021 Simon Southwell
#
# This code is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# The code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this code. If not, see <http://www.gnu.org/licenses/>.
#
###################################################################

#
# Remove key directories and files to ensure a clean build and run
#
rm -f test.log

#
# Run all the rv32ui and rv32mi tests, except scall which needs different parameters
#
for file in tests/add.exe     \
            tests/addi.exe    \
            tests/and.exe     \
            tests/andi.exe    \
            tests/auipc.exe   \
            tests/beq.exe     \
            tests/bge.exe     \
            tests/bgeu.exe    \
            tests/blt.exe     \
            tests/bltu.exe    \
            tests/bne.exe     \
            tests/fence_i.exe \
            tests/jal.exe     \
            tests/jalr.exe    \
            tests/lb.exe      \
            tests/lbu.exe     \
            tests/lh.exe      \
            tests/lhu.exe     \
            tests/lui.exe     \
            tests/lw.exe      \
            tests/or.exe      \
            tests/ori.exe     \
            tests/sb.exe      \
            tests/sh.exe      \
            tests/simple.exe  \
            tests/sll.exe     \
            tests/slli.exe    \
            tests/slt.exe     \
            tests/slti.exe    \
            tests/sltiu.exe   \
            tests/sltu.exe    \
            tests/sra.exe     \
            tests/srai.exe    \
            tests/srl.exe     \
            tests/srli.exe    \
            tests/sub.exe     \
            tests/sw.exe      \
            tests/test.exe    \
            tests/xor.exe     \
            tests/xori.exe    \
            tests/csr.exe     \
            tests/mcsr.exe    \
            tests/sbreak.exe  \
            tests/illegal.exe \
            tests/ma_fetch.exe\
            tests/ma_addr.exe \
            tests/shamt.exe
do
    cp $file test.exe
    echo "running $file"
    ./main.exe | tee -a test.log
done

#
# Run the rv32mi scall test
#
for file in tests/scall.exe
do
    cp $file test.exe
    echo "running $file"
    ./main.exe -s | tee -a test.log
done

#
# Run the rv32um tests
#
for file in tests/mul.exe    \
            tests/mulh.exe   \
            tests/mulhsu.exe \
            tests/mulhu.exe  \
            tests/div.exe    \
            tests/divu.exe   \
            tests/rem.exe    \
            tests/remu.exe
do
    cp $file test.exe
    echo "running $file"
    ./main.exe | tee -a test.log
done

#
# Display the test log
#
grep "Test exit" test.log
