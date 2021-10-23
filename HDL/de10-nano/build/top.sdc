#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name FPGA_CLK1_50           -period   20.00    [get_ports FPGA_CLK1_50]
create_clock -name FPGA_CLK2_50           -period   20.00    [get_ports FPGA_CLK2_50]
create_clock -name FPGA_CLK3_50           -period   20.00    [get_ports FPGA_CLK3_50]
create_clock -name HDMI_TX_CLK            -period "65.0 MHz" [get_ports HDMI_TX_CLK]

create_clock -name HPS_I2C0_SCLK          -period 2500.00    [get_ports HPS_I2C0_SCLK]
create_clock -name HPS_I2C1_SCLK          -period 2500.00    [get_ports HPS_I2C1_SCLK]
create_clock -name HPS_USB_CLKOUT         -period   16.66    [get_ports HPS_USB_CLKOUT]

create_clock -name {altera_reserved_tck}  -period   40.00    {altera_reserved_tck}

# These are virtual clocks, because it's not relative to any internal clock or a pin
create_clock -name virtual_ext_clk_200MHz -period    5.00
create_clock -name virtual_ext_clk_25MHz  -period   40.00

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

#**************************************************************
# Set Input Delay
#**************************************************************

# Create some default input and output constraints

set_input_delay  -max  3.0 -clock virtual_ext_clk_200MHz [get_ports {HPS_ENET_MDIO HPS_ENET_RX* HPS_I2C*_SDAT HPS_SPIM_MISO HPS_UART_RX HPS_USB_DAT* HPS_USB_DIR HPS_USB_NXT HPS_SD_DATA[*] HPS_SD_CMD}]
set_input_delay  -min  2.0 -clock virtual_ext_clk_200MHz [get_ports {HPS_ENET_MDIO HPS_ENET_RX* HPS_I2C*_SDAT HPS_SPIM_MISO HPS_UART_RX HPS_USB_DAT* HPS_USB_DIR HPS_USB_NXT HPS_SD_DATA[*] HPS_SD_CMD}]
set_input_delay  -max  3.0 -clock virtual_ext_clk_25MHz [get_ports {KEY[*] GPIO_0[*]}]
set_input_delay  -min  2.0 -clock virtual_ext_clk_25MHz [get_ports {KEY[*] GPIO_0[*]}]

#**************************************************************
# Set Output Delay
#**************************************************************

# For enhancing USB BlasterII to be reliable, 25MHz

set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay  -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck             3 [get_ports altera_reserved_tdo]

set_output_delay -max  1.0 -clock virtual_ext_clk_200MHz [get_ports {HPS_ENET_GTX_CLK HPS_ENET_MD* HPS_ENET_TX*}]
set_output_delay -min  0.0 -clock virtual_ext_clk_200MHz [get_ports {HPS_ENET_GTX_CLK HPS_ENET_MD* HPS_ENET_TX*}]


set_output_delay -max  1.0 -clock virtual_ext_clk_25MHz [get_ports {LED[*] HPS_I2C*_SDAT HPS_SD_CLK HPS_SD_CMD HPS_SD_DATA[*] HPS_SPIM_MOSI HPS_SPIM_SS HPS_UART_TX HPS_USB_DATA[*] HPS_USB_STP}]
set_output_delay -min  0.0 -clock virtual_ext_clk_25MHz [get_ports {LED[*] HPS_I2C*_SDAT HPS_SD_CLK HPS_SD_CMD HPS_SD_DATA[*] HPS_SPIM_MOSI HPS_SPIM_SS HPS_UART_TX HPS_USB_DATA[*] HPS_USB_STP}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

# False path the virtual clocks with the internal system clock
set_clock_groups -asynchronous -group [get_clocks {u0|pll_0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -group [get_clocks {virtual_ext_clk_25MHz}]
set_clock_groups -asynchronous -group [get_clocks {u0|pll_0|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -group [get_clocks {virtual_ext_clk_200MHz}]

set_clock_groups -asynchronous -group [get_clocks {HPS_USB_CLKOUT}] -group [get_clocks {virtual_ext_clk_25MHz}]
set_clock_groups -asynchronous -group [get_clocks {HPS_USB_CLKOUT}] -group [get_clocks {virtual_ext_clk_200MHz}]
set_clock_groups -asynchronous -group [get_clocks {virtual_ext_clk_200MHz}] -group [get_clocks {virtual_ext_clk_25MHz}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************