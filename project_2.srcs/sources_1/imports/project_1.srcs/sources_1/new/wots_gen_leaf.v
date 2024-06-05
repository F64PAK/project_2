`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 01:28:55 PM
// Design Name: 
// Module Name: wots_gen_leaf
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


module wots_gen_leaf(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] sk_seed,
             input	wire	[319:0]	state_seed,
            // input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	tree_addr,
             input  wire    [31:0]  addr_idx,
             output	reg 	[127:0] leaf, //4480
             output reg           	valid_out
    );
    parameter SPX_ADDR_TYPE_WOTS = 8'd0;
    parameter SPX_ADDR_TYPE_WOTSPK = 8'd1;
    wire [4479:0] pk_wr;
    wire [255:0] wots_addr_wr, wots_pk_addr_wr;
    //wots_addr    : set_type(0) | copy_subtree_addr | set_keypair_addr
    assign wots_addr_wr[255:192] = tree_addr[255:192]; // copy_subtree_addr
    assign wots_addr_wr[167:160] = tree_addr[167:160];
    assign wots_addr_wr[175:168] = SPX_ADDR_TYPE_WOTS; // set_type
    assign wots_addr_wr[143:136] = addr_idx[7:0];      //set_key_pair
    assign wots_addr_wr[191:176] = 0;
    assign wots_addr_wr[159:144] = 0;
    assign wots_addr_wr[135:0] = 0;
    //wots_pk_addr : set_type(1)  | copy_keypair_addr
    assign wots_pk_addr_wr[255:192] = wots_addr_wr[255:192]; //copy_key_pair_addr
    assign wots_pk_addr_wr[167:160] = wots_addr_wr[167:160];
    assign wots_pk_addr_wr[143:136] = wots_addr_wr[143:136];
    assign wots_pk_addr_wr[175:168] = SPX_ADDR_TYPE_WOTSPK; // set_type
    assign wots_pk_addr_wr[191:176] = 0;
    assign wots_pk_addr_wr[159:144] = 0;
    assign wots_pk_addr_wr[135:0] = 0;
    //reg start_in_gen_pk_reg;
    wire valid_out_gen_pk_wr,
         valid_out_thash_wr;
    wire [127:0] out_thash_wr;
    //assign leaf = out_thash_wr;
    //assign valid_out = valid_out_thash_wr;
    /*
    wots_gen_pk wots_gen_pk_wots_gen_leaf(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in),
             .sk_seed(sk_seed),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .addr(wots_addr_wr),
             .pk_out(pk_wr), //4480
             .valid_out(valid_out_gen_pk_wr)
    );
    */
    wots_gen_pk_8_core_sha256 wots_gen_pk_8_core_sha256wots_gen_leaf(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in),
             .sk_seed(sk_seed),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .addr(wots_addr_wr),
             .pk_out(pk_wr), //4480
             .valid_out(valid_out_gen_pk_wr)
    );
    thash thash_wots_gen_leaf(
             .CLK(CLK),
             .RST(RST),
             .start_in(valid_out_gen_pk_wr),
             .in(pk_wr),
             .mode(2'b11),
             .state_seed(state_seed), // pub_seed nay la state_seed
//             .pub_seed(pub_seed), // khong su dung
             .addr(wots_pk_addr_wr),
             .out(out_thash_wr),
             .valid_out(valid_out_thash_wr)
             );
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin 
            valid_out <= 1'b0;
            leaf <= 128'b0;
        end
        else if (valid_out_thash_wr) begin
            valid_out <= 1'b1;
            leaf <= out_thash_wr ;
            
        end
        else begin
            valid_out <= 1'b0;
            leaf <= 128'b0;
        end
    end
endmodule
