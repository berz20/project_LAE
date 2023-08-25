# UNCOMMENT WHEN READY

################################
##   electrical constraints   ##
################################

## voltage configurations
set_property CFGBVS VCCO        [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

################################
##   clock                    ##
################################

## on-board 100 MHz clock
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports clk]


########################
##   slide switches   ##
########################


set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33 } [get_ports BTN_C]   ; #IO_L12N_T1_MRCC_16 Sch=sw[0]


######################
##   push-buttons   ##
######################

# Buttons facing human

#set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports BTN_D]   ; #IO_L6N_T0_VREF_16 Sch=btn[0]
#set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports BTN_U]   ; #IO_L11P_T1_SRCC_16 Sch=btn[1]
#set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports BTN_R]   ; #IO_L11N_T1_SRCC_16 Sch=btn[2]
#set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports BTN_L]   ; #IO_L12P_T1_MRCC_16 Sch=btn[3]

# Buttons facing away from human

set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports BTN_L]   ; #IO_L6N_T0_VREF_16 Sch=btn[0]
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports BTN_R]   ; #IO_L11P_T1_SRCC_16 Sch=btn[1]
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports BTN_U]   ; #IO_L11N_T1_SRCC_16 Sch=btn[2]
set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports BTN_D]   ; #IO_L12P_T1_MRCC_16 Sch=btn[3]


########################
##   Pmod header JA   ##
########################

# Utilized to control servo motors

set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33 } [get_ports SERVO_H ]   ; #IO_0_15 Sch=ja[1]
set_property -dict { PACKAGE_PIN B11  IOSTANDARD LVCMOS33 } [get_ports SERVO_V ]   ; #IO_L4P_T0_15 Sch=ja[2]
#set_property -dict { PACKAGE_PIN A11  IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]   ; #IO_L4N_T0_15 Sch=ja[3]
#set_property -dict { PACKAGE_PIN D12  IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]   ; #IO_L6P_T0_15 Sch=ja[4]
#set_property -dict { PACKAGE_PIN D13  IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]   ; #IO_L6N_T0_VREF_15 Sch=ja[7]
#set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]   ; #IO_L10P_T1_AD11P_15 Sch=ja[8]
#set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]   ; #IO_L10N_T1_AD11N_15 Sch=ja[9]
#set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]   ; #IO_25_15 Sch=ja[10]


########################
##   Pmod Header JD   ##
########################

# Utilized to recive voltage signal from the sp

set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports vp_in]   ; #IO_L11N_T1_SRCC_35 Sch=jd[1]
#set_property -dict { PACKAGE_PIN D3  IOSTANDARD LVCMOS33 } [get_ports vn_in]   ; #IO_L12N_T1_MRCC_35 Sch=jd[2]



################################
##   additional constraints   ##
################################

##
## additional XDC statements to optimize the memory configuration file (.bin)
## to program the external 128 Mb Quad Serial Peripheral Interface (SPI) flash
## memory in order to automatically load the FPGA configuration at power-up
##

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4  [current_design]
set_property CONFIG_MODE SPIx4  [current_design]
