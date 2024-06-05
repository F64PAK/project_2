`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 01:54:55 PM
// Design Name: 
// Module Name: sha256_inc_blocks_tb
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


module sha256_inc_blocks_tb();
reg 			CLK;
reg			RST;
reg     start_in;
reg	[511:0]	message_in;
reg [319:0]	digest_in;
wire [319:0]	digest_out;
wire valid_out;
RTL_sha256_inc_blocks sha256_inc_blocks_tb(CLK,RST,start_in,message_in,digest_in,digest_out,valid_out);
parameter clock = 5;
always #clock CLK=~CLK;
initial begin
    CLK <= 0;
    RST <= 0;
    start_in <= 0;
    message_in <= 512'b0;
    digest_in <= 320'b0;
    #(2*clock)   
    RST <= 1;
    start_in <= 1;
    #(2*clock)
    start_in <= 0;
    #(500*clock) $stop;
end
endmodule
