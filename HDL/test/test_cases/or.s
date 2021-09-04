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
         
         addi  x10, x0,  0x555       # x10 <= 0x00000555
         slli  x10, x10, 12          # x10 <= 0x00555000
         addi  x10, x10, 0x555       # x10 <= 0x00555555
         slli  x10, x10, 8           # x10 <= 0x55555500
         addi  x10, x10, 0x55        # x10 <= 0x55555555
         
         or    x11, x10, x9          # x11 <= 0xffffffff
         or    x11, x10, x0          # x11 <= 0x55555555
         addi  x9,  x0,  0x7f0       # x9  <= 0x7f0
         or    x11, x10, x9          # x11 <= 0x555557f5
         addi  x9,  x0,  -2048       # x9  <= 0xfffff800 
         or    x11, x10, -2048       # x11 <= 0xfffffd55
         
         addi  x9,  x0,  -1366       # x9  <= 0xfffffaaa
         
         or    x11, x0,  x9          # x10 <= 0xfffffaaa
         
         addi  x9,  x0,  -1930       # x9  <= 0xfffff876
         
         or    x11, x10, x9          # x11 <= 0xfffffd77
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
