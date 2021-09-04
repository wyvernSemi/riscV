        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x1,  x0,  1           # x1 <= 1
         addi  x1,  x0,  10          # x1 <= 10
         addi  x1,  x1,  5           # x1 <= 15
         addi  x2,  x0,  -3          # x2 <= -3
         addi  x2,  x1,  0           # x2 <= 15
         addi  x3,  x2,  -11         # x3 <= 4
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
