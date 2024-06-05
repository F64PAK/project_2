`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2024 08:39:55 PM
// Design Name: 
// Module Name: crypto_sign_signature_tb
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


module crypto_sign_signature_tb(

    );
	reg            CLK;
    reg            RST;
    reg            start_in;
    reg    [511:0] sk;
    reg    [511:0] m; //511 bit/loop
    reg    [31:0]  mlen;
    reg    [255:0] key_in;              //randombyte
    reg    [127:0] V_in;                //randombyte
    wire   [255:0] key_out;             //randombyte 
    wire   [127:0] V_out;               //randombyte
    wire   [511:0] sig;
    wire   [63:0]  siglen;
    wire           valid_done_message; // tinh xong m -> truyen them message moi
	wire    	   valid_out_loop;		// xuat ra 512 bit ket qua
    wire           valid_out;			// thuc thi xong
    crypto_sign_signature crypto_sign_signature_tb(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in),
		.sk(sk),
		.m(m), //511 bit/loop
		.mlen(mlen),
		.key_in(key_in),              //randombyte
		.V_in(V_in),                //randombyte
		.key_out(key_out),             //randombyte 
		.V_out(V_out),               //randombyte
		.sig(sig),
		.siglen(siglen),
		.valid_done_message(valid_done_message), // tinh xong m -> truyen them message moi
		.valid_out_loop(valid_out_loop),		// xuat ra 512 bit ket qua
		.valid_out(valid_out)			// thuc thi xong
    );
    parameter delay = 10;
always #(delay/2) CLK = ~CLK;
always @(posedge valid_out_loop) begin
    $monitor ("%h", sig);
    //$monitor ("%h", crypto_sign_signature_tb.buff_out_reg);
end
integer i; 
initial begin
    
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
   
     //mlen = 512 // (nap 2 lan : gen_message va hash_message
    mlen = 32'd33;
    key_in = 256'h92f267aafa3f87ca60d01cb54f29202a3e784ccb7ebcdcfd45542b7f6af77874;
    V_in = 128'h2e0f4479175084aa488b3b74340678aa;
    sk = 512'h7C9935A0B07694AA0C6D10E4DB6B1ADD2FD81A25CCB148032DCD739936737F2DB505D7CFAD1B497499323C8686325E474FDFA42840C84B1DDD0EA5CE46482020;
    
    
    //m = 384'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132;
    m = 384'hd81c4d8d734fcbfbeade3d3f8a039faa2a2c9957e835ad55b22e75bf57bb556ac8800000000000000000000000000388;
    #delay
    RST = 1;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(500*delay);
    /*
    m = 512'h333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'hb3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'hf3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'hb3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'hf3f4f5f6f7f8f9fafbfcfdfeff000102800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001280;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(210*delay);
    */
    /////////////////////////////////////////////////////////////////
    m = 128'hd81c4d8d734fcbfbeade3d3f8a039faa;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h2a2c9957e835ad55b22e75bf57bb556ac88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000288;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    /*
    m = 512'h535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'hd3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'h939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(100*delay);
    
    m = 512'hd3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff00010280000000000000000000000000001180;
    #delay  start_in = 1;
    #delay start_in = 0;
    */
    #(8000000*delay);
    
    $stop;
end
endmodule
