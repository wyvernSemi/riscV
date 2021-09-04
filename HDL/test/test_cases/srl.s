        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x16, x0,  0x123       # x16 <= 0x00000123
         slli  x16, x16, 12          # x16 <= 0x00123000
         addi  x16, x16, 0x456       # x16 <= 0x00123456
         slli  x16, x16, 8           # x16 <= 0x12345600
         addi  x16, x16, 0x78        # x16 <= 0x12345678
         
         addi  x1,  x0,  3           # x1  <= 3
         addi  x2,  x0,  5           # x2  <= 5
         addi  x3,  x0,  21          # x3  <= 21
         addi  x4,  x0,  17          # x4  <= 17
         
         srl   x17, x16, x1          # x17 <= 0x02468acf
         srl   x17, x16, x2          # x17 <= 0x0091a2b3
         srl   x17, x16, x3          # x17 <= 0x00000091
         
         xori  x16, x16, -1          # x16 <= 0xedcba987
         srl   x17, x16, x4          # x17 <= 0x000076e5
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
