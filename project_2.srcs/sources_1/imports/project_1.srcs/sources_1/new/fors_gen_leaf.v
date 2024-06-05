`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 09:16:39 PM
// Design Name: 
// Module Name: fors_gen_leaf
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


module fors_gen_leaf(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] sk_seed,
             input	wire	[319:0]	state_seed,
             //input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	tree_addr,
             input  wire    [31:0]  addr_idx,
             output	reg 	[127:0] leaf, //4480
             output reg           	valid_out
    );
    parameter SPX_ADDR_TYPE_FORSTREE = 8'd3;
    wire [255:0] addr;
    wire [127:0] out_gen_sk_wr;
    wire start_in_gen_sk,
		 valid_out_gen_sk_wr,
		 start_in_thash;
    wire  [127:0] out_wr;
    wire          valid_out_thash;
	assign start_in_gen_sk = start_in;
	assign start_in_thash = valid_out_gen_sk_wr;
	/*
	copy_keypair_addr(fors_leaf_addr, fors_tree_addr);//[255:192]       [167:160] [143:136]
    set_type(fors_leaf_addr, SPX_ADDR_TYPE_FORSTREE); //[175:168]
    set_tree_index(fors_leaf_addr, addr_idx); //[127:120]-2 [119:112]-1  [79:72]-4 [71:64]-3
	*/
	//copy_keypair_addr
	assign  addr[255:192] = tree_addr[255:192];
	assign  addr[167:160] = tree_addr[167:160];
	assign  addr[143:136] = tree_addr[143:136];
	//set_type
	assign  addr[175:168] = SPX_ADDR_TYPE_FORSTREE;
	//set_tree_index
	assign  addr[127:120] = addr_idx[23:16];
	assign  addr[119:112] = addr_idx[31:24];
	assign  addr[79:72]   = addr_idx[7:0];
	assign  addr[71:64]   = addr_idx[15:8]; 
	// assign 0
	assign  addr[191:176] = 0;
	assign  addr[159:144] = 0;
	assign  addr[135:128] = 0;
	assign  addr[111:80] = 0;
	assign  addr[63:0] = 0;
    prf_addr prf_addr_fors_gen_leaf(
		     .CLK(CLK),
             .RST(RST),
             .start_in(start_in_gen_sk),
             .key(sk_seed),
             .addr(addr),
             .out(out_gen_sk_wr),
             .valid_out(valid_out_gen_sk_wr) 
    );
	
	thash thash_fors_gen_leaf(
            .CLK(CLK),
            .RST(RST),
            .start_in(start_in_thash),
            .in(out_gen_sk_wr),
            .mode(2'b00),
            .state_seed(state_seed), // pub_seed nay la state_seed
            //.pub_seed(pub_seed), // khong su dung
            .addr(addr),
            .out(out_wr),
            .valid_out(valid_out_thash)
			);
	always @(posedge CLK or negedge RST) begin
	   if(!RST) begin
	       leaf <= 128'b0;
	       valid_out <= 1'b0;
	   end
	   else if (valid_out_thash ) begin
	       leaf <= out_wr;
	       valid_out <= 1'b1;
	   end
	   else begin
	       leaf <= 128'b0;
	       valid_out <= 1'b0;
	   end
	end
endmodule
