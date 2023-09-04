module vert_counter(
   input wire CLK,
   input wire VS,         // vertical sweep enable
   input wire PWM_limit,  // vertical sweep enable FSM defined
   output reg CNT_D       // counter down enable
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

// module vert_counter(
//    input wire CLK,
//    input wire VS, // horizontal sweep enable FSM defined
//    input wire PWM_limit, // horizontal sweep enable FSM defined
//    output reg CNT_D // counter left enable
// );
//
// // Maximum count for horizontal movement (it sets the servos limits)
// //reg [12:0] currcount = 13'b0_000_000_000_000; // **TODO: value to be defined
//
// // Reduced count to view all the calibration steps in a reasonable simulation
// // time
// // reg [8:0] currcount = 9'b000_000_000; // **TODO: value to be defined
//
// always @(posedge CLK, posedge VS) begin : P1
//
//    if(VS == 1'b1 & PWM_limit == 1'b1) begin
//          CNT_D <= 1'b1;
//    end
//    else begin
//       //currcount <= 13'b0_000_000_000_000;
//       CNT_D <= 1'b0;
//    end
// end
//
//
// endmodule

// //-------------------------------------------------------------------------------- Module Name: max_counter - Behavioral
// // Project Name: 
// // Target Devices: 
// // Description: 
// // 
// // Dependencies: 
// // 
// // Additional Comments:
// // 
// //--------------------------------------------------------------------------------
//
// module vert_counter(
//    input wire CLK,
//    input wire VS, // vertical sweep enable
//    output reg CNT_D // counter down enable
// );
//
// // Maximum count for horizontal movement (it sets the servos limits)
// // reg [11:0] currcount = 12'b000_000_000_000; // **TODO: value to be defined
//
// // Reduced count to view all the calibration steps in a reasonable simulation
// // time
// reg [8:0] currcount = 9'b000_000_000; // **TODO: value to be defined
//
// always @(posedge CLK, posedge VS) begin : P1
//
//    if(VS == 1'b1) begin
//       currcount <= currcount + 1;
//       // if(currcount == 12'b111_111_111_111) begin
//       if(currcount == 9'b111_111_111) begin
//          CNT_D <= 1'b0;
//       end
//       else begin
//          CNT_D <= 1'b1;
//       end
//    end
//    else if(VS == 1'b0) begin
//       // currcount <= 12'b000_000_000_000;
//       currcount <= 9'b000_000_000;
//       CNT_D <= 1'b0;
//    end
// end
//
//
// endmodule
