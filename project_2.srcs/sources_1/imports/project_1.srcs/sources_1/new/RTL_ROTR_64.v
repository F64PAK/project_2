`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:00:32 PM
// Design Name: 
// Module Name: RTL_ROTR_64
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


module RTL_ROTR_64(x,c,result);
input wire [63:0] x,c;
output wire [63:0] result;
assign result = (x >> c) | (x << (64 - c));
//#define ROTR_64(x, c) (((x) >> (c)) | ((x) << (64 - (c))))
endmodule
