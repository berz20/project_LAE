//--------------------------------------------------------------------------------
// Module Name: LCD
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7) 
// Description: LCD driver that operates in 3 possible modes:
//                 - Normal Mode: it shows the operating mode of the device
//                   that can be manual or calibration
//                 - Angel Mode: it shows on the first row the angles at which
//                   the device found the maximum irradiance and in the second
//                   row the current angles
//                 - Debug Mode: it is equal to the angle mode but it displays
//                   the time high of the PWM
//
// Dependencies:
//
// Additional Comments:
//
//--------------------------------------------------------------------------------

`define TB_MODE

`timescale 1 ns / 100 ps

module LCD (

   input wire CLK,

   // Mode switches
   input wire DBG, // Debug mode switch
   input wire ANG, // Angel mode switch

   // ADC Digital output
   input wire [11:0] V_in,

   // Max ADC digital output
   input wire [11:0] max_V_in,

   // Current PWM logic high time
   input wire [14:0] pulseWidth_H,
   input wire [14:0] pulseWidth_V,

   // Max PWM logic high time
   input wire [14:0] pulseWidth_max_H,
   input wire [14:0] pulseWidth_max_V,

   // Enable sweep signals
   input wire HS,
   input wire VS,
   input wire MC,


   // LCD signals
   output reg RS,         // Register Select (LCD control signal)
   output reg EN_OUT,     // Enable (LCD control signal)
   output reg [7:0] data  // Data to be displayed (ASCII characters)

);


// Voltage values
// Max Voltage
reg [11:0] xval_D1;
reg [11:0] xval_D2;

// Current voltage
reg [11:0] xval2_D1;
reg [11:0] xval2_D2;

// PWM time high lenght signal (Debug)
// Max horizontal
reg [14:0] xval3_D1;
reg [14:0] xval3_D2;
reg [14:0] xval3_D3;

// Max vertical
reg [14:0] xval4_D1;
reg [14:0] xval4_D2;
reg [14:0] xval4_D3;

// Current horizontal
reg [14:0] xval5_D1;
reg [14:0] xval5_D2;
reg [14:0] xval5_D3;

// Current vertical
reg [14:0] xval6_D1;
reg [14:0] xval6_D2;
reg [14:0] xval6_D3;

// Angle servos
// Max horizontal
reg [14:0] xval7_D2;
reg [14:0] xval7_D3;

// Max vertical
reg [14:0] xval8_D2;
reg [14:0] xval8_D3;

// Current horizontal
reg [14:0] xval9_D2;
reg [14:0] xval9_D3;

// Current vertical
reg [14:0] xval10_D2;
reg [14:0] xval10_D3;


// Array of 36 registers that contains the ASCII characters and the
// instructions for the LCD
reg [7:0] Datas [1:36];

// Internal counter
reg [16:0] i = 0;
reg [16:0] j = 1;


always @(posedge CLK) begin

   // Voltage values
   xval_D1 <= max_V_in*330/4095;
   xval_D2 <= max_V_in*33/4095; 
 
   xval2_D1 <= V_in*12'd330/12'd4095;
   xval2_D2 <= V_in*12'd33/12'd4095; 
 
   // PWM lenght signal (Debug)
   xval3_D1 <= pulseWidth_max_H/15'd10;
   xval3_D2 <= pulseWidth_max_H/15'd100;
   xval3_D3 <= pulseWidth_max_H/15'd1000;

   xval4_D1 <= pulseWidth_max_V/15'd10;
   xval4_D2 <= pulseWidth_max_V/15'd100;
   xval4_D3 <= pulseWidth_max_V/15'd1000;

   xval5_D1 <= pulseWidth_H/15'd10;
   xval5_D2 <= pulseWidth_H/15'd100;
   xval5_D3 <= pulseWidth_H/15'd1000;

   xval6_D1 <= pulseWidth_V/15'd10;
   xval6_D2 <= pulseWidth_V/15'd100;
   xval6_D3 <= pulseWidth_V/15'd1000;

   // Angle servos 
   xval7_D2 <= pulseWidth_max_H*15'd180/15'd20000 - 15'd45;
   xval7_D3 <= pulseWidth_max_H*18/15'd20000 - 15'd4;

   xval8_D2 <= pulseWidth_max_V*15'd180/15'd20000 - 15'd45;
   xval8_D3 <= pulseWidth_max_V*18/15'd20000 - 15'd4;

   xval9_D2 <= pulseWidth_H*15'd180/15'd20000 - 15'd45;
   xval9_D3 <= pulseWidth_H*18/15'd20000 - 15'd4;

   xval10_D2 <= pulseWidth_V*15'd180/15'd20000 - 15'd45;
   xval10_D3 <= pulseWidth_V*18/15'd20000 - 15'd4;

end


always @(posedge CLK) begin

   // Instruction sequence
   Datas[1] <= 8'h38; // Configures LCD to function set, it sets the LCD to 8 bit mode (2 lines and 5X8 char are default)
   Datas[2] <= 8'h0C; // turns on display and cursor (disable blinking)
   Datas[3] <= 8'h06; // Entry mode set, automatically increment the cursor position after each char is sent
   Datas[4] <= 8'h01; // Clear the display
   Datas[5] <= 8'h80; // Sets the DDRAM (display data RAM) addres to h80 sets the cursor at the beginning of the first line

   // Debug mode
   if (DBG == 1'b1) begin

      // Max horizontal
      Datas[6] <= 8'h48; // H
      Datas[7] <= 8'h3A; // :
      Datas[8] <= 8'h20; // space

      case (xval3_D1%15'd10)
         0 : Datas[12] <= 8'h30;
         1 : Datas[12] <= 8'h31;
         2 : Datas[12] <= 8'h32;
         3 : Datas[12] <= 8'h33;
         4 : Datas[12] <= 8'h34;
         5 : Datas[12] <= 8'h35;
         6 : Datas[12] <= 8'h36;
         7 : Datas[12] <= 8'h37;
         8 : Datas[12] <= 8'h38;
         9 : Datas[12] <= 8'h39;
         default : Datas[12] <= 8'h20;  
      endcase

      case (xval3_D2%15'd10)
         0 : Datas[11] <= 8'h30;
         1 : Datas[11] <= 8'h31;
         2 : Datas[11] <= 8'h32;
         3 : Datas[11] <= 8'h33;
         4 : Datas[11] <= 8'h34;
         5 : Datas[11] <= 8'h35;
         6 : Datas[11] <= 8'h36;
         7 : Datas[11] <= 8'h37;
         8 : Datas[11] <= 8'h38;
         9 : Datas[11] <= 8'h39;
         default : Datas[11] <= 8'h20;  
      endcase

      case (xval3_D3%15'd10)
         0 : Datas[10] <= 8'h30;
         1 : Datas[10] <= 8'h31;
         2 : Datas[10] <= 8'h32;
         3 : Datas[10] <= 8'h33;
         4 : Datas[10] <= 8'h34;
         5 : Datas[10] <= 8'h35;
         6 : Datas[10] <= 8'h36;
         7 : Datas[10] <= 8'h37;
         8 : Datas[10] <= 8'h38;
         9 : Datas[10] <= 8'h39;
         default : Datas[10] <= 8'h20;  
      endcase

      case (xval3_D3/10)
         0 : Datas[9] <= 8'h30;
         1 : Datas[9] <= 8'h31;
         2 : Datas[9] <= 8'h32;
         3 : Datas[9] <= 8'h33;
         4 : Datas[9] <= 8'h34;
         5 : Datas[9] <= 8'h35;
         6 : Datas[9] <= 8'h36;
         7 : Datas[9] <= 8'h37;
         8 : Datas[9] <= 8'h38;
         9 : Datas[9] <= 8'h39;
         default : Datas[9] <= 8'h20;  
      endcase


      // Max vertical
      Datas[13] <= 8'h20; // space
      Datas[14] <= 8'h56; // V
      Datas[15] <= 8'h3A; // :
      Datas[16] <= 8'h20; // space

      case (xval4_D1%15'd10)
         0 : Datas[20] <= 8'h30;
         1 : Datas[20] <= 8'h31;
         2 : Datas[20] <= 8'h32;
         3 : Datas[20] <= 8'h33;
         4 : Datas[20] <= 8'h34;
         5 : Datas[20] <= 8'h35;
         6 : Datas[20] <= 8'h36;
         7 : Datas[20] <= 8'h37;
         8 : Datas[20] <= 8'h38;
         9 : Datas[20] <= 8'h39;
         default : Datas[20] <= 8'h20;  
      endcase

      case (xval4_D2%15'd10)
         0 : Datas[19] <= 8'h30;
         1 : Datas[19] <= 8'h31;
         2 : Datas[19] <= 8'h32;
         3 : Datas[19] <= 8'h33;
         4 : Datas[19] <= 8'h34;
         5 : Datas[19] <= 8'h35;
         6 : Datas[19] <= 8'h36;
         7 : Datas[19] <= 8'h37;
         8 : Datas[19] <= 8'h38;
         9 : Datas[19] <= 8'h39;
         default : Datas[19] <= 8'h20;  
      endcase

      case (xval4_D3%15'd10)
         0 : Datas[18] <= 8'h30;
         1 : Datas[18] <= 8'h31;
         2 : Datas[18] <= 8'h32;
         3 : Datas[18] <= 8'h33;
         4 : Datas[18] <= 8'h34;
         5 : Datas[18] <= 8'h35;
         6 : Datas[18] <= 8'h36;
         7 : Datas[18] <= 8'h37;
         8 : Datas[18] <= 8'h38;
         9 : Datas[18] <= 8'h39;
         default : Datas[18] <= 8'h20;  
      endcase

      case (xval4_D3/10)
         0 : Datas[17] <= 8'h30;
         1 : Datas[17] <= 8'h31;
         2 : Datas[17] <= 8'h32;
         3 : Datas[17] <= 8'h33;
         4 : Datas[17] <= 8'h34;
         5 : Datas[17] <= 8'h35;
         6 : Datas[17] <= 8'h36;
         7 : Datas[17] <= 8'h37;
         8 : Datas[17] <= 8'h38;
         9 : Datas[17] <= 8'h39;
         default : Datas[17] <= 8'h20;  
      endcase

      // Current horizontal
      Datas[21] <= 8'hC0; // new line
      Datas[22] <= 8'h48; // H
      Datas[23] <= 8'h3A; // :
      Datas[24] <= 8'h20; // space

      case (xval5_D1%15'd10)
         0 : Datas[28] <= 8'h30;
         1 : Datas[28] <= 8'h31;
         2 : Datas[28] <= 8'h32;
         3 : Datas[28] <= 8'h33;
         4 : Datas[28] <= 8'h34;
         5 : Datas[28] <= 8'h35;
         6 : Datas[28] <= 8'h36;
         7 : Datas[28] <= 8'h37;
         8 : Datas[28] <= 8'h38;
         9 : Datas[28] <= 8'h39;
         default : Datas[28] <= 8'h20;  
      endcase

      case (xval5_D2%15'd10)
         0 : Datas[27] <= 8'h30;
         1 : Datas[27] <= 8'h31;
         2 : Datas[27] <= 8'h32;
         3 : Datas[27] <= 8'h33;
         4 : Datas[27] <= 8'h34;
         5 : Datas[27] <= 8'h35;
         6 : Datas[27] <= 8'h36;
         7 : Datas[27] <= 8'h37;
         8 : Datas[27] <= 8'h38;
         9 : Datas[27] <= 8'h39;
         default : Datas[27] <= 8'h20;  
      endcase

      case (xval5_D3%15'd10)
         0 : Datas[26] <= 8'h30;
         1 : Datas[26] <= 8'h31;
         2 : Datas[26] <= 8'h32;
         3 : Datas[26] <= 8'h33;
         4 : Datas[26] <= 8'h34;
         5 : Datas[26] <= 8'h35;
         6 : Datas[26] <= 8'h36;
         7 : Datas[26] <= 8'h37;
         8 : Datas[26] <= 8'h38;
         9 : Datas[26] <= 8'h39;
         default : Datas[26] <= 8'h20;  
      endcase

      case (xval5_D3/10)
         0 : Datas[25] <= 8'h30;
         1 : Datas[25] <= 8'h31;
         2 : Datas[25] <= 8'h32;
         3 : Datas[25] <= 8'h33;
         4 : Datas[25] <= 8'h34;
         5 : Datas[25] <= 8'h35;
         6 : Datas[25] <= 8'h36;
         7 : Datas[25] <= 8'h37;
         8 : Datas[25] <= 8'h38;
         9 : Datas[25] <= 8'h39;
         default : Datas[25] <= 8'h20;  
      endcase


      // Current vertical
      Datas[29] <= 8'h20; // space
      Datas[30] <= 8'h56; // V
      Datas[31] <= 8'h3A; // :
      Datas[32] <= 8'h20; // space

      case (xval6_D1%15'd10)
         0 : Datas[36] <= 8'h30;
         1 : Datas[36] <= 8'h31;
         2 : Datas[36] <= 8'h32;
         3 : Datas[36] <= 8'h33;
         4 : Datas[36] <= 8'h34;
         5 : Datas[36] <= 8'h35;
         6 : Datas[36] <= 8'h36;
         7 : Datas[36] <= 8'h37;
         8 : Datas[36] <= 8'h38;
         9 : Datas[36] <= 8'h39;
         default : Datas[36] <= 8'h20;  
      endcase

      case (xval6_D2%15'd10)
         0 : Datas[35] <= 8'h30;
         1 : Datas[35] <= 8'h31;
         2 : Datas[35] <= 8'h32;
         3 : Datas[35] <= 8'h33;
         4 : Datas[35] <= 8'h34;
         5 : Datas[35] <= 8'h35;
         6 : Datas[35] <= 8'h36;
         7 : Datas[35] <= 8'h37;
         8 : Datas[35] <= 8'h38;
         9 : Datas[35] <= 8'h39;
         default : Datas[35] <= 8'h20;  
      endcase

      case (xval6_D3%15'd10)
         0 : Datas[34] <= 8'h30;
         1 : Datas[34] <= 8'h31;
         2 : Datas[34] <= 8'h32;
         3 : Datas[34] <= 8'h33;
         4 : Datas[34] <= 8'h34;
         5 : Datas[34] <= 8'h35;
         6 : Datas[34] <= 8'h36;
         7 : Datas[34] <= 8'h37;
         8 : Datas[34] <= 8'h38;
         9 : Datas[34] <= 8'h39;
         default : Datas[34] <= 8'h20;  
      endcase

      case (xval6_D3/10)
         0 : Datas[33] <= 8'h30;
         1 : Datas[33] <= 8'h31;
         2 : Datas[33] <= 8'h32;
         3 : Datas[33] <= 8'h33;
         4 : Datas[33] <= 8'h34;
         5 : Datas[33] <= 8'h35;
         6 : Datas[33] <= 8'h36;
         7 : Datas[33] <= 8'h37;
         8 : Datas[33] <= 8'h38;
         9 : Datas[33] <= 8'h39;
         default : Datas[33] <= 8'h20;  
      endcase

   end

   // Angel mode
   else if (ANG == 1'b1) begin

      // Max horizontal
      Datas[6] <= 8'h48; // H
      Datas[7] <= 8'h3A; // :
      Datas[8] <= 8'h20; // space

      Datas[12] <= 8'h44; // D

      case (xval7_D2%15'd10)
         0 : Datas[11] <= 8'h30;
         1 : Datas[11] <= 8'h31;
         2 : Datas[11] <= 8'h32;
         3 : Datas[11] <= 8'h33;
         4 : Datas[11] <= 8'h34;
         5 : Datas[11] <= 8'h35;
         6 : Datas[11] <= 8'h36;
         7 : Datas[11] <= 8'h37;
         8 : Datas[11] <= 8'h38;
         9 : Datas[11] <= 8'h39;
         default : Datas[11] <= 8'h20;  
      endcase

      case (xval7_D3%15'd10)
         0 : Datas[10] <= 8'h30;
         1 : Datas[10] <= 8'h31;
         2 : Datas[10] <= 8'h32;
         3 : Datas[10] <= 8'h33;
         4 : Datas[10] <= 8'h34;
         5 : Datas[10] <= 8'h35;
         6 : Datas[10] <= 8'h36;
         7 : Datas[10] <= 8'h37;
         8 : Datas[10] <= 8'h38;
         9 : Datas[10] <= 8'h39;
         default : Datas[10] <= 8'h20;  
      endcase

      case (xval7_D3/10)
         0 : Datas[9] <= 8'h30;
         1 : Datas[9] <= 8'h31;
         2 : Datas[9] <= 8'h32;
         3 : Datas[9] <= 8'h33;
         4 : Datas[9] <= 8'h34;
         5 : Datas[9] <= 8'h35;
         6 : Datas[9] <= 8'h36;
         7 : Datas[9] <= 8'h37;
         8 : Datas[9] <= 8'h38;
         9 : Datas[9] <= 8'h39;
         default : Datas[9] <= 8'h20;  
      endcase


      // Max vertical
      Datas[13] <= 8'h20; // space
      Datas[14] <= 8'h56; // V
      Datas[15] <= 8'h3A; // :
      Datas[16] <= 8'h20; // space

      Datas[20] <= 8'h44; // D

      case (xval8_D2%15'd10)
         0 : Datas[19] <= 8'h30;
         1 : Datas[19] <= 8'h31;
         2 : Datas[19] <= 8'h32;
         3 : Datas[19] <= 8'h33;
         4 : Datas[19] <= 8'h34;
         5 : Datas[19] <= 8'h35;
         6 : Datas[19] <= 8'h36;
         7 : Datas[19] <= 8'h37;
         8 : Datas[19] <= 8'h38;
         9 : Datas[19] <= 8'h39;
         default : Datas[19] <= 8'h20;  
      endcase

      case (xval8_D3%15'd10)
         0 : Datas[18] <= 8'h30;
         1 : Datas[18] <= 8'h31;
         2 : Datas[18] <= 8'h32;
         3 : Datas[18] <= 8'h33;
         4 : Datas[18] <= 8'h34;
         5 : Datas[18] <= 8'h35;
         6 : Datas[18] <= 8'h36;
         7 : Datas[18] <= 8'h37;
         8 : Datas[18] <= 8'h38;
         9 : Datas[18] <= 8'h39;
         default : Datas[18] <= 8'h20;  
      endcase

      case (xval8_D3/10)
         0 : Datas[17] <= 8'h30;
         1 : Datas[17] <= 8'h31;
         2 : Datas[17] <= 8'h32;
         3 : Datas[17] <= 8'h33;
         4 : Datas[17] <= 8'h34;
         5 : Datas[17] <= 8'h35;
         6 : Datas[17] <= 8'h36;
         7 : Datas[17] <= 8'h37;
         8 : Datas[17] <= 8'h38;
         9 : Datas[17] <= 8'h39;
         default : Datas[17] <= 8'h20;  
      endcase

      // Current horizontal
      Datas[21] <= 8'hC0; // new line
      Datas[22] <= 8'h48; // H
      Datas[23] <= 8'h3A; // :
      Datas[24] <= 8'h20; // space

      Datas[28] <= 8'h44; // D

      case (xval9_D2%15'd10)
         0 : Datas[27] <= 8'h30;
         1 : Datas[27] <= 8'h31;
         2 : Datas[27] <= 8'h32;
         3 : Datas[27] <= 8'h33;
         4 : Datas[27] <= 8'h34;
         5 : Datas[27] <= 8'h35;
         6 : Datas[27] <= 8'h36;
         7 : Datas[27] <= 8'h37;
         8 : Datas[27] <= 8'h38;
         9 : Datas[27] <= 8'h39;
         default : Datas[27] <= 8'h20;  
      endcase

      case (xval9_D3%15'd10)
         0 : Datas[26] <= 8'h30;
         1 : Datas[26] <= 8'h31;
         2 : Datas[26] <= 8'h32;
         3 : Datas[26] <= 8'h33;
         4 : Datas[26] <= 8'h34;
         5 : Datas[26] <= 8'h35;
         6 : Datas[26] <= 8'h36;
         7 : Datas[26] <= 8'h37;
         8 : Datas[26] <= 8'h38;
         9 : Datas[26] <= 8'h39;
         default : Datas[26] <= 8'h20;  
      endcase

      case (xval9_D3/10)
         0 : Datas[25] <= 8'h30;
         1 : Datas[25] <= 8'h31;
         2 : Datas[25] <= 8'h32;
         3 : Datas[25] <= 8'h33;
         4 : Datas[25] <= 8'h34;
         5 : Datas[25] <= 8'h35;
         6 : Datas[25] <= 8'h36;
         7 : Datas[25] <= 8'h37;
         8 : Datas[25] <= 8'h38;
         9 : Datas[25] <= 8'h39;
         default : Datas[25] <= 8'h20;  
      endcase


      // Current vertical
      Datas[29] <= 8'h20; // space
      Datas[30] <= 8'h56; // V
      Datas[31] <= 8'h3A; // :
      Datas[32] <= 8'h20; // space

      Datas[36] <= 8'h44; // D

      case (xval10_D2%15'd10)
         0 : Datas[35] <= 8'h30;
         1 : Datas[35] <= 8'h31;
         2 : Datas[35] <= 8'h32;
         3 : Datas[35] <= 8'h33;
         4 : Datas[35] <= 8'h34;
         5 : Datas[35] <= 8'h35;
         6 : Datas[35] <= 8'h36;
         7 : Datas[35] <= 8'h37;
         8 : Datas[35] <= 8'h38;
         9 : Datas[35] <= 8'h39;
         default : Datas[35] <= 8'h20;  
      endcase

      case (xval10_D3%15'd10)
         0 : Datas[34] <= 8'h30;
         1 : Datas[34] <= 8'h31;
         2 : Datas[34] <= 8'h32;
         3 : Datas[34] <= 8'h33;
         4 : Datas[34] <= 8'h34;
         5 : Datas[34] <= 8'h35;
         6 : Datas[34] <= 8'h36;
         7 : Datas[34] <= 8'h37;
         8 : Datas[34] <= 8'h38;
         9 : Datas[34] <= 8'h39;
         default : Datas[34] <= 8'h20;  
      endcase

      case (xval10_D3/10)
         0 : Datas[33] <= 8'h30;
         1 : Datas[33] <= 8'h31;
         2 : Datas[33] <= 8'h32;
         3 : Datas[33] <= 8'h33;
         4 : Datas[33] <= 8'h34;
         5 : Datas[33] <= 8'h35;
         6 : Datas[33] <= 8'h36;
         7 : Datas[33] <= 8'h37;
         8 : Datas[33] <= 8'h38;
         9 : Datas[33] <= 8'h39;
         default : Datas[33] <= 8'h20;  
      endcase
   end

   else begin

      // Normal mode
      if (HS == 1'b1 || VS == 1'b1 || MC == 1'b1) begin

         Datas[6] <= 8'h43; // C
         Datas[7] <= 8'h41; // A
         Datas[8] <= 8'h4C; // L
         Datas[9] <= 8'h49; // I
         Datas[10] <= 8'h42; // B
         Datas[11] <= 8'h52; // R
         Datas[12] <= 8'h41; // A
         Datas[13] <= 8'h54; // T
         Datas[14] <= 8'h49; // I
         Datas[15] <= 8'h4E; // N
         Datas[16] <= 8'h47; // G
         Datas[17] <= 8'h20; // space
         Datas[18] <= 8'h20;
         Datas[19] <= 8'h20;
         Datas[20] <= 8'h20;

      end
      else begin

         Datas[6] <= 8'h4D; // M
         Datas[7] <= 8'h41; // A
         Datas[8] <= 8'h4E; // N
         Datas[9] <= 8'h55; // U
         Datas[10] <= 8'h41; // A
         Datas[11] <= 8'h4C; // L
         Datas[12] <= 8'h20; // space
         Datas[13] <= 8'h43; // C
         Datas[14] <= 8'h54; // T
         Datas[15] <= 8'h52; // R
         Datas[16] <= 8'h4C; // L
         Datas[17] <= 8'h20; // space
         Datas[18] <= 8'h20;
         Datas[19] <= 8'h20;
         Datas[20] <= 8'h20;

      end

      // Max voltage
      Datas[21] <= 8'hC0; // new line
      Datas[22] <= 8'h4D; // M
      Datas[23] <= 8'h3A; // :
      Datas[24] <= 8'h20; // space
      Datas[26] <= 8'h2E; // period

      case (xval_D1%12'd10)
         0 : Datas[28] <= 8'h30;
         1 : Datas[28] <= 8'h31;
         2 : Datas[28] <= 8'h32;
         3 : Datas[28] <= 8'h33;
         4 : Datas[28] <= 8'h34;
         5 : Datas[28] <= 8'h35;
         6 : Datas[28] <= 8'h36;
         7 : Datas[28] <= 8'h37;
         8 : Datas[28] <= 8'h38;
         9 : Datas[28] <= 8'h39;
         default : Datas[28] <= 8'h20;  
      endcase

      case (xval_D2%12'd10)
         0 : Datas[27] <= 8'h30;
         1 : Datas[27] <= 8'h31;
         2 : Datas[27] <= 8'h32;
         3 : Datas[27] <= 8'h33;
         4 : Datas[27] <= 8'h34;
         5 : Datas[27] <= 8'h35;
         6 : Datas[27] <= 8'h36;
         7 : Datas[27] <= 8'h37;
         8 : Datas[27] <= 8'h38;
         9 : Datas[27] <= 8'h39;
         default : Datas[27] <= 8'h20;  
      endcase

      case (xval_D2/12'd10)
         0 : Datas[25] <= 8'h30;
         1 : Datas[25] <= 8'h31;
         2 : Datas[25] <= 8'h32;
         3 : Datas[25] <= 8'h33;
         4 : Datas[25] <= 8'h34;
         5 : Datas[25] <= 8'h35;
         6 : Datas[25] <= 8'h36;
         7 : Datas[25] <= 8'h37;
         8 : Datas[25] <= 8'h38;
         9 : Datas[25] <= 8'h39;
         default : Datas[25] <= 8'h20;  
      endcase

      // Current voltage
      Datas[29] <= 8'h20; // space
      Datas[30] <= 8'h56; // V
      Datas[31] <= 8'h3A; // :
      Datas[32] <= 8'h20; // space
      Datas[34] <= 8'h2E; // period

      case (xval2_D1%12'd10)
         0 : Datas[36] <= 8'h30;
         1 : Datas[36] <= 8'h31;
         2 : Datas[36] <= 8'h32;
         3 : Datas[36] <= 8'h33;
         4 : Datas[36] <= 8'h34;
         5 : Datas[36] <= 8'h35;
         6 : Datas[36] <= 8'h36;
         7 : Datas[36] <= 8'h37;
         8 : Datas[36] <= 8'h38;
         9 : Datas[36] <= 8'h39;
         default : Datas[36] <= 8'h20;  
      endcase

      case (xval2_D2%12'd10)
         0 : Datas[35] <= 8'h30;
         1 : Datas[35] <= 8'h31;
         2 : Datas[35] <= 8'h32;
         3 : Datas[35] <= 8'h33;
         4 : Datas[35] <= 8'h34;
         5 : Datas[35] <= 8'h35;
         6 : Datas[35] <= 8'h36;
         7 : Datas[35] <= 8'h37;
         8 : Datas[35] <= 8'h38;
         9 : Datas[35] <= 8'h39;
         default : Datas[35] <= 8'h20;  
      endcase

      case (xval2_D2/12'd10)
         0 : Datas[33] <= 8'h30;
         1 : Datas[33] <= 8'h31;
         2 : Datas[33] <= 8'h32;
         3 : Datas[33] <= 8'h33;
         4 : Datas[33] <= 8'h34;
         5 : Datas[33] <= 8'h35;
         6 : Datas[33] <= 8'h36;
         7 : Datas[33] <= 8'h37;
         8 : Datas[33] <= 8'h38;
         9 : Datas[33] <= 8'h39;
         default : Datas[33] <= 8'h20;  
      endcase

   end

   // Binary
   // Datas[6] <= 8'h42; // B
   // Datas[7] <= 8'h3A; // : 
   // Datas[8] <= 8'h20; // space
   //
   // if(V_in[11] == 1)
   // Datas[9] <= 8'h31;
   // else Datas[9] <= 8'h30;
   //
   // if(V_in[10] == 1)
   // Datas[10] <= 8'h31;
   // else Datas[10] <= 8'h30;
   //
   // if(V_in[9] == 1)
   // Datas[11] <= 8'h31;
   // else Datas[11] <= 8'h30;
   //
   // if(V_in[8] == 1)
   // Datas[12] <= 8'h31;
   // else Datas[12] <= 8'h30;
   //
   // if(V_in[7] == 1)
   // Datas[13] <= 8'h31;
   // else Datas[13] <= 8'h30;
   //
   // if(V_in[6] == 1)
   // Datas[14] <= 8'h31;
   // else Datas[14] <= 8'h30;
   //
   // if(V_in[5] == 1)
   // Datas[15] <= 8'h31;
   // else Datas[15] <= 8'h30;
   //
   // if(V_in[4] == 1)
   // Datas[16] <= 8'h31;
   // else Datas[16] <= 8'h30;
   //
   // if(V_in[3] == 1)
   // Datas[17] <= 8'h31;
   // else Datas[17] <= 8'h30;
   //
   // if(V_in[2] == 1)
   // Datas[18] <= 8'h31;
   // else Datas[18] <= 8'h30;
   //
   // if(V_in[1] == 1)
   // Datas[19] <= 8'h31;
   // else Datas[19] <= 8'h30;
   //
   // if(V_in[0] == 1)
   // Datas[20] <= 8'h31;
   // else Datas[20] <= 8'h30;

end

`ifdef TB_MODE
always @(posedge CLK) begin

   if (i <= 17'd500) begin
      i <= i + 1; EN_OUT <= 1'b1;
      data <= Datas[j];
   end

   else if (i > 17'd500 & i < 17'd1000) begin
      i <= i + 1; EN_OUT <= 1'b0;
   end

   else if (i == 17'd1000) begin
      j <= j + 1; i <= 0;
   end

   else i <= 0;

   if (j <= 5) RS <= 0;             // sets register select to instruction mode

   else if (j > 5 & j< 21) RS <= 1; // sets register select to character mode

   else if (j == 21) RS <= 0;

   else if (j > 21 & j < 37) RS <= 1;

   else if (j == 37) begin 
      RS <= 1; j <= 5;

   end

end

`elsif

always @(posedge CLK) begin

   if (i <= 17'd50000) begin
      i <= i + 1; EN_OUT <= 1'b1;
      data <= Datas[j];
   end

   else if (i > 17'd50000 & i < 17'd100000) begin
      i <= i + 1; EN_OUT <= 1'b0;
   end

   else if (i == 17'd100000) begin
      j <= j + 1; i <= 0;
   end

   else i <= 0;

   if (j <= 5) RS <= 0;             // sets register select to instruction mode

   else if (j > 5 & j< 21) RS <= 1; // sets register select to character mode

   else if (j == 21) RS <= 0;

   else if (j > 21 & j < 37) RS <= 1;

   else if (j == 37) begin 
      RS <= 1; j <= 5;

   end

end

`endif

endmodule
