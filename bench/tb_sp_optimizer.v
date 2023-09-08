//define the mode of operation
`define TEST_MODE
// `define FPGA_MODE


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
// Clock Divider
reg div_clk = 0;

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
    ANG = 0;
    DBG = 0;
    BTN_L = 0;
    BTN_R = 0;
    BTN_U = 0;
    BTN_D = 0;
    BTN_C = 0;
    // CLK = 0;
    // V_in = 12'b000000000000;

    RST = 1'b1;
    #100;

    RST = 1'b0;
    #100;
    // Start the machine by setting BTN_C to 1
    BTN_L = 1;
    #1000;

    BTN_L = 0;
    #1000;

    BTN_R = 1;
    #1000;

    BTN_R = 0;
    #1000;

    BTN_L = 1;
    #1000;

    BTN_L = 0;
    #1000;

    BTN_R = 1;
    #1000;

    BTN_R = 0;
    #1000;
    BTN_U = 1;
    #1000;

    BTN_L = 1;
    #1000;

    BTN_L = 0;
    #1000;

    BTN_R = 1;
    #1000;

    BTN_R = 0;
    #1000;
    BTN_U = 0;
    #1000;

    BTN_D = 1;
    #1000;

    BTN_D = 0;
    #1000;
    // Wait for a few clock cycles to let the machine start
    BTN_C = 1;
    #1000;


    // Repeat the trend multiple times
    // for (j = 0; j < NUM_CYCLES; j = j + 1) begin
    //     // Increase V_in from 0 to the max value
    //     for (i = 0; i < SIM_TIME/2; i = i + 10) begin
    //         V_in = ((i+1) * 4096) / (SIM_TIME/2) + $random %2048; // Linearly increase V_in from 0 to 1023
    //         #50; // Wait for a few clock cycles
    //     end
    //
    //     // Decrease V_in from the max value to half the max value
    //     for (i = SIM_TIME/2; i >= 0; i = i - 10) begin
    //         V_in = ((i+1) * 4096) / (SIM_TIME/2) + $random %2048; // Linearly decrease V_in from 1023 to 512
    //         #50; // Wait for a few clock cycles
    //     end
    // end
    // Stop the machine by setting BTN_C back to 0
    // BTN_C = 0;

    // Wait for a few clock cycles to observe the final outputs
    #10;

    $finish; // End simulation
end

`ifdef TEST_MODE
// Monitor
always @(posedge CLK) begin
    $display("V_in = %d, SERVO_H = %b, SERVO_V = %b, STAT = %b",
             V_in, SERVO_H, SERVO_V, STAT);
end
`endif

endmodule

// `timescale 1ns / 100ps
//
// module tb_sp_optimizer;
//
// // Parameters
// // parameter CLK_PERIOD = 10; // Clock period in time units (e.g., ns, us)
// parameter SIM_TIME = 10000; // Simulation time in time units (e.g., ns, us)
// parameter NUM_CYCLES = 5;  // Number of times to repeat the trend
//
// // Inputs
// reg BTN_L, BTN_R, BTN_U, BTN_D, BTN_C;
// wire [11:0] V_in;
// wire RS;
// wire EN_OUT;
// wire [7:0] data_LCD;
// // Outputs
// // wire [3:0] DISP_EN;
// // wire [7:0] SSD;
// wire [11:0] max_V_in;
// wire [31:0] pulseWidth_max_H;
// wire [31:0] pulseWidth_max_V;
// // wire PWM_limit_cw_H;
// // wire PWM_limit_cw_V;
// wire MC;
// wire HS;
// wire VS;
// wire cnt_ru;
// wire cnt_l;
// wire cnt_d;
// wire servo_l;
// wire servo_r;
// wire servo_u;
// wire servo_d;
// wire SERVO_H;
// wire SERVO_V;
// // wire [31:0] PWM_H;
// // wire [31:0] PWM_V;
// wire [2:0] STAT;
// wire [1:0] direction_lr;
// wire [1:0] direction_ud;
// wire [31:0] servo_position_H;
// wire [31:0] servo_position_V;
// wire PWM_limit_H;
// wire PWM_limit_V;
// wire div_clk;
// // Clock Divider
// reg div_clk = 0;
//
// wire CLK ;
// integer i = 0;
// integer j = 0;
// // real vp_in;
//
// ClockGen  #(.PERIOD(10.0)) ClockGen_inst (.clk(CLK) ) ;   // override default period as module parameter (default is 50.0 ns)
// // Instantiate the DUT (Device Under Test)
// sp_optimizer dut(
//     .BTN_L(BTN_L),
//     .BTN_R(BTN_R),
//     .BTN_U(BTN_U),
//     .BTN_D(BTN_D),
//     .BTN_C(BTN_C),
//     .CLK(CLK),
//     // .vp_in(vp_in),
//     .V_in(V_in),
//     .RS(RS),
//     .EN_OUT(EN_OUT),
//     .data_LCD(data_LCD),
//     .max_V_in(max_V_in),
//     .pulseWidth_max_H(pulseWidth_max_H),
//     .pulseWidth_max_V(pulseWidth_max_V),
//     // .PWM_limit_cw_H(PWM_limit_cw_H),
//     // .PWM_limit_cw_V(PWM_limit_cw_V),
//     .HS(HS),
//     .VS(VS),
//     .MC(MC),
//     .cnt_l(cnt_l),
//     .cnt_d(cnt_d),
//     .cnt_ru(cnt_ru),
//     .direction_lr(direction_lr),
//     .direction_ud(direction_ud),
//     // .V_out(), // Unused output in test bench
//     // .DISP_EN(DISP_EN),
//     // .SSD(SSD),
//     .servo_l(servo_l),
//     .servo_r(servo_r),
//     .servo_u(servo_u),
//     .servo_d(servo_d),
//     .SERVO_H(SERVO_H),
//     .SERVO_V(SERVO_V),
//     .servo_position_H(servo_position_H),
//     .servo_position_V(servo_position_V),
//     .PWM_limit_H(PWM_limit_H),
//     .PWM_limit_V(PWM_limit_V),
//     .div_clk(div_clk),
//     //.PWM_H(PWM_H),
//     //.PWM_V(PWM_V),
//     .STAT(STAT)
// );
//
// // Stimulus
// initial begin
//     // Initialize inputs
//     BTN_L = 0;
//     BTN_R = 0;
//     BTN_U = 0;
//     BTN_D = 0;
//     BTN_C = 0;
//     // CLK = 0;
//     // V_in = 12'b000000000000;
//
//     // Start the machine by setting BTN_C to 1
//     BTN_L = 1;
//     #10;
//
//     BTN_L = 0;
//     #10;
//
//     BTN_R = 1;
//     #10;
//
//     BTN_R = 0;
//     #10;
//
//     BTN_U = 1;
//     #100000;
//
//     BTN_U = 0;
//     #10;
//
//     BTN_D = 1;
//     #10;
//
//     BTN_D = 0;
//     #10;
//     // Wait for a few clock cycles to let the machine start
//     BTN_C = 1;
//     #10;
//
//
//     // Repeat the trend multiple times
//     // for (j = 0; j < NUM_CYCLES; j = j + 1) begin
//     //     // Increase V_in from 0 to the max value
//     //     for (i = 0; i < SIM_TIME/2; i = i + 10) begin
//     //         V_in = ((i+1) * 4096) / (SIM_TIME/2) + $random %2048; // Linearly increase V_in from 0 to 1023
//     //         #50; // Wait for a few clock cycles
//     //     end
//     //
//     //     // Decrease V_in from the max value to half the max value
//     //     for (i = SIM_TIME/2; i >= 0; i = i - 10) begin
//     //         V_in = ((i+1) * 4096) / (SIM_TIME/2) + $random %2048; // Linearly decrease V_in from 1023 to 512
//     //         #50; // Wait for a few clock cycles
//     //     end
//     // end
//     // Stop the machine by setting BTN_C back to 0
//     // BTN_C = 0;
//
//     // Wait for a few clock cycles to observe the final outputs
//     #100000;
//
//     $finish; // End simulation
// end
//
// // Monitor
// always @(posedge CLK) begin
//     $display("V_in = %d, SERVO_H = %b, SERVO_V = %b, STAT = %b",
//              V_in, SERVO_H, SERVO_V, STAT);
// end
//
// endmodule
