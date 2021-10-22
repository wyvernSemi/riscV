        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         nop
         nop
         lui  x1, 0x80000
         lui  x8, 0x8
         nop
         nop
         nop
         
         .word 0x00000000
