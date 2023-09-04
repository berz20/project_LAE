
// file: xadc_wiz_0_tb.v
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//----------------------------------------------------------------------------
// XADC Monitor wizard demonstration testbench
//----------------------------------------------------------------------------
// This demonstration testbench instantiates the example design for the 
// XADC wizard. Input clock is generated in this testbench.
//----------------------------------------------------------------------------
// Bipolar signals are applied with Vn = 0

`timescale 1ps/1ps
`define wait_eoc @(negedge EOC_TB)
`define wait_eoc_p @(posedge EOC_TB)
`define wait_eos @(posedge EOS_TB)
`define wait_drdy @(negedge DRDY_TB)
`define wait_drdy_p @(posedge DRDY_TB)
`define wait_done @(posedge BUSY_TB)
`define wait_busy @(negedge BUSY_TB)
module tb_xadc ();

  // timescale is 1ps/1ps
  localparam  ONE_NS      = 1000;
   integer    count       = 0   ;
  wire EOC_TB;
  wire EOS_TB;

// Input clock generation



  localparam time PER1    = 10*ONE_NS;
  // Declare the input clock signals
  reg         DCLK_TB     = 0;


  reg [6:0] DADDR_TB;
  reg DEN_TB;
  reg DWE_TB;
  reg [15:0] DI_TB;
  wire [15:0] DO_TB;
  wire DRDY_TB;
  reg RESET_TB;
  wire ALARM_OUT_TB;
  wire VCCAUX_ALARM_TB;
  wire VCCINT_ALARM_TB;
  wire USER_TEMP_ALARM_TB;
  wire BUSY_TB;
  wire [4:0] CHANNEL_TB;
  wire OT_TB;

// Input clock generation

always begin
  DCLK_TB = #(PER1/2) ~DCLK_TB;
end


always @(posedge DCLK_TB or posedge RESET_TB)
begin
  if (RESET_TB) begin
   DADDR_TB = 7'b0000000; //{2'b00, CHANNEL_TB};
   DI_TB = 16'b0000000000000000;
   DWE_TB = 1'b0;
   DEN_TB = 1'b0; //EOC_TB;
  end
  else begin
   DADDR_TB = {2'b00, CHANNEL_TB};
   DI_TB = 16'b0000000000000000;
   DWE_TB = 1'b0;
   DEN_TB = EOC_TB;
  end
end

initial
begin
  $display ("Timing checks are not valid");
  assign RESET_TB = 1'b1;
  #(10*PER1);
  assign RESET_TB = 1'b0;
  #(10*PER1);
  $display ("Timing checks are valid");
   `wait_eoc_p;
   `wait_eoc;
   `wait_eoc_p;
   `wait_eoc;
   `wait_eoc_p;
   `wait_eoc;
   `wait_drdy_p;	
   `wait_drdy;	
    $display ("This TB supports CONSTANT Waveform comaprision. User should compare the analog input and digital output for SIN, TRAINGLE, SQUARE waves !!") ;
    $display ("Waiting for Analog Waveform to complete !!") ;
    #(10400000.0);
  $display("SYSTEM_CLOCK_COUNTER : %0d\n",$time/PER1);
  $display ("Test Completed Successfully");
  $finish;
end




// Start of the testbench


reg IF_RD_CNT = 1'b0;




reg [11:0] Analog_Wave_Single_Ch;

always @ (posedge DCLK_TB)
begin
  if (DRDY_TB)
    Analog_Wave_Single_Ch <= DO_TB[15:4];
end   

  // Instantiation of the example design
  //---------------------------------------------------------
  xadc dut (
     .daddr_in(DADDR_TB[6:0]),
     .dclk_in(~DCLK_TB),
     .den_in(DEN_TB),
     .di_in(DI_TB[15:0]),
     .dwe_in(DWE_TB),
     .do_out(DO_TB[15:0]),
     .drdy_out(DRDY_TB),
     .reset_in(RESET_TB),
     .vccaux_alarm_out(VCCAUX_ALARM_TB),
     .vccint_alarm_out(VCCINT_ALARM_TB),
     .user_temp_alarm_out(USER_TEMP_ALARM_TB),
     .busy_out(BUSY_TB),
     .channel_out(CHANNEL_TB[4:0]),
     .eoc_out(EOC_TB),
     .eos_out(EOS_TB),
     .ot_out(OT_TB),
     .alarm_out(ALARM_OUT_TB),
     .vp_in(1'b0),
     .vn_in(1'b0)

         );

endmodule



