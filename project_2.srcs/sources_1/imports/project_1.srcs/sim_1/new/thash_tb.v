`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2024 03:51:30 PM
// Design Name: 
// Module Name: thash_tb
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


module thash_tb();
             reg 			CLK;
             reg			RST;
             reg			start_in;
             reg    [4479:0]in;
             reg	[1:0]	mode;
             reg	[319:0]	state_seed;
             reg    [383:0] pub_seed;
             reg	[255:0]	addr;
             wire	[127:0]	out;
             wire           valid_out;
thash thash_tb(.CLK(CLK),
               .RST(RST),
               .start_in(start_in),
               .in(in),
               .mode(mode),
               .pub_seed(pub_seed),
               .state_seed(state_seed),
               .addr(addr),
               .out(out),
               .valid_out(valid_out) );
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
    addr = 256'b0001001000110100010101100111100010011010101111001101111011110000000100110101011110011011110111110010010001101000101011001110000011111110111011011111101011001110110010101111111010111010101111101101111010101101101111101110111110001011101011011111000000001101;
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
    in = 4479'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132;
    mode = 2'b11;
    state_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    addr = 256'h0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(900*delay);
    
    // mode 11 done
    
    
    // inblocks = 1 -> buf = {576 bytes Z,22,16,26 bytes paddeed} (38 bytes = 304 bit)
    /// mode 00
    // inblocks = 2 -> buf = {576 bytes Z,22,32,10bytes padded} (54 bytes = 432 bit)
    // inblocks = 33 -> buf = {64 bytes Z,22,528,26 bytes padded} (550 bytes = 4400 bit) -> 576 bytes -> 9 lan loop 
    // inblocks = 35 -> buf = {22,560,58 bytes padded} (582 bytes = 4656 bit -> 640 bytes = 5120 bit) -> 9 lan lop
    $stop;
end
endmodule
