        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x8,  x0,  0x555       # x8 <= 0x00000555
         sll   x8,  x8,  12          # x8 <= 0x00555000
         addi  x8,  x8,  0x555       # x8 <= 0x00555555
         sll   x8,  x8,  8           # x8 <= 0x55555500
         addi  x8,  x8,  0x55        # x8 <= 0x55555555
         
         xor   x9,  x8,  x8          # x9 <= 0x00000000
         xor   x9,  x8,  x9          # x9 <= 0x55555555
         addi  x7,  x0,  -1          # x7 <= 0xffffffff
         xor   x9,  x8,  x7          # x9 <= 0xaaaaaaaa
         
         addi  x7,  x0, -1366        # x7 <= 0xfffffaaa
         addi  x8,  x0, -1930        # x8 <= 0xfffff876
         xor   x9,  x8, x7           # x8 <= 0x000002dc
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
