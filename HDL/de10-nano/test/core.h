// Block name: core, using byte offsets

#include <stdint.h>

#ifndef __CORE_H__
#define __CORE_H__

#define CSR_CORE_LOCAL                                0x00000000
#define CSR_CORE_IMEM                                 0x00020000
#define CSR_CORE_DMEM                                 0x00040000
#define CSR_CORE_CONTROL                              0x00000000
#define CSR_CORE_CONTROL_CLR_HALT                     0
#define CSR_CORE_CONTROL_CLR_HALT_WIDTH               1
#define CSR_CORE_CONTROL_CLR_HALT_MASK                0x00000001
#define CSR_CORE_CONTROL_HALT_ON_ADDR                 1
#define CSR_CORE_CONTROL_HALT_ON_ADDR_WIDTH           1
#define CSR_CORE_CONTROL_HALT_ON_ADDR_MASK            0x00000002
#define CSR_CORE_CONTROL_HALT_ON_UNIMP                2
#define CSR_CORE_CONTROL_HALT_ON_UNIMP_WIDTH          1
#define CSR_CORE_CONTROL_HALT_ON_UNIMP_MASK           0x00000004
#define CSR_CORE_CONTROL_HALT_ON_ECALL                3
#define CSR_CORE_CONTROL_HALT_ON_ECALL_WIDTH          1
#define CSR_CORE_CONTROL_HALT_ON_ECALL_MASK           0x00000008

#define CSR_CORE_STATUS                               0x00000004
#define CSR_CORE_STATUS_HALTED                        0
#define CSR_CORE_STATUS_HALTED_WIDTH                  1
#define CSR_CORE_STATUS_HALTED_MASK                   0x00000001
#define CSR_CORE_STATUS_RESET                         1
#define CSR_CORE_STATUS_RESET_WIDTH                   1
#define CSR_CORE_STATUS_RESET_MASK                    0x00000002

#define CSR_CORE_HALT_ADDR                            0x00000008

#define CSR_CORE_GP                                   0x0000000c

#define CSR_CORE_TEST_TIMER_LO                        0x00000010

#define CSR_CORE_TEST_TIMER_HI                        0x00000014

#define CSR_CORE_TEST_TIME_CMP_LO                     0x00000018

#define CSR_CORE_TEST_TIME_CMP_HI                     0x0000001c

#define CSR_CORE_TEST_EXT_SW_INTERRUPT                0x00000020


#endif
