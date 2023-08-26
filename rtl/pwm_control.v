//--------------------------------------------------------------------------------
// Module Name: pwm_control - Behavioral
// Project Name: 
// Target Devices: 
// Description: Creates a pwm signal according to the direction we want the
//              servo to travel. 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module pwm_control(
   input wire CLK,
   input wire [1:0] DIR,
   input wire EN,
   output reg SERVO
);

// the clk used is the 100 MHz reduced by a 100 factor so 1Mhz therefore the
// period is 1us and this constant are to be viewed in us
// This are the simulation constants for a more compact pwm signal
// integer time_high_stopped = 15 ; // 15 us
// integer time_high_ccw = 16 ;
// integer time_high_cw = 14 ;
// integer time_low = 200 ;

// OLD_This are the effective constants to be used
integer time_high_stopped = 1500 ; // 1.5 ms
integer time_high_ccw = 1520 ;
integer time_high_cw = 1480 ;
integer time_low = 20000 ;

// This are the effective constants to be used for 
// integer time_high_stopped = 1500 ; // 1.5 ms
// integer time_high_ccw = 2000 ;
// integer time_high_cw = 980 ;
// integer time_low = 20000 ;  

//change time_high and time_low to change the period and duty cycle of the pwm wave (1300 = ccw, 1500 = stopped, 1700 = cw)

integer th_cntr = 0;
integer tl_cntr = 0;

// Due to the fact that it changes at every rising edge of clk it always 
always @(CLK, DIR, EN) begin
   if (EN == 1'b1) begin
      // stopping the servos
      if (CLK == 1'b1) begin
         if (DIR == 2'b00) begin
            if (tl_cntr <= time_low - 1) begin
               tl_cntr <= tl_cntr + 1 ;
               SERVO <= 1'b0 ;
            end
            else if (th_cntr <= time_high_stopped - 1) begin
               th_cntr <= th_cntr + 1 ;
               SERVO <= 1'b0 ;
            end
            else begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
            end
         end // stopping the servos
		 
         // servo clockwise
         else if (DIR == 2'b01) begin
            if (tl_cntr <= time_low - 1) begin
               tl_cntr <= tl_cntr + 1 ;
               SERVO <= 1'b0 ;
            end
            else if (th_cntr <= time_high_ccw - 1) begin
               th_cntr <= th_cntr + 1 ;
               SERVO <= 1'b1 ;
            end
            else begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
            end
         end // servo clockwise
		 
         // servo counter-clockwise
         else if (DIR == 2'b10) begin
            if (tl_cntr <= time_low - 1) begin
               tl_cntr <= tl_cntr + 1 ;
               SERVO <= 1'b0 ;
            end
            else if (th_cntr <= time_high_cw - 1) begin
               th_cntr <= th_cntr + 1 ;
               SERVO <= 1'b1 ;
            end
            else begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
            end
         end // servo counter-clockwise
      end // if enable
   end
end // always

endmodule
