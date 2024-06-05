`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2024 08:59:22 AM
// Design Name: 
// Module Name: gen_message_random_tb
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


module gen_message_random_tb(

    );
    reg            CLK;
    reg            RST;
    reg            start_in;
    reg    [31:0]  loop_in;
    reg    [127:0] sk_prf;
    reg    [127:0] optrand;
    reg    [511:0] m;
    reg    [31:0]  mlen;
    wire   [127:0] R;
    wire           valid_done_message;
    wire           valid_out;
    gen_message_random gen_message_random_tb(
    .CLK(CLK),
    .RST(RST),
    .start_in(start_in),
    .loop_in(loop_in),
    .sk_prf(sk_prf),
    .optrand(optrand),
    .m(m),
    .mlen(mlen),
    .R(R),
    .valid_done_message(valid_done_message),
    .valid_out(valid_out)
    );
    //"C:\Users\phamkiet\Verilog\project_1\sig.txt"

parameter delay = 10;
always #(delay/2) CLK = ~CLK;
integer i; 
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    
    /*
     //meln = 64 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd2; // 64 - 48 
    mlen = 32'd64;
    sk_prf = 128'h112233445566778899aabbccddeeff00;
    optrand = 128'h0102030405060708090a0b0c0d0e0f10;
    m = 384'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132;
    #delay
    RST = 1;
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    m = 512'h333435363738393a3b3c3d3e3f404142800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000480;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    */
    /*
     //meln = 32 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd1; // 64 - 48 
    mlen = 32'd39;
    sk_prf = 128'h112233445566778899aabbccddeeff00;
    optrand = 128'h0102030405060708090a0b0c0d0e0f10;
    m = 384'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728298000000000000003b8;
    #delay
    RST = 1;
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    */
    /*
     //meln = 45 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd2; // 45 + 16 > 55 
    mlen = 32'd45;
    sk_prf = 128'h112233445566778899aabbccddeeff00;
    optrand = 128'h0102030405060708090a0b0c0d0e0f10;
    m = 384'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f800000;
    #delay
    RST = 1;
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    m = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e8;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(50000*delay);
    */
    
     //mlen = 512 // > dung voi truong hop mlen >= 64 nhung can test them de xem vong lap
    loop_in = 32'd9; // 64 - 48 
    mlen = 32'd512;
    sk_prf = 128'h112233445566778899aabbccddeeff00;
    optrand = 128'h0102030405060708090a0b0c0d0e0f10;
    m = 384'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132;
    #delay
    RST = 1;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(133*delay);
    
    m = 512'h333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'h737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'hb3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'hf3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'h333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'h737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'hb3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    
    m = 512'hf3f4f5f6f7f8f9fafbfcfdfeff000102800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001280;
    #delay  start_in = 1;
    #delay start_in = 0;
    #(67*delay);
    #(132*delay);
    #(10*delay);
    
    $stop;
end
endmodule
