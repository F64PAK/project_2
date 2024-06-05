`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 01:49:26 PM
// Design Name: 
// Module Name: RTL_u32_to_bytes
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RTL_u32_to_bytes(u32,byte);
input wire [31:0] u32;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
output wire [31:0] byte; // 4x8 = 32 bit
//output  reg valid_out;


//always @(posedge CLK or negedge RST)	
//	begin
//		if(RST == 1'b0) begin
//			byte 			<= 32'b0;
//			valid_out 			<= 1'b0;
//		end
//		else begin
//			if(start_in) begin
assign 			 byte[7:0] = u32[31:24];
assign 			 byte[15:8] = u32[23:16];
assign 			 byte[23:16] = u32[15:8];
assign 			 byte[31:24] = u32[7:0];
//				valid_out 			<= 1'b1;
//			end
//			else begin
//				byte 			<= byte;
//				valid_out 			<= valid_out;
	//		end
	//	end
//	end
endmodule
