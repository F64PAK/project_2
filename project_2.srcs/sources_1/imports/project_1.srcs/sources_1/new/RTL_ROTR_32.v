`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:00:32 PM
// Design Name: 
// Module Name: RTL_ROTR_32
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


module RTL_ROTR_32(x,c,result);
input wire [31:0] x,c;
output wire [31:0] result;
assign result = (x >> c) | (x << (32 - c));
endmodule
//#define ROTR_32(x, c) (((x) >> (c)) | ((x) << (32 - (c))))