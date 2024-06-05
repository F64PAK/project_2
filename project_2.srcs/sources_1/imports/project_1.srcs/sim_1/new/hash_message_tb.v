`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 09:22:04 PM
// Design Name: 
// Module Name: hash_message_tb
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


module hash_message_tb(

    );
	reg		         CLK;
    reg		         RST;
    reg		         start_in;
    reg		 [255:0] pk;
    reg		 [127:0] R;
    reg		 [31:0]  loop_in;
    reg		 [511:0] m; //511 bit/loop
    reg		 [31:0]  mlen;
    wire     [199:0] digest;
    wire     [63:0]  tree;
    wire     [31:0]  leaf_idx;
    wire             valid_done_message;
    wire             valid_out;
    hash_message hash_message_tb(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in),
		.pk(pk),
		.R(R),
		.loop_in(loop_in),
		.m(m), //511 bit/loop
		.mlen(mlen),
		.digest(digest),
		.tree(tree),
		.leaf_idx(leaf_idx),
		.valid_done_message(valid_done_message),
		.valid_out(valid_out)
    );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
integer i; 
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    
    
     //meln = 64 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    /*
    loop_in = 32'd2; // 64 - 48 
    mlen = 32'd15;
    R = 128'h0405060708090a0b0c0d0e0f10111213;
    pk = 256'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021222324;
    m = 128'h030405060708090a0b0c0d0e0f101180;
    #delay
    RST = 1;
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    m = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001f8;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    */ //done
    /*
    //meln = 7 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd1; // 64 - 48 
    mlen = 32'd7;
    R = 128'h0405060708090a0b0c0d0e0f10111213;
    pk = 256'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021222324;
    m = 384'h030405060708098000000000000001b8; //padded
    #delay
    RST = 1;
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    */ //done
    
    /*
     //meln = 16 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd1; // 64 - 48 (thuc te la 2 lan (inc + final) inc duoc tinh ben trong -> mlen = 64 -> loop_in = 1
    mlen = 32'd16;
    R = 128'h0405060708090a0b0c0d0e0f10111213;
    pk = 256'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021222324;
    m = 128'h030405060708090a0b0c0d0e0f101112;
    #delay
    RST = 1;
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    m = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    */
    
     //mlen = 512 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd8; // 64 - 48 (thuc te la 2 lan (inc + final) inc duoc tinh ben trong -> mlen = 64 -> loop_in = 1
    mlen = 32'd512; // loop_in = 8 ((512-16)/64) == 7 loop + 48 bit = 8 loop (48<55)
    R = 128'h0405060708090a0b0c0d0e0f10111213;
    pk = 256'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021222324;
    m = 128'h030405060708090a0b0c0d0e0f101112;
    #delay
    RST = 1;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'h131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'h535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'h939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'hd3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'h131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'h535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'h939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    m = 512'hd3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff00010280000000000000000000000000001180;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    
    $stop;
    
end

endmodule
