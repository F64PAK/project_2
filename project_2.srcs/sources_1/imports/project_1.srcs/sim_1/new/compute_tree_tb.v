`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2024 10:08:20 PM
// Design Name: 
// Module Name: compute_tree_tb
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


module compute_tree_tb();
             reg 			CLK;
             reg			RST;
             reg			start_in;
             reg    [127:0] leaf;
             reg    [767:0] auth_path;
             reg    [31:0]  leaf_idx;
             reg    [31:0]  idx_offset;
             reg    [31:0]  tree_height;
             reg	[319:0]	state_seed;
             reg    [383:0] pub_seed; // khong su dung
             reg	[255:0]	addr;
             wire	    [127:0]	root;
             wire           	valid_out;
compute_root compute_root_tb(
             CLK,
             RST,
             start_in,
             leaf,
             auth_path,
             leaf_idx,
             idx_offset,
             tree_height,
             state_seed,
             pub_seed,
             addr,
             root,
             valid_out );

parameter delay = 10;
always #(delay/2) CLK = ~CLK;
initial begin
    CLK=0;
    ////////
    /*
    RST = 0;
    start_in=0;
    in = 128'habcdabcdabcdabcdabcdabcdabcdabcd;
    mode = 2'b00;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    addr = 64'b0;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(600*delay);
    */
    // done mode 00
    ////////
    /*
    RST = 0;
    start_in=0;
    in = 256'habcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcd;
    mode = 2'b01;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    addr = 64'b0;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(600*delay);
    // mode 01 done
    */
    /*
    RST = 0;
    start_in=0;
    in = 4224'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f1011;
    mode = 2'b10;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    addr = 64'b0;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(600*delay);
    */
    // mode 10 done
    
    RST = 0;
    start_in=0;
    leaf = 128'h030405060708090a0b0c0d0e0f101112;
    auth_path = 384'h0102030405060708090a0b0c0d0e0f10030405060708090a0b0c0d0e0f10111220f4efbff77f0000b327020001000000;
    leaf_idx = 32'h12345678;
    idx_offset = 32'habcdef10;
    tree_height = 32'd6;
    state_seed = 320'b0;
    addr = 256'h0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011;
    //pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(600*delay);
    
    $stop;
end
endmodule

