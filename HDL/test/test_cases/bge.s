        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi x1, x0, -1
         addi x2, x0, -2
         bge  x1, x2, JUMP1
         addi x3, x0, 1
         addi x4, x0, 2
         addi x5, x0, 3
         addi x6, x0, 4
         addi x7, x0, 5
JUMP1:
         addi x8, x0, 6
         addi x9, x0, 7
         addi x10,x0, 8
         nop
         nop
         nop

         .word 0x00000000
