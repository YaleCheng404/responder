module Buzzer_module
(
	CLK, RSTn, Buzzer_Answer, Buzzer_TimeOver, Answer_true, TimeOver_Stop, Buzzer_Out
);
	 input CLK;
	 input RSTn;
	 input Buzzer_Answer;
	 input Buzzer_TimeOver;
     input Answer_true;
     input TimeOver_Stop;
     
 	 output Buzzer_Out;

	 parameter _Answer = 17'd95419, _TimeOver = 17'd50607, _true = 17'd95419 ;
	
     reg [22:0]Count1;
     reg [22:0]Count2;
     reg [22:0]Pulse_x;
	 reg W_buzzer1;
     reg W_buzzer2;
	
   always @ ( posedge CLK )
		begin
			if( Buzzer_Answer == 1)
				Pulse_x <= _Answer;
            else if( Answer_true == 1 && !TimeOver_Stop )
                Pulse_x <= _true;                
			else if( Buzzer_TimeOver == 1 )
				Pulse_x <= _TimeOver;
			else 
				Pulse_x <= 'd20000;
		end
		
   always @ ( posedge CLK )
		begin			
			if( (Pulse_x == _Answer)  | (Pulse_x == _TimeOver) )
				begin
					if( Count1 == Pulse_x )
						begin
							Count1 <= 23'd0;
							W_buzzer1 <= ~W_buzzer1;
						end
					else 
						Count1 <= Count1 + 1'b1;
				end
			else 
				begin
					W_buzzer1 <= 1'b1;
					Count1 <= 23'd0;
				end
		end	

   always @ ( negedge CLK )
		begin			
			if( (Pulse_x == _true) | (Pulse_x == _TimeOver) )
				begin
					if( Count2 == Pulse_x )
						begin
							Count2 <= 23'd0;
							W_buzzer2 <= ~W_buzzer2;
						end
					else 
						Count2 <= Count2 + 1'b1;
				end
			else 
				begin
					W_buzzer2 <= 1'b1;
					Count2 <= 23'd0;
				end
		end	
	 assign Buzzer_Out = W_buzzer1 | W_buzzer2;
	        
endmodule
