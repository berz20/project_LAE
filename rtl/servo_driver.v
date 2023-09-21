//--------------------------------------------------------------------------------

// Module Name: servo_driver
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7) 
// Description: Module that interfaces the pwm_control to the specified servo
// motor
//
// Dependencies: - TickCounter.v
//               _ pwm_control.v
//
// Additional Comments:
//
//--------------------------------------------------------------------------------

//define the mode of operation
// `define TEST_MODE
`define FPGA_MODE

`timescale 1 ns / 100 ps

module servo_driver(

   input wire CLK,
   input wire RST,

   // enable signal which tell the servo which way to turn
   input wire BTN_0,
   input wire BTN_1,

   // Enable sweep signals
   input wire MC, // Max counter
   input wire ES, // Enable sweep (HS or VS)
   // Max PWM logic high time horizontal or vertical
   input wire [31:0] pulseWidth_max,

   // PWM signal
   output wire SERVO,

   // Current PWM logic high time
   output wire [31:0] servo_position,

   // Signal to limit the sweep for servos
   output reg PWM_limit,

   // Direction sweep signal
   output reg [1:0] direction // (2'b00: stop, 2'b01: CounterClockWise, 2'b10: ClockWise)
);

// Internal clk reduced from the PLL clk (100 MHz) to 1 MHz
// wire inter_clk;


always @(posedge CLK) begin

   if(BTN_0 == 1'b0 && BTN_1 == 1'b0) begin
      direction <= 2'b00;   // stop
   end

   else if(BTN_0 == 1'b1 && BTN_1 == 1'b0) begin
      direction <= 2'b01;   // ccw
   end

   else if(BTN_0 == 1'b0 && BTN_1 == 1'b1) begin
      direction <= 2'b10;   // cw
   end

   else begin
      direction <= 2'b00;   // stop
   end

end

`ifdef TEST_MODE

always @(posedge CLK) begin
   if (servo_position < 7000 ) begin
      PWM_limit <= 1'b0;
   end
   else PWM_limit <= 1'b1;

   $display("PWM_limit 700 = ", PWM_limit);
end

// this is a test tick counter to view more pwm pulses, it only divides the clk
// by 2
// TickCounterRst #(.MAX(2)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;

`endif

`ifdef FPGA_MODE

always @(posedge CLK) begin
   if (servo_position < 25000 ) begin
      PWM_limit <= 1'b0;
   end
   else PWM_limit <= 1'b1;

   $display("PWM_limit = ", PWM_limit);
end

// Tickcounter should decrease the clk frequency from 100 MHz to 1 Mhz in
// order to change the period of the clk that becomes 1 us so the constants in
// the pwm_control are expressed in us due to the fact that the increase in
// the counter happens every rising edge of clk
// TickCounterRst #(.MAX(100)) PWM_clock (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;

`endif

pwm_control pwm_control_0(
   .CLK(CLK),
   .RST(RST),
   .DIR(direction),
   .EN(1'b1),
   .MC(MC),
   .ES(ES),
   .pulseWidth_max(pulseWidth_max),
   .pulseWidth(servo_position),
   .SERVO(SERVO)
);


endmodule
