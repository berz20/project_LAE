//--------------------------------------------------------------------------------
// Module Name: max_counter - Behavioral
// Project Name: 
// Target Devices: 
// Description:  counts up to a predefinite value that has been specified and
//               then send a signal to the FSM which then dfeactivated the 
//               current counter and activates the next one. This next counter
//               which is activated each time after the horizontal counter and
//               vertical coutner finish incrementing and reach their value 
//               (max counter)
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module horiz_counter(
   input wire CLK,
   input wire HS, // horizontal sweep enable FSM defined
   output reg CNT_L // counter left enable
);

reg [12:0] currcount = 13'b0_000_000_000_000; // **TODO: value to be defined

always @(posedge CLK, posedge HS) begin : P1

   if(HS == 1'b1) begin
      currcount <= currcount + 1;
      if(currcount == 13'b1_111_111_111_111) begin
         CNT_L <= 1'b0;
      end
      else begin
         CNT_L <= 1'b1;
      end
   end
   else if(HS == 1'b0) begin
      currcount <= 13'b0_000_000_000_000;
      CNT_L <= 1'b0;
   end
end


endmodule
