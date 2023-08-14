`timescale 1ns / 100ps

module tb_xadc;

// Inputs
reg AdcClk;
reg AdcSoc;
// Outputs
wire AdcEoc;
wire [11:0] AdcData;

// Instantiate the XADC module
XADC xadc_inst (
    .AdcClk(AdcClk),
    .AdcSoc(AdcSoc),
    .AdcEoc(AdcEoc),
    .AdcData(AdcData)
);

// Clock generation
reg clk = 0;
always #5 clk = ~clk;

// Initialize inputs
initial begin
    AdcClk = 0;
    AdcSoc = 0;

    // Start an ADC conversion
    AdcSoc = 1;
    #10;
    AdcSoc = 0;

    // Wait for conversion to complete
    repeat (100) @clk;

    // Display ADC data
    $display("AdcData = %h", AdcData);

    $finish; // End simulation
end

endmodule
