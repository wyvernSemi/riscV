// ------------------------------------------------------------------
// 
//  Copyright (c) 2021 Simon Southwell. All rights reserved.
// 
//  Date: 14th August 2021
// 
//  Example C code for testing remote debugger connection
// 
//  This file is part of the RISC-V instruction set simulator
//  (rv32_cpu).
// 
//  This code is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This code is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this code. If not, see <http://www.gnu.org/licenses/>.
// 
// ------------------------------------------------------------------

// ------------------------------------------
// INCLUDES
// ------------------------------------------

// Marco Paland's lightweight printf (github.com/mpaland/printf)
#include "printf.h"

// ------------------------------------------
// DEFINES
// ------------------------------------------

#define OUTCHAR_ADDR  0x80000000

// ------------------------------------------
// STATIC VARIABLES
// ------------------------------------------

static char buf[1024];

// ------------------------------------------
// FUNCTIONS
// ------------------------------------------

// ------------------------------------------
// Output character function for printf
//
void _putchar (char c)
{
    char* p = (char*) OUTCHAR_ADDR;
    
    *p = c;
}

// ------------------------------------------
// Example function to return the square of
// an integer
//
int func (int in)
{
    return in * in;
}

// ==========================================
//                   MAIN
// ==========================================

int main (int args, int**argv)
{
    unsigned val = 0;
    
    // Accumulate the squares of integers 1 to 10 inclusive
    for (int i = 1; i <= 10; i++)
    {
        val += func(i);
    }
    
    // Print the result.
    printf("val = %d\n", val);

    return 0;
}