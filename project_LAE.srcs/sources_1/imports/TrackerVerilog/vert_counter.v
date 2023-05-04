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
   input wire VS,
   output reg CNT_D
);

reg [11:0] currcount = 12'b000000000000;

always @(posedge CLK, posedge VS) begin : P1

   if(VS == 1'b1) begin
      currcount <= currcount + 1;
      if(currcount == 12'b111111111111) begin
         CNT_D <= 1'b0;
      end
      else begin
         CNT_D <= 1'b1;
      end
   end
   else if(VS == 1'b0) begin
      currcount <= 12'b000000000000;
      CNT_D <= 1'b0;
   end
end


endmodule
