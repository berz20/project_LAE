//----------------------------------------------------------------------
// Description: Special seven segment display driver;
//
// interface description for bin to bcd converter
//------------------------------------------------------------------

module bin2bcdconv(
   input  wire [9:0] BIN_CNT_IN,
   output reg  [3:0] LSD_OUT,
   output reg  [3:0] MSD_OUT,
   output reg  [3:0] MMSD_OUT,
   output reg  [3:0] MMMSD_OUT
);


//-------------------------------------------------------------------
// description of 8-bit binary to 3-digit BCD converter
//-------------------------------------------------------------------

integer cnt_tot = 0;
integer MMMSD, MMSD, MSD, LSD = 0;

integer i;

always @(BIN_CNT_IN) begin : P1

   // convert input binary value to decimal
   cnt_tot <= 0;

   if((BIN_CNT_IN[9] == 1'b1)) begin
      cnt_tot <= cnt_tot + 512;
   end
   if((BIN_CNT_IN[8] == 1'b1)) begin
      cnt_tot <= cnt_tot + 256;
   end
   if((BIN_CNT_IN[7] == 1'b1)) begin
      cnt_tot <= cnt_tot + 128;
   end
   if((BIN_CNT_IN[6] == 1'b1)) begin
      cnt_tot <= cnt_tot + 64;
   end
   if((BIN_CNT_IN[5] == 1'b1)) begin
      cnt_tot <= cnt_tot + 32;
   end
   if((BIN_CNT_IN[4] == 1'b1)) begin
      cnt_tot <= cnt_tot + 16;
   end
   if((BIN_CNT_IN[3] == 1'b1)) begin
      cnt_tot <= cnt_tot + 8;
   end
   if((BIN_CNT_IN[2] == 1'b1)) begin
      cnt_tot <= cnt_tot + 4;
   end
   if((BIN_CNT_IN[1] == 1'b1)) begin
      cnt_tot <= cnt_tot + 2;
   end
   if((BIN_CNT_IN[0] == 1'b1)) begin
      cnt_tot <= cnt_tot + 1;
   end
   // initialize intermediate signals
   MMMSD <= 0;
   MMSD <= 0;
   MSD <= 0;
   LSD <= 0;
   // calculate the MMMSD
   if (cnt_tot >= 1000) begin
      MMMSD <= 1;
      cnt_tot <= cnt_tot - 1000;
   end

   // calculate the MMSB

   for (i = 0; i < 9; i=i+1) begin
      if (cnt_tot >= 0 && cnt_tot <100) break; 
      MMSD <= MMSD + 1; // increment the mmds count
   cnt_tot <= cnt_tot - 100;
end

// calculate the MSB
for (i = 0; i < 9; i=i+1) begin
   if (cnt_tot >= 0 && cnt_tot <10) break; 
   MSD <= MSD + 1; // increment the mds count
cnt_tot <= cnt_tot - 10;
   end

   LSD <= cnt_tot;
   // LSD is what is left over

   // -- convert LSD to binary
   case (LSD)
      9: LSD_OUT <= 4'b1001;
      8: LSD_OUT <= 4'b1000;
      7: LSD_OUT <= 4'b0111;
      6: LSD_OUT <= 4'b0110;
      5: LSD_OUT <= 4'b0101;
      4: LSD_OUT <= 4'b0100;
      3: LSD_OUT <= 4'b0011;
      2: LSD_OUT <= 4'b0010;
      1: LSD_OUT <= 4'b0001;
      0: LSD_OUT <= 4'b0000;
      default: LSD_OUT <= 4'b0000;
   endcase
   // convert MSD to binary
   case (MSD)
      9: MSD_OUT <= 4'b1001;
      8: MSD_OUT <= 4'b1000;
      7: MSD_OUT <= 4'b0111;
      6: MSD_OUT <= 4'b0110;
      5: MSD_OUT <= 4'b0101;
      4: MSD_OUT <= 4'b0100;
      3: MSD_OUT <= 4'b0011;
      2: MSD_OUT <= 4'b0010;
      1: MSD_OUT <= 4'b0001;
      0: MSD_OUT <= 4'b0000;
      default: MSD_OUT <= 4'b0000;
   endcase

   // convert MMSD to binary
   case (MMSD)
      9: MMSD_OUT <= 4'b1001;
      8: MMSD_OUT <= 4'b1000;
      7: MMSD_OUT <= 4'b0111;
      6: MMSD_OUT <= 4'b0110;
      5: MMSD_OUT <= 4'b0101;
      4: MMSD_OUT <= 4'b0100;
      3: MMSD_OUT <= 4'b0011;
      2: MMSD_OUT <= 4'b0010;
      1: MMSD_OUT <= 4'b0001;
      0: MMSD_OUT <= 4'b0000;
      default: MMSD_OUT <= 4'b0000;
   endcase

   // convert MMSD
   case (MMMSD)
      1: MMMSD_OUT <= 4'b0001;
      0: MMMSD_OUT <= 4'b0000;
      default: MMMSD_OUT <= 4'b0000;
   endcase
end

endmodule
