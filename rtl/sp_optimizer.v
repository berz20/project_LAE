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
`timescale 1 ns / 100 ps

module sp_optimizer(
input wire BTN_L,
input wire BTN_R,
input wire BTN_U,
input wire BTN_D,
input wire BTN_C,
input wire CLK,
input wire RST,
input wire DBG,
input wire ANG,
input wire vauxp,
input wire vauxn,
// // input wire vp_in,
output wire [11:0] V_in,
output wire RS,
output wire EN_OUT,
output wire [7:0] data_LCD,
// output wire [11:0] max_V_in,
// output wire [31:0] pulseWidth_max_H,
// output wire [31:0] pulseWidth_max_V,
// // output wire PWM_limit_cw_H,
// // output wire PWM_limit_cw_V,
// output wire HS,
// output wire VS,
// output wire MC,
// output wire cnt_l,
// output wire cnt_d,
// output wire cnt_ru,
// // input wire V_out,
// // output wire [3:0] DISP_EN,
// // output wire [7:0] SSD,
// output wire [1:0] direction_lr,
// output wire [1:0] direction_ud,
output wire servo_l,
output wire servo_r,
output wire servo_u,
output wire servo_d,
output wire SERVO_H,
output wire SERVO_V
// output wire [31:0] servo_position_H,
// output wire [31:0] servo_position_V,
// output wire general_enable_H,
// output wire general_enable_V,
// output wire div_clk,
// //output wire [31:0] PWM_H,
// //output wire [31:0] PWM_V,
// output wire [2:0] STAT
);

wire debounced_btn_L, debounced_btn_R, debounced_btn_U, debounced_btn_D, debounced_btn_C;
wire [31:0] servo_position_H;
wire [31:0] servo_position_V;
wire [31:0] pulseWidth_max_H;
wire [31:0] pulseWidth_max_V;
wire general_enable_H;
wire general_enable_V;
wire HS; wire VS;
wire MC; // define horizontal sweep, vertical sweep and max counter enable signals
wire cnt_l; wire cnt_d; // define counter left and right enable signals
wire cnt_ru;
wire [9:0] max_volt = 10'b0000000000; wire [9:0] volt = 10'b0000000000; // wire which contain max voltage e voltage readed form adc
// wire servo_l; wire servo_r; wire servo_u; wire servo_d; // define servo left right up and down signals
wire reset;
wire div_clk;
wire cnt_rst;

wire pll_clk, pll_locked ;

PLL  PLL_inst ( .CLK_IN(CLK), .CLK_OUT(pll_clk), .LOCKED(pll_locked) ) ;

///////////////////////////
//   ADC SOC generator   //
///////////////////////////

// assert a single clock-pulse "SOC" once every 0.1 seconds

wire adc_soc ;

// TickCounterRst #(.MAX(2200)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(adc_soc)) ;
// TickCounterRst #(.MAX(2200)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(div_clk)) ;


////////////////////////////////////////////////////////////
//    XADC configured to read on-die temperature sensor   //
////////////////////////////////////////////////////////////

wire adc_eoc ;
// wire vp_in, vn_in ;

// wire [11:0] V_in;
wire [11:0] max_V_in;
wire [2:0] STAT;
wire [1:0] direction_lr;
wire [1:0] direction_ud;
// wire [11:0] adc_data ;
// wire [15:0] do_out ;

// assign adc_data = 12'hABC ;    // **DEBUG

  wire EOC_TB;
  wire EOS_TB;

  reg [6:0] DADDR_TB;
  reg DEN_TB;
  reg DWE_TB;
  reg [15:0] DI_TB;
  wire [15:0] DO_TB;
  wire DRDY_TB;
  reg RESET_TB;
  wire [2:0] ALM_unused;
  wire ALARM_OUT_TB;
  wire FLOAT_VCCAUX_ALARM;
  wire FLOAT_VCCINT_ALARM;
  wire FLOAT_USER_TEMP_ALARM;
  wire BUSY_TB;
  wire [4:0] CHANNEL_TB;

  xadc xadc_inst (
     .daddr_in(7'h10),
     .dclk_in(pll_clk),
     .den_in(EOC_TB),
     .di_in(16'b0),
     .dwe_in(1'b0),
     .adc_out(V_in[11:0]),
     .drdy_out(DRDY_TB),
     .reset_in(RESET_TB),
     .vauxp0(vauxp),      // Stimulus for Channels is applied from the SIM_MONITOR_FILE
     .vauxn0(vauxn),
     .busy_out(BUSY_TB),
     .channel_out(CHANNEL_TB[4:0]),
     .eoc_out(EOC_TB),
     .eos_out(EOS_TB),
     .alarm_out(ALARM_OUT_TB),
     .vp_in(1'b0),
     .vn_in(1'b0)

         );
// XADC  XADC (
//
//    .AdcClk    (        pll_clk ),
//    .AdcSoc    (        div_clk ),
//    .AdcEoc    (        adc_eoc ),
//    .AdcData   (     adc_data[11:0] )
//
// ) ;


// Debouncers 
Debouncer debouncer_L (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_L), // Segnale del pulsante sinistro
   .debounced_btn(debounced_btn_L) // Segnale del pulsante sinistro debounchato
);

Debouncer debouncer_R (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_R), // Segnale del pulsante destro
   .debounced_btn(debounced_btn_R) // Segnale del pulsante destro debounchato
);

Debouncer debouncer_U (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_U), // Segnale del pulsante su
   .debounced_btn(debounced_btn_U) // Segnale del pulsante su debounchato
);


Debouncer debouncer_D (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_D), // Segnale del pulsante giù
   .debounced_btn(debounced_btn_D) // Segnale del pulsante giù debounchato
);

Debouncer debouncer_C (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_C), // Segnale del pulsante centrale
   .debounced_btn(debounced_btn_C) // Segnale del pulsante centrale debounchato
);

// Instantiation of finite state machine
FSM fsm0(
   .BTN_L(debounced_btn_L),
   .BTN_R(debounced_btn_R),
   .BTN_U(debounced_btn_U),
   .BTN_D(debounced_btn_D),
   .BTN_C(debounced_btn_C),
   .CNT_L(cnt_l),
   .CNT_RU(cnt_ru),
   .CNT_D(cnt_d),
   .CLK(div_clk),
   .RST(RST),
   .HS(HS),
   .VS(VS),
   .MC(MC),
   .SERVO_L(servo_l),
   .SERVO_R(servo_r),
   .SERVO_U(servo_u),
   .SERVO_D(servo_d),
   .STAT(STAT),
   .CNT_RST(cnt_rst));

// Instantiation o the two servo drivers which control the servos by pwm_control and
// a clk divider
servo_driver servo_driver0(
   .CLK(pll_clk),
   .RST(RST),
   .BTN_0(servo_l),
   .BTN_1(servo_r),
   .MC(MC),
   .ES(HS),
   .pulseWidth_max(pulseWidth_max_H),
   .direction(direction_lr),
   .servo_position(servo_position_H),
   .general_enable(general_enable_H),
   // .PWM_limit_cw(PWM_limit_cw_H),
   .SERVO(SERVO_H));

servo_driver servo_driver1(
   .CLK(pll_clk),
   .RST(RST),
   .BTN_0(servo_d),
   .BTN_1(servo_u),
   .MC(MC),
   .ES(VS),
   .pulseWidth_max(pulseWidth_max_V),
   .direction(direction_ud),
   .servo_position(servo_position_V),
   .general_enable(general_enable_V),
   // .PWM_limit_cw(PWM_limit_cw_V),
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
   .CLK(div_clk),
   .PV(V_in),
   .LV(max_V_in),
   .GT(reset));

// clk_div cd0(
//    .clk(pll_clk),
//    .sclk(div_clk));

// TIckcounter faster than the actual in orded to reduce the time to switch
// the sweeping steps
TickCounterRst #(.MAX(2150)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(div_clk)) ;

// Counter which counts the number of steps taken from the max voltage
max_counter max_counter0(
   .CLK(div_clk),
   .CNT_RST(cnt_rst),
   .RESET(reset),
   // .PWM_limit_cw_H(PWM_limit_cw_H),
   // .PWM_limit_cw_V(PWM_limit_cw_V),
   .MC(MC),
   .CNT_RU(cnt_ru));

// Counter to limit the horizontal range of movement of servos
horiz_counter horiz_counter0(
   .CLK(div_clk),
   .HS(HS),
   .PWM_limit(general_enable_H),
   .CNT_L(cnt_l));

// Counter to limit the vertical range of movement of servos
vert_counter vert_counter0(
   .CLK(div_clk),
   .VS(VS),
   .PWM_limit(general_enable_V),
   .CNT_D(cnt_d));

// Flip Flop array which register the max voltage
FF_Array FF_Array0(
   .CLK(div_clk),
   .RST(RST),
   .GT(reset),
   .pulseWidth_H(servo_position_H),
   .pulseWidth_V(servo_position_V),
   // .EN_H(servo_r),
   // .EN_V(servo_u),
   .PV(V_in),
   .pulseWidth_max_H(pulseWidth_max_H),
   .pulseWidth_max_V(pulseWidth_max_V),
   .LV(max_V_in));

LCD LCD_disp (
   .CLK(div_clk),
   .DBG(DBG),
   .ANG(ANG),
   // .EN(1'b1),
   .V_in(V_in[11:0]),
   .max_V_in(max_V_in[11:0]),
   .pulseWidth_H(servo_position_H),
   .pulseWidth_V(servo_position_V),
   .pulseWidth_max_H(pulseWidth_max_H),
   .pulseWidth_max_V(pulseWidth_max_V),
   .HS(HS),
   .VS(VS),
   .MC(MC),
   .RS(RS),
   // .RW(RW),
   .EN_OUT(EN_OUT),
   .data(data_LCD[7:0]));

endmodule





// //--------------------------------------------------------------------------------
// // Module Name: sp_optimizer - Behavioral
// // Project Name:
// // Target Devices:
// // Description:
// //
// // Dependencies:
// //
// // Additional Comments:
// //
// //--------------------------------------------------------------------------------
// `timescale 1 ns / 100 ps
//
// module sp_optimizer(
// input wire BTN_L,
// input wire BTN_R,
// input wire BTN_U,
// input wire BTN_D,
// input wire BTN_C,
// input wire CLK,
// input wire RST,
// // input wire vp_in,
// output wire [11:0] V_in,
// output wire RS,
// output wire EN_OUT,
// output wire [7:0] data_LCD,
// output wire [11:0] max_V_in,
// output wire [31:0] pulseWidth_max_H,
// output wire [31:0] pulseWidth_max_V,
// // output wire PWM_limit_cw_H,
// // output wire PWM_limit_cw_V,
// output wire HS,
// output wire VS,
// output wire MC,
// output wire cnt_l,
// output wire cnt_d,
// output wire cnt_ru,
// // input wire V_out,
// // output wire [3:0] DISP_EN,
// // output wire [7:0] SSD,
// output wire [1:0] direction_lr,
// output wire [1:0] direction_ud,
// output wire servo_l,
// output wire servo_r,
// output wire servo_u,
// output wire servo_d,
// output wire SERVO_H,
// output wire SERVO_V,
// output wire [31:0] servo_position_H,
// output wire [31:0] servo_position_V,
// output wire general_enable_H,
// output wire general_enable_V,
// output wire div_clk,
// //output wire [31:0] PWM_H,
// //output wire [31:0] PWM_V,
// output wire [2:0] STAT
// );
//
// // wire general_enable_H;
// // wire general_enable_V;
// // wire HS; wire VS;
// // wire MC; // define horizontal sweep, vertical sweep and max counter enable signals
// // wire cnt_l; wire cnt_d; // define counter left and right enable signals
// // wire cnt_ru;
// wire [9:0] max_volt = 10'b0000000000; wire [9:0] volt = 10'b0000000000; // wire which contain max voltage e voltage readed form adc
// // wire servo_l; wire servo_r; wire servo_u; wire servo_d; // define servo left right up and down signals
// wire reset;
// // wire div_clk;
// wire cnt_rst;
//
// wire pll_clk, pll_locked ;
//
// PLL  PLL_inst ( .CLK_IN(CLK), .CLK_OUT(pll_clk), .LOCKED(pll_locked) ) ;
//
// ///////////////////////////
// //   ADC SOC generator   //
// ///////////////////////////
//
// // assert a single clock-pulse "SOC" once every 0.1 seconds
//
// wire adc_soc ;
//
// // TickCounterRst #(.MAX(2200)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(adc_soc)) ;
// // TickCounterRst #(.MAX(2200)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(div_clk)) ;
//
//
// ////////////////////////////////////////////////////////////
// //    XADC configured to read on-die temperature sensor   //
// ////////////////////////////////////////////////////////////
//
// wire adc_eoc ;
// // wire vp_in, vn_in ;
//
// // wire [11:0] V_in;
// // wire [11:0] max_V_in;
// // wire [2:0] STAT;
// // wire [1:0] direction_lr;
// // wire [1:0] direction_ud;
// // wire [11:0] adc_data ;
// // wire [15:0] do_out ;
//
// // assign adc_data = 12'hABC ;    // **DEBUG
//
//   wire EOC_TB;
//   wire EOS_TB;
//
//   reg [6:0] DADDR_TB;
//   reg DEN_TB;
//   reg DWE_TB;
//   reg [15:0] DI_TB;
//   wire [15:0] DO_TB;
//   wire DRDY_TB;
//   reg RESET_TB;
//   wire [2:0] ALM_unused;
//   wire ALARM_OUT_TB;
//   wire FLOAT_VCCAUX_ALARM;
//   wire FLOAT_VCCINT_ALARM;
//   wire FLOAT_USER_TEMP_ALARM;
//   wire BUSY_TB;
//   wire [4:0] CHANNEL_TB;
//
//   xadc xadc_inst (
//      .daddr_in(7'h10),
//      .dclk_in(pll_clk),
//      .den_in(EOC_TB),
//      .di_in(16'b0),
//      .dwe_in(1'b0),
//      .adc_out(V_in[11:0]),
//      .drdy_out(DRDY_TB),
//      .reset_in(RESET_TB),
//      .vauxp0(1'b0),      // Stimulus for Channels is applied from the SIM_MONITOR_FILE
//      .vauxn0(1'b0),
//      .busy_out(BUSY_TB),
//      .channel_out(CHANNEL_TB[4:0]),
//      .eoc_out(EOC_TB),
//      .eos_out(EOS_TB),
//      .alarm_out(ALARM_OUT_TB),
//      .vp_in(1'b0),
//      .vn_in(1'b0)
//
//          );
// // XADC  XADC (
// //
// //    .AdcClk    (        pll_clk ),
// //    .AdcSoc    (        div_clk ),
// //    .AdcEoc    (        adc_eoc ),
// //    .AdcData   (     adc_data[11:0] )
// //
// // ) ;
//
//
// // Instantiation of finite state machine
// FSM fsm0(
//    .BTN_L(BTN_L),
//    .BTN_R(BTN_R),
//    .BTN_U(BTN_U),
//    .BTN_D(BTN_D),
//    .BTN_C(BTN_C),
//    .CNT_L(cnt_l),
//    .CNT_RU(cnt_ru),
//    .CNT_D(cnt_d),
//    .CLK(div_clk),
//    .HS(HS),
//    .VS(VS),
//    .MC(MC),
//    .SERVO_L(servo_l),
//    .SERVO_R(servo_r),
//    .SERVO_U(servo_u),
//    .SERVO_D(servo_d),
//    .STAT(STAT),
//    .CNT_RST(cnt_rst));
//
// // Instantiation o the two servo drivers which control the servos by pwm_control and
// // a clk divider
// servo_driver servo_driver0(
//    .CLK(pll_clk),
//    .BTN_0(servo_l),
//    .BTN_1(servo_r),
//    .MC(MC),
//    .ES(HS),
//    .pulseWidth_max(pulseWidth_max_H),
//    .direction(direction_lr),
//    .servo_position(servo_position_H),
//    .general_enable(general_enable_H),
//    // .PWM_limit_cw(PWM_limit_cw_H),
//    .SERVO(SERVO_H));
//
// servo_driver servo_driver1(
//    .CLK(pll_clk),
//    .BTN_0(servo_d),
//    .BTN_1(servo_u),
//    .MC(MC),
//    .ES(VS),
//    .pulseWidth_max(pulseWidth_max_V),
//    .direction(direction_ud),
//    .servo_position(servo_position_V),
//    .general_enable(general_enable_V),
//    // .PWM_limit_cw(PWM_limit_cw_V),
//    .SERVO(SERVO_V));
//
// // Voltage visualizer which outputs current voltage on the seven segment
// // display
// // volt_vis volt_vis0(
// //    .CLK(CLK),
// //    .V_in(V_in),
// //    .V_out(V_out),
// //    .V_value(volt),
// //    .DISP_EN(DISP_EN),
// //    .SSD(SSD));
//
// // Compare current voltage with the one stored in the register
// voltage_comparator voltage_comparator0(
//    .PV(V_in),
//    .LV(max_V_in),
//    .GT(reset));
//
// // clk_div cd0(
// //    .clk(pll_clk),
// //    .sclk(div_clk));
//
// // TIckcounter faster than the actual in orded to reduce the time to switch
// // the sweeping steps
// TickCounterRst #(.MAX(2150)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(div_clk)) ;
//
// // Counter which counts the number of steps taken from the max voltage
// max_counter max_counter0(
//    .CLK(div_clk),
//    .CNT_RST(cnt_rst),
//    .RESET(reset),
//    // .PWM_limit_cw_H(PWM_limit_cw_H),
//    // .PWM_limit_cw_V(PWM_limit_cw_V),
//    .MC(MC),
//    .CNT_RU(cnt_ru));
//
// // Counter to limit the horizontal range of movement of servos
// horiz_counter horiz_counter0(
//    .CLK(div_clk),
//    .HS(HS),
//    .PWM_limit(general_enable_H),
//    .CNT_L(cnt_l));
//
// // Counter to limit the vertical range of movement of servos
// vert_counter vert_counter0(
//    .CLK(div_clk),
//    .VS(VS),
//    .PWM_limit(general_enable_V),
//    .CNT_D(cnt_d));
//
// // Flip Flop array which register the max voltage
// FF_Array FF_Array0(
//    .CLK(div_clk),
//    .GT(reset),
//    .pulseWidth_H(servo_position_H),
//    .pulseWidth_V(servo_position_V),
//    // .EN_H(servo_r),
//    // .EN_V(servo_u),
//    .PV(V_in),
//    .pulseWidth_max_H(pulseWidth_max_H),
//    .pulseWidth_max_V(pulseWidth_max_V),
//    .LV(max_V_in));
//
// LCD LCD_disp (
//    .CLK(div_clk),
//    .RST(reset),
//    // .EN(1'b1),
//    .V_in(V_in[11:0]),
//    .max_V_in(max_V_in[11:0]),
//    .HS(HS),
//    .VS(VS),
//    .MC(MC),
//    .RS(RS),
//    // .RW(RW),
//    .EN_OUT(EN_OUT),
//    .data(data_LCD[7:0]));
//
// endmodule
