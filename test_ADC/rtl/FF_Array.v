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
   input wire [31:0] pulseWidth_H,
   input wire [31:0] pulseWidth_V,
   input wire EN_H,
   input wire EN_V,
   input wire [11:0] PV, // pendig value
   output reg [31:0] pulseWidth_max,
   output reg [11:0] LV // last value (lenght of bits stored defualt to 10 least significant bit of ADC are not considered as they define the minimum threshold for differnce of potential)
);

reg [11:0] inter = 12'b000000000000;
reg [31:0] inter_pulse = 32'b0;

always @(posedge CLK,GT,PV) begin
   pulseWidth_max <= 32'b0;
      if(GT == 1'b1) begin
         LV <= PV; // if enable is set to high to LV is set to PV otherwise it keeps is value 
         inter <= PV;
         if (EN_V) begin
            pulseWidth_max <= pulseWidth_V;
            inter_pulse <= pulseWidth_V;
         end 
         else if (EN_H) begin
            pulseWidth_max <= pulseWidth_H;
            inter_pulse <= pulseWidth_H;
         end
         // pulseWidth_max <= pulseWidth;
         // inter_pulse <= pulseWidth;
      end
      else begin
         LV <= inter;
         pulseWidth_max <= inter_pulse;

      end
   end


endmodule
