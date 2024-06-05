`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 02:25:49 PM
// Design Name: 
// Module Name: prf_addr_tb
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


module prf_addr_tb();
             reg 			CLK;
             reg			RST;
             reg			start_in;
             reg    [127:0] key;
             reg    [255:0] addr;
             wire	[127:0]	out;
             wire           valid_out;
prf_addr prf_addr_tb(
             CLK,
             RST,
             start_in,
             key,
             addr,
             out,
             valid_out );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
initial begin
    CLK=0;
    
    RST = 0;
    start_in=0;
    key = 128'h0102030405060708090a0b0c0d0e0f10;
    addr = 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(100*delay);
    key = 128'h2122232425262728292a2b2c2d2e2f30;
    addr = 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(100*delay);
    $stop;
end
endmodule
