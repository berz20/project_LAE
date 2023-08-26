`timescale 1ns / 100ps

module tb_sp_optimizer;

// Parameters
// parameter CLK_PERIOD = 10; // Clock period in time units (e.g., ns, us)
parameter SIM_TIME = 10000; // Simulation time in time units (e.g., ns, us)
parameter NUM_CYCLES = 5;  // Number of times to repeat the trend

// Inputs
reg BTN_L, BTN_R, BTN_U, BTN_D, BTN_C;
reg [11:0] V_in;
// Outputs
// wire [3:0] DISP_EN;
// wire [7:0] SSD;
reg [11:0] max_V_in;
wire servo_l;
wire servo_r;
wire servo_u;
wire servo_d;
wire SERVO_H;
wire SERVO_V;
reg [2:0] STAT;
reg [1:0] direction_lr;
reg [1:0] direction_ud;
// Clock Divider
reg div_clk = 0;

wire CLK ;
integer i = 0;
integer j = 0;

ClockGen  #(.PERIOD(10.0)) ClockGen_inst (.clk(pll_clk) ) ;   // override default period as module parameter (default is 50.0 ns)
// Instantiate the DUT (Device Under Test)
// sp_optimizer dut(
//     .BTN_L(BTN_L),
//     .BTN_R(BTN_R),
//     .BTN_U(BTN_U),
//     .BTN_D(BTN_D),
//     .BTN_C(BTN_C),
//     .CLK(CLK),
//     .V_in(V_in),
//     .max_V_in(max_V_in),
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
//     .STAT(STAT)
// );

// wire pll_clk, pll_locked ;
//
// PLL  PLL_inst ( .CLK_IN(CLK), .CLK_OUT(pll_clk), .LOCKED(pll_locked) ) ;

// TIckcounter faster than the actual in orded to reduce the time to switch
// the sweeping steps 
// TickCounterRst #(.MAX(24414)) AdcSocGen (.clk(pll_clk), .rst(~pll_locked), .tick(div_clk)) ;

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
   .CLK(pll_clk),
   .BTN_0(servo_l),
   .BTN_1(servo_r),
   .direction(direction_lr),
   .SERVO(SERVO_H));

servo_driver servo_driver1(
   .CLK(pll_clk),
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
   .clk(pll_clk),
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
   .CLK(pll_clk),
   .GT(reset),
   .PV(V_in),
   .LV(max_V_in));
// Stimulus
initial begin
    // Initialize inputs
    BTN_L = 0;
    BTN_R = 0;
    BTN_U = 0;
    BTN_D = 0;
    BTN_C = 0;
    // CLK = 0;
    V_in = 12'b000000000000;

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

    // Generate a stream of volt signals
    // You can replace this loop with any specific test scenario

    // Repeat the trend multiple times
    for (j = 0; j < NUM_CYCLES; j = j + 1) begin
        // Increase V_in from 0 to the max value
        for (i = 0; i < SIM_TIME/2; i = i + 10) begin
            V_in = ((i+1) * 4096) / (SIM_TIME/2) + $random %2048; // Linearly increase V_in from 0 to 1023
            #50; // Wait for a few clock cycles
        end

        // Decrease V_in from the max value to half the max value
        for (i = SIM_TIME/2; i >= 0; i = i - 10) begin
            V_in = ((i+1) * 4096) / (SIM_TIME/2) + $random %2048; // Linearly decrease V_in from 1023 to 512
            #50; // Wait for a few clock cycles
        end
    end
    // Stop the machine by setting BTN_C back to 0
    // BTN_C = 0;

    // Wait for a few clock cycles to observe the final outputs
    #10;

    $finish; // End simulation
end

// Monitor
always @(posedge CLK) begin
    $display("V_in = %d, SERVO_H = %b, SERVO_V = %b, STAT = %b",
             V_in, SERVO_H, SERVO_V, STAT);
end

endmodule
