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


module RTL_Sigma1_32(x,result);
input wire [31:0] x;
output wire [31:0] result;
wire [31:0] result0,result1,result2;
RTL_ROTR_32 ROTR0_S1(.x(x),.c(6),.result(result0));
RTL_ROTR_32 ROTR1_S1(.x(x),.c(11),.result(result1));
RTL_ROTR_32 ROTR2_S1(.x(x),.c(25),.result(result2));
assign result = (result0 ^ result1 ^ result2);
endmodule
//#define Sigma1_32(x) (ROTR_32(x, 6) ^ ROTR_32(x,11) ^ ROTR_32(x,25))