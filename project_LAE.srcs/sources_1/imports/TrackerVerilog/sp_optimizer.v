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
input wire V_in,
input wire V_out,
output wire [3:0] DISP_EN,
output wire [7:0] SSD,
output wire SERVO_H,
output wire SERVO_V,
output wire [4:0] STAT
);




wire hs; wire vs; wire mc;
wire cnt_l; wire cnt_ru; wire cnt_d;
wire [9:0] max_volt = 10'b0000000000; wire [9:0] volt = 10'b0000000000;
wire servo_l; wire servo_r; wire servo_u; wire servo_d;
wire reset;
wire div_clk;
wire cnt_rst;

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

  servo_driver servo_driver0(
      .CLK(CLK),
    .BTN_0(servo_l),
    .BTN_1(servo_r),
    .SERVO(SERVO_H));

  servo_driver servo_driver1(
      .CLK(CLK),
    .BTN_0(servo_u),
    .BTN_1(servo_d),
    .SERVO(SERVO_V));

  volt_vis volt_vis0(
      .CLK(CLK),
    .V_in(V_in),
    .V_out(V_out),
    .V_value(volt),
    .DISP_EN(DISP_EN),
    .SSD(SSD));

  voltage_comparator voltage_comparator0(
      .PV(volt),
    .LV(max_volt),
    .GT(reset));

  clk_div cd0(
      .clk(CLK),
    .sclk(div_clk));

  max_counter max_counter0(
      .CLK(div_clk),
    .FSM_RST(cnt_rst),
    .RESET(reset),
    .MC(mc),
    .CNT_RU(cnt_ru));

  horiz_counter horiz_counter0(
      .CLK(div_clk),
    .HS(hs),
    .CNT_L(cnt_l));

  vert_counter vert_counter0(
      .CLK(div_clk),
    .VS(vs),
    .CNT_D(cnt_d));

  FF_Array FF_Array0(
      .CLK(CLK),
    .EN(reset),
    .A(volt),
    .LV(max_volt));


endmodule
