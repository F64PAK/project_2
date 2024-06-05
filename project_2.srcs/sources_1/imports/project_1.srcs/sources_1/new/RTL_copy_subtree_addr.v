`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 04:35:15 PM
// Design Name: 
// Module Name: RTL_copy_subtree_addr
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


module RTL_copy_subtree_addr(addr_in,sub_in,addr_out);
input wire [255:0] addr_in,sub_in; // 8x8 = 64
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
assign			addr_out[((SPX_OFFSET_TREE+8)*8-1): 0 ] = sub_in[((SPX_OFFSET_TREE+8)*8-1):0];
assign			addr_out[255 : ((SPX_OFFSET_TREE+8)*8) ] = addr_in[255:((SPX_OFFSET_TREE+8)*8)];
//				valid_out 			<= 1'b1;
//			end
//			else begin
//				addr_out			<= addr_out;
//				valid_out 			<= valid_out;
//			end
//		end
//	end


endmodule
