`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 10:18:56 PM
// Design Name: 
// Module Name: crypto_sign_verify_tb
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


module crypto_sign_verify_tb(
    );
	reg            		CLK;
    reg            		RST;
    reg            		start_in;
    reg    [895:0]	    in; //17088 bytes
    reg    [511:0] 		m; //511 bit/loop
    reg    [31:0]  		mlen;
    reg    [255:0]  	pk;
    wire             	valid_done_message; // tinh xong m -> truyen them message moi
    wire                valid_verify;
    wire             	valid_out;			// thuc thi xong
    wire					valid_done_hash_message;
	wire					valid_done_loop_fors;
	wire					valid_done_fors;
	wire					valid_done_loop_wots;
	wire					valid_done_thash;
	wire					valid_done_compute_root;
    crypto_sign_verify crypto_sign_verify_tb(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in),
		.in(in), //17088 bytes
		.m(m), //511 bit/loop
		.mlen(mlen),
		.pk(pk),
		.valid_done_message(valid_done_message), // tinh xong m -> truyen them message moi
		.valid_verify(valid_verify),
		.valid_out(valid_out),			// thuc thi xong
		.valid_done_hash_message(valid_done_hash_message),
		.valid_done_loop_fors(valid_done_loop_fors),
		.valid_done_fors(valid_done_fors),
		.valid_done_loop_wots(valid_done_loop_wots),
		.valid_done_thash(valid_done_thash),
		.valid_done_compute_root(valid_done_compute_root)
    );
	parameter delay = 10;
always #(delay/2) CLK = ~CLK;
//always @(posedge valid_out_loop) begin
    //$monitor ("%h", sig);
    //$monitor ("%h", crypto_sign_signature_tb.buff_out_reg);
//end
    reg [896:0] sig_reg [0:826]; 
    integer i;
    integer z,y;
initial begin
    $readmemh("C:/Users/phamkiet/Verilog/project_2/project_2.srcs/sources_1/imports/project_1.srcs/sources_1/new/sig_verify.mem", sig_reg); 

end
always @(i) begin
    in = sig_reg[i];
end
/*
initial begin 
    for (i=0; i<267; i=i+1) begin
        sig = {sig[136575:0],sig_reg[i]};
    end
end
*/
/*
initial begin
    
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    pk = 256'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021;
     //mlen = 512 // (nap hash_message)
    mlen = 32'd512;
    m = 128'h030405060708090a0b0c0d0e0f101112;
    #delay
    RST = 1;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'hd3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'hd3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff00010280000000000000000000000000001180;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(900000*delay);
    
    $stop;
end
*/

initial begin
    
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    pk = 256'hB505D7CFAD1B497499323C8686325E474FDFA42840C84B1DDD0EA5CE46482020;
     //mlen = 512 // (nap hash_message)
    mlen = 32'd33;
    m = 128'hd81c4d8d734fcbfbeade3d3f8a039faa;
    #delay
    RST = 1;
    i = 0;
    //////////////////////////////////////////
    /////////////////////////////////////////
    #delay  start_in = 1;
    #delay start_in = 0;
    #(200*delay);
    
    m = 512'h2a2c9957e835ad55b22e75bf57bb556ac88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000288;
    #delay start_in = 1;
    #delay start_in = 0;
    //#(200*delay);
    #(1100*delay);
    //////////////////////////////////
    ///HASH_MESSAGE///////////////////
    //////////////////////////////////
    
    //for (i=0; i<33; i=i+1) begin
    for (i=1; i<34; i=i+1) begin
    //sig_in = sig_reg[i];
    //sig = sig_reg[i];
    //key_in = key[i];
    start_in = 1;
    #delay start_in = 0;
    #(490*delay); //475,5
    end
    i = i - 1;
    #(1000*delay);
    //////////////////////////////////
    //////FORS////////////////////////
    //////////////////////////////////
    for (z = 0 ; z<22; z=z+1) begin // LOOP
        for(y = 0 ; y < 35; y=y+1) begin // WOTS
            i = i + 1;
            start_in = 1;
            #delay start_in = 0;
            #(5000*delay); //475,5
        end
        // Compute_root
        i = i + 1;
        start_in = 1;
        #delay start_in = 0;
        #(5000*delay); //475,5
    end
    
    ///////////////////////////////////
    ///LOOP//////////////////
    //////////////////////////
    #(900000*delay);
    
    $stop;
end

endmodule

