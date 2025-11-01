// Countdown timer with overtime signalling.
module Timer_module (
    input        RSTn,
    input        CLK,
    input        Start,
    input        Timer_Start,
    input        Answer,
    output reg [3:0] TimerH,
    output reg [3:0] TimerL,
    output reg       Buzzer_TimeOver,
    output reg       LED_OverTime,
    output reg       TimeOver_Block,
    output reg       TimeOver_Stop
);

    localparam [24:0] T1S = 25'd25_000_000;

    reg        clk_div;
    reg [24:0] count;
    reg        pulse_state;

    // 1 Hz clock divider (assuming 50 MHz input clock).
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            count   <= 25'd0;
            clk_div <= 1'b0;
        end else if (!Start) begin
            if (count == T1S - 1'b1) begin
                count   <= 25'd0;
                clk_div <= ~clk_div;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

    // High digit counts down from 9.
    always @(posedge clk_div or negedge RSTn) begin
        if (!RSTn || Start) begin
            TimerH <= 4'd9;
        end else if (!Timer_Start && TimerH != 4'd0) begin
            TimerH <= TimerH - 1'b1;
        end
    end

    // Low digit counts down from 5 once the answer period begins.
    always @(posedge clk_div or negedge RSTn) begin
        if (!RSTn || Start) begin
            TimerL <= 4'd5;
        end else if (Timer_Start) begin
            if (Answer && TimerL != 4'd0) begin
                TimerL <= TimerL - 1'b1;
            end
        end else begin
            TimerL <= 4'd5;
        end
    end

    // Blink the overtime indicators when one of the counters reaches 1.
    always @(posedge clk_div or negedge RSTn) begin
        if (!RSTn) begin
            Buzzer_TimeOver <= 1'b0;
            LED_OverTime    <= 1'b0;
            pulse_state     <= 1'b0;
        end else if ((TimerH == 4'd1) || (TimerL == 4'd1)) begin
            pulse_state     <= ~pulse_state;
            Buzzer_TimeOver <= ~pulse_state;
            LED_OverTime    <= ~pulse_state;
        end else begin
            pulse_state     <= 1'b0;
            Buzzer_TimeOver <= 1'b0;
            LED_OverTime    <= 1'b0;
        end
    end

    // Flag that the timer expired.
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            TimeOver_Block <= 1'b0;
            TimeOver_Stop  <= 1'b0;
        end else if (Start) begin
            TimeOver_Block <= 1'b0;
            TimeOver_Stop  <= 1'b0;
        end else if ((TimerH == 4'd0) || (TimerL == 4'd0)) begin
            TimeOver_Block <= 1'b1;
            TimeOver_Stop  <= 1'b1;
        end
    end

endmodule
