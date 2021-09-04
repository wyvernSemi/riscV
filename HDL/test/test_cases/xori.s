        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x8,  x0,  0x555       # x8 <= 0x00000555
         xori  x9,  x8,  0x555       # x9 <= 0x00000000
         xori  x9,  x8,  0x000       # x9 <= 0x00000555
         xori  x9,  x8,  0x7ff       # x9 <= 0x000002aa
         xori  x9,  x8,  -1          # x9 <= 0xfffffaaa
         
         addi  x8,  x0, -1366        # x8 <= 0xfffffaaa
         xori  x9,  x8, -1930        # x8 <= 0x000002dc
         
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         
         .word 0x00000000
