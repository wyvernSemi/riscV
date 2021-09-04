        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x1,  x0,  1           # x1 <= 1
         add   x2,  x0, x1           # x2 <= 1
         addi  x1,  x0,  10          # x1 <= 10
         add   x2,  x1, x2           # x2 <= 11
         add   x2,  x2, x1           # x2 <= 21
         
         addi  x1,  x0,  -3          # x1 <= -3
         add   x2,  x2, x1           # x2 <= 18
         addi  x1,  x0,  -19         # x1 <= -19
         add   x2,  x1, x2           # x2 <= -1
         add   x0,  x0,  0           # NOP
         add   x0,  x0,  0           # NOP
         
         .word 0x00000000
