//--------------------------------------------------------------------------------
// Module Name: vert_counter
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7)
// Description: this module outputs the CNT_L which controls the transition
//              between the vert_sweep and vert_max. This signal is setted
//              high every time the PWM_limit, which is a signal that is high
//              when the position of the servo is 180 degrees, is low and the
//              currcount is not yet arrived to 31, this additional condition
//              only prevents the CNT_L signal to become zero too early and
//              permits the servos to move in the right direction even if some
//              glitches happen to PWM_limit
//
// Dependencies:
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module vert_counter(

   input wire CLK,

   // Enable vertical sweep signal
   input wire VS,


   // Signal to limit the sweep for servos
   input wire PWM_limit,


   // Counter for limiting down sweep 
   output reg CNT_D

);


reg [4:0] currcount = 5'b00_000;


always @(posedge CLK) begin

   if (VS == 1'b1) begin

      if (PWM_limit == 1'b0 | currcount != 5'b11_111) begin
         CNT_D <= 1'b1;
         currcount <= currcount + 1;
      end

      else begin
         currcount <= 5'b00_000;
         CNT_D <= 1'b0;
      end

   end

   else begin
      currcount <= 5'b00_000;
      CNT_D <= 1'b0;
   end

end

endmodule
