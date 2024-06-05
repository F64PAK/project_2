`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 03:38:23 PM
// Design Name: 
// Module Name: gen_chain_tb
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


module gen_chain_tb();
reg CLK;
reg RST;
reg start_in;
reg [128:0] in;
reg [319:0]	state_seed;
reg [383:0] pub_seed;
reg [255:0]	addr;
reg [31:0]  start;
reg [31:0]  steps;
wire [127:0]	out;
wire valid_out;
gen_chain gen_chain_tb(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in),
             .in(in),
             .state_seed(state_seed),
             .pub_seed(pub_seed),
             .addr(addr),
             .start(start),
             .steps(steps),
             .out(out),
             .valid_out(valid_out)
    );   
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    start = 32'd2;
    steps = 32'd20;
    in = 128'h060708090a0b0c0d0e0f101112131415;
    //pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    //addr = 256'b0001001000110100010101100111100010011010101111001101111011110000000100110101011110011011110111110010010001101000101011001110000011111110111011011111101011001110110010101111111010111010101111101101111010101101101111101110111110001011101011011111000000001101;
    state_seed = 320'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a;
    addr = 256'h123456789abcdef013579bdf2468ace0feedfacecafe02bedeadbeef8badf00d;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(1000*delay);
    
    // mode 11 done
    
    
    // inblocks = 1 -> buf = {576 bytes Z,22,16,26 bytes paddeed} (38 bytes = 304 bit)
    /// mode 00
    // inblocks = 2 -> buf = {576 bytes Z,22,32,10bytes padded} (54 bytes = 432 bit)
    // inblocks = 33 -> buf = {64 bytes Z,22,528,26 bytes padded} (550 bytes = 4400 bit) -> 576 bytes -> 9 lan loop 
    // inblocks = 35 -> buf = {22,560,58 bytes padded} (582 bytes = 4656 bit -> 640 bytes = 5120 bit) -> 9 lan lop
    $stop;
end
 
endmodule
