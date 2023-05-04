//--------------------------------------------------------------------------------
// Module Name: FF_Array - Behavioral
// Project Name: 
// Target Devices: 
// Description:  Register (storage current max voltage)
//               this value is then sent tothe module called Comparator
//               where is compared with all the raw values that come from 
//               the ADC
// 
// Dependencies: 
// 
// Additional Comments: is created behaviorally so that you may use various amounts of bits without changing much of code 
// 
//--------------------------------------------------------------------------------

module FF_Array(
   input wire CLK,
   input wire EN, // enable signal
   input wire [9:0] A,
   output reg [9:0] LV // last value (lenght of bits stored defualt to 10 least significant bit of ADC are not considered as they define the minimum threshold for differnce of potential)
);

reg [9:0] inter = 10'b0000000000;

always @(posedge CLK, posedge A, posedge EN) begin
   if(EN == 1'b1) begin
      LV <= A; // if enable is set to high to LV is set to A otherwise it keeps is value 
      inter <= A;
   end
   else begin
      LV <= inter;
   end
end


endmodule
