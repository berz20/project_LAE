
// file: xadc_wiz_0_exdes.v
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
// XADC wizard example design
//----------------------------------------------------------------------------
// This example design instantiates the generated file containing the
// System Monitor instantiation.
//----------------------------------------------------------------------------

`timescale 1ns / 1 ps
module xadc (

   input wire [6:0] daddr_in,
   input wire AdcClk,
   input wire den_in,
   input wire [15:0] di_in,
   input wire dwe_in,
   input wire reset_in,
   input wire vp_in,
   input wire vn_in,
   output wire AdcEoc,
   output wire [11:0] AdcData

);

// module xadc
//      (
//           daddr_in,            // Address bus for the dynamic reconfiguration port
//           dclk_in,             // Clock input for the dynamic reconfiguration port
//           den_in,              // Enable Signal for the dynamic reconfiguration port
//           di_in,               // Input data bus for the dynamic reconfiguration port
//           dwe_in,              // Write Enable for the dynamic reconfiguration port
//           reset_in,            // Reset signal for the System Monitor control logic
//           busy_out,            // ADC Busy signal
//           channel_out,         // Channel Selection Outputs
//           do_out,              // Output data bus for dynamic reconfiguration port
//           drdy_out,            // Data ready signal for the dynamic reconfiguration port
//           eoc_out,             // End of Conversion Signal
//           eos_out,             // End of Sequence Signal
//           ot_out,              // Over-Temperature alarm output
//           vccaux_alarm_out,    // VCCAUX-sensor alarm output
//           vccint_alarm_out,    //  VCCINT-sensor alarm output
//           user_temp_alarm_out, // Temperature-sensor alarm output
//           alarm_out,           
//           vp_in,               // Dedicated Analog Input Pair
//           vn_in);
//
//    input vp_in;
//    input vn_in;
//    input [6:0] daddr_in;
//    input dclk_in;
//    input den_in;
//    input [15:0] di_in;
//    input dwe_in;
//    input reset_in;
//    output busy_out;
//    output [4:0] channel_out;
//    output [15:0] do_out;
//    output drdy_out;
//    output eoc_out;
//    output eos_out;
//    output ot_out;
//    output vccaux_alarm_out;
//    output vccint_alarm_out;
//    output user_temp_alarm_out;
//    output alarm_out;

   wire GND_BIT;

   reg rst_sync;
   reg rst_sync_int;
   reg rst_sync_int1;
   reg rst_sync_int2;

   assign GND_BIT = 0;

     always @(posedge reset_in or posedge AdcClk) begin
       if (reset_in) begin
            rst_sync <= 1'b1;
            rst_sync_int <= 1'b1;
            rst_sync_int1 <= 1'b1;
            rst_sync_int2 <= 1'b1;
       end
       else begin
            rst_sync <= 1'b0;
            rst_sync_int <= rst_sync;
            rst_sync_int1 <= rst_sync_int;
            rst_sync_int2 <= rst_sync_int1;
       end
    end



   wire [4:0] channel_out;
   wire [15:0] do_out;

xadc_wiz_0
xadc_wiz_inst (
      .daddr_in(daddr_in[6:0]),
      .dclk_in(AdcClk),
      .den_in(den_in),
      .di_in(di_in[15:0]),
      .dwe_in(dwe_in),
      .reset_in(rst_sync_int2),
 
      .vccaux_alarm_out(vccaux_alarm_out),
      .vccint_alarm_out(vccint_alarm_out),
      .user_temp_alarm_out(user_temp_alarm_out),
      .busy_out(busy_out),
      .channel_out(channel_out[4:0]),
      .do_out(do_out[15:0]),
      .drdy_out(drdy_out),
      .eoc_out(eoc_out),
      .eos_out(AdcEoc),
      .ot_out(ot_out),
      .alarm_out(alarm_out),
      .vp_in(vp_in),
      .vn_in(vn_in)
      );

   //////////////////////////////////////////////////////
   //   register ADC output into a bank of FlipFlops   //
   //////////////////////////////////////////////////////

   reg [11:0] adc_data_reg = 12'hFFF ;

   always @(posedge AdcClk) begin

      if( AdcEoc )

         adc_data_reg[11:0] <= do_out[15:4] ;  // only 12-bits do_out[15:4] are meaningful
   end

   assign AdcData[11:0] = adc_data_reg[11:0] ;

endmodule
