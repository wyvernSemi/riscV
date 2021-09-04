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
         
         srli  x17, x16, 3           # x17 <= 0x02468acf
         srli  x17, x16, 5           # x17 <= 0x0091a2b3
         srli  x17, x16, 21          # x17 <= 0x00000091
         
         xori  x16, x16, -1          # x16 <= 0xedcba987
         srli  x17, x16, 17          # x19 <= 0x000076e5
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
