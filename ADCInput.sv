// NOTE: Adapted from Starter Code from Intel/Terasic for ADC Input.
// All ADC submodules are from Intel/Terasic as well.
// This file is from a Terasic starter code file, with some reductions made for unneeded sections.


// ============================================================================
// Copyright (c) 2016 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================


module ADCInput(input clk,  inout [15: 0] ARDUINO_IO, inout ARDUINO_RESET_N, output led);  



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire reset_n;
wire sys_clk;


//=======================================================
//  Structural coding
//=======================================================

assign reset_n = 1'b1;

    adc_qsys u0 (
        .clk_clk                              (clk),                    //                        clk.clk
        .reset_reset_n                        (reset_n),                //                        reset.reset_n
        .modular_adc_0_command_valid          (1'b1),                   //                        modular_adc_0_command.valid
        .modular_adc_0_command_channel        (1'b1),        				//                       .channel
        .modular_adc_0_command_startofpacket  (1'b1),                   //                       .startofpacket
        .modular_adc_0_command_endofpacket    (1'b1),    					//                       .endofpacket
        .modular_adc_0_command_ready          (command_ready),          //                       .ready
        .modular_adc_0_response_valid         (response_valid),         // modular_adc_0_response.valid
        .modular_adc_0_response_channel       (response_channel),       //                       .channel
        .modular_adc_0_response_data          (response_data),          //                       .data
        .modular_adc_0_response_startofpacket (response_startofpacket), //                       .startofpacket
        .modular_adc_0_response_endofpacket   (response_endofpacket),   //                       .endofpacket
        .clock_bridge_sys_out_clk_clk         (sys_clk)                 //                       clock_bridge_sys_out_clk.clk
    );

	 
////////////////////////////////////////////
// command
wire  command_valid;
wire  [4:0] command_channel;
wire  command_startofpacket;
wire  command_endofpacket;
wire command_ready;

////////////////////////////////////////////
// response
wire response_valid/* synthesis keep */;
wire [4:0] response_channel;
wire [11:0] response_data;
wire response_startofpacket;
wire response_endofpacket;
reg [4:0]  cur_adc_ch /* synthesis noprune */;
reg [11:0] adc_sample_data /* synthesis noprune */;
reg [12:0] vol /* synthesis noprune */;

assign reading_out = vol;

always @ (posedge sys_clk)
begin
	if (response_valid)
	begin
		adc_sample_data <= response_data;
		cur_adc_ch <= response_channel;
		
		vol <= response_data * 2 * 2500 / 4095;
	end
end			


	LaserDetection(clk, vol, light_triggered);

	assign led = light_triggered;
	

endmodule