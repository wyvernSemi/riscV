        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x18, x0,  0x123       # x18 <= 0x00000123
         slli  x18, x18, 12          # x18 <= 0x00123000
         addi  x18, x18, 0x456       # x18 <= 0x00123456
         slli  x18, x18, 8           # x18 <= 0x12345600
         addi  x18, x18, 0x78        # x18 <= 0x12345678
         
         addi  x1,  x0,  3           # x1  <= 3
         addi  x2,  x0,  5           # x2  <= 5
         addi  x3,  x0,  21          # x3  <= 21
         addi  x4,  x0,  17          # x4  <= 17
         
         sra   x19, x18, x1          # x19 <= 0x02468acf
         sra   x19, x18, x2          # x19 <= 0x0091a2b3
         sra   x19, x18, x3          # x19 <= 0x00000091
         
         xori  x18, x18, -1          # x18 <= 0xedcba987
         
         sra   x19, x18, x4          # x19 <= 0xfffff6e5
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
