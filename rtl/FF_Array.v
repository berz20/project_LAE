//--------------------------------------------------------------------------------
// Module Name: FF_PVrray - Behavioral
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
   input wire GT, // enable signal 
   input wire [11:0] PV, // pendig value
   output reg [11:0] LV // last value (lenght of bits stored defualt to 10 least significant bit of ADC are not considered as they define the minimum threshold for differnce of potential)
);

reg [11:0] inter = 12'b000000000000;

always @(posedge CLK, posedge PV, posedge GT) begin
   if(GT == 1'b1) begin
      LV <= PV; // if enable is set to high to LV is set to PV otherwise it keeps is value 
      inter <= PV;
   end
   else begin
      LV <= inter;
   end
end


endmodule
