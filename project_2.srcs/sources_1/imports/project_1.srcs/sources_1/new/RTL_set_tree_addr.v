`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2023 11:20:29 AM
// Design Name: 
// Module Name: RTL_set_tree_addr
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


module RTL_set_tree_addr(addr_in,tree,addr_out);
input wire [255:0] addr_in; // 8x8 = 64
input wire [63:0]   tree;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in,start_in_sub;
output  [255:0] addr_out;
//output  reg valid_out;
`include "sha256_offsets.vh"
wire [63:0] utb_out;
//output valid_out_utb;
//ull_to_bytes(&((unsigned char *)addr)[SPX_OFFSET_TREE], 8, tree );
RTL_ull_to_bytes utb0 (.ull(tree),.byte(utb_out));
// convert tree 64 bit to 8 byte -> store in addr_out[71:8] with SPX_OFFSETS_TREE = 1
//always @(posedge CLK or negedge RST)	
//	begin
//		if(RST == 1'b0) begin
//			addr_out 			<= 256'b0;
//			valid_out 			<= 1'b0;
//		end
//		else begin
//			if(start_in) begin
	   assign      addr_out[((SPX_OFFSET_TREE+8)*8-1) :(SPX_OFFSET_TREE*8)] = utb_out ;
	   assign      addr_out[((SPX_OFFSET_TREE)*8-1) : 0 ] = addr_in[((SPX_OFFSET_TREE)*8-1) : 0 ] ;
	   assign      addr_out[ 255 :((SPX_OFFSET_TREE+8)*8)] = addr_in[ 255 :((SPX_OFFSET_TREE+8)*8)];
//				valid_out 			<= 1'b1;
//			end
//			else begin
//				addr_out			<= addr_out;
//				valid_out 			<= valid_out;
//			end
//		end
//	end
endmodule
/*void set_tree_addr(uint32_t addr[8], uint64_t tree)
{
#if (SPX_TREE_HEIGHT * (SPX_D - 1)) > 64
    #error Subtree addressing is currently limited to at most 2^64 trees
#endif
    ull_to_bytes(&((unsigned char *)addr)[SPX_OFFSET_TREE], 8, tree );
}*/