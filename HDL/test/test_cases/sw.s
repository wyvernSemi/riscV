        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         nop
         nop
         addi x1, x0, 0x12
         addi x2, x0, -1234
         sw   x2, 0x0e(x1)
         nop
         nop
         
         .word 0x00000000
