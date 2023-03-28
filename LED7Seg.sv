module LED7Seg(
	input clk,
	input fsm_state_t system_state,	
	input int timer, 
	input logic [0:3] current_value,
	output logic [9:0] led,
	output logic [1:7] hexl1,
	output logic [1:7] hexl2,
	output logic [1:7] hexr
	);
	
	reg [32:0] timer_flash = 0;
	logic [9:0] led1 = 10'b0000000000;
	int ones, tens;
	
	
	always_ff@(posedge clk) begin
		case (system_state)
			STATE_IDLE: begin
				led1 <= 10'b0000000000;
			end
			STATE_SET: begin
				led1 <= 10'b1111111111;
			end
			STATE_TRIGGER: begin
				led1 <= 10'b1111111111;
			end
			STATE_ALERT: begin
				timer_flash <= timer_flash + 1;
				if (timer_flash == 25_000_000) begin
					timer_flash <= 0;
					led1 <= ~led1;
				end
				
			end
		endcase
	end
	

	
	assign led = led1;
	digitseparator(timer, ones, tens);
	sevensegmentdisplaydecoder disp1(ones, hexl2);
	sevensegmentdisplaydecoder disp2(tens, hexl1);
	sevensegmentdisplaydecoder disp3(current_value, hexr);
	
endmodule