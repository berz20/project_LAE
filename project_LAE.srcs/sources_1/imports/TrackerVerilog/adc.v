//--------------------------------------------------------------------------------
// Module Name: volt_vis - Behavioral
// Project Name: 
// Target Devices: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module adc(
   // input wire V_in,
   // input wire V_out,
   // input wire clk,
   // output wire d_rdy,
   // output wire [15:0] do_out
   input wire [15 : 0] di_in,
   input wire [6 : 0] daddr_in,
   input wire den_in,
   input wire dwe_in,
   output wire drdy_out,
   output wire [15 : 0] do_out,
   input wire dclk_in,
   input wire reset_in,
   input wire vp_in,
   input wire vn_in,
   output wire user_temp_alarm_out,
   output wire vccint_alarm_out,
   output wire vccaux_alarm_out,
   output wire ot_out,
   output wire [4 : 0] channel_out,
   output wire eoc_out,
   output wire alarm_out,
   output wire eos_out,
   output wire busy_out
   );



   // Data read from the register in the ADC which contains the voltage on channel 6 

   // port map synthesized from the IP catalog
   wire [6:0] ADC_addr;
   wire ADC_enable;

   assign ADC_addr = {3'b001,4'h6};
   xadc_wiz_0 ADC(
      .di_in(di_in),                              // input wire [15 : 0] di_in
      .daddr_in(daddr_in),                        // input wire [6 : 0] daddr_in
      .den_in(den_in),                            // input wire den_in
      .dwe_in(dwe_in),                            // input wire dwe_in
      .drdy_out(drdy_out),                        // output wire drdy_out
      .do_out(do_out),                            // output wire [15 : 0] do_out
      .dclk_in(dclk_in),                          // input wire dclk_in
      .reset_in(reset_in),                        // input wire reset_in
      .vp_in(vp_in),                              // input wire vp_in
      .vn_in(vn_in),                              // input wire vn_in
      .user_temp_alarm_out(user_temp_alarm_out),  // output wire user_temp_alarm_out
      .vccint_alarm_out(vccint_alarm_out),        // output wire vccint_alarm_out
      .vccaux_alarm_out(vccaux_alarm_out),        // output wire vccaux_alarm_out
      .ot_out(ot_out),                            // output wire ot_out
      .channel_out(channel_out),                  // output wire [4 : 0] channel_out
      .eoc_out(eoc_out),                          // output wire eoc_out
      .alarm_out(alarm_out),                      // output wire alarm_out
      .eos_out(eos_out),                          // output wire eos_out
      .busy_out(busy_out)                        // output wire busy_out
   );


endmodule
