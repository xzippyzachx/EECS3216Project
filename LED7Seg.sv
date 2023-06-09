module LED7Seg(
	input clk,
	input fsm_state_t system_state,	
	input int timer, 
	input logic [3:0] current_value,
	output logic [9:6] led, // TODO: Changed to only use left 4 LEDs, to use others for debugging other states. Change back once passcode can be displayed elsewhere.
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
				led1 <= 10'b0101010101; //TODO: Changed to differentiate between SET and TRIGGER. Can change back later. 
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
	sevensegmentdisplaydecoder disp1((system_state == STATE_TRIGGER), ones, hexl2);
	sevensegmentdisplaydecoder disp2((system_state == STATE_TRIGGER), tens, hexl1);
	sevensegmentdisplaydecoder disp3(1'b1, current_value, hexr);
	
endmodule