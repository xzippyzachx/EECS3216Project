module LaserDetection(input wire clk, input wire[12:0] light_sensor, output wire laser_triggered);

	parameter sIdle = 1'b0, sLaserCrossed = 1'b1;
	logic nextState, state;
	
		always_comb begin
			case (state)
				sIdle:
					begin
						if (light_sensor/1000 != 4'h4) begin
							laser_triggered = 1'b1;
							nextState = sLaserCrossed;
						end
						else begin
							laser_triggered = 1'b0;
							nextState = sIdle;
						end
					end
				sLaserCrossed:
					begin
						if (light_sensor/1000 == 4'h4) begin
							laser_triggered = 1'b0;
							nextState = sIdle;
						end
						else begin
							laser_triggered = 1'b1;
							nextState = sLaserCrossed;
						end
					end
				default:
					begin
						nextState = sIdle;
						laser_triggered = 1'b0;
					end
			endcase
		end
		
	always @(posedge clk) begin
		state <= nextState;
	end
	
endmodule