`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 10:11:11 AM
// Design Name: 
// Module Name: RTL_set_tree_index
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


module RTL_set_tree_index(addr_in,tree_index,addr_out);
input wire [255:0] addr_in; // 8x8 = 64
input wire [31:0]   tree_index;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in,start_in_sub;
output wire [255:0] addr_out;
//output  reg valid_out,valid_out_sub;
`include "sha256_offsets.vh"
wire [31:0] byte_out;
RTL_u32_to_bytes u32tb (.u32(tree_index),.byte(byte_out));
//always @(posedge CLK or negedge RST)	
//	begin
//		if(RST == 1'b0) begin
//			addr_out 			<= addr_in;
//			valid_out 			<= 1'b0;
//		end
//		else begin
//			if(start_in) begin
assign 			addr_out[((SPX_OFFSET_TREE_INDEX)*8-1):0] = addr_in[((SPX_OFFSET_TREE_INDEX)*8-1):0];
assign 			addr_out[((SPX_OFFSET_TREE_INDEX+1)*8-1):SPX_OFFSET_TREE_INDEX*8] = byte_out[7:0];
assign 			addr_out[((SPX_OFFSET_TREE_INDEX+2)*8-1):(SPX_OFFSET_TREE_INDEX+1)*8] = byte_out[15:8];
assign 			addr_out[((SPX_OFFSET_TREE_INDEX+3)*8-1):(SPX_OFFSET_TREE_INDEX+2)*8] = byte_out[23:16];
assign 			addr_out[((SPX_OFFSET_TREE_INDEX+4)*8-1):(SPX_OFFSET_TREE_INDEX+3)*8] = byte_out[31:24];
assign 			addr_out[255 :((SPX_OFFSET_TREE_INDEX+4)*8)] = addr_in[255 :((SPX_OFFSET_TREE_INDEX+4)*8)];
// 				valid_out 			<= 1'b1;
//			end
//			else begin
//				addr_out			<= addr_out;
//				valid_out 			<= valid_out;
//			end
//		end
//	end
    //u32_to_bytes(&((unsigned char *)addr)[SPX_OFFSET_TREE_INDEX], tree_index );
endmodule
