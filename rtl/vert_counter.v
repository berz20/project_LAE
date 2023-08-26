//--------------------------------------------------------------------------------
// Module Name: max_counter - Behavioral
// Project Name: 
// Target Devices: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module vert_counter(
   input wire CLK,
   input wire VS, // vertical sweep enable 
   output reg CNT_D // counter down enable
);

// Maximum count for horizontal movement (it sets the servos limits)
// reg [11:0] currcount = 12'b000_000_000_000; // **TODO: value to be defined

// Reduced count to view all the calibration steps in a reasonable simulation
// time 
reg [8:0] currcount = 9'b000_000_000; // **TODO: value to be defined

always @(posedge CLK, posedge VS) begin : P1

   if(VS == 1'b1) begin
      currcount <= currcount + 1;
      // if(currcount == 12'b111_111_111_111) begin
      if(currcount == 9'b111_111_111) begin
         CNT_D <= 1'b0;
      end
      else begin
         CNT_D <= 1'b1;
      end
   end
   else if(VS == 1'b0) begin
      // currcount <= 12'b000_000_000_000;
      currcount <= 9'b000_000_000;
      CNT_D <= 1'b0;
   end
end


endmodule
