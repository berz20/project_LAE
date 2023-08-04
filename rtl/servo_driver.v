//--------------------------------------------------------------------------------
// Module Name: servo_driver - Behavioral
// Project Name: 
// Target Devices: 
// Description: two servo driver module (one for each motor) control the speed
//              and direction of the servos which rotate the frame and solar panel.
//              Take in an enable signal form the FSM and then send a PWM
//              (pulse width modulation) signal to their respective servo
//              which determines the direction and speed that the servos
//              rotate. This determine the direction and the speed of the
//              servos. 
// 
// Dependencies:
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------
`timescale 1 us / 100 ps

module servo_driver(
   input wire CLK,
   input wire BTN_0, // enable signal which tell the servo which way to turn
   input wire BTN_1,
   output wire SERVO,
   output reg [1:0] direction
);

// reg [1:0] direction;
wire inter_clk;

always @(BTN_0, BTN_1, CLK) begin
   if(BTN_0 == 1'b0 && BTN_1 == 1'b0) begin
      direction <= 2'b00;
   end
   else if(BTN_0 == 1'b1 && BTN_1 == 1'b0) begin
      direction <= 2'b01;
   end
   else if(BTN_0 == 1'b0 && BTN_1 == 1'b1) begin
      direction <= 2'b10;
   end
   else begin
      direction <= 2'b00;
   end
end

// function given from Catalog of servos

pwm_control pwm_control_0(
   .CLK(CLK),
   .DIR(direction),
   .EN(1'b1),
   .SERVO(SERVO));

clk_div2 clk_div2_0(
   .clk(CLK),
   .sclk(inter_clk));


endmodule
