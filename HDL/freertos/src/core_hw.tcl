# TCL File Generated by Component Editor 18.1
# Fri Sep 01 10:54:02 BST 2023
# DO NOT MODIFY


# 
# core "core" v0.0
#  2023.09.01.10:54:02
# Top Level Verilog FPGA logic
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module core
# 
set_module_property DESCRIPTION "Top Level Verilog FPGA logic"
set_module_property NAME core
set_module_property VERSION 0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME core
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL core
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file dp_ram.v VERILOG PATH ip/intel/dp_ram.v
add_fileset_file altera_up_sync_fifo.v VERILOG PATH ip/intel/altera_up_sync_fifo.v
add_fileset_file altera_up_rs232_counters.v VERILOG PATH ip/intel/altera_up_rs232_counters.v
add_fileset_file altera_up_rs232_out_serializer.v VERILOG PATH ip/intel/altera_up_rs232_out_serializer.v
add_fileset_file altera_up_rs232_in_deserializer.v VERILOG PATH ip/intel/altera_up_rs232_in_deserializer.v
add_fileset_file uart_rs232.v VERILOG PATH ip/intel/uart_rs232.v
add_fileset_file rv32i_alu.v VERILOG PATH ../../src/rv32i_alu.v
add_fileset_file rv32i_decode.v VERILOG PATH ../../src/rv32i_decode.v
add_fileset_file rv32i_regfile.v VERILOG PATH ../../src/rv32i_regfile.v
add_fileset_file rv32i_cpu_core.v VERILOG PATH ../../src/rv32i_cpu_core.v
add_fileset_file zicsr_auto.vh VERILOG PATH ../../src/zicsr_auto.vh
add_fileset_file zicsr_rv32_regs_auto.v VERILOG PATH ../../src/zicsr_rv32_regs_auto.v
add_fileset_file rv32_zicsr.v VERILOG PATH ../../src/rv32_zicsr.v
add_fileset_file rv32_m.v VERILOG PATH ../../src/rv32_m.v
add_fileset_file uart.v VERILOG PATH uart.v
add_fileset_file core.v VERILOG PATH core.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter CLK_FREQ_MHZ INTEGER 100 "Must match pll_0's outclk0 frequency"
set_parameter_property CLK_FREQ_MHZ DEFAULT_VALUE 100
set_parameter_property CLK_FREQ_MHZ DISPLAY_NAME CLK_FREQ_MHZ
set_parameter_property CLK_FREQ_MHZ TYPE INTEGER
set_parameter_property CLK_FREQ_MHZ UNITS None
set_parameter_property CLK_FREQ_MHZ ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CLK_FREQ_MHZ DESCRIPTION "Must match pll_0's outclk0 frequency"
set_parameter_property CLK_FREQ_MHZ HDL_PARAMETER true
add_parameter RV32I_RESET_VECTOR STD_LOGIC_VECTOR 0 "PC address at reset"
set_parameter_property RV32I_RESET_VECTOR DEFAULT_VALUE 0
set_parameter_property RV32I_RESET_VECTOR DISPLAY_NAME RV32I_RESET_VECTOR
set_parameter_property RV32I_RESET_VECTOR WIDTH 32
set_parameter_property RV32I_RESET_VECTOR TYPE STD_LOGIC_VECTOR
set_parameter_property RV32I_RESET_VECTOR UNITS None
set_parameter_property RV32I_RESET_VECTOR DESCRIPTION "PC address at reset"
set_parameter_property RV32I_RESET_VECTOR HDL_PARAMETER true
add_parameter RV32I_TRAP_VECTOR STD_LOGIC_VECTOR 4 "Trap vector address"
set_parameter_property RV32I_TRAP_VECTOR DEFAULT_VALUE 4
set_parameter_property RV32I_TRAP_VECTOR DISPLAY_NAME RV32I_TRAP_VECTOR
set_parameter_property RV32I_TRAP_VECTOR WIDTH 32
set_parameter_property RV32I_TRAP_VECTOR TYPE STD_LOGIC_VECTOR
set_parameter_property RV32I_TRAP_VECTOR UNITS None
set_parameter_property RV32I_TRAP_VECTOR DESCRIPTION "Trap vector address"
set_parameter_property RV32I_TRAP_VECTOR HDL_PARAMETER true
add_parameter RV32I_LOG2_REGFILE_ENTRIES INTEGER 5 "log2(#regfile entries). Valid values are 4 (RV32E) and 5 (RV32I)"
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES DEFAULT_VALUE 5
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES DISPLAY_NAME RV32I_LOG2_REGFILE_ENTRIES
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES TYPE INTEGER
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES UNITS None
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES DESCRIPTION "log2(#regfile entries). Valid values are 4 (RV32E) and 5 (RV32I)"
set_parameter_property RV32I_LOG2_REGFILE_ENTRIES HDL_PARAMETER true
add_parameter RV32I_REGFILE_USE_MEM BOOLEAN true "Selects between memory and register based regfile implementation"
set_parameter_property RV32I_REGFILE_USE_MEM DEFAULT_VALUE true
set_parameter_property RV32I_REGFILE_USE_MEM DISPLAY_NAME RV32I_REGFILE_USE_MEM
set_parameter_property RV32I_REGFILE_USE_MEM WIDTH ""
set_parameter_property RV32I_REGFILE_USE_MEM TYPE BOOLEAN
set_parameter_property RV32I_REGFILE_USE_MEM UNITS None
set_parameter_property RV32I_REGFILE_USE_MEM DESCRIPTION "Selects between memory and register based regfile implementation"
set_parameter_property RV32I_REGFILE_USE_MEM HDL_PARAMETER true
add_parameter RV32I_IMEM_ADDR_WIDTH INTEGER 16 "Address width of internal instruction memory"
set_parameter_property RV32I_IMEM_ADDR_WIDTH DEFAULT_VALUE 16
set_parameter_property RV32I_IMEM_ADDR_WIDTH DISPLAY_NAME RV32I_IMEM_ADDR_WIDTH
set_parameter_property RV32I_IMEM_ADDR_WIDTH TYPE INTEGER
set_parameter_property RV32I_IMEM_ADDR_WIDTH UNITS None
set_parameter_property RV32I_IMEM_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32I_IMEM_ADDR_WIDTH DESCRIPTION "Address width of internal instruction memory"
set_parameter_property RV32I_IMEM_ADDR_WIDTH HDL_PARAMETER true
add_parameter RV32I_DMEM_ADDR_WIDTH INTEGER 13 "Address width of internal data memory"
set_parameter_property RV32I_DMEM_ADDR_WIDTH DEFAULT_VALUE 13
set_parameter_property RV32I_DMEM_ADDR_WIDTH DISPLAY_NAME RV32I_DMEM_ADDR_WIDTH
set_parameter_property RV32I_DMEM_ADDR_WIDTH TYPE INTEGER
set_parameter_property RV32I_DMEM_ADDR_WIDTH UNITS None
set_parameter_property RV32I_DMEM_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32I_DMEM_ADDR_WIDTH DESCRIPTION "Address width of internal data memory"
set_parameter_property RV32I_DMEM_ADDR_WIDTH HDL_PARAMETER true
add_parameter RV32I_IMEM_INIT_FILE STRING UNUSED "Specify IMEM initialisation file"
set_parameter_property RV32I_IMEM_INIT_FILE DEFAULT_VALUE UNUSED
set_parameter_property RV32I_IMEM_INIT_FILE DISPLAY_NAME RV32I_IMEM_INIT_FILE
set_parameter_property RV32I_IMEM_INIT_FILE TYPE STRING
set_parameter_property RV32I_IMEM_INIT_FILE UNITS None
set_parameter_property RV32I_IMEM_INIT_FILE DESCRIPTION "Specify IMEM initialisation file"
set_parameter_property RV32I_IMEM_INIT_FILE HDL_PARAMETER true
add_parameter RV32I_DMEM_INIT_FILE STRING UNUSED "Specify DMEM initialisation file"
set_parameter_property RV32I_DMEM_INIT_FILE DEFAULT_VALUE UNUSED
set_parameter_property RV32I_DMEM_INIT_FILE DISPLAY_NAME RV32I_DMEM_INIT_FILE
set_parameter_property RV32I_DMEM_INIT_FILE TYPE STRING
set_parameter_property RV32I_DMEM_INIT_FILE UNITS None
set_parameter_property RV32I_DMEM_INIT_FILE DESCRIPTION "Specify DMEM initialisation file"
set_parameter_property RV32I_DMEM_INIT_FILE HDL_PARAMETER true
add_parameter RV32_ZICSR_EN INTEGER 1 "Enable/disable Zicsr extensions"
set_parameter_property RV32_ZICSR_EN DEFAULT_VALUE 1
set_parameter_property RV32_ZICSR_EN DISPLAY_NAME RV32_ZICSR_EN
set_parameter_property RV32_ZICSR_EN TYPE INTEGER
set_parameter_property RV32_ZICSR_EN UNITS None
set_parameter_property RV32_ZICSR_EN ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32_ZICSR_EN DESCRIPTION "Enable/disable Zicsr extensions"
set_parameter_property RV32_ZICSR_EN HDL_PARAMETER true
add_parameter RV32_DISABLE_TIMER INTEGER 0 "Disable/enable RT timer (if Zicsr extensions enabled)"
set_parameter_property RV32_DISABLE_TIMER DEFAULT_VALUE 0
set_parameter_property RV32_DISABLE_TIMER DISPLAY_NAME RV32_DISABLE_TIMER
set_parameter_property RV32_DISABLE_TIMER TYPE INTEGER
set_parameter_property RV32_DISABLE_TIMER UNITS None
set_parameter_property RV32_DISABLE_TIMER ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32_DISABLE_TIMER DESCRIPTION "Disable/enable RT timer (if Zicsr extensions enabled)"
set_parameter_property RV32_DISABLE_TIMER HDL_PARAMETER true
add_parameter RV32_DISABLE_INSTRET INTEGER 0 "Disable/enable instruction retired counter (if Zicsr extensions enabled)"
set_parameter_property RV32_DISABLE_INSTRET DEFAULT_VALUE 0
set_parameter_property RV32_DISABLE_INSTRET DISPLAY_NAME RV32_DISABLE_INSTRET
set_parameter_property RV32_DISABLE_INSTRET TYPE INTEGER
set_parameter_property RV32_DISABLE_INSTRET UNITS None
set_parameter_property RV32_DISABLE_INSTRET ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32_DISABLE_INSTRET DESCRIPTION "Disable/enable instruction retired counter (if Zicsr extensions enabled)"
set_parameter_property RV32_DISABLE_INSTRET HDL_PARAMETER true
add_parameter RV32_M_EN INTEGER 1 "Enable/disable RV32M extensions"
set_parameter_property RV32_M_EN DEFAULT_VALUE 1
set_parameter_property RV32_M_EN DISPLAY_NAME RV32_M_EN
set_parameter_property RV32_M_EN TYPE INTEGER
set_parameter_property RV32_M_EN UNITS None
set_parameter_property RV32_M_EN ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32_M_EN DESCRIPTION "Enable/disable RV32M extensions"
set_parameter_property RV32_M_EN HDL_PARAMETER true
add_parameter RV32M_FIXED_TIMING INTEGER 0 "Enable/disable fixed timings for RV32M extensions (no optimistaion logic)"
set_parameter_property RV32M_FIXED_TIMING DEFAULT_VALUE 0
set_parameter_property RV32M_FIXED_TIMING DISPLAY_NAME RV32M_FIXED_TIMING
set_parameter_property RV32M_FIXED_TIMING TYPE INTEGER
set_parameter_property RV32M_FIXED_TIMING UNITS None
set_parameter_property RV32M_FIXED_TIMING ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32M_FIXED_TIMING DESCRIPTION "Enable/disable fixed timings for RV32M extensions (no optimistaion logic)"
set_parameter_property RV32M_FIXED_TIMING HDL_PARAMETER true
add_parameter RV32M_MUL_INFERRED INTEGER 1 "Enable/disable inferred multiplication for RV32M extensions (FPGA DSP elements)"
set_parameter_property RV32M_MUL_INFERRED DEFAULT_VALUE 1
set_parameter_property RV32M_MUL_INFERRED DISPLAY_NAME RV32M_MUL_INFERRED
set_parameter_property RV32M_MUL_INFERRED TYPE INTEGER
set_parameter_property RV32M_MUL_INFERRED UNITS None
set_parameter_property RV32M_MUL_INFERRED ALLOWED_RANGES -2147483648:2147483647
set_parameter_property RV32M_MUL_INFERRED DESCRIPTION "Enable/disable inferred multiplication for RV32M extensions (FPGA DSP elements)"
set_parameter_property RV32M_MUL_INFERRED HDL_PARAMETER true


# 
# display items
# 
add_display_item "" VECTORS GROUP ""
add_display_item "" TIMING GROUP ""
add_display_item "" MEMORY GROUP ""
add_display_item "" EXTENSIONS GROUP ""


# 
# connection point csr
# 
add_interface csr avalon end
set_interface_property csr addressUnits WORDS
set_interface_property csr associatedClock clk
set_interface_property csr associatedReset reset
set_interface_property csr bitsPerSymbol 8
set_interface_property csr burstOnBurstBoundariesOnly false
set_interface_property csr burstcountUnits WORDS
set_interface_property csr explicitAddressSpan 0
set_interface_property csr holdTime 0
set_interface_property csr linewrapBursts false
set_interface_property csr maximumPendingReadTransactions 0
set_interface_property csr maximumPendingWriteTransactions 0
set_interface_property csr readLatency 0
set_interface_property csr readWaitTime 1
set_interface_property csr setupTime 0
set_interface_property csr timingUnits Cycles
set_interface_property csr writeWaitTime 0
set_interface_property csr ENABLED true
set_interface_property csr EXPORT_OF ""
set_interface_property csr PORT_NAME_MAP ""
set_interface_property csr CMSIS_SVD_VARIABLES ""
set_interface_property csr SVD_ADDRESS_GROUP ""

add_interface_port csr avs_csr_address address Input 18
add_interface_port csr avs_csr_write write Input 1
add_interface_port csr avs_csr_writedata writedata Input 32
add_interface_port csr avs_csr_read read Input 1
add_interface_port csr avs_csr_readdata readdata Output 32
set_interface_assignment csr embeddedsw.configuration.isFlash 0
set_interface_assignment csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment csr embeddedsw.configuration.isPrintableDevice 0


# 
# connection point rx
# 
add_interface rx avalon start
set_interface_property rx addressUnits SYMBOLS
set_interface_property rx associatedClock clk
set_interface_property rx associatedReset reset
set_interface_property rx bitsPerSymbol 8
set_interface_property rx burstOnBurstBoundariesOnly false
set_interface_property rx burstcountUnits WORDS
set_interface_property rx doStreamReads false
set_interface_property rx doStreamWrites false
set_interface_property rx holdTime 0
set_interface_property rx linewrapBursts false
set_interface_property rx maximumPendingReadTransactions 0
set_interface_property rx maximumPendingWriteTransactions 0
set_interface_property rx readLatency 0
set_interface_property rx readWaitTime 1
set_interface_property rx setupTime 0
set_interface_property rx timingUnits Cycles
set_interface_property rx writeWaitTime 0
set_interface_property rx ENABLED true
set_interface_property rx EXPORT_OF ""
set_interface_property rx PORT_NAME_MAP ""
set_interface_property rx CMSIS_SVD_VARIABLES ""
set_interface_property rx SVD_ADDRESS_GROUP ""

add_interface_port rx avm_rx_waitrequest waitrequest Input 1
add_interface_port rx avm_rx_burstcount burstcount Output 12
add_interface_port rx avm_rx_address address Output 32
add_interface_port rx avm_rx_read read Output 1
add_interface_port rx avm_rx_readdata readdata Input 32
add_interface_port rx avm_rx_readdatavalid readdatavalid Input 1


# 
# connection point tx
# 
add_interface tx avalon start
set_interface_property tx addressUnits SYMBOLS
set_interface_property tx associatedClock clk
set_interface_property tx associatedReset reset
set_interface_property tx bitsPerSymbol 8
set_interface_property tx burstOnBurstBoundariesOnly false
set_interface_property tx burstcountUnits WORDS
set_interface_property tx doStreamReads false
set_interface_property tx doStreamWrites false
set_interface_property tx holdTime 0
set_interface_property tx linewrapBursts false
set_interface_property tx maximumPendingReadTransactions 0
set_interface_property tx maximumPendingWriteTransactions 0
set_interface_property tx readLatency 0
set_interface_property tx readWaitTime 1
set_interface_property tx setupTime 0
set_interface_property tx timingUnits Cycles
set_interface_property tx writeWaitTime 0
set_interface_property tx ENABLED true
set_interface_property tx EXPORT_OF ""
set_interface_property tx PORT_NAME_MAP ""
set_interface_property tx CMSIS_SVD_VARIABLES ""
set_interface_property tx SVD_ADDRESS_GROUP ""

add_interface_port tx avm_tx_burstcount burstcount Output 12
add_interface_port tx avm_tx_address address Output 32
add_interface_port tx avm_tx_write write Output 1
add_interface_port tx avm_tx_writedata writedata Output 32
add_interface_port tx avm_tx_waitrequest waitrequest Input 1


# 
# connection point debug_out_1
# 
add_interface debug_out_1 conduit end
set_interface_property debug_out_1 associatedClock clk
set_interface_property debug_out_1 associatedReset reset
set_interface_property debug_out_1 ENABLED true
set_interface_property debug_out_1 EXPORT_OF ""
set_interface_property debug_out_1 PORT_NAME_MAP ""
set_interface_property debug_out_1 CMSIS_SVD_VARIABLES ""
set_interface_property debug_out_1 SVD_ADDRESS_GROUP ""

add_interface_port debug_out_1 debug_out debug_out Output 32


# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 50000000
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point clk_x2
# 
add_interface clk_x2 clock end
set_interface_property clk_x2 clockRate 100000000
set_interface_property clk_x2 ENABLED true
set_interface_property clk_x2 EXPORT_OF ""
set_interface_property clk_x2 PORT_NAME_MAP ""
set_interface_property clk_x2 CMSIS_SVD_VARIABLES ""
set_interface_property clk_x2 SVD_ADDRESS_GROUP ""

add_interface_port clk_x2 clk_x2 clk Input 1


# 
# connection point clk_div2
# 
add_interface clk_div2 clock end
set_interface_property clk_div2 clockRate 25000000
set_interface_property clk_div2 ENABLED true
set_interface_property clk_div2 EXPORT_OF ""
set_interface_property clk_div2 PORT_NAME_MAP ""
set_interface_property clk_div2 CMSIS_SVD_VARIABLES ""
set_interface_property clk_div2 SVD_ADDRESS_GROUP ""

add_interface_port clk_div2 clk_div2 clk Input 1


# 
# connection point hdmi
# 
add_interface hdmi conduit end
set_interface_property hdmi associatedClock clk
set_interface_property hdmi associatedReset reset
set_interface_property hdmi ENABLED true
set_interface_property hdmi EXPORT_OF ""
set_interface_property hdmi PORT_NAME_MAP ""
set_interface_property hdmi CMSIS_SVD_VARIABLES ""
set_interface_property hdmi SVD_ADDRESS_GROUP ""

add_interface_port hdmi hdmi_i2c_sda_in sda_in Input 1
add_interface_port hdmi hdmi_i2c_sda_out sda_out Output 1
add_interface_port hdmi hdmi_i2c_sda_oe sda_oe Output 1
add_interface_port hdmi hdmi_i2c_scl i2c_scl Output 1
add_interface_port hdmi hdmi_i2s i2s Output 1
add_interface_port hdmi hdmi_lrclk lrck Output 1
add_interface_port hdmi hdmi_mclk mclk Output 1
add_interface_port hdmi hdmi_sclk sclk Output 1
add_interface_port hdmi hdmi_tx_clk tx_clk Output 1
add_interface_port hdmi hdmi_tx_d tx_d Output 24
add_interface_port hdmi hdmi_tx_de tx_de Output 1
add_interface_port hdmi hdmi_tx_hs tx_hs Output 1
add_interface_port hdmi hdmi_tx_vs tx_vs Output 1
add_interface_port hdmi hdmi_tx_int tx_int Input 1


# 
# connection point adc
# 
add_interface adc conduit end
set_interface_property adc associatedClock clk
set_interface_property adc associatedReset reset
set_interface_property adc ENABLED true
set_interface_property adc EXPORT_OF ""
set_interface_property adc PORT_NAME_MAP ""
set_interface_property adc CMSIS_SVD_VARIABLES ""
set_interface_property adc SVD_ADDRESS_GROUP ""

add_interface_port adc adc_convst convst Output 1
add_interface_port adc adc_sck sck Output 1
add_interface_port adc adc_sdo sdo Input 1
add_interface_port adc adc_sdi sdi Output 1


# 
# connection point arduino
# 
add_interface arduino conduit end
set_interface_property arduino associatedClock clk
set_interface_property arduino associatedReset reset
set_interface_property arduino ENABLED true
set_interface_property arduino EXPORT_OF ""
set_interface_property arduino PORT_NAME_MAP ""
set_interface_property arduino CMSIS_SVD_VARIABLES ""
set_interface_property arduino SVD_ADDRESS_GROUP ""

add_interface_port arduino arduino_io_out io_out Output 16
add_interface_port arduino arduino_io_oe io_oe Output 16
add_interface_port arduino arduino_io_in io_in Input 16
add_interface_port arduino arduino_reset_n reset_n Input 1


# 
# connection point gpio
# 
add_interface gpio conduit end
set_interface_property gpio associatedClock clk
set_interface_property gpio associatedReset reset
set_interface_property gpio ENABLED true
set_interface_property gpio EXPORT_OF ""
set_interface_property gpio PORT_NAME_MAP ""
set_interface_property gpio CMSIS_SVD_VARIABLES ""
set_interface_property gpio SVD_ADDRESS_GROUP ""

add_interface_port gpio gpio_in in Input 72
add_interface_port gpio gpio_out out Output 72
add_interface_port gpio gpio_oe oe Output 72


# 
# connection point key
# 
add_interface key conduit end
set_interface_property key associatedClock clk
set_interface_property key associatedReset reset
set_interface_property key ENABLED true
set_interface_property key EXPORT_OF ""
set_interface_property key PORT_NAME_MAP ""
set_interface_property key CMSIS_SVD_VARIABLES ""
set_interface_property key SVD_ADDRESS_GROUP ""

add_interface_port key key in Input 2


# 
# connection point led
# 
add_interface led conduit end
set_interface_property led associatedClock clk
set_interface_property led associatedReset reset
set_interface_property led ENABLED true
set_interface_property led EXPORT_OF ""
set_interface_property led PORT_NAME_MAP ""
set_interface_property led CMSIS_SVD_VARIABLES ""
set_interface_property led SVD_ADDRESS_GROUP ""

add_interface_port led led out Output 8


# 
# connection point sw
# 
add_interface sw conduit end
set_interface_property sw associatedClock clk
set_interface_property sw associatedReset reset
set_interface_property sw ENABLED true
set_interface_property sw EXPORT_OF ""
set_interface_property sw PORT_NAME_MAP ""
set_interface_property sw CMSIS_SVD_VARIABLES ""
set_interface_property sw SVD_ADDRESS_GROUP ""

add_interface_port sw sw in Input 4
