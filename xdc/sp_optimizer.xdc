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
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports CLK]

## create a 100 MHz clock signal with 50% duty cycle for reg2reg Static Timing Analysis (STA)
create_clock -period 10.000 -name clk100 -waveform {0.000 5.000} -add [get_ports CLK]

## constrain the in2reg timing paths (assume approx. 1/2 clock period)
# set_input_delay -clock clk100 2.000 [all_inputs]
set_input_delay -clock clk100 2.000 [get_ports BTN_L]
set_input_delay -clock clk100 2.000 [get_ports BTN_R]
set_input_delay -clock clk100 2.000 [get_ports BTN_U]
set_input_delay -clock clk100 2.000 [get_ports BTN_D]
set_input_delay -clock clk100 2.000 [get_ports BTN_C]
set_input_delay -clock clk100 2.000 [get_ports RST]
set_input_delay -clock clk100 2.000 [get_ports DBG]
set_input_delay -clock clk100 2.000 [get_ports ANG]
set_input_delay -clock clk100 2.000 [get_ports vauxp]
set_input_delay -clock clk100 2.000 [get_ports vauxn]

## constrain the reg2out timing paths (assume approx. 1/2 clock period)
set_output_delay -clock clk100 2.000 [get_ports V_in]
set_output_delay -clock clk100 2.000 [get_ports RS]
set_output_delay -clock clk100 2.000 [get_ports EN_OUT]
set_output_delay -clock clk100 2.000 [get_ports data_LCD]
set_output_delay -clock clk100 2.000 [get_ports servo_l]
set_output_delay -clock clk100 2.000 [get_ports servo_r]
set_output_delay -clock clk100 2.000 [get_ports servo_u]
set_output_delay -clock clk100 2.000 [get_ports servo_d]
set_output_delay -clock clk100 2.000 [get_ports SERVO_H]
set_output_delay -clock clk100 2.000 [get_ports SERVO_V]

########################
##   slide switches   ##
########################


# set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33 } [get_ports BTN_R]   ; #IO_L12N_T1_MRCC_16 Sch=sw[0]
# set_property -dict { PACKAGE_PIN C11  IOSTANDARD LVCMOS33 } [get_ports BTN_U]   ; #IO_L13P_T2_MRCC_16 Sch=sw[1]
# set_property -dict { PACKAGE_PIN C10  IOSTANDARD LVCMOS33 } [get_ports BTN_D]   ; #IO_L13N_T2_MRCC_16 Sch=sw[2]
# set_property -dict { PACKAGE_PIN A10  IOSTANDARD LVCMOS33 } [get_ports BTN_L]   ; #IO_L14P_T2_SRCC_16 Sch=sw[3]


set_property -dict { PACKAGE_PIN A8   IOSTANDARD LVCMOS33 } [get_ports BTN_C]   ; #IO_L12N_T1_MRCC_16 Sch=sw[0]
set_property -dict { PACKAGE_PIN C11  IOSTANDARD LVCMOS33 } [get_ports RST]   ; #IO_L13P_T2_MRCC_16 Sch=sw[1]
set_property -dict { PACKAGE_PIN C10  IOSTANDARD LVCMOS33 } [get_ports DBG]   ; #IO_L13N_T2_MRCC_16 Sch=sw[2]
set_property -dict { PACKAGE_PIN A10  IOSTANDARD LVCMOS33 } [get_ports ANG]   ; #IO_L14P_T2_SRCC_16 Sch=sw[3]


######################
##   push-buttons   ##
######################

# Buttons facing human

#set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports BTN_D]   ; #IO_L6N_T0_VREF_16 Sch=btn[0]
#set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports BTN_U]   ; #IO_L11P_T1_SRCC_16 Sch=btn[1]
#set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports BTN_R]   ; #IO_L11N_T1_SRCC_16 Sch=btn[2]
#set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports BTN_L]   ; #IO_L12P_T1_MRCC_16 Sch=btn[3]

# Buttons facing away from human

set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports BTN_R]   ; #IO_L6N_T0_VREF_16 Sch=btn[0]
set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS33 } [get_ports BTN_U]   ; #IO_L11P_T1_SRCC_16 Sch=btn[1]
set_property -dict { PACKAGE_PIN B9  IOSTANDARD LVCMOS33 } [get_ports BTN_D]   ; #IO_L11N_T1_SRCC_16 Sch=btn[2]
set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports BTN_L]   ; #IO_L12P_T1_MRCC_16 Sch=btn[3]

# set_property -dict { PACKAGE_PIN D9  IOSTANDARD LVCMOS33 } [get_ports RST]   ; #IO_L6N_T0_VREF_16 Sch=btn[0]
# set_property -dict { PACKAGE_PIN B8  IOSTANDARD LVCMOS33 } [get_ports BTN_C]   ; #IO_L12P_T1_MRCC_16 Sch=btn[3]

#######################
##   standard LEDs   ##
#######################

set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports servo_r ]   ; #IO_L24N_T3_35 Sch=led[4]
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports servo_u ]   ; #IO_25_35 Sch=led[5]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports servo_d ]   ; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports servo_l ]   ; #IO_L24N_T3_A00_D16_14 Sch=led[7]

##################
##   RGB LEDs   ##
##################

set_property -dict { PACKAGE_PIN E1  IOSTANDARD LVCMOS33 } [get_ports V_in[0]]   ; #IO_L18N_T2_35 Sch=led0_b
# set_property -dict { PACKAGE_PIN F6  IOSTANDARD LVCMOS33 } [get_ports SERVO_H]   ; #IO_L19N_T3_VREF_35 Sch=led0_g
set_property -dict { PACKAGE_PIN F6  IOSTANDARD LVCMOS33 } [get_ports V_in[1]]   ; #IO_L19N_T3_VREF_35 Sch=led0_g
set_property -dict { PACKAGE_PIN G6  IOSTANDARD LVCMOS33 } [get_ports V_in[2]]   ; #IO_L19P_T3_35 Sch=led0_r
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports V_in[3]]   ; #IO_L20P_T3_35 Sch=led1_b
# set_property -dict { PACKAGE_PIN J4  IOSTANDARD LVCMOS33 } [get_ports SERVO_V]   ; #IO_L21P_T3_DQS_35 Sch=led1_g
set_property -dict { PACKAGE_PIN J4  IOSTANDARD LVCMOS33 } [get_ports V_in[4]]   ; #IO_L21P_T3_DQS_35 Sch=led1_g
set_property -dict { PACKAGE_PIN G3  IOSTANDARD LVCMOS33 } [get_ports V_in[5]]   ; #IO_L20N_T3_35 Sch=led1_r
set_property -dict { PACKAGE_PIN H4  IOSTANDARD LVCMOS33 } [get_ports V_in[6]]   ; #IO_L21N_T3_DQS_35 Sch=led2_b
set_property -dict { PACKAGE_PIN J2  IOSTANDARD LVCMOS33 } [get_ports V_in[7]]   ; #IO_L22N_T3_35 Sch=led2_g
set_property -dict { PACKAGE_PIN J3  IOSTANDARD LVCMOS33 } [get_ports V_in[8]]   ; #IO_L22P_T3_35 Sch=led2_r
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports V_in[9]]   ; #IO_L23P_T3_35 Sch=led3_b
set_property -dict { PACKAGE_PIN H6  IOSTANDARD LVCMOS33 } [get_ports V_in[10]]   ; #IO_L24P_T3_35 Sch=led3_g
set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports V_in[11]]   ; #IO_L23N_T3_35 Sch=led3_r


########################
##   Pmod header JA   ##
########################

# Utilized to control servo motors

set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33 } [get_ports SERVO_H ]   ; #IO_0_15 Sch=ja[1]
set_property -dict { PACKAGE_PIN B11  IOSTANDARD LVCMOS33 } [get_ports SERVO_V ]   ; #IO_L4P_T0_15 Sch=ja[2]
set_property -dict { PACKAGE_PIN A11  IOSTANDARD LVCMOS33 } [get_ports RS ]   ; #IO_L4N_T0_15 Sch=ja[3]
set_property -dict { PACKAGE_PIN D12  IOSTANDARD LVCMOS33 } [get_ports EN_OUT ]   ; #IO_L6P_T0_15 Sch=ja[4]
# set_property -dict { PACKAGE_PIN D13  IOSTANDARD LVCMOS33 } [get_ports SERVO_H]   ; #IO_L6N_T0_VREF_15 Sch=ja[7]
# set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33 } [get_ports SERVO_V]   ; #IO_L10P_T1_AD11P_15 Sch=ja[8]
#set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]   ; #IO_L10N_T1_AD11N_15 Sch=ja[9]
#set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]   ; #IO_25_15 Sch=ja[10]

# set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33 } [get_ports data_LCD[0]]   ; #IO_0_15 Sch=ja[1]
# set_property -dict { PACKAGE_PIN B11  IOSTANDARD LVCMOS33 } [get_ports data_LCD[1]]   ; #IO_L4P_T0_15 Sch=ja[2]
# set_property -dict { PACKAGE_PIN A11  IOSTANDARD LVCMOS33 } [get_ports data_LCD[2]]   ; #IO_L4N_T0_15 Sch=ja[3]
# set_property -dict { PACKAGE_PIN D12  IOSTANDARD LVCMOS33 } [get_ports data_LCD[3]]   ; #IO_L6P_T0_15 Sch=ja[4]
# set_property -dict { PACKAGE_PIN D13  IOSTANDARD LVCMOS33 } [get_ports data_LCD[4]]   ; #IO_L6N_T0_VREF_15 Sch=ja[7]
# set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33 } [get_ports data_LCD[5]]   ; #IO_L10P_T1_AD11P_15 Sch=ja[8]
# set_property -dict { PACKAGE_PIN A18  IOSTANDARD LVCMOS33 } [get_ports data_LCD[6]]   ; #IO_L10N_T1_AD11N_15 Sch=ja[9]
# set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports data_LCD[7]]   ; #IO_25_15 Sch=ja[10]

########################
##   Pmod Header JB   ##
########################

# set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports pll_clk]   ; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]   ; #IO_L11N_T1_SRCC_15 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]   ; #IO_L12P_T1_MRCC_15 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]   ; #IO_L12N_T1_MRCC_15 Sch=jb_n[2]
#set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]   ; #IO_L23P_T3_FOE_B_15 Sch=jb_p[3]
#set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]   ; #IO_L23N_T3_FWE_B_15 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]   ; #IO_L24P_T3_RS1_15 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]   ; #IO_L24N_T3_RS0_15 Sch=jb_n[4]


########################
##   Pmod Header JD   ##
########################

# Utilized to recive voltage signal from the sp

set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports data_LCD[0]]   ; #IO_0_15 Sch=ja[1]
set_property -dict { PACKAGE_PIN D3  IOSTANDARD LVCMOS33 } [get_ports data_LCD[1]]   ; #IO_L4P_T0_15 Sch=ja[2]
set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports data_LCD[2]]   ; #IO_L4N_T0_15 Sch=ja[3]
set_property -dict { PACKAGE_PIN F3  IOSTANDARD LVCMOS33 } [get_ports data_LCD[3]]   ; #IO_L6P_T0_15 Sch=ja[4]
set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports data_LCD[4]]   ; #IO_L6N_T0_VREF_15 Sch=ja[7]
set_property -dict { PACKAGE_PIN D2  IOSTANDARD LVCMOS33 } [get_ports data_LCD[5]]   ; #IO_L10P_T1_AD11P_15 Sch=ja[8]
set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports data_LCD[6]]   ; #IO_L10N_T1_AD11N_15 Sch=ja[9]
set_property -dict { PACKAGE_PIN G2  IOSTANDARD LVCMOS33 } [get_ports data_LCD[7]]   ; #IO_25_15 Sch=ja[10]

# set_property -dict { PACKAGE_PIN D4  IOSTANDARD LVCMOS33 } [get_ports SERVO_H]   ; #IO_L11N_T1_SRCC_35 Sch=jd[1]
# set_property -dict { PACKAGE_PIN D3  IOSTANDARD LVCMOS33 } [get_ports SERVO_V]   ; #IO_L12N_T1_MRCC_35 Sch=jd[2]
#
# set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports RS]   ; #IO_L13P_T2_MRCC_35 Sch=jd[3]
# set_property -dict { PACKAGE_PIN F3  IOSTANDARD LVCMOS33 } [get_ports EN_OUT]   ; #IO_L13N_T2_MRCC_35 Sch=jd[4]
#set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports { jd[4] }]   ; #IO_L14P_T2_SRCC_35 Sch=jd[7]
#set_property -dict { PACKAGE_PIN D2  IOSTANDARD LVCMOS33 } [get_ports { jd[5] }]   ; #IO_L14N_T2_SRCC_35 Sch=jd[8]
#set_property -dict { PACKAGE_PIN H2  IOSTANDARD LVCMOS33 } [get_ports { jd[6] }]   ; #IO_L15P_T2_DQS_35 Sch=jd[9]
#set_property -dict { PACKAGE_PIN G2  IOSTANDARD LVCMOS33 } [get_ports { jd[7] }]   ; #IO_L15N_T2_DQS_35 Sch=jd[10]

############################################
##   ChipKit Single-Ended Analog Inputs   ##
############################################

## NOTE: The ck_an_p pins can be used as single ended analog inputs with voltages from 0-3.3V (Chipkit Analog pins A0-A5).
##       These signals should only be connected to the XADC core. When using these pins as digital I/O, use pins ck_io[14-19].

# set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports vauxn]; #IO_L1N_T0_AD4N_35 Sch=ck_an_n[0]
# set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports vauxp]; #IO_L1P_T0_AD4P_35 Sch=ck_an_p[0]
#set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[1] }]; #IO_L3N_T0_DQS_AD5N_35 Sch=ck_an_n[1]
#set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[1] }]   ; #IO_L3P_T0_DQS_AD5P_35 Sch=ck_an_p[1]
#set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[2] }]   ; #IO_L7N_T1_AD6N_35 Sch=ck_an_n[2]
#set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[2] }]   ; #IO_L7P_T1_AD6P_35 Sch=ck_an_p[2]
#set_property -dict { PACKAGE_PIN A1    IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[3] }]   ; #IO_L9N_T1_DQS_AD7N_35 Sch=ck_an_n[3]
#set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[3] }]   ; #IO_L9P_T1_DQS_AD7P_35 Sch=ck_an_p[3]
#set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { ck_an_n[4] }]   ; #IO_L10N_T1_AD15N_35 Sch=ck_an_n[4]
#set_property -dict { PACKAGE_PIN B3    IOSTANDARD LVCMOS33 } [get_ports { ck_an_p[4] }]   ; #IO_L10P_T1_AD15P_35 Sch=ck_an_p[4]
set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports vauxn]   ; #IO_L1N_T0_AD0N_15 Sch=ck_an_n[5]
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports vauxp]   ; #IO_L1P_T0_AD0P_15 Sch=ck_an_p[5]


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
