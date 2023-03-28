typedef enum logic [1:0] {STATE_IDLE = 2'b00, STATE_SET = 2'b01, STATE_TRIGGER = 2'b10, STATE_ALERT = 2'b11} fsm_state_t;

module EECS3216Project (
	input clock,		//50 MHz
	input fsm_state_t temp,
	output h_sync,
	output v_sync,
	output [3:0] red_ouput,
	output [3:0] blue_ouput,
	output [3:0] green_ouput,
	output [9:0] leds,
	output [1:7] hexl1,
	output [1:7] hexl2,
	output [1:7] hexlr
	);
	
	
	LED7Seg(clock, temp, 20, temp, leds, hexl1, hexl2, hexlr);
	
	VGADisplay(clock, temp, 20, h_sync, v_sync, red_ouput, blue_ouput, green_ouput);
	
	
endmodule