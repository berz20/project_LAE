module LCD (
    input wire clk,        // Clock signal
    input wire rst,        // Reset signal
    output wire rs,        // Register Select (0: Command, 1: Data)
    output wire rw,        // Read/Write (0: Write, 1: Read - not used in write-only mode)
    output wire [2:0] e,   // Enable (enable pulse)
    output wire [7:0] data, // Data to be displayed (8-bit ASCII code)
    input wire busy,       // LCD Busy Flag (indicates when the LCD is busy)
    input wire enable,     // Enable signal for data transfer
    input wire [15:0] V_in // Input voltage data (16-bit ADC output)
);

    // Internal signals
    reg [1:0] state;
    reg [7:0] lcd_data;
    reg [3:0] digit_count;
    reg [7:0] ascii_data;
    
    // Constants for LCD commands
    localparam CLEAR_DISPLAY = 8'h01;
    localparam DISPLAY_ON = 8'h0C;
    localparam CURSOR_HOME = 8'h02;
    localparam ENTRY_MODE_SET = 8'h06;

    // Constants for ASCII conversion
    localparam ASCII_ZERO = 8'h30;

    // State constants
    localparam IDLE = 2'b00;
    localparam COMMAND = 2'b01;
    localparam DATA = 2'b10;
    localparam DISPLAY_CHAR = 2'b11;

    // Initialize signals
    assign rs = (state == DATA || state == DISPLAY_CHAR);
    assign rw = 0;  // Write mode

    // ASCII conversion logic
    always @(*) begin
        if (digit_count == 4'h0) begin
            ascii_data = (V_in[15:12] + ASCII_ZERO);
        end else if (digit_count == 4'h1) begin
            ascii_data = (V_in[11:8] + ASCII_ZERO);
        end else if (digit_count == 4'h2) begin
            ascii_data = (V_in[7:4] + ASCII_ZERO);
        end else if (digit_count == 4'h3) begin
            ascii_data = (V_in[3:0] + ASCII_ZERO);
        end
    end

    // State machine for data transfer
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            lcd_data <= 8'bzzzzzzzz;
            digit_count <= 4'h0;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        state <= COMMAND;
                        lcd_data <= CLEAR_DISPLAY;
                    end
                end
                COMMAND: begin
                    if (!enable) begin
                        state <= DISPLAY_CHAR;
                    end
                end
                DISPLAY_CHAR: begin
                    if (!enable) begin
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (!enable) begin
                        state <= DISPLAY_CHAR;
                        if (digit_count < 4'h4) begin
                            digit_count <= digit_count + 1;
                        end else begin
                            digit_count <= 4'h0;
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Assign enable signals for LCD control
    assign e[0] = (state == COMMAND || state == DATA);
    assign e[1] = 1'b0;
    assign e[2] = 1'b0;

    // Assign data to be displayed
    assign data = (state == DATA) ? ascii_data : 8'bzzzzzzzz;

endmodule
