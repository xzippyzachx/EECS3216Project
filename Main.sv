//// ============================================================================
//// Copyright (c) 2016 by Terasic Technologies Inc.
//// ============================================================================
////
//// Permission:
////
////   Terasic grants permission to use and modify this code for use
////   in synthesis for all Terasic Development Boards and Altera Development 
////   Kits made by Terasic.  Other use of this code, including the selling 
////   ,duplication, or modification of any portion is strictly prohibited.
////
//// Disclaimer:
////
////   This VHDL/Verilog or C/C++ source code is intended as a design reference
////   which illustrates how these types of functions can be implemented.
////   It is the user's responsibility to verify their design for
////   consistency and functionality through the use of formal
////   verification methods.  Terasic provides no warranty regarding the use 
////   or functionality of this code.
////
//// ============================================================================
////           
////  Terasic Technologies Inc
////  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
////  
////  
////                     web: http://www.terasic.com/  
////                     email: support@terasic.com
////
//// ============================================================================
//
//
//
//module Main(
//
//      ///////// Clocks /////////
//      input              ADC_CLK_10,
//      input              MAX10_CLK1_50,
//      input              MAX10_CLK2_50,
//
//      ///////// KEY /////////
//      input    [ 1: 0]   KEY,
//
//      ///////// SW /////////
//      input    [ 9: 0]   SW,
//
//      ///////// LEDR /////////
//      output   [ 9: 0]   LEDR,
//
//      ///////// HEX /////////
//      output   [ 7: 0]   HEX0,
//
//      ///////// ARDUINO /////////
//      inout    [15: 0]   ARDUINO_IO,
//      inout              ARDUINO_RESET_N 
//);
//
//
//
////=======================================================
////  REG/WIRE declarations
////=======================================================
//
//wire reset_n;
//wire sys_clk;
//
//
////=======================================================
////  Structural coding
////=======================================================
//
//assign reset_n = 1'b1;
//
//
//
//    adc_qsys u0 (
//        .clk_clk                              (MAX10_CLK1_50),                              //                    clk.clk
//        .reset_reset_n                        (reset_n),                        //                  reset.reset_n
//        .modular_adc_0_command_valid          (1'b1),          //                                 modular_adc_0_command.valid
//        .modular_adc_0_command_channel        (1'b1),        //                             .channel
//        .modular_adc_0_command_startofpacket  (1'b1),  //    ignore                              .startofpacket
//        .modular_adc_0_command_endofpacket    (1'b1),    //  ignore                              .endofpacket
//        .modular_adc_0_command_ready          (command_ready),          //                       .ready
//        .modular_adc_0_response_valid         (response_valid),         // modular_adc_0_response.valid
//        .modular_adc_0_response_channel       (response_channel),       //                       .channel
//        .modular_adc_0_response_data          (response_data),          //                       .data
//        .modular_adc_0_response_startofpacket (response_startofpacket), //                       .startofpacket
//        .modular_adc_0_response_endofpacket   (response_endofpacket),    //                       .endofpacket
//        .clock_bridge_sys_out_clk_clk         (sys_clk)          // clock_bridge_sys_out_clk.clk
//    );
//
//	 
//////////////////////////////////////////////
//// command
//wire  command_valid;
//wire  [4:0] command_channel;
//wire  command_startofpacket;
//wire  command_endofpacket;
//wire command_ready;
//
//////////////////////////////////////////////
//// response
//wire response_valid/* synthesis keep */;
//wire [4:0] response_channel;
//wire [11:0] response_data;
//wire response_startofpacket;
//wire response_endofpacket;
//reg [4:0]  cur_adc_ch /* synthesis noprune */;
//reg [11:0] adc_sample_data /* synthesis noprune */;
//reg [12:0] vol /* synthesis noprune */;
//
//
//always @ (posedge sys_clk)
//begin
//	if (response_valid)
//	begin
//		adc_sample_data <= response_data;
//		cur_adc_ch <= response_channel;
//		
//		vol <= response_data * 2 * 2500 / 4095;
//	end
//end			
//
//
//assign ARDUINO_IO[7] = 1'b1;
//
//	LaserDetection detect(MAX10_CLK1_50, vol, LEDR[0]);
//	passcode(KEY[0], SW[3:0], MAX10_CLK1_50, 4'd1, LEDR[2], HEX0, LEDR[9:6]);
//	
//
////assign HEX5[7] = 1'b1; // low active
////assign HEX4[7] = 1'b1; // low active
////assign HEX3[7] = 1'b0; // low active
////assign HEX2[7] = 1'b1; // low active
////assign HEX1[7] = 1'b1; // low active
////assign HEX0[7] = 1'b1; // low active
////
////SEG7_LUT	SEG7_LUT_ch (
////	.oSEG(HEX5),
////	.iDIG(SW[2:0])
////);
////
////assign HEX4 = 8'b10111111;
////
////SEG7_LUT	SEG7_LUT_v (
////	.oSEG(HEX3),
////	.iDIG(vol/1000)
////);
////
////SEG7_LUT	SEG7_LUT_v_1 (
////	.oSEG(HEX2),
////	.iDIG(vol/100 - (vol/1000)*10)
////);
////
////SEG7_LUT	SEG7_LUT_v_2 (
////	.oSEG(HEX1),
////	.iDIG(vol/10 - (vol/100)*10)
////);
////
////SEG7_LUT	SEG7_LUT_v_3 (
////	.oSEG(HEX0),
////	.iDIG(vol - (vol/10)*10)
////);
//
//
//
//
//
//endmodule
//
//module LaserDetection(input wire clk, input wire[12:0] light_sensor, output wire laser_triggered);
//
//	parameter sIdle = 1'b0, sLaserCrossed = 1'b1;
//	logic nextState, state;
//	
//		always_comb begin
//			case (state)
//				sIdle:
//					begin
//						if (light_sensor/1000 != 4'h4) begin
//							laser_triggered = 1'b1;
//							nextState = sLaserCrossed;
//						end
//						else begin
//							laser_triggered = 1'b0;
//							nextState = sIdle;
//						end
//					end
//				sLaserCrossed:
//					begin
//						if (light_sensor/1000 == 4'h4) begin
//							laser_triggered = 1'b0;
//							nextState = sIdle;
//						end
//						else begin
//							laser_triggered = 1'b1;
//							nextState = sLaserCrossed;
//						end
//					end
//				default:
//					begin
//						nextState = sIdle;
//						laser_triggered = 1'b0;
//					end
//			endcase
//		end
//		
//	always @(posedge clk) begin
//		state <= nextState;
//	end
//	
//endmodule
