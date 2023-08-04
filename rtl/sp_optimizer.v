//--------------------------------------------------------------------------------
// Module Name: sp_optimizer - Behavioral
// Project Name: 
// Target Devices: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------
`timescale 1 us / 100 ps

module sp_optimizer(
input wire BTN_L,
input wire BTN_R,
input wire BTN_U,
input wire BTN_D,
input wire BTN_C,
input wire CLK,
input wire [9:0] V_in,
output wire [9:0] max_V_in,
// input wire V_out,
// output wire [3:0] DISP_EN,
// output wire [7:0] SSD,
output reg [1:0] direction_lr,
output reg [1:0] direction_ud,
output wire servo_l,
output wire servo_r,
output wire servo_u,
output wire servo_d,
output wire SERVO_H,
output wire SERVO_V,
output reg [2:0] STAT
);

wire hs; wire vs; wire mc; // define horizontal sweep, vertical sweep and max counter enable signals
wire cnt_l; wire cnt_ru; wire cnt_d; // define counter left and right enable signals
wire [9:0] max_volt = 10'b0000000000; wire [9:0] volt = 10'b0000000000; // wire which contain max voltage e voltage readed form adc
// wire servo_l; wire servo_r; wire servo_u; wire servo_d; // define servo left right up and down signals
wire reset;
wire div_clk;
wire cnt_rst;


// Instantiation of finite state machine 
FSM fsm0(
   .BTN_L(BTN_L),
   .BTN_R(BTN_R),
   .BTN_U(BTN_U),
   .BTN_D(BTN_D),
   .BTN_C(BTN_C),
   .CNT_L(cnt_l),
   .CNT_RU(cnt_ru),
   .CNT_D(cnt_d),
   .CLK(div_clk),
   .HS(hs),
   .VS(vs),
   .MC(mc),
   .SERVO_L(servo_l),
   .SERVO_R(servo_r),
   .SERVO_U(servo_u),
   .SERVO_D(servo_d),
   .STAT(STAT),
   .CNT_RST(cnt_rst));

// Instantiation o the two servo drivers which control the servos by pwm_control and
// a clk divider
servo_driver servo_driver0(
   .CLK(CLK),
   .BTN_0(servo_l),
   .BTN_1(servo_r),
   .direction(direction_lr),
   .SERVO(SERVO_H));

servo_driver servo_driver1(
   .CLK(CLK),
   .BTN_0(servo_u),
   .BTN_1(servo_d),
   .direction(direction_ud),
   .SERVO(SERVO_V));

// Voltage visualizer which outputs current voltage on the seven segment
// display
// volt_vis volt_vis0(
//    .CLK(CLK),
//    .V_in(V_in),
//    .V_out(V_out),
//    .V_value(volt),
//    .DISP_EN(DISP_EN),
//    .SSD(SSD));

// Compare current voltage with the one stored in the register
voltage_comparator voltage_comparator0(
   .PV(V_in),
   .LV(max_V_in),
   .GT(reset));

clk_div cd0(
   .clk(CLK),
   .sclk(div_clk));

// Counter which counts the number of steps taken from the max voltage 
max_counter max_counter0(
   .CLK(div_clk),
   .CNT_RST(cnt_rst),
   .RESET(reset),
   .MC(mc),
   .CNT_RU(cnt_ru));

// Counter to limit the horizontal range of movement of servos
horiz_counter horiz_counter0(
   .CLK(div_clk),
   .HS(hs),
   .CNT_L(cnt_l));

// Counter to limit the vertical range of movement of servos
vert_counter vert_counter0(
   .CLK(div_clk),
   .VS(vs),
   .CNT_D(cnt_d));

// Flip Flop array which register the max voltage
FF_Array FF_Array0(
   .CLK(CLK),
   .GT(reset),
   .PV(V_in),
   .LV(max_V_in));


endmodule
