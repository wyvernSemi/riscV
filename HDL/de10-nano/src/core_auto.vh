// Block name: core
// And now for some register addresses...
`define CSR_LOCAL_ADDR                      32'h00000000
`define CSR_LOCAL_ADDR_INT                  0
`define CSR_IMEM_ADDR                       32'h00008000
`define CSR_IMEM_ADDR_INT                   32768
`define CSR_DMEM_ADDR                       32'h00010000
`define CSR_DMEM_ADDR_INT                   65536

`define CSR_CONTROL_ADDR                     5'h00
`define CSR_CONTROL_ADDR_INT                 0
`define CSR_CONTROL_CLR_HALT                 0:0
`define CSR_CONTROL_HALT_ON_ADDR             1:1
`define CSR_CONTROL_HALT_ON_UNIMP            2:2
`define CSR_STATUS_ADDR                      5'h01
`define CSR_STATUS_ADDR_INT                  1
`define CSR_STATUS_HALTED                    0:0
`define CSR_STATUS_RESET                     1:1
`define CSR_HALT_ADDR_ADDR                   5'h02
`define CSR_HALT_ADDR_ADDR_INT               2
`define CSR_GP_ADDR                          5'h03
`define CSR_GP_ADDR_INT                      3

