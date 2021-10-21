        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:
         nop
         nop
         addi x1, x0, 0x12
         addi x2, x0, -1234
         sw   x2, 0x0e(x1)
         addi x2, x0, 1234
         sw   x2, 0x22(x1)
         nop
         nop
         lw  x3, 0x0e(x1)
         lw  x4, 0x22(x1)
         lh  x6, 0x0e(x1)
         addi x5, x2, 0
         addi x7, x1, 0
         addi x8, x0, 0x789
         lh   x9, 0x10(x1)
         lb   x10, 0x0f(x1)
         nop
         nop
         nop
         nop
         nop

         .word 0x00000000
