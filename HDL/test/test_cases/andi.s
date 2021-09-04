        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x12, x0,  0x555       # x12 <= 0x00000555
         andi  x13, x12, 0x7aa       # x13 <= 0x00000500
         andi  x13, x12, 0x000       # x13 <= 0x00000000
         andi  x13, x12, 0x7f0       # x13 <= 0x00000550
         andi  x13, x12, -1561       # x13 <= 0x00000145
         
         addi  x12, x0,  -1366       # x12 <= 0xfffffaaa
         andi  x13, x12, -1930       # x13 <= 0xfffff822
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
