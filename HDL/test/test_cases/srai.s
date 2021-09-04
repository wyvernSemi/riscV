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
         
         srai  x19, x18, 3           # x19 <= 0x02468acf
         srai  x19, x18, 5           # x19 <= 0x0091a2b3
         srai  x19, x18, 21          # x19 <= 0x00000091
         
         xori  x18, x18, -1          # x18 <= 0xedcba987
         
         srai  x19, x18, 17          # x19 <= 0xfffff6e5
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
