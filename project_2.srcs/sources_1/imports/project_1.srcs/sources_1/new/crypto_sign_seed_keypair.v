`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2024 08:35:40 PM
// Design Name: 
// Module Name: crypto_sign_seed_keypair
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


module crypto_sign_seed_keypair(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input	wire	[319:0]	state_seed,
             input  wire    [383:0] seed, 
             output reg     [511:0] sk,
             output	reg	    [255:0] pk, 
             output reg           	valid_out
    );
    
    //wire [383:0] auth_path_wr;
    wire [255:0] top_tree_addr_wr;
    wire start_in_seed_state_wr;
    wire [319:0] state_seed_out_wr;
    wire valid_out_seed_wr;
    reg [319:0] state_seed_reg;
    assign top_tree_addr_wr = {24'b0,8'd21,48'b0,8'd2,168'b0};
    assign start_in_seed_state_wr = start_in;
    RTL_seed_state seed_state_sign_seed_keypair(
                           .CLK(CLK),
                           .RST(RST),
                           .pub_seed(seed[127:0]),
                           //.state_seed(state_seed),
                           .start_in(start_in_seed_state_wr),
                           .state_out(state_seed_out_wr),
                           .valid_out(valid_out_seed_wr)
    );
    wire [127:0] root_wr;
    wire [767:0] auth_path_wr;
    wire valid_out_treehash;
    reg start_in_treehash;
    //assign start_in_treehash = valid_out_seed_wr;
    treehash treehash_crypto_sign_seed_keypair(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_treehash),
             .mode(1'b0),
             .sk_seed(seed[383:256]),
             .state_seed(state_seed_out_wr),
             //input  wire    [383:0] pub_seed, // khong su dung
             .tree_addr(top_tree_addr_wr),
             .leaf_idx(32'b0),
             .idx_offset(32'b0),
             .tree_height(32'd3),
             .auth_path_out(auth_path_wr),
             .root(root_wr), 
             .valid_out(valid_out_treehash)
    );
    
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            sk <= 512'b0;
            pk <= 256'b0;
            valid_out <= 1'b0;
            start_in_treehash <= 1'b0;
            state_seed_reg <= 320'b0;
        end
        else if (start_in) begin
            sk <= 512'b0;
            pk <= 256'b0;
            valid_out <= 1'b0;
            start_in_treehash <= 1'b0;
            state_seed_reg <= 320'b0;
        end
        else if (valid_out_seed_wr) begin
            start_in_treehash <= 1'b1;
            state_seed_reg <= state_seed_out_wr;
        end
        else if (valid_out_treehash) begin
            sk <= {seed,root_wr};
            pk <= {seed[127:0],root_wr};
            valid_out <= 1'b1;
        end
        else begin
            sk <= 512'b0;
            pk <= 256'b0;
            start_in_treehash <= 1'b0;
            valid_out <= 1'b0;
        end
    end
endmodule
