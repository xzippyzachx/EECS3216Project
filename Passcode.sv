module Passcode(input btn0, input[3:0] SW, input wire clk, input integer timer, output wire passcode_correct, output wire[3:0] led);
	
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
	
//	const integer tMax = 20*50000000 - 1;
//	logic[31:0] t;
//	integer seconds;

//	initial begin
//		seconds = 0;
//	end
	always_comb begin
	
		case (state)
			sIdle:
				begin
					if (SW==A & oneShotBtn==1'b1) begin
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
					else if ((oneShotBtn==1'b1 & SW!=B) | timer == 20) begin
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
					else if ((oneShotBtn==1'b1 & SW!=C) | timer == 20) begin
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
					else if ((oneShotBtn==1'b1 & SW!=D) | timer == 20) begin
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
					if (oneShotBtn==1'b1) begin //Added a button-press as a confirmation once completed.
						passcode_correct = 1'b0;
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
	
//	// timer flip-flop
//	always_ff @(posedge clk) begin
//		if (state != nextState) t <= 0;
//		else if (t != tMax) t <= t + 1;
//	end
//	
//	always @ (posedge clk) begin
//		if(state != nextState) seconds = 0;
//		else if (state!=sIdle & state!=sDig4Corr & t != 0 & t % (50000000-1) == 0) seconds <= seconds + 1;
//	end
	
	
endmodule







//module Passcode(input btn0, input[3:0] SW, input wire clk, input integer seconds_timer, output wire passcode_correct, output wire [3:0] led);
//
//	typedef enum logic [2:0] {S_IDLE = 3'b000, S_DIG1CORR = 3'b001, S_DIG2CORR = 3'b010, S_DIG3CORR = 3'b011, S_DIG4CORR = 3'b100} passcode_state_t;
//
//	parameter[3:0] A = 4'b0001;
//	parameter[3:0] B = 4'b0010;
//	parameter[3:0] C = 4'b0011;
//	parameter[3:0] D = 4'b0100;
//
//	passcode_state_t state, nextState;
//		
//	wire oneShotBtn0, one_shot, btnInv;
//	assign btnInv = ~btn0;
//
//	assign led[0] = (passcode_correct);
//	assign led[1] = (state == S_DIG2CORR);
//	assign led[2] = (state == S_DIG1CORR);
//	assign led[3] = (state == S_IDLE);
//
//	
//	always @(posedge clk) begin
//		
//		case(state)
//			S_IDLE:
//				begin
//					if (oneShotBtn0 == 1'b1 && SW==A) begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG1CORR;
//					end
//					else begin
//						passcode_correct = 1'b0;
//						nextState = S_IDLE;
//					end
//				end
//			S_DIG1CORR:
//				begin
//					if (oneShotBtn0 == 1'b1 & SW == B) begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG2CORR;
//					end
//					else if ((oneShotBtn0 == 1'b1 & SW != B)) begin
//						passcode_correct = 1'b0;
//						nextState = S_IDLE;
//					end
//					else begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG1CORR;
//					end
//				end
//			S_DIG2CORR:
//				begin
//					if (oneShotBtn0 == 1'b1 & SW == C) begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG3CORR;
//					end
//					else if ((oneShotBtn0 == 1'b1 & SW != C)) begin
//						passcode_correct = 1'b0;
//						nextState = S_IDLE;
//					end
//					else begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG2CORR;
//					end
//				end
//			S_DIG3CORR:
//				begin
//					if (oneShotBtn0 == 1'b1 & SW == D) begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG4CORR;
//					end
//					else if ((oneShotBtn0 == 1'b1 & SW != D)) begin
//						passcode_correct = 1'b0;
//						nextState = S_IDLE;
//					end
//					else begin
//						passcode_correct = 1'b0;
//						nextState = S_DIG3CORR;
//					end
//				end
//			S_DIG4CORR:
//				begin
//					passcode_correct = 1'b1;
//					nextState = S_DIG4CORR;
//				end
//			default:
//				begin
//					passcode_correct = 1'b0;
//					nextState = S_IDLE;
//				end
//		endcase
//	
//	end
//	always @(posedge clk) begin
//		state <= nextState;  
//	end
//	
//	// Btn one-shot
//	always_ff @(posedge clk) begin  
//		one_shot <= btnInv;
//		oneShotBtn0 = btnInv & ~one_shot;
//	end
//		
//endmodule