`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2024 09:29:27 AM
// Design Name: 
// Module Name: wots_checksum_tb
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


module wots_checksum_tb();
reg start_in,CLK,RST;
reg [1023:0] msg_base_w;
wire [95:0] csum_base_w;
wire valid_out;
wots_checksum wots_checksum_tb(start_in,CLK,RST,msg_base_w,csum_base_w,valid_out);
parameter delay = 10;
always #(delay/2) CLK= !CLK;
initial begin
CLK = 0;
RST = 0;
start_in = 0;
msg_base_w = 1023'h0;
#delay
RST = 1;
#delay
start_in = 1;
#delay
start_in = 0;
#(50*delay) $stop;
end
endmodule
