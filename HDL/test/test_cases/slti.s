        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x4,  x0,  122         # x4 <= 122
         slti  x5,  x4,  123         # x5 <= 1
         slti  x5,  x4,  122         # x5 <= 0
         slti  x5,  x4,  0x7ff       # x5 <= 1
         slti  x5,  x4,  -2048       # x5 <= 0

         addi  x4,  x0,  -122        # x4 <= -122
         slti  x5,  x4,  -121        # x5 <= 1
         slti  x5,  x4,  -122        # x5 <= 0
         slti  x5,  x4,  0x7ff       # x5 <= 1
         slti  x5,  x4,  -2048       # x5 <= 0

         addi  x6,  x0,  122         # x6 <= 122
         sltiu x7,  x6,  123         # x7 <= 1
         sltiu x7,  x6,  122         # x7 <= 0
         sltiu x7,  x6,  -1          # x7 <= 1
         sltiu x7,  x6,  121         # x7 <= 0

         addi  x6,  x0,  -122        # x6 <= -122 (0xffffff86)
         sltiu x7,  x6,  -121        # x7 <= 1
         sltiu x7,  x6,  -122        # x7 <= 0
         sltiu x7,  x6,  -1          # x7 <= 1
         sltiu x7,  x6,  1           # x7 <= 0

         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP

         .word 0x00000000
