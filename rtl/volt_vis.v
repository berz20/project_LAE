//--------------------------------------------------------------------------------
// Module Name: volt_vis - Behavioral
// Project Name: 
// Target Devices: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments:
// 
//--------------------------------------------------------------------------------

module volt_vis(
input wire CLK,
input wire V_in,
input wire V_out,
output wire [9:0] V_value,
output wire [3:0] DISP_EN,
output wire [7:0] SSD
);

wire valid; wire sign;
wire [15:0] value;

  assign valid = 1'b1;
  assign sign = 1'b0;
  assign V_value = value[15:6];
  // adc adc0(
  //     .V_in(V_in),
  //   .V_out(V_out),
  //   .clk(CLK),
  //   .d_rdy(/* open */),
  //   .do_out(value));

  //15:4 2^10
  sseg_dec sseg0(
      .ALU_VAL(value[15:6]),
    .SIGN(sign),
    .VALID(valid),
    .CLK(CLK),
    .DISP_EN(DISP_EN),
    .SEGMENTS(SSD));


endmodule
