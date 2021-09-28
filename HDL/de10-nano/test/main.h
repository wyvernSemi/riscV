/**************************************************************/
/* main.h                                   Date: 2021/09/27  */
/*                                                            */
/* Copyright (c) 2021 Simon Southwell. All rights reserved.   */
/*                                                            */
/**************************************************************/

#include "CCoreAuto.h"

#ifndef _MAIN_H_
#define _MAIN_H_

extern bool        fullResetFpga();
extern void*       getFpgaVirtualBaseAddress();
extern void        write_mem(uint32_t addr, uint32_t word, uint32_t type, bool &access_fault);

#endif
