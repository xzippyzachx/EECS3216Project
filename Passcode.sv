module Passcode(input btn0, input[3:0] SW, input wire clk, input integer timer, input fsm_state_t system_state, output wire passcode_correct, output wire[2:0] passcode_state, output wire[3:0] led);
	
	//Passcode
	parameter[3:0] A = 4'b0001;
	parameter[3:0] B = 4'b0010;
	parameter[3:0] C = 4'b0010;	
	parameter[3:0] D = 4'b0100;
	
	//State parameters
	parameter[2:0] sIdle = 3'd0, sDig1Corr = 3'd1,  sDig2Corr = 3'd2, sDig3Corr = 3'd3, sDig4Corr = 3'd4;
	logic[2:0] state, nextState;
	
	
	// Temp - can be removed in system for actual LED setup.
	assign led[3] = (state==sDig1Corr);
	assign led[2] = (state==sDig2Corr);
	assign led[1] = (state==sDig3Corr);
	assign led[0] = (state==sDig4Corr);
	
	//Invert button and one-shot
	wire oneShotBtn;
	wire one_shot;
	wire btnInv;
	assign btnInv = ~btn0;
	assign passcode_state = state;
	
	always_comb begin
	
		case (state)
			sIdle:
				begin
					if ((system_state == STATE_SET | system_state == STATE_TRIGGER) & SW==A & oneShotBtn==1'b1) begin
						passcode_correct = 1'b0;
						nextState = sDig1Corr;
					end
					else begin
						passcode_correct = 1'b0;
						nextState = sIdle;
					end
				end
			sDig1Corr:
				begin
					if (SW==B & oneShotBtn==1'b1) begin
						passcode_correct = 1'b0;
						nextState = sDig2Corr;
					end
					else if ((oneShotBtn==1'b1 & SW!=B) | timer == 0) begin
						passcode_correct = 1'b0;
						nextState = sIdle;
					end
					else begin
						passcode_correct = 1'b0;
						nextState = sDig1Corr;
					end
				end
			sDig2Corr:
				begin
					if(SW==C & oneShotBtn==1'b1) begin
						passcode_correct = 1'b0;
						nextState = sDig3Corr;
					end
					else if ((oneShotBtn==1'b1 & SW!=C) | timer == 0) begin
						passcode_correct = 1'b0;
						nextState = sIdle;
					end
					else begin
						passcode_correct = 1'b0;
						nextState = sDig2Corr;
					end
				end
			sDig3Corr:
				begin
					if(SW==D & oneShotBtn==1'b1) begin
						passcode_correct = 1'b0;
						nextState = sDig4Corr;
					end
					else if ((oneShotBtn==1'b1 & SW!=D) | timer == 0) begin
						passcode_correct = 1'b0;
						nextState = sIdle;
					end
					else begin
						passcode_correct = 1'b0;
						nextState = sDig3Corr;
					end
				end
			sDig4Corr:
				begin
					if (system_state==STATE_IDLE) begin //Check registered in main system before going back to idle.
						passcode_correct = 1'b1;
						nextState = sIdle;
					end
					else begin
						passcode_correct = 1'b1;
						nextState = sDig4Corr;
					end
				end
	
			default:
				begin
					passcode_correct = 1'b0;
					nextState = sIdle;
				end
				
		endcase
	
	end
	
	always @ (posedge clk) begin
		state <= nextState;
	end
	
	
	// One-shot for Btn0 input.
	// Required to prevent state by-pass between
	// transitions such as (SW=A) followed by (SW!=B) on btn press.
	always_ff @(posedge clk) begin  
		one_shot <= btnInv;
		oneShotBtn = btnInv & ~one_shot;
	end

endmodule