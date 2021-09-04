        .file   "test.s"
        .text
_start: .global _start
        .global main
main:                                # Delta changes
         nop
         nop
         ecall
         addi x1, x0, 1
         addi x2, x0, 2
         addi x3, x0, 3
         addi x4, x0, 4

         .org 0x40
finish:
          addi x5, x0, 5
          nop
          nop
         .word 0x00000000
