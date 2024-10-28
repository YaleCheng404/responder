module Timer_module
(	
	RSTn, CLK, Start, Timer_Start, Answer, TimerH, TimerL, Buzzer_TimeOver, LED_OverTime, TimeOver_Block, TimeOver_Stop
);
	 input RSTn;
	 input CLK; 
     input Start;
	 input Timer_Start;
     input Answer; 
     
	 output reg [3:0]TimerH;
	 output reg [3:0]TimerL;
	 output reg Buzzer_TimeOver;
	 output reg LED_OverTime;
	 output reg TimeOver_Block;
     output reg TimeOver_Stop;
     
	 reg count1=0;
	 reg CLK1; 
	 reg [24:0]Count;
     
	 parameter T1S = 25'd25_000_000;		

	always @ (posedge CLK or negedge RSTn)
		begin 
			if ( !RSTn )
				 begin
					 Count <= 0;
					 CLK1 <= 0;
				 end				
			else if ( Start == 0 )  
				begin
					if ( Count == T1S - 25'b1 )
						 begin
							 Count <= 0;
							 CLK1 <= ~CLK1;		
						 end
					else
					   Count <= Count + 1;
				end
		end

	always @ ( posedge CLK1 or negedge RSTn )
		begin
			if( !RSTn )  		
				begin
					TimerH <= 4'd9;
				end
			else if( Start == 0 )		
				begin
                    if( Timer_Start == 1 )
                        TimerH <= TimerH;
                    else if( TimerH == 4'd0 )
                        TimerH <= TimerH;
                    else     
					    TimerH <= TimerH - 1'b1;
				end
		end
	
	always @ ( posedge CLK1 or negedge RSTn )
		begin
			if( !RSTn )  		
				begin
					TimerL <= 4'd5;
				end
			else if( Timer_Start == 1 )		
				begin
                    if( Answer == 0 )
                        TimerL <= TimerL;
                    else if( TimerL == 4'd0 )
                        TimerL <= TimerL;
                    else     
						TimerL <= TimerL - 1'b1;
				end
		end

	always @ ( posedge CLK1 )
		begin
			if( TimerH == 'd1 | TimerL == 'd1 ) 	
				begin
                    if( count1 == 1'b1 )
						begin
							Buzzer_TimeOver <= 0;
							LED_OverTime <= 0;
							count1 <= 0;
						end
					else
						begin
							Buzzer_TimeOver <= 1;		
							LED_OverTime <= 1;		
							count1 <= count1 + 1'b1;
						end
				end
			else
				begin
					Buzzer_TimeOver <= 0;
					LED_OverTime <= 0;
					count1 <= 0;			
				end
		end	
	always @ ( posedge CLK or negedge RSTn )	
		begin
			if( !RSTn )  		
				begin
					TimeOver_Block <= 0;
                    TimeOver_Stop <= 0;
				end
			else if( TimerH == 'd0 | TimerL == 'd0 )		
				begin
                    TimeOver_Block <= 1;
                    TimeOver_Stop <= 1;
				end
		end   
         
endmodule

	
	