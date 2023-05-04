//--------------------------------------------------------------------------------
// Module Name: max_counter - Behavioral
// Project Name: 
// Target Devices: 
// Description: Counter that incremetns throughout the whole time the system
//              is calibrating. The counter increments by one every time it
//              goes through the rising edge od the clock signal. whenever
//              a new max value is detected by the comparator, it sends
//              a reset signal to the max counter. In that case the current
//              count that the max counter has restarts back to zero and
//              continues to increment until the horizontal or veritcal
//              counter reaches the end off its sweep cycle. When e the
//              increment is finished its control signal causes the max
//              counter to starts decrementing and during the decrement is
//              sent a control signal to the FSM which moves th eservo back to
//              the direction of the max voltage
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module max_counter(
   input wire CLK,
   input wire FSM_RST,
   input wire RESET,
   input wire MC,
   output reg CNT_RU
);

reg [12:0] currcount = 13'b0_000_000_000_000;

always @(posedge CLK, posedge FSM_RST, posedge RESET, posedge MC) begin : P1

   if(RESET == 1'b1 || FSM_RST == 1'b1) begin
      currcount <= 13'b0_000_000_000_000;
      CNT_RU <= 1'b0;
   end else begin
      if(MC == 1'b0) begin
         currcount <= currcount + 1;
         CNT_RU <= 1'b0;
      end
      else if(MC == 1'b1) begin
         currcount <= currcount - 1;
         if(currcount == 13'b0_000_000_000_000) begin
            CNT_RU <= 1'b0;
         end
         else begin
            CNT_RU <= 1'b1;
         end
      end
   end
end


endmodule
