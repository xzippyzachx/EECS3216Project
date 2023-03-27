
//Seperates value into each digit value
module digitseparator (value, ones, tens);
	input [0:7] value;
	output reg [0:4] ones, tens;

	always @(value) begin
		ones = (value % 10);
		if(value > 9) begin
			tens = (value - ones) / 10;
		end else begin
			tens = 0;
		end
	end

endmodule