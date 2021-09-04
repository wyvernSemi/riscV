        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x14, x0,  0x123       # x14 <= 0x00000123
         addi  x13, x0,  12          # x13 <= 12
         sll   x14, x14, x13         # x14 <= 0x00123000
         addi  x14, x14, 0x456       # x14 <= 0x00123456
         addi  x13, x0,  8           # x13 <= 8
         sll   x15, x14, x13         # x15 <= 0x12345600
         addi  x15, x15, 0x78        # x15 <= 0x12345678
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
