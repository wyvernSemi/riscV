        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         nop
         nop
         lui  x3, 0x12345
         lui  x4, 0xfedcb
         nop
         nop
         nop
         
         .word 0x00000000
