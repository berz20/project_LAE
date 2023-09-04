`timescale 1 ns / 100 ps

module servo_driver(
   input wire CLK,
   input wire RST,
   input wire BTN_0, // enable signal which tell the servo which way to turn
   input wire BTN_1,
   input wire MC,
   input wire ES, //enable sweep (HS or VS)
   input wire [31:0] pulseWidth_max,
   output wire SERVO,
   output wire [31:0] servo_position,
   output reg general_enable,
   // output wire PWM_limit_cw,
   output reg [1:0] direction
);

// reg [1:0] direction;
wire inter_clk;
// reg pwm_enable = 1'b1;

always @(posedge CLK) begin
   if (RST == 1'b1) begin
      direction <= 2'b10;
   end
   else if(BTN_0 == 1'b0 && BTN_1 == 1'b0) begin
      direction <= 2'b00;   // stop
   end
   else if(BTN_0 == 1'b1 && BTN_1 == 1'b0) begin
      direction <= 2'b01;   // cw
   end
   else if(BTN_0 == 1'b0 && BTN_1 == 1'b1) begin
      direction <= 2'b10;   // ccw
   end
   else begin
      direction <= 2'b00;   // stop
   end
end

// always @(direction) begin
//    pwm_enable <= ~pwm_enable;
// end


always @(posedge CLK) begin
   if (servo_position < 2500 ) begin
      general_enable <= 1'b0;
   end
   else general_enable <= 1'b1;

   $display("PWM_limit = ", general_enable);
end

// function given from Catalog of servos

pwm_control pwm_control_0(
   .CLK(inter_clk),
   // .RST(RST),
   .DIR(direction),
   .EN(1'b1),
   .MC(MC),
   .ES(ES),
   .pulseWidth_max(pulseWidth_max),
   .pulseWidth(servo_position),
   // .PWM_limit_cw(PWM_limit_cw),
   .SERVO(SERVO));

// Tickcounter should decrease the clk frequency from 100 MHz to 1 Mhz in
// order to change the period of the clk that becomes 1us so the constants in
// the pwm_control are expressed in us due to the fact that the increase in
// the counter happens every rising edge of clk
TickCounterRst #(.MAX(100)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;

// this is a test tick counter to view more pwm pulses it only divides the clk
// by 2
// TickCounterRst #(.MAX(2)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;

// clk_div2 clk_div2_0(
//    .clk(CLK),
//    .sclk(inter_clk));


endmodule


// //--------------------------------------------------------------------------------
// // Module Name: servo_driver - Behavioral
// // Project Name: 
// // Target Devices: 
// // Description: two servo driver module (one for each motor) control the speed
// //              and direction of the servos which rotate the frame and solar panel.
// //              Take in an enable signal form the FSM and then send a PWM
// //              (pulse width modulation) signal to their respective servo
// //              which determines the direction and speed that the servos
// //              rotate. This determine the direction and the speed of the
// //              servos. 
// // 
// // Dependencies:
// // 
// // Additional Comments:
// // 
// //--------------------------------------------------------------------------------
// `timescale 1 ns / 100 ps
//
// module servo_driver(
//    input wire CLK,
//    input wire BTN_0, // enable signal which tell the servo which way to turn
//    input wire BTN_1,
//    output wire SERVO,
//    output wire [31:0] servo_position,
//    output reg general_enable,
//    output reg [1:0] direction
// );
//
// // reg [1:0] direction;
// wire inter_clk;
// reg pwm_enable = 1'b1;
//
// always @(BTN_0, BTN_1, CLK) begin
//    if(BTN_0 == 1'b0 && BTN_1 == 1'b0) begin
//       direction <= 2'b00;   // stop
//    end
//    else if(BTN_0 == 1'b1 && BTN_1 == 1'b0) begin
//       direction <= 2'b01;   // cw
//    end
//    else if(BTN_0 == 1'b0 && BTN_1 == 1'b1) begin
//       direction <= 2'b10;   // ccw
//    end
//    else begin
//       direction <= 2'b00;   // stop
//    end
// end
//
// always @(direction) begin
//    pwm_enable <= ~pwm_enable;
// end
//
//
// always @(CLK) begin
//    if (servo_position < 2500 ) begin
//       general_enable <= 1'b1;
//    end
//    else general_enable <= 1'b0;
//
//    $display("PWM_limit = ", general_enable);
// end
//
// // function given from Catalog of servos
//
// pwm_control pwm_control_0(
//    .CLK(CLK),
//    .DIR(direction),
//    .EN(pwm_enable),
//    .pulseWidth(servo_position),
//    .SERVO(SERVO));
//
// // Tickcounter should decrease the clk frequency from 100 MHz to 1 Mhz in
// // order to change the period of the clk that becomes 1us so the constants in
// // the pwm_control are expressed in us due to the fact that the increase in
// // the counter happens every rising edge of clk
// // TickCounterRst #(.MAX(50)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;
//
// // this is a test tick counter to view more pwm pulses it only divides the clk
// // by 2
// // TickCounterRst #(.MAX(2)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;
//
// clk_div2 clk_div2_0(
//    .clk(CLK),
//    .sclk(inter_clk));
//
//
// endmodule

// //--------------------------------------------------------------------------------
// // Module Name: servo_driver - Behavioral
// // Project Name: 
// // Target Devices: 
// // Description: two servo driver module (one for each motor) control the speed
// //              and direction of the servos which rotate the frame and solar panel.
// //              Take in an enable signal form the FSM and then send a PWM
// //              (pulse width modulation) signal to their respective servo
// //              which determines the direction and speed that the servos
// //              rotate. This determine the direction and the speed of the
// //              servos. 
// // 
// // Dependencies:
// // 
// // Additional Comments:
// // 
// //--------------------------------------------------------------------------------
// `timescale 1 ns / 100 ps
//
// module servo_driver(
//    input wire CLK,
//    input wire BTN_0, // enable signal which tell the servo which way to turn
//    input wire BTN_1,
//    output wire SERVO,
//    output reg [1:0] direction
// );
//
// // reg [1:0] direction;
// wire inter_clk;
//
// always @(BTN_0, BTN_1, CLK) begin
//    if(BTN_0 == 1'b0 && BTN_1 == 1'b0) begin
//       direction <= 2'b00;   // stop
//    end
//    else if(BTN_0 == 1'b1 && BTN_1 == 1'b0) begin
//       direction <= 2'b01;   // cw
//    end
//    else if(BTN_0 == 1'b0 && BTN_1 == 1'b1) begin
//       direction <= 2'b10;   // ccw
//    end
//    else begin
//       direction <= 2'b00;   // stop
//    end
// end
//
// // function given from Catalog of servos
//
// pwm_control pwm_control_0(
//    .CLK(inter_clk),
//    .DIR(direction),
//    .EN(1'b1),
//    .SERVO(SERVO));
//
// // Tickcounter should decrease the clk frequency from 100 MHz to 1 Mhz in
// // order to change the period of the clk that becomes 1us so the constants in
// // the pwm_control are expressed in us due to the fact that the increase in
// // the counter happens every rising edge of clk
// // TickCounterRst #(.MAX(50)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;
//
// // this is a test tick counter to view more pwm pulses it only divides the clk
// // by 2
// // TickCounterRst #(.MAX(2)) AdcSocGen (.clk(CLK), .rst(1'b0), .tick(inter_clk)) ;
//
// clk_div2 clk_div2_0(
//    .clk(CLK),
//    .sclk(inter_clk));
//
//
// endmodule
