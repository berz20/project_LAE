`timescale 1ns / 1 ps


module xadc
     (
          daddr_in,            // Address bus for the dynamic reconfiguration port
          dclk_in,             // Clock input for the dynamic reconfiguration port
          den_in,              // Enable Signal for the dynamic reconfiguration port
          di_in,               // Input data bus for the dynamic reconfiguration port
          dwe_in,              // Write Enable for the dynamic reconfiguration port
          reset_in,            // Reset signal for the System Monitor control logic
          vauxp0,              // Auxiliary channel 0
          vauxn0,
          busy_out,            // ADC Busy signal
          channel_out,         // Channel Selection Outputs
          adc_out,              // Output data bus for dynamic reconfiguration port
          drdy_out,            // Data ready signal for the dynamic reconfiguration port
          eoc_out,             // End of Conversion Signal
          eos_out,             // End of Sequence Signal
          alarm_out,           
          vp_in,               // Dedicated Analog Input Pair
          vn_in);
     
   input  wire vp_in;
   input  wire vn_in;
   input  wire [6:0] daddr_in;
   input  wire dclk_in;
   input  wire den_in;
   input  wire [15:0] di_in;
   input  wire dwe_in;
   input  wire reset_in;
   input  wire vauxp0;
   input  wire vauxn0;
   output wire busy_out;
   output wire [4:0] channel_out;
   output reg  [11:0] adc_out;
   output wire drdy_out;
   output wire eoc_out;
   output wire eos_out;
   output wire alarm_out;

   wire [15:0] do_out;
   wire GND_BIT;
   wire [2:0] GND_BUS3;
    
   wire FLOAT_VCCAUX;
     
   wire FLOAT_VCCINT;
     
   wire FLOAT_USER_TEMP_ALARM;

   reg rst_sync;
   reg rst_sync_int;
   reg rst_sync_int1;
   reg rst_sync_int2;

   assign GND_BIT = 0;
   assign GND_BUS3 = 3'b000;

     always @(posedge reset_in or posedge dclk_in) begin
       if (reset_in) begin
            rst_sync <= 1'b1;
            rst_sync_int <= 1'b1;
            rst_sync_int1 <= 1'b1;
            rst_sync_int2 <= 1'b1;
       end
       else begin
            rst_sync <= 1'b0;
            rst_sync_int <= rst_sync;     
            rst_sync_int1 <= rst_sync_int; 
            rst_sync_int2 <= rst_sync_int1;
       end
    end

    always @ (posedge dclk_in) begin
      if (drdy_out)
         adc_out <= do_out[15:4];
    end


xadc_wiz_0
xadc_inst (
      .daddr_in(daddr_in[6:0]),
      .dclk_in(dclk_in),
      .den_in(den_in),
      .di_in(di_in[15:0]),
      .dwe_in(dwe_in),
      .reset_in(rst_sync_int2),
      .vauxp0(vauxp0), 
      .vauxn0(vauxn0),
      .busy_out(busy_out),
      .channel_out(channel_out[4:0]),
      .do_out(do_out[15:0]),
      .drdy_out(drdy_out),
      .eoc_out(eoc_out),
      .eos_out(eos_out),
      .alarm_out(alarm_out),
      .vp_in(vp_in),
      .vn_in(vn_in)
      );
endmodule
