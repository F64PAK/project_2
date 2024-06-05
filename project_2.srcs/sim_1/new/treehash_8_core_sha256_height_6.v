`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2024 08:36:53 AM
// Design Name: 
// Module Name: treehash_8_core_sha256_height_6
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


module treehash_8_core_sha256_height_6_tb(

    );
                 reg 			CLK;
             reg			RST;
             reg			start_in;
             reg    [127:0] sk_seed;
             reg	[319:0]	state_seed;
             reg    [383:0] pub_seed; // khong su dung
             reg	[255:0]	tree_addr;
             reg    [31:0]  leaf_idx;
             reg    [31:0]  idx_offset;
             reg    [31:0]  tree_height;
             wire     [767:0] auth_path;
             wire	    [127:0] root; 
             wire           	valid_out;
treehash_fors_gen_leaf_8_core_sha256_height_6 treehash_fors_gen_leaf_8_core_sha256_height_6_tb(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in),
             .sk_seed(sk_seed),
             //.mode(1'b1),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .tree_addr(tree_addr),
             .leaf_idx(leaf_idx),
             .idx_offset(idx_offset),
             .tree_height(tree_height),
             .auth_path_out(auth_path),
             .root(root), 
             .valid_out(valid_out)
    );
parameter delay = 10;
reg node_reg = treehash_fors_gen_leaf_8_core_sha256_height_6.node_reg;
reg valid_sha256 = treehash_fors_gen_leaf_8_core_sha256_height_6.valid_out_wr_0;
always #(delay/2) CLK = ~CLK;
always @(posedge valid_sha256) begin
    $monitor ("%h", node_reg);
end
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    leaf_idx = 32'h00000010;
    idx_offset = 32'h00000000;
    tree_height =  32'd6;
    sk_seed = 128'h0405060708090a0b0c0d0e0f10111213;
    //pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    //addr = 256'b0001001000110100010101100111100010011010101111001101111011110000000100110101011110011011110111110010010001101000101011001110000011111110111011011111101011001110110010101111111010111010101111101101111010101101101111101110111110001011101011011111000000001101;
    state_seed = 320'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c;
    tree_addr = 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(100000*delay);
    $display("%h",auth_path);
    /*
    start_in = 0;
    leaf_idx = 32'h00000010;
    idx_offset = 32'h00000080;
    tree_height =  32'd6;
    sk_seed = 128'h0405060708090a0b0c0d0e0f10111213;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    //addr = 256'b0001001000110100010101100111100010011010101111001101111011110000000100110101011110011011110111110010010001101000101011001110000011111110111011011111101011001110110010101111111010111010101111101101111010101101101111101110111110001011101011011111000000001101;
    state_seed = 320'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c;
    //tree_addr = 256'h123456789abcdef0000003df0000ac0000000000000090000000000000000000;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(100000*delay);
    $display("%h",auth_path);
    */
    #delay;
    $stop;
end

endmodule
