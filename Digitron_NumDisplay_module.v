// Time and player number multiplexer for the seven-segment display.
module Digitron_NumDisplay_module (
    input        CLK,
    input  [3:0] Player_Number,
    input  [3:0] TimerH,
    input  [3:0] TimerL,
    input        RSTn,
    output [7:0] Digitron_Out,
    output [3:0] DigitronCS_Out
);

    localparam integer SCAN_DIV = 16'd200;

    reg [15:0] scan_count;
    reg [1:0]  scan_index;
    reg [3:0]  current_value;
    reg [3:0]  cs_reg;
    reg [7:0]  seg_reg;

    localparam [7:0]
        SEG_0 = 8'b0011_1111,
        SEG_1 = 8'b0000_0110,
        SEG_2 = 8'b0101_1011,
        SEG_3 = 8'b0100_1111,
        SEG_4 = 8'b0110_0110,
        SEG_5 = 8'b0110_1101,
        SEG_6 = 8'b0111_1101,
        SEG_7 = 8'b0000_0111,
        SEG_8 = 8'b0111_1111,
        SEG_9 = 8'b0110_1111;

    // Divide the input clock to provide a scanning tick.
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            scan_count <= 16'd0;
            scan_index <= 2'd0;
        end else if (scan_count == SCAN_DIV) begin
            scan_count <= 16'd0;
            scan_index <= scan_index + 1'b1;
        end else begin
            scan_count <= scan_count + 1'b1;
        end
    end

    // Choose which digit is active.
    always @(*) begin
        case (scan_index)
            2'd0: begin
                current_value = TimerL;
                cs_reg        = 4'b1110;
            end
            2'd1: begin
                current_value = TimerH;
                cs_reg        = 4'b1101;
            end
            2'd2: begin
                current_value = Player_Number;
                cs_reg        = 4'b1011;
            end
            default: begin
                current_value = 4'd0;
                cs_reg        = 4'b0111;
            end
        endcase
    end

    // Decode the selected value into the segment pattern.
    always @(*) begin
        case (current_value)
            4'd0: seg_reg = SEG_0;
            4'd1: seg_reg = SEG_1;
            4'd2: seg_reg = SEG_2;
            4'd3: seg_reg = SEG_3;
            4'd4: seg_reg = SEG_4;
            4'd5: seg_reg = SEG_5;
            4'd6: seg_reg = SEG_6;
            4'd7: seg_reg = SEG_7;
            4'd8: seg_reg = SEG_8;
            4'd9: seg_reg = SEG_9;
            default: seg_reg = SEG_0;
        endcase
    end

    assign Digitron_Out   = seg_reg;
    assign DigitronCS_Out = cs_reg;

endmodule
