//--------------------------------------------------------------------------------
// Module Name: FSM - Behavioral
// Project Name: 
// Target Devices: 
// Description:  5 stati manual vertical sweep horizontal sweep search max
// horiz and vertical
// 
// Dependencies: 
// 
//--------------------------------------------------------------------------------

module FSM(
   input wire BTN_L, // input buttons
   input wire BTN_R,
   input wire BTN_U,
   input wire BTN_D,
   input wire BTN_C, // Button center (main button) **TODO: da fare con pressione
   input wire CNT_L, // signals which come from the counters and tell the FWM drive the corresponding servos
   input wire CNT_RU,
   input wire CNT_D,
   input wire CLK, // clock signal
   input wire RST, // reset signal
   output reg HS, // horizontal sweep signal, enable signal which go to counters
   output reg VS, // vertical sweep
   output reg MC, // Maximum counter
   output reg SERVO_L, // servo enable signal
   output reg SERVO_R,
   output reg SERVO_U,
   output reg SERVO_D,
   output reg [2:0] STAT, // possible states of FSM
   output reg CNT_RST // reset signal for oe of the counters 
);

// defining states (Modes: Manual, Horizontal Sweep, Horizontal Max State, Vertical Sweep. Vertical Max State)
parameter [2:0]
   man = 3'd0,
   hor_sweep = 3'd1,
   hor_max = 3'd2,
   vert_sweep = 3'd3,
   vert_max = 3'd4;

reg [2:0] PS = man;  // Present State
reg [2:0] NS;  // Next state

always @(posedge CLK) begin
   if (RST == 1'b1) begin
      PS <= man;
   end
   else begin
   // if (CLK == 1) begin
      PS <= NS;
   end
end

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
            NS <= hor_sweep; // go into the first calibration state if the center button is pressed
            CNT_RST <= 1'b0;
            HS <= 1'b1; // The horizontal counter start counting up 
            VS <= 1'b0;
            MC <= 1'b0;
         end
         else begin
            // Manual management of the servos
            if((BTN_L == 1'b1)) begin
               SERVO_L <= 1'b1;
               SERVO_R <= 1'b0;
            end
            else begin
               SERVO_L <= 1'b0;
            end
            if((BTN_R == 1'b1)) begin
               SERVO_R <= 1'b1;
               SERVO_L <= 1'b0;
            end
            else begin
               SERVO_R <= 1'b0;
            end
            if((BTN_U == 1'b1)) begin
               SERVO_U <= 1'b1;
               SERVO_D <= 1'b0;
            end
            else begin
               SERVO_U <= 1'b0;
            end
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



Debouncer #(DEBOUNCE_TIME) debouncer_L (
   .clk(CLK),
   .rst(RST),
   .btn(BTN_L), // Segnale del pulsante sinistro
   .debounced_btn(debounced_btn_L) // Segnale del pulsante sinistro debounchato
);

Debouncer #(DEBOUNCE_TIME) debouncer_R (
   .clk(CLK),
   .rst(RST),
   .btn(BTN_R), // Segnale del pulsante destro
   .debounced_btn(debounced_btn_R) // Segnale del pulsante destro debounchato
);

Debouncer #(DEBOUNCE_TIME) debouncer_U (
   .clk(CLK),
   .rst(RST),
   .btn(BTN_U), // Segnale del pulsante su
   .debounced_btn(debounced_btn_U) // Segnale del pulsante su debounchato
);


Debouncer #(DEBOUNCE_TIME) debouncer_D (
   .clk(CLK),
   .rst(RST),
   .btn(BTN_D), // Segnale del pulsante giù
   .debounced_btn(debounced_btn_D) // Segnale del pulsante giù debounchato
);

Debouncer #(DEBOUNCE_TIME) debouncer_C (
   .clk(CLK),
   .rst(RST),
   .btn(BTN_C), // Segnale del pulsante centrale
   .debounced_btn(debounced_btn_C) // Segnale del pulsante centrale debounchato
);

endmodule
