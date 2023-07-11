//=============================================================
// 
// Copyright (c) 2023 Simon Southwell. All rights reserved.
//
// Date: 29th April 2023
//
// This file is part of the rv32 instruction set simulator.
//
// The code is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this code. If not, see <http://www.gnu.org/licenses/>.
//
//=============================================================

#include <stdint.h>

#define UART_BASE_ADDR    0x80000000
#define UART_RBR_OFFSET   0x00
#define UART_LSR_OFFSET   0x14

#define UART_LSR_DR_BIT   0
#define UART_LSR_TEMT_BIT 6

volatile uint32_t *uart_tx  = (volatile uint32_t *) (UART_BASE_ADDR + UART_RBR_OFFSET);
volatile uint32_t *uart_rx  = (volatile uint32_t *) (UART_BASE_ADDR + UART_RBR_OFFSET);
volatile uint32_t *uart_lsr = (volatile uint32_t *) (UART_BASE_ADDR + UART_LSR_OFFSET);

// -------------------------------------------------------------------------
// Output a single byte over the UART
// -------------------------------------------------------------------------
int outbyte(int c)
{
    // Wait until transmitter isn't busy
    //while ((*uart_lsr & (1 < UART_LSR_TEMT_BIT)) == 0);
    
    *uart_tx = c;
     
    return 0;
}

// -------------------------------------------------------------------------
// Input a single byte over the UART
// -------------------------------------------------------------------------
int inbyte(void)
{
    // Wait for a byte available
    while ((*uart_lsr & (1 << UART_LSR_DR_BIT)) == 0);
     
    return *uart_rx;
}

