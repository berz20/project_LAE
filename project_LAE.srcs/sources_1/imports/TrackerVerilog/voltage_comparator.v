//--------------------------------------------------------------------------------
// Module Name: voltage_comparator - Behavioral
// Project Name: 
// Target Devices: 
// Description: takes in two values of the same bit size and sends the greater
//              value to the register. This two value are from the register
//              and the ADC. If the value form the ADC is greater than the
//              value in the register, the comparator outputs a high signal
//              which causes the register to store the value that was in the
//              ADC. In this way is found the max voltage while sweeping
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module voltage_comparator(
   input wire [9:0] PV, // pending value (ADC)
   input wire [9:0] LV, // last value (register)
   output reg GT // greater flag
);

always @(PV, LV) begin
   if(PV[9:4] > LV[9:4]) begin
      GT <= 1'b1;
   end
   else begin
      GT <= 1'b0;
   end
end


endmodule
