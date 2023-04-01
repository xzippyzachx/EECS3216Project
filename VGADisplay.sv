
module VGADisplay (
	input clock,		//50 MHz
	input fsm_state_t system_state,
	input [2:0] passcode_state,
	input [0:7] timer,
	output h_sync,
	output v_sync,
	output [3:0] red_ouput,
	output [3:0] blue_ouput,
	output [3:0] green_ouput
	);
	parameter[2:0] sIdle = 3'd0, sDig1Corr = 3'd1,  sDig2Corr = 3'd2, sDig3Corr = 3'd3, sDig4Corr = 3'd4;
	
	reg [0:4] countdown_tens;
	reg [0:4] countdown_ones;
	reg [1:7] countdown_tens_7seg;
	reg [1:7] countdown_ones_7seg;
	
	reg flash = 0;
	int flash_counter = 0;
	
	reg [9:0] x_counter = 0;
	reg [9:0] y_counter = 0;
	reg [9:0] red = 0;
	reg [9:0] green = 0;
	reg [9:0] blue = 0;
	
	localparam screen_height = 480;
	localparam screen_width = 640;
	localparam y_start = 35;
	localparam x_start = 144;
			
	wire clock_25MHz;
	wire clock_120Hz;
	
	reg reset = 0;
	clockdivider(
		.areset(reset),
		.inclk0(clock),
		.c0(clock_25MHz),
		.locked()
	);
	
	clockdivider_120Hz(clock, clock_120Hz);
		
	// counter and sync generation
	always @(posedge clock_25MHz)  // horizontal counter
	begin 
		if (x_counter < 799)
			x_counter <= x_counter + 1;  // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels 
		else
			x_counter <= 0;
	end
	
	always @ (posedge clock_25MHz)  // vertical counter
	begin 
		if (x_counter == 799)  // only counts up 1 count after horizontal finishes 800 counts
			begin
				if (y_counter < 525)  // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
					y_counter <= y_counter + 1;
				else
					y_counter <= 0;              
			end
	end
	
	// hsync and vsync output assignments
	assign h_sync = (x_counter >= 0 && x_counter < 96) ? 1:0;  // hsync high for 96 counts
	assign v_sync = (y_counter >= 0 && y_counter < 2) ? 1:0;   // vsync high for 2 counts
	
	digitseparator(timer, countdown_ones, countdown_tens);
	
	sevensegmentdisplaydecoder tensDigit(1'b1, countdown_tens, countdown_tens_7seg);
	sevensegmentdisplaydecoder onesDigit(1'b1, countdown_ones, countdown_ones_7seg);
			
	
	//Main Update Loop
	always @ (posedge clock_120Hz)
	begin
				
		if (system_state == STATE_ALERT)	// Alerting
		begin
			flash_counter <= flash_counter + 1;
		
			if(flash_counter == 30)
			begin
				flash <= ~flash;
				flash_counter <= 0;
			end
		end
		else
		begin
			flash <= 0;
			flash_counter <= 0;
		end
		
	end
	
	// Display Loop
	always @ (posedge clock)
	begin
	
		//Background
		red <= 4'h00;    // black
		green <= 4'h00;
		blue <= 4'h00;
		
		if (system_state == STATE_IDLE) 			// Idle
		begin
			red <= 4'h00;
			green <= 4'hFF;
			blue <= 4'h00;
		end
		else if (system_state == STATE_SET) 	// Armed
		begin
			red <= 4'hCF;
			green <= 4'h0F;
			blue <= 4'h30;
		end
		else if (system_state == STATE_TRIGGER)	// Triggered
		begin
			red <= 4'hFF;
			green <= 4'h00;
			blue <= 4'h00;
			
			//Countdown
			//Tens Digit
			if(countdown_tens_7seg[1] == 0)
			begin
				if (y_counter >= y_start + 195 && y_counter <= y_start + 200 && x_counter >= x_start + 260 && x_counter <= x_start + 300)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_tens_7seg[2] == 0)
			begin
				if (y_counter >= y_start + 195 && y_counter <= y_start + 235 && x_counter >= x_start + 295 && x_counter <= x_start + 300)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_tens_7seg[3] == 0)
			begin
				if (y_counter >= y_start + 235 && y_counter <= y_start + 275 && x_counter >= x_start + 295 && x_counter <= x_start + 300)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_tens_7seg[4] == 0)
			begin
				if (y_counter >= y_start + 270 && y_counter <= y_start + 275 && x_counter >= x_start + 260 && x_counter <= x_start + 300)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_tens_7seg[5] == 0)
			begin
				if (y_counter >= y_start + 235 && y_counter <= y_start + 275 && x_counter >= x_start + 260 && x_counter <= x_start + 265)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_tens_7seg[6] == 0)
			begin
				if (y_counter >= y_start + 195 && y_counter <= y_start + 235 && x_counter >= x_start + 260 && x_counter <= x_start + 265)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_tens_7seg[7] == 0)
			begin
				if (y_counter >= y_start + 233 && y_counter <= y_start + 238 && x_counter >= x_start + 260 && x_counter <= x_start + 300)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			
			// Ones Digit
			if(countdown_ones_7seg[1] == 0)
			begin
				if (y_counter >= y_start + 195 && y_counter <= y_start + 200 && x_counter >= x_start + screen_width - 300 && x_counter <= x_start + screen_width - 260)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_ones_7seg[2] == 0)
			begin
				if (y_counter >= y_start + 195 && y_counter <= y_start + 235 && x_counter >= x_start + screen_width - 265 && x_counter <= x_start + screen_width - 260)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_ones_7seg[3] == 0)
			begin
				if (y_counter >= y_start + 235 && y_counter <= y_start + 275 && x_counter >= x_start + screen_width - 265 && x_counter <= x_start + screen_width - 260)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_ones_7seg[4] == 0)
			begin
				if (y_counter >= y_start + 270 && y_counter <= y_start + 275 && x_counter >= x_start + screen_width - 300 && x_counter <= x_start + screen_width - 260)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_ones_7seg[5] == 0)		
			begin
				if (y_counter >= y_start + 235 && y_counter <= y_start + 275 && x_counter >= x_start + screen_width - 300 && x_counter <= x_start + screen_width - 295)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_ones_7seg[6] == 0)		
			begin
				if (y_counter >= y_start + 195 && y_counter <= y_start + 235 && x_counter >= x_start + screen_width - 300 && x_counter <= x_start + screen_width - 295)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if(countdown_ones_7seg[7] == 0)
			begin
				if (y_counter >= y_start + 233 && y_counter <= y_start + 238 && x_counter >= x_start + screen_width - 300 && x_counter <= x_start + screen_width - 260)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			
		end
		else if (system_state == STATE_ALERT)	// Alerting
		begin
			if(flash)
			begin
				red <= 4'hFF;
				green <= 4'hFF;
				blue <= 4'hFF;
			end
			else
			begin
				red <= 4'hFF;
				green <= 4'h00;
				blue <= 4'h00;
			end
		end
		
		// Passcode digits		
		if (system_state == STATE_SET || system_state == STATE_TRIGGER) 	// Armed or Triggered
		begin
			
			if (passcode_state == sDig1Corr || passcode_state == sDig2Corr || passcode_state == sDig3Corr || passcode_state == sDig4Corr)
			begin
				if (y_counter >= y_start + 420 && y_counter <= y_start + 440 && x_counter >= x_start + 250 && x_counter <= x_start + 270)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if (passcode_state == sDig2Corr || passcode_state == sDig3Corr || passcode_state == sDig4Corr)
			begin
				if (y_counter >= y_start + 420 && y_counter <= y_start + 440 && x_counter >= x_start + 290 && x_counter <= x_start + 310)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if (passcode_state == sDig3Corr || passcode_state == sDig4Corr)
			begin
				if (y_counter >= y_start + 420 && y_counter <= y_start + 440 && x_counter >= x_start + 330 && x_counter <= x_start + 350)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
			if (passcode_state == sDig4Corr)
			begin
				if (y_counter >= y_start + 420 && y_counter <= y_start + 440 && x_counter >= x_start + 370 && x_counter <= x_start + 390)
				begin
					red <= 4'hFF;
					green <= 4'hFF;
					blue <= 4'hFF;
				end
			end
				
		end
		
		
		// Corners
		// Top Left
		if (y_counter >= y_start && y_counter <= y_start + 10 && x_counter >= x_start && x_counter <= x_start + 40)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		if (y_counter >= y_start + 10 && y_counter <= y_start + 40 && x_counter >= x_start && x_counter <= x_start + 10)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		//Top Right
		if (y_counter >= y_start && y_counter <= y_start + 10 && x_counter >= x_start + screen_width - 40 && x_counter <= x_start + screen_width)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		if (y_counter >= y_start + 10 && y_counter <= y_start + 40 && x_counter >= x_start + screen_width - 10 && x_counter <= x_start + screen_width)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		// Bottom Left
		if (y_counter >= y_start + screen_height - 40 && y_counter <= y_start + screen_height && x_counter >= x_start && x_counter <= x_start + 10)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		if (y_counter >= y_start + screen_height - 10 && y_counter <= y_start + screen_height && x_counter >= x_start && x_counter <= x_start + 40)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		// Bottom Right
		if (y_counter >= y_start + screen_height - 40 && y_counter <= y_start + screen_height && x_counter >= x_start + screen_width - 10 && x_counter <= x_start + screen_width)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
		if (y_counter >= y_start + screen_height - 10 && y_counter <= y_start + screen_height && x_counter >= x_start + screen_width - 40 && x_counter <= x_start + screen_width)
		begin
			red <= 4'hFF;
			green <= 4'hFF;
			blue <= 4'hFF;
		end
	
	end
	
	// Color output assignments
	assign red_ouput = (x_counter > 144 && x_counter <= 783 && y_counter > 35 && y_counter <= 514) ? red : 4'h0;
	assign green_ouput = (x_counter > 144 && x_counter <= 783 && y_counter > 35 && y_counter <= 514) ? green : 4'h0;
	assign blue_ouput = (x_counter > 144 && x_counter <= 783 && y_counter > 35 && y_counter <= 514) ? blue : 4'h0;	
	
endmodule

module clockdivider_120Hz(clock_input, clock_output);
	input clock_input;
	output reg clock_output = 0;
   reg [27:0] i = 0;
    
	always @ (posedge clock_input)
	begin
		if (i == 416666) //120Hz
		begin
			i <= 0;
			clock_output = ~clock_output;
		end
		else 
			i <= i+1;
	end
 
endmodule
