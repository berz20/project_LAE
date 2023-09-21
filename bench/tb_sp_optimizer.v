//define the mode of operation
// `define TEST_MODE
`define FPGA_MODE

//Test options 
// `define LCD_NORM
// `define LCD_ANG
// `define LCD_DBG
`define CALIBRATION_NORM
// `define CALIBRATION_ANG
// `define CALIBRATION_DBG
// `define MANUAL

`timescale 1ns / 100ps

module tb_sp_optimizer;

// Parameters
// parameter CLK_PERIOD = 10; // Clock period in time units (e.g., ns, us)
parameter SIM_TIME = 10000; // Simulation time in time units (e.g., ns, us)
parameter NUM_CYCLES = 5;  // Number of times to repeat the trend

`ifdef TEST_MODE

wire [11:0] max_V_in;
wire [31:0] pulseWidth_max_H;
wire [31:0] pulseWidth_max_V;
// wire PWM_limit_cw_H;
// wire PWM_limit_cw_V;
wire MC;
wire HS;
wire VS;
wire cnt_ru;
wire cnt_l;
wire cnt_d;
wire [2:0] STAT;
wire [1:0] direction_lr;
wire [1:0] direction_ud;
wire [31:0] servo_position_H;
wire [31:0] servo_position_V;
wire PWM_limit_H;
wire PWM_limit_V;
wire div_clk;

`endif
// Inputs
wire vauxp;
wire vauxn;
wire RS;
wire EN_OUT;
wire [7:0] data_LCD;
reg BTN_L, BTN_R, BTN_U, BTN_D, BTN_C;
wire [11:0] V_in;
wire servo_l;
wire servo_r;
wire servo_u;
wire servo_d;
wire SERVO_H;
wire SERVO_V;

wire CLK ;
reg RST ;
reg DBG ;
reg ANG ;
integer i = 0;
integer j = 0;
// real vp_in;

ClockGen  #(.PERIOD(10.0)) ClockGen_inst (.clk(CLK) ) ;   // override default period as module parameter (default is 50.0 ns)

// Instantiate the DUT (Device Under Test)
//
`ifdef FPGA_MODE
sp_optimizer dut(
    .BTN_L(BTN_L),
    .BTN_R(BTN_R),
    .BTN_U(BTN_U),
    .BTN_D(BTN_D),
    .BTN_C(BTN_C),
    .CLK(CLK),
    .RST(RST),
    .DBG(DBG),
    .ANG(ANG),
    .vauxp(1'b0),
    .vauxn(1'b0),
    .V_in(V_in),
    .RS(RS),
    .EN_OUT(EN_OUT),
    .data_LCD(data_LCD),
    .servo_l(servo_l),
    .servo_r(servo_r),
    .servo_u(servo_u),
    .servo_d(servo_d),
    .SERVO_H(SERVO_H),
    .SERVO_V(SERVO_V)
);
`endif

`ifdef TEST_MODE
sp_optimizer dut(
    .BTN_L(BTN_L),
    .BTN_R(BTN_R),
    .BTN_U(BTN_U),
    .BTN_D(BTN_D),
    .BTN_C(BTN_C),
    .CLK(CLK),
    .RST(RST),
    .DBG(DBG),
    .ANG(ANG),
    .vauxp(1'b0),
    .vauxn(1'b0),
    .V_in(V_in),
    .RS(RS),
    .EN_OUT(EN_OUT),
    .data_LCD(data_LCD),
    .max_V_in(max_V_in),
    .pulseWidth_max_H(pulseWidth_max_H),
    .pulseWidth_max_V(pulseWidth_max_V),
    .HS(HS),
    .VS(VS),
    .MC(MC),
    .cnt_l(cnt_l),
    .cnt_d(cnt_d),
    .cnt_ru(cnt_ru),
    .direction_lr(direction_lr),
    .direction_ud(direction_ud),
    .servo_l(servo_l),
    .servo_r(servo_r),
    .servo_u(servo_u),
    .servo_d(servo_d),
    .SERVO_H(SERVO_H),
    .SERVO_V(SERVO_V),
    .servo_position_H(servo_position_H),
    .servo_position_V(servo_position_V),
    .PWM_limit_H(PWM_limit_H),
    .PWM_limit_V(PWM_limit_V),
    .div_clk(div_clk),
    .STAT(STAT)
);
`endif
// Stimulus
initial begin
    // Initialize inputs
    RST   = 1'b1;
    ANG   = 1'b0;
    DBG   = 1'b0;
    BTN_L = 1'b0;
    BTN_R = 1'b0;
    BTN_U = 1'b0;
    BTN_D = 1'b0;
    BTN_C = 1'b0;

    #100000;

    RST = 1'b0;
    #10000;
end
      
`ifdef MANUAL

initial begin

    // Manual mode: user input: - Left  1 ms
    //                          - Right 1 ms
    //                          - Up    1 ms
    //                          - Down  1 ms
    //                          - Right 0.5 ms
    //                          - Down  0.5 ms
    
    #110000;
    BTN_L = 1'b1;
    #10000000; // 10 ms

    BTN_L = 1'b0;
    #1000;    // 1 us 

    BTN_R = 1'b1;
    #11000000; // 11 ms

    BTN_R = 1'b0;
    #1000;    // 1 us 

    BTN_U = 1'b1;
    #9800000; // 9.8 ms

    BTN_U = 1'b0;
    #1000;    // 1 us 

    BTN_D = 1'b1;
    #13000000; // 12 ms

    BTN_D = 1'b0;
    #1000;    // 1us

    BTN_R = 1'b1;
    #5000000;  // 5 ms

    BTN_D = 1'b1;
    #7000000;  // 5 ms

    BTN_R = 1'b0;
    #1000;    // 1 us 

    BTN_D = 1'b0;
    #1000;    // 1 us 

    #10;

    $finish; // End simulation
end

`endif

`ifdef CALIBRATION_NORM

initial begin

    // Wait for a few clock cycles to let the machine start
    #110000;
    BTN_C = 1'b1;
    #34000000; // 34 ms

    BTN_C = 1'b0;
    #46000000;     // 1 us 

    $finish; // End simulation
end

`endif

`ifdef CALIBRATION_ANG

initial begin

    // Wait for a few clock cycles to let the machine start
    #110000;
    ANG = 1'b1;

    BTN_C = 1'b1;
    #34000000; // 34 ms

    BTN_C = 1'b0;
    #46000000;     // 1 us 

    $finish; // End simulation
end

`endif

`ifdef CALIBRATION_DBG

initial begin

    // Wait for a few clock cycles to let the machine start
    #110000;
    DBG = 1'b1;

    BTN_C = 1'b1;
    #34000000; // 34 ms

    BTN_C = 1'b0;
    #46000000;     // 1 us 

    $finish; // End simulation
end

`endif

`ifdef TEST_MODE
// Monitor
always @(posedge CLK) begin
    $display("V_in = %d, SERVO_H = %b, SERVO_V = %b, STAT = %b",
             V_in, SERVO_H, SERVO_V, STAT);
end
`endif

endmodule
