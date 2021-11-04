rm -f test.log

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
            tests/csr         \
            tests/mcsr        \
            tests/sbreak      \
            tests/illegal     \
            tests/ma_fetch    \
            tests/ma_addr     \
            tests/shamt
do
    cp $file test.exe
    echo "running $file"
    ./main.exe | tee -a test.log
done

for file in tests/scall.exe
do
    cp $file test.exe
    echo "running $file"
    ./main.exe -s | tee -a test.log
done

grep "Test exit" test.log
