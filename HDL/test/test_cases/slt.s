        .file   "test.s"
        .text
        .align 4
_start: .global _start
        .global main
main:                                # Delta changes
         addi  x4,  x0,  122         # x4 <= 122
         addi  x3,  x0,  123         # x3 <= 123
         slt   x5,  x4,  x3          # x5 <= 1
         addi  x3,  x0,  122         # x3 <= 122
         slt   x5,  x4,  x3          # x5 <= 0
         addi  x3,  x0,  0x7ff       # x3 <= 0x7ff
         slt   x5,  x4,  x3          # x5 <= 1
         addi  x3,  x0,  -2048       # x3 <= -2048
         slt   x5,  x4,  x3          # x5 <= 0

         addi  x4,  x0,  -122        # x4 <= -122
         addi  x3,  x0,  -121        # x3 <= -121
         slt   x5,  x4,  x3          # x5 <= 1
         addi  x3,  x0,  -122        # x3 <= -122
         slt   x5,  x4,  x3          # x5 <= 0
         addi  x3,  x0,  0x7ff       # x3 <= 0x7ff
         slt   x5,  x4,  x3          # x5 <= 1
         addi  x3,  x0,  -2048       # x3 <= -2048
         slt   x5,  x4,  x3          # x5 <= 0

         addi  x6,  x0,  122         # x6 <= 122
         addi  x3,  x0,  123         # x3 <= 123
         sltu  x7,  x6,  x3          # x7 <= 1
         addi  x3,  x0,  122         # x3 <= 122
         sltu  x7,  x6,  x3          # x7 <= 0
         addi  x3,  x0,  -1          # x3 <= -1
         sltu  x7,  x6,  x3          # x7 <= 1
         addi  x3,  x0,  121         # x3 <= 121
         sltu  x7,  x6,  x3          # x7 <= 0

         addi  x6,  x0,  -122        # x6 <= -122 (0xffffff86)
         addi  x3,  x0,  -121        # x3 <= -121
         sltu  x7,  x6,  x3          # x7 <= 1
         addi  x3,  x0,  -122        # x3 <= -122
         sltu  x7,  x6,  x3          # x7 <= 0
         addi  x3,  x0,  -1          # x3 <= -1
         sltu  x7,  x6,  x3          # x7 <= 1
         addi  x3,  x0,  1           # x3 <= 1
         sltu  x7,  x6,  x3          # x7 <= 0

         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP
         addi  x0,  x0,  0           # NOP

         .word 0x00000000
