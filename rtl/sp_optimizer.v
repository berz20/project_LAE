//--------------------------------------------------------------------------------

// Module Name: sp_optimizer
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7) 
// Description: RTL top module of solar tracker
//
// Dependencies: - TickCounter.v
//               - xadc.v
//               - FSM.v
//               - Debouncer.v
//               - servo_driver.v
//               - voltage_comparator.v
//               - horiz_counter.v
//               - vert_counter.v
//               - max_counter.v
//               - FF_Array.v
//               _ LCD.v
//
//               IP: PLL
//
// Additional Comments:
//
//--------------------------------------------------------------------------------

//define the mode of operation
// `define TEST_MODE
`define FPGA_MODE

`timescale 1 ns / 100 ps

`ifdef TEST_MODE

   module sp_optimizer(

      input wire CLK,
      input wire RST,

      // Input button definition
      input wire BTN_L,
      input wire BTN_R,
      input wire BTN_U,
      input wire BTN_D,

      // Mode switches
      input wire BTN_C, // Calibration mode switch
      input wire DBG,   // Debug mode switch 
      input wire ANG,   // Angel mode switch

      // ADC Input volatges
      input wire vauxp,
      input wire vauxn,

      // ADC Digital output
      output wire [11:0] V_in,

      // LCD signals
      output wire RS,             // Register select
      output wire EN_OUT,         // Enable
      output wire [7:0] data_LCD, // LCD data

      // Maximum signals
      output wire [11:0] max_V_in,         // Max ADC digital output
      output wire [31:0] pulseWidth_max_H, // Max PWM logic high time horizontal (sets the position for max in horizontal sweep)
      output wire [31:0] pulseWidth_max_V, // Max PWM logic high time vertical (sets the position for max in vertical sweep)

      // Enable sweep signals
      output wire HS, // Horizontal sweep
      output wire VS, // Vertical sweep 
      output wire MC, // Max counter

      // Counter for limiting sweep 
      output wire cnt_l,  // counter left
      output wire cnt_d,  // counter down
      output wire cnt_ru, // counter right up

      // Direction sweep signals
      output wire [1:0] direction_lr, // direction left / right
      output wire [1:0] direction_ud, // direction up / down

      // Direction driver signals
      output wire servo_l, // left sweep
      output wire servo_r, // right sweep
      output wire servo_u, // up sweep
      output wire servo_d, // down sweep
      
      // PWM signals
      output wire SERVO_H, // horizontal signal
      output wire SERVO_V, // vertical signal

      // Current PWM logic high time
      output wire [31:0] servo_position_H, // horizontal
      output wire [31:0] servo_position_V, // vertical

      // Signal to limit the sweep for servos
      output wire PWM_limit_H,
      output wire PWM_limit_V,

      // CLK divided
      output wire div_clk,

      // FSM state
      output wire [2:0] STAT

   );


   // Debounce time for buttons
   parameter integer DEB_TIME = 1; 

   // Divider parameter for clk
   parameter integer TICK_DIV = 2150; 


   // PLL Instantiation

   wire pll_clk; 
   wire pll_locked;

   PLL  PLL_inst ( .CLK_IN(CLK), .CLK_OUT(pll_clk), .LOCKED(pll_locked) ) ;

   // XADC configured to read input voltages

   wire EOC;
   wire EOS;

   reg [6:0] DADDR;
   reg DEN;
   reg DWE;
   reg [15:0] DI;
   wire [15:0] DO;
   wire DRDY;
   reg RESET;
   wire [2:0] ALM_unused;
   wire ALARM_OUT;
   wire FLOAT_VCCAUX_ALARM;
   wire FLOAT_VCCINT_ALARM;
   wire FLOAT_USER_TEMP_ALARM;
   wire BUSY;
   wire [4:0] CHANNEL;

   // define input voltages at zero since the adc during the simulation takes
   // values from the simulation file (SIM_MONITOR_FILE)

   xadc xadc_inst (
      .daddr_in(7'h10),
      .dclk_in(pll_clk),
      .den_in(EOC),
      .di_in(16'b0),
      .dwe_in(1'b0),
      .adc_out(V_in[11:0]),
      .drdy_out(DRDY),
      .reset_in(RESET),
      .vauxp0(1'b0),      // Stimulus for Channels is applied from the SIM_MONITOR_FILE
      .vauxn0(1'b0),
      .busy_out(BUSY),
      .channel_out(CHANNEL[4:0]),
      .eoc_out(EOC),
      .eos_out(EOS),
      .alarm_out(ALARM_OUT),
      .vp_in(1'b0),
      .vn_in(1'b0)

   );

`endif

`ifdef FPGA_MODE

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

      output wire [11:0] V_in,
      output wire RS,
      output wire EN_OUT,
      output wire [7:0] data_LCD,
      output wire servo_l,
      output wire servo_r,
      output wire servo_u,
      output wire servo_d,
      output wire SERVO_H,
      output wire SERVO_V

   );

   // Debounce time for buttons
   parameter integer DEB_TIME = 5000; 

   // Divider parameter for clk
   parameter integer TICK_DIV = 2150; 


   wire [11:0] max_V_in;
   wire [31:0] pulseWidth_max_H;
   wire [31:0] pulseWidth_max_V;
   wire HS;
   wire VS;
   wire MC;
   wire cnt_l;
   wire cnt_d;
   wire cnt_ru;
   wire [1:0] direction_lr;
   wire [1:0] direction_ud;
   wire [31:0] servo_position_H;
   wire [31:0] servo_position_V;
   wire PWM_limit_H;
   wire PWM_limit_V;
   wire div_clk;
   wire [2:0] STAT;

   // PLL Instantiation

   wire pll_clk; 
   wire pll_locked;

   PLL  PLL_inst ( .CLK_IN(CLK), .CLK_OUT(pll_clk), .LOCKED(pll_locked) ) ;

   wire EOC;
   wire EOS;

   reg [6:0] DADDR;
   reg DEN;
   reg DWE;
   reg [15:0] DI;
   wire [15:0] DO;
   wire DRDY;
   // reg RESET;
   wire [2:0] ALM_unused;
   wire ALARM_OUT;
   wire FLOAT_VCCAUX_ALARM;
   wire FLOAT_VCCINT_ALARM;
   wire FLOAT_USER_TEMP_ALARM;
   wire BUSY;
   wire [4:0] CHANNEL;

   // XADC instantiation

   xadc xadc_inst (
      .daddr_in(7'h10),
      .dclk_in(pll_clk),
      .den_in(EOC),
      .di_in(16'b0),
      .dwe_in(1'b0),
      .adc_out(V_in[11:0]),
      .drdy_out(DRDY),
      .reset_in(1'b0),
      .vauxp0(vauxp),      // Stimulus for Channels is applied from the SIM_MONITOR_FILE
      .vauxn0(vauxn),
      .busy_out(BUSY),
      .channel_out(CHANNEL[4:0]),
      .eoc_out(EOC),
      .eos_out(EOS),
      .alarm_out(ALARM_OUT),
      .vp_in(1'b0),
      .vn_in(1'b0)

   );

`endif


// Debounce button signals
wire debounced_btn_L;
wire debounced_btn_R; 
wire debounced_btn_U; 
wire debounced_btn_D; 
wire debounced_btn_C;


// Reset for maximum signals
wire reset;   // From voltage comparator
wire cnt_rst; // From FSM


// TickCounter used to reduce the PLL CLK
TickCounterRst #(.MAX(TICK_DIV)) Div_clk (.clk(pll_clk), .rst(~pll_locked), .tick(div_clk));


// Debouncers for button
Debouncer #(.DEBOUNCE_TIME(DEB_TIME)) debouncer_L (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_L), // Button signal left
   .debounced_btn(debounced_btn_L) // Button signal left debounced
);

Debouncer #(.DEBOUNCE_TIME(DEB_TIME)) debouncer_R (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_R), // Button signal right
   .debounced_btn(debounced_btn_R) // Button signal right debounced
);

Debouncer #(.DEBOUNCE_TIME(DEB_TIME)) debouncer_U (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_U), // Button signal up
   .debounced_btn(debounced_btn_U) // Button signal up debounced
);


Debouncer #(.DEBOUNCE_TIME(DEB_TIME)) debouncer_D (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_D), // Button signal down
   .debounced_btn(debounced_btn_D) // Button signal down debounced
);

Debouncer #(.DEBOUNCE_TIME(DEB_TIME)) debouncer_C (
   .clk(div_clk),
   .rst(RST),
   .btn(BTN_C), // Button signal centrale
   .debounced_btn(debounced_btn_C) // Button signal centrale debounced
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
   .CNT_RST(cnt_rst)
);


// Instantiation of the two servo drivers which control the servos by 
// pwm_control and a TickCounter
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
   .PWM_limit(PWM_limit_H),
   .SERVO(SERVO_H)
);

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
   .PWM_limit(PWM_limit_V),
   .SERVO(SERVO_V)
);


// Compare current voltage with the one stored in the register
voltage_comparator voltage_comparator0(
   .CLK(div_clk),
   .PV(V_in[11:4]), // [3:0] last bits are not relevant in the comparison
   .LV(max_V_in[11:4]),
   .GT(reset)
);


// Counter which sets the time limit for the right and up direction movement
max_counter max_counter0(
   .CLK(div_clk),
   .CNT_RST(cnt_rst),
   .MC(MC),
   .CNT_RU(cnt_ru)
);


// Counter to limit the horizontal range of movement of servos
horiz_counter horiz_counter0(
   .CLK(div_clk),
   .HS(HS),
   .PWM_limit(PWM_limit_H),
   .CNT_L(cnt_l)
);


// Counter to limit the vertical range of movement of servos
vert_counter vert_counter0(
   .CLK(div_clk),
   .VS(VS),
   .PWM_limit(PWM_limit_V),
   .CNT_D(cnt_d)
);


// Flip Flop array which register the max voltage and the PWM logic time high
// for the maximum position of the servos
FF_Array FF_Array0(
   .CLK(div_clk),
   .RST(RST),
   .GT(reset),
   .pulseWidth_H(servo_position_H),
   .pulseWidth_V(servo_position_V),
   .PV(V_in),
   .pulseWidth_max_H(pulseWidth_max_H),
   .pulseWidth_max_V(pulseWidth_max_V),
   .LV(max_V_in)
);


// LCD instantiation
LCD LCD_disp (
   .CLK(div_clk),
   .DBG(DBG),
   .ANG(ANG),
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
   .EN_OUT(EN_OUT),
   .data(data_LCD[7:0])
);


endmodule
