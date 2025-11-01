// Top-level integration for the responder system.
module responder (
    input        RSTn,
    input        CLK,
    input        Start,
    input  [3:0] Key_In,
    input        Answer,
    output [3:0] LED_Out,
    output       Buzzer_Out,
    output       LED_OverTime_Out,
    output [7:0] Digitron_Out,
    output [3:0] DigitronCS_Out
);

    wire [3:0] player_number;
    wire [3:0] timer_h;
    wire [3:0] timer_l;
    wire       buzzer_answer;
    wire       buzzer_time_over;
    wire       timer_start;
    wire       answer_true;
    wire       time_over_block;
    wire       time_over_stop;

    Sel_module u_sel (
        .RSTn           (RSTn),
        .CLK            (CLK),
        .Start          (Start),
        .K1             (Key_In[0]),
        .K2             (Key_In[1]),
        .K3             (Key_In[2]),
        .K4             (Key_In[3]),
        .Answer         (Answer),
        .TimeOver_Block (time_over_block),
        .LED_Out        (LED_Out),
        .Player_Number  (player_number),
        .Buzzer_Answer  (buzzer_answer),
        .Timer_Start    (timer_start),
        .Answer_true    (answer_true)
    );

    Timer_module u_timer (
        .RSTn           (RSTn),
        .CLK            (CLK),
        .Start          (Start),
        .Timer_Start    (timer_start),
        .Answer         (Answer),
        .TimerH         (timer_h),
        .TimerL         (timer_l),
        .Buzzer_TimeOver(buzzer_time_over),
        .LED_OverTime   (LED_OverTime_Out),
        .TimeOver_Block (time_over_block),
        .TimeOver_Stop  (time_over_stop)
    );

    Buzzer_module u_buzzer (
        .CLK            (CLK),
        .RSTn           (RSTn),
        .Buzzer_Answer  (buzzer_answer),
        .Buzzer_TimeOver(buzzer_time_over),
        .Answer_true    (answer_true),
        .TimeOver_Stop  (time_over_stop),
        .Buzzer_Out     (Buzzer_Out)
    );

    Digitron_NumDisplay_module u_digitron (
        .CLK            (CLK),
        .Player_Number  (player_number),
        .TimerH         (timer_h),
        .TimerL         (timer_l),
        .RSTn           (RSTn),
        .Digitron_Out   (Digitron_Out),
        .DigitronCS_Out (DigitronCS_Out)
    );

endmodule
