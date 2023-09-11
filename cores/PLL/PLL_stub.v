// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Sun Sep 10 12:35:58 2023
// Host        : berz-msi running 64-bit Archcraft
// Command     : write_verilog -force -mode synth_stub /home/berz/Documents/UNI/MAG_1/project_LAE/cores/PLL/PLL_stub.v
// Design      : PLL
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module PLL(CLK_OUT, LOCKED, CLK_IN)
/* synthesis syn_black_box black_box_pad_pin="CLK_OUT,LOCKED,CLK_IN" */;
  output CLK_OUT;
  output LOCKED;
  input CLK_IN;
endmodule
