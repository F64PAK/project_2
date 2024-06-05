`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:11:57 PM
// Design Name: 
// Module Name: RTL_Sigma0_32
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


module RTL_Sigma0_32(x,result);
input wire [31:0] x;
output wire [31:0] result;
wire [31:0] result0,result1,result2;
RTL_ROTR_32 ROTR0_S0(.x(x),.c(2),.result(result0));
RTL_ROTR_32 ROTR1_S0(.x(x),.c(13),.result(result1));
RTL_ROTR_32 ROTR2_S0(.x(x),.c(22),.result(result2));
assign result = (result0 ^ result1 ^ result2);
endmodule
//#define Sigma0_32(x) (ROTR_32(x, 2) ^ ROTR_32(x,13) ^ ROTR_32(x,22))