// Player selection and answer detection.
module Sel_module (
    input        CLK,
    input        RSTn,
    input        Start,
    input        K1,
    input        K2,
    input        K3,
    input        K4,
    input        Answer,
    input        TimeOver_Block,
    output reg [3:0] LED_Out,
    output reg [3:0] Player_Number,
    output reg       Buzzer_Answer,
    output reg       Timer_Start,
    output reg       Answer_true
);

    localparam integer ANSWER_WINDOW = 25'd24_999_999;

    reg        locked;
    reg [24:0] answer_count;
    reg [24:0] buzzer_count;

    wire [3:0] key_hit = {~K4, ~K3, ~K2, ~K1};

    function automatic [3:0] led_for_key (input [1:0] index);
        case (index)
            2'd0: led_for_key = 4'b0001;
            2'd1: led_for_key = 4'b0010;
            2'd2: led_for_key = 4'b0100;
            default: led_for_key = 4'b1000;
        endcase
    endfunction

    function automatic [3:0] player_for_key (input [1:0] index);
        player_for_key = {2'b00, index} + 4'd1;
    endfunction

    // Manage LED/buzzer behaviour based on key presses and answer timing.
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            LED_Out        <= 4'b0000;
            Player_Number  <= 4'd0;
            Buzzer_Answer  <= 1'b0;
            Timer_Start    <= 1'b0;
            Answer_true    <= 1'b0;
            answer_count   <= 25'd0;
            buzzer_count   <= 25'd0;
            locked         <= 1'b0;
        end else if (!Start) begin
            if (Timer_Start) begin
                if (!Answer) begin
                    if (answer_count < ANSWER_WINDOW) begin
                        answer_count <= answer_count + 1'b1;
                        Answer_true  <= 1'b1;
                    end else begin
                        Answer_true <= 1'b0;
                    end
                end else begin
                    Answer_true  <= 1'b0;
                    answer_count <= 25'd0;
                end

                if (Answer) begin
                    if (buzzer_count < ANSWER_WINDOW) begin
                        buzzer_count  <= buzzer_count + 1'b1;
                        Buzzer_Answer <= 1'b1;
                    end else begin
                        Buzzer_Answer <= 1'b0;
                    end
                end else begin
                    Buzzer_Answer <= 1'b0;
                    buzzer_count  <= 25'd0;
                end
            end else begin
                Answer_true   <= 1'b0;
                Buzzer_Answer <= 1'b0;
                answer_count  <= 25'd0;
                buzzer_count  <= 25'd0;

                if (!locked && !TimeOver_Block) begin
                    if (key_hit[0]) begin
                        select_player(2'd0);
                    end else if (key_hit[1]) begin
                        select_player(2'd1);
                    end else if (key_hit[2]) begin
                        select_player(2'd2);
                    end else if (key_hit[3]) begin
                        select_player(2'd3);
                    end
                end
            end
        end else begin
            // Start asserted: release the lock for the next round.
            locked        <= 1'b0;
            Timer_Start   <= 1'b0;
            Buzzer_Answer <= 1'b0;
            Answer_true   <= 1'b0;
            answer_count  <= 25'd0;
            buzzer_count  <= 25'd0;
            LED_Out       <= 4'b0000;
            Player_Number <= 4'd0;
        end
    end

    task automatic select_player (input [1:0] index);
        begin
            LED_Out       <= led_for_key(index);
            Player_Number <= player_for_key(index);
            Timer_Start   <= 1'b1;
            locked        <= 1'b1;
        end
    endtask

endmodule
