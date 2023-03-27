module EECS3216Project (
	input clock,		//50 MHz
	input [1:0] temp,
	output h_sync,
	output v_sync,
	output [3:0] red_ouput,
	output [3:0] blue_ouput,
	output [3:0] green_ouput
	);
	
	
	VGADisplay(clock, temp, 20, h_sync, v_sync, red_ouput, blue_ouput, green_ouput);
	
	
endmodule