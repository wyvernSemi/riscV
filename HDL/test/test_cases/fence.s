        .file   "test.s"
        .text
_start: .global _start
        .global main
main:                                # Delta changes
         addi x1, x0, 1
         addi x2, x0, 2
         fence
         addi x3, x0, 3
         addi x4, x0, 4
         nop
         nop

         .word 0x00000000
