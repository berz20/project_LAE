//--------------------------------------------------------------------------------

// Module Name: pwm_control
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7) 
// Description: Module that generates the PWM signal changing the logic high
// time in order to set the new angel
//
// Dependencies:
//
// Additional Comments:
//
//--------------------------------------------------------------------------------

//define the mode of operation
// `define TB_MODE
`define FP_MODE

`timescale 1ns / 100ps

module pwm_control(

   input wire CLK,
   input wire RST,

   // Direction sweep signal
   input wire [1:0] DIR,

   // Debug signal enable
   input wire EN,

   
   // Enable sweep signals
   input wire MC,
   input wire ES, // enable sweep state FSM (HS or VS)

   // Max PWM logic high time horizontal
   input wire [14:0] pulseWidth_max,

   
   // Current PWM logic high time
   output reg [14:0] pulseWidth,

   // PWM signals
   output reg SERVO
);

// The servo motor used are the MS60
// map 0 - 180 deg 500 - 2500 us time high PWM signal

parameter reg [14:0] minPulseWidth = 5000;

`ifdef FP_MODE

// increase / decrease interval for changing time high
parameter reg [14:0] inc_dec_interval = 100;
// Additional variable to decide the time low of the PWM
reg [18:0] time_low = 150000;

`endif 

`ifdef TB_MODE

// increase / decrease interval for changing time high
parameter reg [14:0] inc_dec_interval = 4000;
// Additional variable to decide the time low of the PWM
reg [14:0] time_low = 15000;

`endif 

// Counter to set the time high and time low of the PWM signal
reg [14:0] th_cntr = 0;
reg [18:0] tl_cntr = 0;

// Additional flag signal to set the servos at 500 (0 degree) every time the
// calibration starts
reg tmp_flag = 1'b0;

// Additional variable to take trace of the actual position of the servos
reg [14:0] tmp_th = minPulseWidth;

// Additional variable to decide the time high of the PWM
reg [14:0] tmp_th_cw = minPulseWidth;

always @(posedge CLK) begin

   pulseWidth <= tmp_th;

   // When RST is high it puts the servos to the 0 degree position
   if (RST == 1'b1) begin

      // Sets the time high to 500 us
      if (th_cntr < minPulseWidth) begin
         th_cntr <= th_cntr + 1 ;
         SERVO <= 1'b1 ;
         pulseWidth <= minPulseWidth;
         tmp_th_cw <= minPulseWidth;
         tmp_th <= minPulseWidth;
      end
      // Sets the time low to 1500 us
      else if (tl_cntr < time_low) begin
         tl_cntr <= tl_cntr + 1 ;
         SERVO <= 1'b0 ;
         pulseWidth <= minPulseWidth;
         tmp_th_cw <= minPulseWidth;
         tmp_th <= minPulseWidth;
      end

      else begin
         tl_cntr <= 0 ;
         th_cntr <= 0 ;
         SERVO <= 1'b0 ;
         pulseWidth <= minPulseWidth;
         tmp_th_cw <= minPulseWidth;
         tmp_th <= minPulseWidth;
      end

   end

   else if (EN == 1'b1) begin

      // Direction is in stop mode
      if (DIR == 2'b00) begin
         SERVO <= 1'b0;
         tl_cntr <= 0 ;
         th_cntr <= 0 ;
         SERVO <= 1'b0 ;
      end

      // Direction CounterClockWise
      else if (DIR == 2'b01) begin

         // Sets the PWM time high to 500 every time the calibration starts
         if (ES == 1'b1 && tmp_flag == 1'b0) begin
            tmp_th_cw <= minPulseWidth;
            tmp_flag <= 1'b1;
         end 

         if (th_cntr < tmp_th_cw) begin
            th_cntr <= th_cntr + 1 ;
            SERVO <= 1'b1 ;
            tmp_th <= tmp_th_cw;
            pulseWidth <= tmp_th_cw;
         end

         else if (tl_cntr < time_low) begin
            tl_cntr <= tl_cntr + 1 ;
            SERVO <= 1'b0 ;
            tmp_th <= tmp_th_cw;
            pulseWidth <= tmp_th_cw;
         end

         else begin

            // Updates the time high value
            if (tmp_th_cw < 25000) begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
               tmp_th <= tmp_th_cw;
               pulseWidth <= tmp_th_cw;
               tmp_th_cw <= tmp_th_cw + inc_dec_interval;
            end

            // If the extreme limit is reached it stops
            else begin 
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
               tmp_th <= tmp_th_cw;
               pulseWidth <= tmp_th_cw;
            end

         end

      end

      else if (DIR == 2'b10) begin

         // The flag is set to low in order to permit the setting of the
         // position to 500 at the start of the new calibration
         tmp_flag <= 1'b0;

         // When the calibration is is Horizontal / Vertical max the time high
         // is set to the pulse width relative to the maximum irradiance
         // position
         if (MC == 1'b1) begin

            if (th_cntr < pulseWidth_max) begin
               th_cntr <= th_cntr + 1 ;
               SERVO <= 1'b1 ;
               $display("pulseWidth_max = ",pulseWidth_max);
               pulseWidth <= pulseWidth_max;
               tmp_th_cw <= pulseWidth_max;
               tmp_th <= pulseWidth_max;
            end

            else if (tl_cntr < time_low) begin
               tl_cntr <= tl_cntr + 1 ;
               SERVO <= 1'b0 ;
               $display("pulseWidth_max = ",pulseWidth_max);
               pulseWidth <= pulseWidth_max;
               tmp_th_cw <= pulseWidth_max;
               tmp_th <= pulseWidth_max;
            end

            else begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
               $display("pulseWidth_max = ",pulseWidth_max);
               pulseWidth <= pulseWidth_max;
               tmp_th_cw <= pulseWidth_max;
               tmp_th <= pulseWidth_max;
            end

         end

         // This condition is used in manual mode
         else if (th_cntr < tmp_th_cw) begin
            th_cntr <= th_cntr + 1 ;
            SERVO <= 1'b1 ;
            tmp_th <= tmp_th_cw;
            $display("tmp_th =",tmp_th);
            pulseWidth <= tmp_th_cw;
         end

         else if (tl_cntr < time_low) begin
            tl_cntr <= tl_cntr + 1 ;
            SERVO <= 1'b0 ;
            tmp_th <= tmp_th_cw;
            $display("tmp_th =",tmp_th);
            pulseWidth <= tmp_th_cw;
         end

         else begin
            
            // If the servo hasn't reached yet the extreme limit it continues
            // to change the pulse widht time high
            if (tmp_th_cw > 5000) begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
               tmp_th <= tmp_th_cw;
               $display("tmp_th =",tmp_th);
               pulseWidth <= tmp_th_cw;
               tmp_th_cw <= tmp_th_cw - inc_dec_interval;
            end

            else begin
               tl_cntr <= 0 ;
               th_cntr <= 0 ;
               SERVO <= 1'b0 ;
               tmp_th <= tmp_th_cw;
               $display("tmp_th =",tmp_th);
               pulseWidth <= tmp_th_cw;
            end

         end

      end

   end

   // Resets everything and updates the pulseWidth with the new "position" of
   // the servos
   else begin
      th_cntr <= 0;
      tl_cntr <= 0;
      SERVO <= 1'b0;
      pulseWidth <= tmp_th;
      tmp_th_cw <= minPulseWidth;
   end
end

endmodule
