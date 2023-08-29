`timescale 1ns / 100ps

module tb_sp_optimizer;

// Parameters
// parameter CLK_PERIOD = 10; // Clock period in time units (e.g., ns, us)
parameter SIM_TIME = 10000; // Simulation time in time units (e.g., ns, us)
parameter NUM_CYCLES = 5;  // Number of times to repeat the trend

// Inputs
reg BTN_L, BTN_R, BTN_U, BTN_D, BTN_C;
wire [11:0] V_in;
// Outputs
// wire [3:0] DISP_EN;
// wire [7:0] SSD;
wire [11:0] max_V_in;
wire [31:0] pulseWidth_max_H;
wire [31:0] pulseWidth_max_V;
// wire PWM_limit_cw_H;
// wire PWM_limit_cw_V;
wire mc;
wire hs;
wire vs;
wire cnt_ru;
wire cnt_l;
wire cnt_d;
wire servo_l;
wire servo_r;
wire servo_u;
wire servo_d;
wire SERVO_H;
wire SERVO_V;
// wire [31:0] PWM_H;
// wire [31:0] PWM_V;
wire [2:0] STAT;
wire [1:0] direction_lr;
wire [1:0] direction_ud;
wire [31:0] servo_position_H;
wire [31:0] servo_position_V;
// Clock Divider
reg div_clk = 0;

wire CLK ;
integer i = 0;
integer j = 0;
// real vp_in;

ClockGen  #(.PERIOD(10.0)) ClockGen_inst (.clk(CLK) ) ;   // override default period as module parameter (default is 50.0 ns)
// Instantiate the DUT (Device Under Test)
sp_optimizer dut(
    .BTN_L(BTN_L),
    .BTN_R(BTN_R),
    .BTN_U(BTN_U),
    .BTN_D(BTN_D),
    .BTN_C(BTN_C),
    .CLK(CLK),
    // .vp_in(vp_in),
    .V_in(V_in),
    .max_V_in(max_V_in),
    .pulseWidth_max_H(pulseWidth_max_H),
    .pulseWidth_max_V(pulseWidth_max_V),
    // .PWM_limit_cw_H(PWM_limit_cw_H),
    // .PWM_limit_cw_V(PWM_limit_cw_V),
    .hs(hs),
    .vs(vs),
    .mc(mc),
    .cnt_l(cnt_l),
    .cnt_d(cnt_d),
    .cnt_ru(cnt_ru),
    .direction_lr(direction_lr),
    .direction_ud(direction_ud),
    // .V_out(), // Unused output in test bench
    // .DISP_EN(DISP_EN),
    // .SSD(SSD),
    .servo_l(servo_l),
    .servo_r(servo_r),
    .servo_u(servo_u),
    .servo_d(servo_d),
    .SERVO_H(SERVO_H),
    .SERVO_V(SERVO_V),
    .servo_position_H(servo_position_H),
    .servo_position_V(servo_position_V),
    //.PWM_H(PWM_H),
    //.PWM_V(PWM_V),
    .STAT(STAT)
);

// Stimulus
initial begin
    // Initialize inputs
    BTN_L = 0;
    BTN_R = 0;
    BTN_U = 0;
    BTN_D = 0;
    BTN_C = 0;
    // CLK = 0;
    // V_in = 12'b000000000000;

    // Start the machine by setting BTN_C to 1
    BTN_L = 1;
    #10;

    BTN_L = 0;
    #10;

    BTN_R = 1;
    #10;

    BTN_R = 0;
    #10;

    BTN_U = 1;
    #100000;

    BTN_U = 0;
    #10;

    BTN_D = 1;
    #10;

    BTN_D = 0;
    #10;
    // Wait for a few clock cycles to let the machine start
    BTN_C = 1;
    #10;


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
    #10000000;

    $finish; // End simulation
end

// Monitor
always @(posedge CLK) begin
    $display("V_in = %d, SERVO_H = %b, SERVO_V = %b, STAT = %b",
             V_in, SERVO_H, SERVO_V, STAT);
end

endmodule
