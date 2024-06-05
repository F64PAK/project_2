`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 09:56:37 AM
// Design Name: 
// Module Name: RTL_load_bigendian_64
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


module RTL_load_bigendian_64(bytes,result);
input wire [63:0] bytes; // 8 x 8 = 64
output wire [63:0] result;
assign result[7:0] = bytes[7:0];
assign result[15:8] = bytes[15:8];
assign result[23:16] = bytes[23:16];
assign result[31:24] = bytes[31:24];
assign result[39:32] = bytes[39:32];
assign result[47:40] = bytes[47:40];
assign result[55:48] = bytes[55:48];
assign result[63:56] = bytes[63:56];
endmodule
