typedef enum logic [1:0] {STATE_IDLE = 2'b00, STATE_SET = 2'b01, STATE_TRIGGER = 2'b10, STATE_ALERT = 2'b11} fsm_state_t;

module EECS3216Project (
	input clock,		//50 MHz
	input wire btn0,
	input wire btn1,
	input wire rst,
	input logic[3:0] SW,
	input logic swLaser, //TODO: Temporary until laser module added.
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
	
	fsm_state_t system_state;
	integer seconds_timer;
	wire [2:0] passcode_state;
	
	LED7Seg(clock, system_state, seconds_timer, SW, leds[9:6], hexl1, hexl2, hexlr);
	
	VGADisplay(clock, system_state, passcode_state, seconds_timer, h_sync, v_sync, red_ouput, blue_ouput, green_ouput);
	
	SystemState(clock, rst, btn1, swLaser, passcode_correct, system_state, seconds_timer);
	
	Passcode(btn0, SW, clock, seconds_timer, passcode_correct, passcode_state, leds[3:0]);

endmodule