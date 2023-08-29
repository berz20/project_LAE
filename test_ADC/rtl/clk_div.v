//---------------------------------------------------------------------
// Module to divide the clock
//---------------------------------------------------------------------
// no timescale needed

`timescale 1 ns / 100 ps

module clk_div(
   input wire clk,
   output reg sclk
);

parameter MAX_COUNT = 244;
reg tmp_clk = 1'b0;
integer div_cnt = 0;

always @(clk,tmp_clk) begin : P1

   if(clk==1) begin
      if((div_cnt == MAX_COUNT)) begin
         tmp_clk <=  ~tmp_clk;
         div_cnt <= 0;
      end
      else begin
         div_cnt <= div_cnt + 1;
      end
      sclk <= tmp_clk;
   end
end

endmodule