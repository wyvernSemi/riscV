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
        la    x3, data      # Load x3 with address of data label
        lw    x3, 0(x3)     # Load a word from memory at byte address labelled data
        not   x3, x3        # One's complement x3
        la    x4, data      # Load x4 with address of data label
        sw    x3, 4(x4)     # Store x3 to memory at byte address in x4 , offset by 4
         
        ###    END OF TEST CODE   ###
         
        # Exit test using RISC-V International's riscv-tests pass/fail criteria
        li    a0, 0         # set a0 (x10) to 0 to indicate a pass code
        li    a7, 93        # set a7 (x17) to 93 (5dh) to indicate reached the end of the test
        ebreak

        # -----------------------------------------
        # Data section Note starts at 0x1000, as 
        # set by DATAADDR variable in rv_asm.bat.
        # -----------------------------------------
        .data
        
# Label for the beginning of data
data:
        .word 0x12345678    # Test word data value
