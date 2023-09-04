`timescale 1ps/1ps
`define wait_eoc @(negedge EOC_TB)
`define wait_eoc_p @(posedge EOC_TB)
`define wait_eos @(posedge EOS_TB)
`define wait_drdy @(negedge DRDY_TB)
`define wait_drdy_p @(posedge DRDY_TB)
`define wait_done @(posedge BUSY_TB)
`define wait_busy @(negedge BUSY_TB)
module tb_xadc ();

  // timescale is 1ps/1ps
  localparam  ONE_NS      = 1000;
   integer    count       = 0   ;
  wire EOC_TB;
  wire EOS_TB;

// Input clock generation



  localparam time PER1    = 10*ONE_NS;
  // Declare the input clock signals
  reg         DCLK_TB     = 0;


  reg [6:0] DADDR_TB;
  reg DEN_TB;
  reg DWE_TB;
  reg [15:0] DI_TB;
  wire [15:0] DO_TB;
  wire DRDY_TB;
  reg RESET_TB;
  wire [2:0] ALM_unused;
  wire ALARM_OUT_TB;
  wire FLOAT_VCCAUX_ALARM;
  wire FLOAT_VCCINT_ALARM;
  wire FLOAT_USER_TEMP_ALARM;
  wire BUSY_TB;
  wire [4:0] CHANNEL_TB;

// Input clock generation

always begin
  DCLK_TB = #(PER1/2) ~DCLK_TB;
end


always @(posedge DCLK_TB or posedge RESET_TB)
begin
  if (RESET_TB) begin
   DADDR_TB = 7'b0000000; //{2'b00, CHANNEL_TB};
   DI_TB = 16'b0000000000000000;
   DWE_TB = 1'b0;
   DEN_TB = 1'b0; //EOC_TB;
  end
  else begin
   DADDR_TB = {2'b00, CHANNEL_TB};
   DI_TB = 16'b0000000000000000;
   DWE_TB = 1'b0;
   DEN_TB = EOC_TB;
  end
end

initial
begin
  $display ("Timing checks are not valid");
  assign RESET_TB = 1'b1;
  #(10*PER1);
  assign RESET_TB = 1'b0;
  #(100000*PER1);
  $finish;
end




// Start of the testbench


reg IF_RD_CNT = 1'b0;




reg [11:0] Analog_Wave_Single_Ch;

always @ (posedge DCLK_TB)
begin
  if (DRDY_TB)
    Analog_Wave_Single_Ch <= DO_TB[15:4];
end   

  // Instantiation of the example design
  //---------------------------------------------------------
  xadc dut (
     .daddr_in(DADDR_TB[6:0]),
     .dclk_in(~DCLK_TB),
     .den_in(DEN_TB),
     .di_in(DI_TB[15:0]),
     .dwe_in(DWE_TB),
     .do_out(DO_TB[15:0]),
     .drdy_out(DRDY_TB),
     .reset_in(RESET_TB),
     .vauxp0(1'b0),      // Stimulus for Channels is applied from the SIM_MONITOR_FILE
     .vauxn0(1'b0),
     .busy_out(BUSY_TB),
     .channel_out(CHANNEL_TB[4:0]),
     .eoc_out(EOC_TB),
     .eos_out(EOS_TB),
     .alarm_out(ALARM_OUT_TB),
     .vp_in(1'b0),
     .vn_in(1'b0)

         );

endmodule



