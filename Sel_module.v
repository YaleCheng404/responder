module Sel_module
(
	RSTn, CLK, Start, K1, K2, K3, K4, Answer, TimeOver_Block, LED_Out, Player_Number, Buzzer_Answer, Timer_Start, Answer_true
); 
	 input CLK;
	 input RSTn;
	 input Start;
	 input K1, K2, K3, K4;
     input Answer;
     input TimeOver_Block; 
     
	 output reg [3:0]LED_Out;
	 output reg [3:0]Player_Number;
	 output reg Buzzer_Answer;
	 output reg Timer_Start;
     output reg Answer_true;
	 	 
	 reg Block; 	
	 reg [24:0]Count1='d0;
     reg [24:0]Count2='d0;

	always @ ( posedge CLK or negedge RSTn ) 
		begin 	
			if( !RSTn ) 
			    begin 
					LED_Out <= 4'b0;
					Block <= 0; 
					Timer_Start <= 0; 
					Buzzer_Answer <= 0;
                    Answer_true <= 0;				
					Count1 <= 'd0;
                    Count2 <= 'd0;	
					Player_Number <= 4'd0;						
			    end
			else if( Start == 0 )		
				begin 
					if( Timer_Start == 1 ) 	
						begin
                            if( Answer == 0 )
                                begin
                                    if( Count1 == 25'd24_999_999 )
								        begin
									        Answer_true <= 0;							
									        Count1 <= Count1;
								        end
							         else 
								        begin
									        Answer_true <= 1;	
									        Count1 <= Count1 + 25'b1;
								        end
                                end
                             else
                                begin
                                    if( Count2 == 25'd24_999_999 )
								        begin
									        Buzzer_Answer <= 0;							
									        Count2 <= Count2;
								        end
							         else 
								        begin
									        Buzzer_Answer <= 1;	
									        Count2 <= Count2 + 25'b1;
								        end
                                end
						 end			
					 else if( !K1 && !Block && !TimeOver_Block ) 	
						 begin 
							 LED_Out <= 4'b0001; 	
							 Block <= 1; 
							 Timer_Start <= 1;	
							 Player_Number <= 4'd1; 
						 end 
					 else if( !K2 && !Block && !TimeOver_Block ) 
						 begin 
							 LED_Out <= 4'b0010;
							 Block <= 1;
							 Timer_Start <= 1;
							 Player_Number <= 4'd2;	
						 end 		
					 else if( !K3 && !Block && !TimeOver_Block ) 
						 begin 
							 LED_Out <= 4'b0100;
							 Block <= 1;
							 Timer_Start <= 1; 
							 Player_Number <= 4'd3;
						 end 	 
					 else if( !K4 && !Block && !TimeOver_Block ) 
						 begin 
							 LED_Out <= 4'b1000;
							 Block <= 1;
							 Timer_Start <= 1;
							 Player_Number <= 4'd4;	
						 end 
				  end
		end 

endmodule
