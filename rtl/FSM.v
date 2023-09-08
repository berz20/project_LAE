//--------------------------------------------------------------------------------
// Module Name: FSM
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7) 
// Description:  5 states: - manual (user controls the movement with buttons)
//                         - horizontal sweep (device sweeps left searching for
//                           maximum)
//                         - horizontal max (device sweeps to the maximum
//                           irradiance position)
//                         - vertical sweep (device sweeps down searching
//                           for maximum)
//                         - vertical max (device sweeps up to the maximum
//                           irradiance position)
// 
// Dependencies:
// 
// Additional Comments:
//
//--------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module FSM(

   input wire CLK, // clock signal
   input wire RST, // reset signal

   // Input button definition
   input wire BTN_L,
   input wire BTN_R,
   input wire BTN_U,
   input wire BTN_D,

   // Mode switch
   input wire BTN_C, // Calibration mode switch

   // Counter for limiting sweep 
   input wire CNT_L,  // Counter left
   input wire CNT_D,  // Counter down
   input wire CNT_RU, // Counter right up 


   // Enable sweep signals
   output reg HS, // Horizontal sweep
   output reg VS, // Vertical sweep
   output reg MC, // Max counter


   // Direction driver signals
   output reg SERVO_L, // left sweep
   output reg SERVO_R, // right sweep
   output reg SERVO_U, // up sweep
   output reg SERVO_D, // down sweep

   // FSM state
   output reg [2:0] STAT, // possible states of FSM

   // Reset for maximum signals
   output reg CNT_RST
);


// Defining states
parameter [2:0]
   man = 3'd0,
   hor_sweep = 3'd1,
   hor_max = 3'd2,
   vert_sweep = 3'd3,
   vert_max = 3'd4;


// State transition variables
reg [2:0] PS = man;  // Present State
reg [2:0] NS;  // Next state


// Transition sequential block
always @(posedge CLK) begin
   if (RST == 1'b1) begin
      PS <= man;
   end
   else begin
      PS <= NS;
   end
end

// Main sequential block
always @(PS, BTN_L, BTN_R, BTN_U, BTN_D, BTN_C, CNT_L, CNT_RU, CNT_D) begin

   SERVO_L <= 1'b0;
   SERVO_R <= 1'b0;
   SERVO_U <= 1'b0;
   SERVO_D <= 1'b0;

   case(PS)

      // Manual mode
      man : begin

         STAT <= man;

         if((BTN_C == 1'b1)) begin
            // Go into the first calibration state if the center button is pressed
            NS <= hor_sweep;
            CNT_RST <= 1'b0;
            HS <= 1'b1; // The horizontal counter start counting up 
            VS <= 1'b0;
            MC <= 1'b0;
         end

         else begin

            // Manual management of the servos
            // Left
            if((BTN_L == 1'b1)) begin
               SERVO_L <= 1'b1;
               SERVO_R <= 1'b0;
            end
            else begin
               SERVO_L <= 1'b0;
            end

            // Right
            if((BTN_R == 1'b1)) begin
               SERVO_R <= 1'b1;
               SERVO_L <= 1'b0;
            end
            else begin
               SERVO_R <= 1'b0;
            end

            // Up
            if((BTN_U == 1'b1)) begin
               SERVO_U <= 1'b1;
               SERVO_D <= 1'b0;
            end
            else begin
               SERVO_U <= 1'b0;
            end

            // Down
            if((BTN_D == 1'b1)) begin
               SERVO_D <= 1'b1;
               SERVO_U <= 1'b0;
            end
            else begin
               SERVO_D <= 1'b0;
            end

            NS <= man; // remains in manual state
            CNT_RST <= 1'b1; // keeps the max counter reset
            HS <= 1'b0; // all the other counters remain low
            VS <= 1'b0;
            MC <= 1'b0;
         end
      end

      // Horizontal Sweep Mode 
      hor_sweep : begin

         STAT <= hor_sweep ;

         SERVO_U <= 1'b0;
         SERVO_D <= 1'b0;
         CNT_RST <= 1'b0;

         if((CNT_L == 1'b1)) begin
            SERVO_L <= 1'b1;
            SERVO_R <= 1'b0;
            HS <= 1'b1;
            VS <= 1'b0;
            MC <= 1'b0;
            NS <= hor_sweep;
         end
         else begin
            SERVO_L <= 1'b0;
            SERVO_R <= 1'b0;
            NS <= hor_max; // triggers horizontal max state
            HS <= 1'b0;
            VS <= 1'b0;
            MC <= 1'b1;
         end
      end

      // Horizontal Max State Mode
      hor_max : begin

         STAT <= hor_max;

         SERVO_U <= 1'b0;
         SERVO_D <= 1'b0;
         CNT_RST <= 1'b0;

         if((CNT_RU == 1'b1)) begin
            SERVO_R <= 1'b1;
            SERVO_L <= 1'b0;
            HS <= 1'b0;
            VS <= 1'b0;
            MC <= 1'b1;
            NS <= hor_max;
         end
         else begin
            SERVO_R <= 1'b0;
            SERVO_L <= 1'b0;
            NS <= vert_sweep; // Triggers veritcal search
            MC <= 1'b0;
            VS <= 1'b1;
            HS <= 1'b0;
         end
      end

      // Veritcal Sweep Mode
      vert_sweep : begin

         STAT <= vert_sweep;

         SERVO_L <= 1'b0;
         SERVO_R <= 1'b0;
         CNT_RST <= 1'b0;

         if((CNT_D == 1'b1)) begin
            SERVO_D <= 1'b1;
            SERVO_U <= 1'b0;
            NS <= vert_sweep;
            HS <= 1'b0;
            VS <= 1'b1;
            MC <= 1'b0;
         end
         else begin
            SERVO_D <= 1'b0;
            SERVO_U <= 1'b0;
            NS <= vert_max; // Go to maximum vertical voltage
            HS <= 1'b0;
            VS <= 1'b0;
            MC <= 1'b1;
         end
      end

      // Vertical Max State Mode
      vert_max : begin

         STAT <= vert_max;

         SERVO_L <= 1'b0;
         SERVO_R <= 1'b0;
         CNT_RST <= 1'b0;

         if((CNT_RU == 1'b1)) begin
            SERVO_U <= 1'b1;
            SERVO_D <= 1'b0;
            NS <= vert_max;
            HS <= 1'b0;
            VS <= 1'b0;
            MC <= 1'b1;
         end
         else begin
            SERVO_U <= 1'b0;
            SERVO_D <= 1'b0;
            NS <= man; // Returns to Manual Mode
            HS <= 1'b0;
            VS <= 1'b0;
            MC <= 1'b0;
         end
      end

      // Default Mode
      default : begin

         NS <= man;
         
         SERVO_L <= 1'b0;
         SERVO_R <= 1'b0;
         SERVO_U <= 1'b0;
         SERVO_D <= 1'b0;
         CNT_RST <= 1'b1;
         HS <= 1'b0;
         VS <= 1'b0;
         MC <= 1'b0;

         STAT <= 3'b000;
      end

   endcase

end

endmodule
