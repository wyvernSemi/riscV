        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x9,  x0,  0x555       # x9  <= 0x00000555
         slli  x9,  x9,  12          # x9  <= 0x00555000
         addi  x9,  x9,  0x555       # x9  <= 0x00555555
         slli  x9,  x9,  9           # x9  <= 0xaaaaaa00
         addi  x9,  x9,  0xaa        # x9  <= 0xaaaaaaaa
         
         addi  x12, x0,  0x555       # x10 <= 0x00000555
         slli  x12, x12, 12          # x10 <= 0x00555000
         addi  x12, x12, 0x555       # x10 <= 0x00555555
         slli  x12, x12, 8           # x10 <= 0x55555500
         addi  x12, x12, 0x55        # x10 <= 0x55555555
         
         
         and   x13, x12, x9          # x13 <= 0x00000000
         and   x13, x12, x0          # x13 <= 0x00000000
         
         addi  x9,  x0,  0x7f0       # x9  <= 0x7f0
         
         and   x13, x12, x9          # x13 <= 0x00000550
         
         addi  x9,  x0,  -1561       # x9  <= 0xfffff9e7
         and   x13, x12, x9          # x13 <= 0x55555145
         
         addi  x12, x0,  -1366       # x12 <= 0xfffffaaa
         addi  x9,  x0,  -1930       # x9  <= 0xfffff876
         and   x13, x12, x9          # x13 <= 0xfffff822
         
         nop                         # NOP
         nop                         # NOP
         nop                         # NOP
         
         .word 0x00000000
