// Generate the audible response tones.
module Buzzer_module (
    input CLK,
    input RSTn,
    input Buzzer_Answer,
    input Buzzer_TimeOver,
    input Answer_true,
    input TimeOver_Stop,
    output Buzzer_Out
);

    localparam [16:0] ANSWER_TONE   = 17'd95_419;
    localparam [16:0] TIMEOVER_TONE = 17'd50_607;
    localparam [16:0] CORRECT_TONE  = 17'd95_419;
    localparam [16:0] IDLE_TONE     = 17'd20_000;

    reg [22:0] counter_a;
    reg [22:0] counter_b;
    reg [16:0] pulse_period;
    reg        buzzer_a;
    reg        buzzer_b;

    wire [16:0] selected_tone =
        Buzzer_Answer               ? ANSWER_TONE   :
        (Answer_true && !TimeOver_Stop) ? CORRECT_TONE  :
        Buzzer_TimeOver             ? TIMEOVER_TONE :
                                     IDLE_TONE;

    // Choose the active tone period.
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            pulse_period <= IDLE_TONE;
        end else begin
            pulse_period <= selected_tone;
        end
    end

    // Primary square-wave generator.
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            counter_a <= 23'd0;
            buzzer_a  <= 1'b1;
        end else if (pulse_period == ANSWER_TONE || pulse_period == TIMEOVER_TONE) begin
            if (counter_a == pulse_period) begin
                counter_a <= 23'd0;
                buzzer_a  <= ~buzzer_a;
            end else begin
                counter_a <= counter_a + 1'b1;
            end
        end else begin
            buzzer_a  <= 1'b1;
            counter_a <= 23'd0;
        end
    end

    // Secondary square-wave generator for overlapping tones.
    always @(negedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            counter_b <= 23'd0;
            buzzer_b  <= 1'b1;
        end else if (pulse_period == CORRECT_TONE || pulse_period == TIMEOVER_TONE) begin
            if (counter_b == pulse_period) begin
                counter_b <= 23'd0;
                buzzer_b  <= ~buzzer_b;
            end else begin
                counter_b <= counter_b + 1'b1;
            end
        end else begin
            buzzer_b  <= 1'b1;
            counter_b <= 23'd0;
        end
    end

    assign Buzzer_Out = buzzer_a | buzzer_b;

endmodule
