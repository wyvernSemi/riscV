        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x1,  x0,  1           # x1 <= 1
         sub   x2,  x0, x1           # x2 <= -1
         addi  x1,  x0,  10          # x1 <= 10
         sub   x2,  x1, x2           # x2 <= 11
         sub   x2,  x2, x1           # x2 <= 1
         
         addi  x1,  x0,  -3          # x1 <= -3
         sub   x2,  x2, x1           # x2 <= 4
         addi  x1,  x0,  -19         # x1 <= -19
         sub   x2,  x1, x2           # x2 <= -23
         nop                         # NOP
         nop                         # NOP
         
         .word 0x00000000
