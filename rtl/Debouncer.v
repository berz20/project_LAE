//--------------------------------------------------------------------------------

// Module Name: Debouncer
// Project Name: Solar Tracker
// Target Devices: xc7a35ticsg324-1L (Arty A7) 
// Description: Module to debounce button signals
//
// Dependencies: - TickCounter.v
//
// Additional Comments:
//
//--------------------------------------------------------------------------------

`timescale 1ns / 100ps

module Debouncer #(parameter integer DEBOUNCE_TIME = 5000) (

   input wire clk,
   input wire rst,
   // Signal to be stabilized
   input wire btn,
   
   // Stabilized signal
   output wire debounced_btn
);

wire tick;

TickCounterRst #(DEBOUNCE_TIME) debounce_counter (
   .clk(clk),
   .rst(rst),
   .tick(tick)
);

reg btn_buffer = 1'b0; // Signal buffer

always @(posedge clk) begin
   if (tick) begin
      btn_buffer <= btn;
   end
end

assign debounced_btn = btn_buffer;

endmodule
