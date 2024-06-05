`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:07:27 PM
// Design Name: 
// Module Name: RTL_Maj
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


module RTL_Maj(x,y,z,result);
input wire [31:0] x,y,z;
output wire [31:0] result;
assign result = (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)));
//#define Maj(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
endmodule
