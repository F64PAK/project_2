`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2024 12:36:32 PM
// Design Name: 
// Module Name: chain_lengths_tb
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


module chain_lengths_tb();
reg start_in,CLK,RST;
reg [127:0] msg;
wire [1119:0] out_lenghts;
wire valid_out;
chain_lengths chain_lengths_tb(start_in,CLK,RST,msg,out_lenghts,valid_out);
parameter delay = 10;
reg [1119:0] out;
wire [95:0] check;
assign check = out_lenghts[95:0];
always #(delay/2) CLK= !CLK;
initial begin

CLK = 0;
RST = 0;
start_in = 0;
msg = 128'h0c0d0e0f101112131415161718191a1b;
#delay
RST = 1;
#delay
start_in = 1;
#delay
start_in = 0;
#(50*delay)
    $display("%h", out_lenghts);
   

 $finish;
end
endmodule
