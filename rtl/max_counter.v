//--------------------------------------------------------------------------------
// Module Name: max_counter
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7)
// Description: this module counts with a counter "currcount" the time needed
//              to sweep from the 0 degree position to the 180 degree one,
//              then it outputs the CNT_RU signal that in the FSM manages the
//              transition between hor_max and vert_sweep and vert_max to man
//              When the CNT_RU is high the FSM is in the max searching mode
//              so the PWM signal output which has a fixed duty cycle is given
//              for the same time during which the device sweeps from 0 to 180
//              degree
// 
// Dependencies:
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module max_counter(

   input wire CLK,

   // Reset for maximum signals
   input wire CNT_RST, // From voltage comparator

   // Max counter enable
   input wire MC,

   // Counter for limiting sweep right / up
   output reg CNT_RU
);


// Maximum count for horizontal movement (it sets the servos limits)
reg [21:0] currcount = 22'b0; // **TODO: value to be defined


always @(posedge CLK) begin

   if (CNT_RST == 1'b1) begin
      currcount <= 22'b0;
      CNT_RU <= 1'b0;
   end

   else if (CLK == 1'b1) begin

      if (MC == 1'b0) begin
         currcount <= currcount + 1;
         CNT_RU <= 1'b0;
      end

      else if (MC == 1'b1) begin
         currcount <= currcount - 1;

         if (currcount == 22'b0) begin
            CNT_RU <= 1'b0;
         end

         else begin
            CNT_RU <= 1'b1;
         end

      end

   end

end

endmodule
