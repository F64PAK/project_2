`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 02:08:37 PM
// Design Name: 
// Module Name: RTL_bytes_to_ull
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


module RTL_bytes_to_ull(byte,ull);
input wire [63:0] byte; // 8x8 = 64
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
output wire [63:0] ull;
//output  reg valid_out;

//always @(posedge CLK or negedge RST)	
//	begin
//		if(RST == 1'b0) begin
//			ull 			<= 64'b0;
//			valid_out 			<= 1'b0;
//		end
//		else begin
//			if(start_in) begin
assign 			 ull[63:56] = byte[63:56] ;
assign 			 ull[55:48] = byte[55:48];
assign 			 ull[47:40] = byte[47:40];
assign 			 ull[39:32] = byte[39:32];
assign 			 ull[31:24] = byte[31:24];
assign 			 ull[23:16] = byte[23:16];
assign 			 ull[15:8] = byte[15:8];
assign 			 ull[7:0] = byte[7:0];    
// 				valid_out 			<= 1'b1;
//			end
//			else begin
//				ull			<= ull;
//				valid_out 			<= valid_out;
//			end
//		end
//	end
endmodule
