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

`timescale 1 us / 100 ps

module pwm_control(
   input wire CLK,
   input wire [1:0] DIR,
   input wire EN,
   output reg SERVO
);

integer time_high_stopped = 1500 ; // 1.5 ms
integer time_high_ccw = 1520 ;
integer time_high_cw = 1480 ;
integer time_low = 20000 ;  
// integer time_high_stopped = 1500 ; // 1.5 ms
// integer time_high_ccw = 1520 ;
// integer time_high_cw = 1480 ;
// integer time_low = 20000 ;  

//change time_high and time_low to change the period and duty cycle of the pwm wave (1300 = ccw, 1500 = stopped, 1700 = cw)

integer th_cntr = 0;
integer tl_cntr = 0;

always @(CLK, DIR, EN) begin
   if (EN == 1'b1) begin
      // stopping the servos
      if (DIR == 2'b00) begin
         if (tl_cntr <= time_low) begin
            tl_cntr <= tl_cntr + 1 ;
            SERVO <= 1'b0 ;
         end
         else if (th_cntr <= time_high_stopped) begin
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
         if (tl_cntr <= time_low) begin
            tl_cntr <= tl_cntr + 1 ;
            SERVO <= 1'b0 ;
         end
         else if (th_cntr <= time_high_ccw) begin
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
         if (tl_cntr <= time_low) begin
            tl_cntr <= tl_cntr + 1 ;
            SERVO <= 1'b0 ;
         end
         else if (th_cntr <= time_high_cw) begin
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
end // always

endmodule
