#
# Example RISC-V assembly program
#
        # -----------------------------------------
        # Program section (known as text)
        # -----------------------------------------
        .text
        
# Start symbol (must be present), exported as a global symbol.
_start: .global _start

# Export main as a global symbol
        .global main

# Label for entry point of test code
main:
        ### TEST CODE STARTS HERE ###
        
        addi  x1, x0, 12    # Add 12 to x0 (= 0) and put in x1
        addi  x3, x0, 0     # Make sure x3 is 0
        lui   x3, 0x1       # Load x3 upper bits (31:12) with 1 (= address of 0x1000)
        lw    x3, 0(x3)     # Load a word from memory at byte address labelled data
        xori  x3, x3, -1    # XOR x3 with -1 (0xffffffff) and put result back in x3
        addi  x4, x0, 0     # Make sure x4 is 0
        lui   x4, 0x1       # Load x4 upper bits (31:12) with 1 (= address of 0x1000)
        sw    x3, 4(x4)     # Store x3 to memory at byte address in x4 (0x1000 = start of data), offset by 4
         
        ###    END OF TEST CODE   ###
         
        # Exit test using RISC-V International's riscv-tests pass/fail criteria
        li    a0, 0         # set a0 (x10) to 0 to indicate a pass code
        li    a7, 93        # set a7 (x17) to 93 (5dh) to indicate reached the end of the test
        ebreak
        mret

        # -----------------------------------------
        # Data section Note starts at 0x1000, as 
        # set by DATAADDR variable in rv_asm.bat.
        # -----------------------------------------
        .data
        
# Label for the beginning of data
data:
        .word 0x12345678    # Test word data value
