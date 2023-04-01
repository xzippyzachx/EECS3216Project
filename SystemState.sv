module SystemState(
	input wire clk,
	input wire rst,
	input wire btn1, 
	input wire laser_triggered,
	input wire passcode_correct,
	output fsm_state_t system_state,
	output integer seconds_timer
);
	
	wire btn1Inv = ~btn1;
	fsm_state_t nextState;
	
	const integer clkCycle = 50000000;
	const integer tMax = 20*clkCycle - 1;
	logic[31:0] t;
	
	initial begin
		system_state = STATE_IDLE;
		t = 0;
		seconds_timer = 20;
	end
	
	always @(posedge clk) begin
		case(system_state)
			STATE_IDLE:
				begin
					if(btn1Inv == 1'b1) begin
						nextState = STATE_SET;
					end
					else begin
						nextState = STATE_IDLE;
					end
				end
			STATE_SET:
				begin
					if(passcode_correct == 1'b1 & laser_triggered == 1'b0) begin
						nextState = STATE_IDLE;
					end
					else if(passcode_correct == 1'b0 & laser_triggered == 1'b1) begin
						nextState = STATE_TRIGGER;
					end
					else begin
						nextState = STATE_SET;
					end
				end
			STATE_TRIGGER:
				begin
					if (passcode_correct == 1'b1 & seconds_timer > 0) begin
						nextState = STATE_IDLE;
					end
					else if (passcode_correct == 1'b0 & seconds_timer <= 0) begin
						nextState = STATE_ALERT;
					end
					else begin
						nextState = STATE_TRIGGER;
					end
				end
			STATE_ALERT:
				begin
						nextState = STATE_ALERT;
				end
			default: nextState = STATE_IDLE;
		endcase
	end
	
	always @(posedge clk, posedge rst) begin
		if(rst) system_state <= STATE_IDLE;
		else system_state <= nextState;
	end
		
	//Timer
	always_ff @(posedge clk) begin
		if (system_state != nextState) begin
			t <= 0;
			seconds_timer <= 20;
		end
		else begin
			if (t != tMax) t = t + 1; //NOTE: Seems to need to be '=' and not '<=' for seconds to count. (need to wait for t=t+1 to occur??)
			if (system_state==STATE_TRIGGER & t != 0 & t % (clkCycle-1)==0) seconds_timer = seconds_timer - 1;
		end
	end
	
	

endmodule