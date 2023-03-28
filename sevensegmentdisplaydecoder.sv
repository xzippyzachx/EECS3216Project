
//Seven Segment Display Decoder - 9 number digits
module sevensegmentdisplaydecoder (
	input [0:3] dec,
	output reg [1:7] ledout
	);
	
	always @(dec)
		case (dec)
			0: ledout = 7'b0000001;
			1: ledout = 7'b1001111;
			2: ledout = 7'b0010010;
			3: ledout = 7'b0000110;
			4: ledout = 7'b1001100;
			5: ledout = 7'b0100100;
			6: ledout = 7'b0100000;
			7: ledout = 7'b0001111;
			8: ledout = 7'b0000000;
			9: ledout = 7'b0000100;
		endcase
endmodule