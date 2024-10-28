module responder
(
	RSTn, CLK, Start, Key_In, Answer, LED_Out, Buzzer_Out, LED_OverTime_Out, Digitron_Out, DigitronCS_Out
);
	 input RSTn;	
	 input CLK; 
	 input Start;		
	 input [3:0]Key_In; 
     input Answer;
     
	 output [3:0]LED_Out;
	 output Buzzer_Out;
	 output LED_OverTime_Out;		
	 output [7:0]Digitron_Out; 
	 output [3:0]DigitronCS_Out;
	 
	 wire [3:0]Player_Number;
	 wire [3:0]TimerH;
	 wire [3:0]TimerL;
	 wire Buzzer_Answer;
	 wire Buzzer_TimeOver;
	 wire Timer_Start;
     wire Answer_true;
     wire TimeOver_Block;
     wire TimeOver_Stop;

	Sel_module U1
	(
		.RSTn( RSTn ) ,                      //input
		.CLK( CLK ) ,	
		.Start( Start ) ,		
		.K1( Key_In[0] ) ,	
		.K2( Key_In[1] ) ,	
		.K3( Key_In[2] ) ,	
		.K4( Key_In[3] ) ,
        .Answer( Answer ) ,
        .TimeOver_Block( TimeOver_Block ),	                 //input     
		.LED_Out( LED_Out ) ,	             //output
		.Player_Number( Player_Number ) ,	
		.Buzzer_Answer( Buzzer_Answer ) ,	
		.Timer_Start( Timer_Start ) ,
        .Answer_true( Answer_true ) 	     //output
	);

	Timer_module U2
	(
		.RSTn( RSTn ) ,	                      //input
		.CLK( CLK ) ,
        .Start( Start ) ,	
		.Timer_Start( Timer_Start ) ,	      
        .Answer( Answer ) ,	                  //input
		.TimerH( TimerH ) ,	                  //output
		.TimerL( TimerL ) ,	                  
		.Buzzer_TimeOver( Buzzer_TimeOver ) ,	
		.LED_OverTime( LED_OverTime_Out ) ,
        .TimeOver_Block( TimeOver_Block ) ,
        .TimeOver_Stop( TimeOver_Stop )	  //output
	);

	Buzzer_module U3
	(
		.CLK( CLK ) ,	                      //input
		.RSTn( RSTn ) ,	
		.Buzzer_Answer( Buzzer_Answer ) ,	
		.Buzzer_TimeOver( Buzzer_TimeOver ) ,
        .Answer_true( Answer_true ),
        .TimeOver_Stop( TimeOver_Stop ),	  //input
		.Buzzer_Out( Buzzer_Out ) 	          //output	
	);

	Digitron_NumDisplay_module U4
	(
		.CLK( CLK ) ,                         //input
		.Player_Number( Player_Number ) ,	
		.TimerH( TimerH ) ,	
		.TimerL( TimerL ) ,
        .RSTn( RSTn ) ,	                      //input
		.Digitron_Out( Digitron_Out ) ,	      //output
		.DigitronCS_Out( DigitronCS_Out )     //output	
	);

endmodule 