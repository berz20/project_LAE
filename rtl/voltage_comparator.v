//--------------------------------------------------------------------------------
// Module Name: voltage_comparator
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7)
// Description: takes in two values of the same bit size and sends the greater
//              value to the register. This two value are from the register
//              and the ADC. If the value from the ADC is greater than the
//              value in the register, the comparator outputs a high signal
//              which causes the register to store the value that was in the
//              ADC. In this way is found the max voltage while sweeping
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module voltage_comparator(

   input wire CLK,
   
   input wire [7:0] PV, // pending value (ADC)
   input wire [7:0] LV, // last value (register)

   output reg GT // greater flag

);

always @(posedge CLK) begin

   if(PV[7:0] > LV[7:0]) begin
      GT <= 1'b1;
   end

   else begin
      GT <= 1'b0;
   end

end

endmodule
