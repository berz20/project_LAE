//--------------------------------------------------------------------------------
// Module Name: max_counter - Behavioral
// Project Name: 
// Target Devices: 
// Description: Special seven segment display driver;
//              4 digit seven-segment display driver. Outputs are active
//              low and configured ABCEDFG in "segment" output. 
//
//  two special inputs: 
// 
//      VALID: if VALID = 0, four dashes will be display
//             if VALID = 1, decimal number appears on display
//
//       SIGN: if SIGN = 1, a minus SIGN appears in left-most digit
//             if SIGN = 0, no minus SIGN appears
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module sseg_dec(
   input wire [9:0] ALU_VAL,
   input wire SIGN,
   input wire VALID,
   input wire CLK,
   output wire [3:0] DISP_EN,
   output wire [7:0] SEGMENTS
);




//-----------------------------------------------------------
// description of ssegment decoder
//-----------------------------------------------------------
// declaration of 8-bit binary to 2-digit BCD converter --
// intermediate signal declaration -----------------------
reg [1:0] cnt_dig;
reg [3:0] digit;
wire [3:0] lsd; wire [3:0] msd; wire [3:0] mmsd; wire [3:0] mmmsd;
wire SCLK;

// instantiation of bin to bcd converter -----------------
bin2bcdconv my_conv(
.BIN_CNT_IN(ALU_VAL),
.LSD_OUT(lsd),
.MSD_OUT(msd),
.MMSD_OUT(mmsd),
.MMMSD_OUT(mmmsd));

  clk_div my_clk(
     .clk(CLK),
     .sclk(SCLK));

  // advance the count (used for display multiplexing) -----
  always @(posedge SCLK) begin
     cnt_dig <= cnt_dig + 1;
  end

  // select the display sseg data abcdefg (active low) -----
  assign segments = digit == 4'b0000 ? 8'b00000011 : digit == 4'b0001 ? 8'b10011111 : digit == 4'b0010 ? 8'b00100101 : digit == 4'b0011 ? 8'b00001101 : digit == 4'b0100 ? 8'b10011001 : digit == 4'b0101 ? 8'b01001001 : digit == 4'b0110 ? 8'b01000001 : digit == 4'b0111 ? 8'b00011111 : digit == 4'b1000 ? 8'b00000001 : digit == 4'b1001 ? 8'b00001001 : digit == 4'b1110 ? 8'b11111101 : digit == 4'b1110 ? 8'b11111111 : 8'b11111111;
  // actuate the correct display --------------------------
  assign disp_en = cnt_dig == 2'b00 ? 4'b1110 : cnt_dig == 2'b01 ? 4'b1101 : cnt_dig == 2'b10 ? 4'b1011 : cnt_dig == 2'b11 ? 4'b0111 : 4'b1111;
  always @(cnt_dig, lsd, msd, mmsd, mmmsd, SIGN, VALID) begin : P1
     reg [3:0] mmmsd_v, mmsd_v, msd_v;

     mmmsd_v = mmmsd;
     mmsd_v = mmsd;
     msd_v = msd;
     // do the lead zero blanking for two msb's
     if((mmmsd_v == 4'h0)) begin
        if((mmsd_v == 4'h0)) begin
           if((msd_v == 4'h0)) begin
              msd_v = 4'hF;
           end
           mmsd_v = 4'hF;
        end
        mmmsd_v = 4'hF;
     end
     if((VALID == 1'b1)) begin
        if((SIGN == 1'b0)) begin
           case(cnt_dig)
              2'b00 : begin
                 digit <= mmmsd_v;
              end
              2'b01 : begin
                 digit <= mmsd_v;
              end
              2'b10 : begin
                 digit <= msd_v;
              end
              2'b11 : begin
                 digit <= lsd;
              end
              default : begin
                 digit <= 4'b0000;
              end
           endcase
        end
        else begin
           case(cnt_dig)
              2'b00 : begin
                 digit <= 4'b1110;
              end
              2'b01 : begin
                 digit <= mmsd_v;
              end
              2'b10 : begin
                 digit <= msd_v;
              end
              2'b11 : begin
                 digit <= lsd;
              end
              default : begin
                 digit <= 4'b0000;
              end
           endcase
        end
     end
     else begin
        digit <= 4'b1110;
     end
  end

  endmodule
