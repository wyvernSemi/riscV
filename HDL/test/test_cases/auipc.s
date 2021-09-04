        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         nop
         nop
         auipc  x3, 0x12345
         auipc  x4, 0xfedcb
         nop
         nop
         nop
         
         .word 0x00000000
         nop
         nop
         
