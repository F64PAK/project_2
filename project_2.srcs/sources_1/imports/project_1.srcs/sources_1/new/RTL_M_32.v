`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:28:59 PM
// Design Name: 
// Module Name: RTL_M_32
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


module RTL_M_32(w0, w14, w9, w1,w0_out);
input wire [31:0] w0, w14, w9, w1;
output wire [31:0] w0_out;
wire [31:0] result0,result1;
RTL_Msigma1_32 Msigma1_M(.x(x),.result(result0));
RTL_Msigma0_32 Msigma0_M(.x(x),.result(result1));
assign w0_out = result0 + (w9) + result1 + (w0);
endmodule
//#define M_32(w0, w14, w9, w1) w0 = sigma1_32(w14) + (w9) + sigma0_32(w1) + (w0);