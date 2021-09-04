        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x10, x0,  0x555       # x10 <= 0x00000555
         ori   x11, x10, 0x7aa       # x11 <= 0x000007ff
         ori   x11, x10, 0x000       # x11 <= 0x00000555
         ori   x11, x10, 0x7f0       # x11 <= 0x000007f5
         ori   x11, x10, -2048       # x11 <= 0xfffffd55
         
         ori   x10, x0,  -1366       # x10 <= 0xfffffaaa
         ori   x11, x10, -1930       # x11 <= 0xfffffafe
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
