`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 05:00:10 PM
// Design Name: 
// Module Name: RTL_set_keypair_addr
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


module RTL_set_keypair_addr(addr_in,keypair,addr_out);
input wire [255:0] addr_in; // 8x8 = 64
input wire [31:0]   keypair;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
output wire [255:0] addr_out;
//output  reg valid_out;
`include "sha256_offsets.vh"
//always @(posedge CLK or negedge RST)	
//	begin
//		if(RST == 1'b0) begin
//			addr_out 			<= addr_in;
//			valid_out 			<= 1'b0;
//		end
//		else begin
//			if(start_in) begin
assign			addr_out[((SPX_OFFSET_KP_ADDR1+1)*8-1):((SPX_OFFSET_KP_ADDR1)*8)] = keypair[7:0];
assign			addr_out[255:((SPX_OFFSET_KP_ADDR1+1)*8)] = addr_in[255:((SPX_OFFSET_KP_ADDR1+1)*8)];
assign			addr_out[((SPX_OFFSET_KP_ADDR1)*8-1):0] = addr_in[((SPX_OFFSET_KP_ADDR1)*8-1):0];

//				valid_out 			<= 1'b1;
//			end
//			else begin
//				addr_out			<= addr_out;
//				valid_out 			<= valid_out;
//			end
//		end
//	end

endmodule