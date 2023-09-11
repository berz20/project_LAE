//--------------------------------------------------------------------------------
// Module Name: FF_Array
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7)
// Description:  Register (storage current max voltage)
//               this value is then sent to the module called
//               voltage_comparator where is compared with all
//               the raw values that come from the ADC
//
// Dependencies:
//
// Additional Comments:
//
//--------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module FF_Array(

   input wire CLK,
   input wire RST,

   // Reset for maximum signals
   input wire GT, // From voltage comparator
      
   // Max PWM logic high time
   input wire [31:0] pulseWidth_H,
   input wire [31:0] pulseWidth_V,

   // Current PWM logic high time
   input wire [11:0] PV, // pendig value

   // Max ADC digital output registered in the array of FF
   output reg [11:0] LV, // last value

   // Max PWM logic high time
   output reg [31:0] pulseWidth_max_H,
   output reg [31:0] pulseWidth_max_V

);


always @(posedge CLK) begin

   // When RST is high the position of servos is set to 0 degrees 
   // and the max voltage value to zero
   if (RST == 1'b1) begin
         LV <= 12'b000000000000;
         pulseWidth_max_H <= 32'd5000;
         pulseWidth_max_V <= 32'd5000;

   end 

   else begin

      if(GT == 1'b1) begin
         // if enable is set to high to LV is set to PV otherwise it keeps is value 
         // Updates the voltage values
         LV <= PV;

         // Updates the "position" values
         pulseWidth_max_V <= pulseWidth_V;
         pulseWidth_max_H <= pulseWidth_H;
      end

   end

end

endmodule
