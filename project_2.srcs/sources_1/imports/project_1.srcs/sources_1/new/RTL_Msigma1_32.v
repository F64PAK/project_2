`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:21:19 PM
// Design Name: 
// Module Name: RTL_Msigma0_32
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


module RTL_Msigma1_32(x,result);
input wire [31:0] x;
output wire [31:0] result;
wire [31:0] result0,result1,result2;
RTL_ROTR_32 ROTR0_Ms0(.x(x),.c(17),.result(result0));
RTL_ROTR_32 ROTR1_Ms0(.x(x),.c(19),.result(result1));
RTL_SHR SHR_Ms0(.x(x),.c(10),.result(result2));
assign result = (result0 ^ result1 ^ result2);
endmodule
//#define sigma1_32(x) (ROTR_32(x,17) ^ ROTR_32(x,19) ^ SHR(x,10))