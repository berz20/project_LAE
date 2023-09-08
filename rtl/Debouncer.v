`timescale 1ns / 100ps

module Debouncer #(parameter integer DEBOUNCE_TIME = 5000) (
   input wire clk,
   input wire rst,
   input wire btn,           // Segnale del pulsante da stabilizzare
   output wire debounced_btn // Segnale del pulsante stabilizzato
);

wire tick;

TickCounterRst #(DEBOUNCE_TIME) debounce_counter (
   .clk(clk),
   .rst(rst), // segnale di reset esterno
   .tick(tick)
);

reg btn_buffer = 1'b0; // Buffer del pulsante

always @(posedge clk) begin
   if (tick) begin
      btn_buffer <= btn;
   end
end

assign debounced_btn = btn_buffer;

endmodule
