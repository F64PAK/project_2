`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 09:46:34 AM
// Design Name: 
// Module Name: RTL_load_bigendian_32
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


module RTL_load_bigendian_32(bytes,result);
input wire [31:0]bytes; //8 x 4 = 32 bit
output wire [31:0] result;
assign result[7:0] = bytes[7:0];
assign result[15:8] = bytes[15:8];
assign result[23:16] = bytes[23:16];
assign result[31:24] = bytes[31:24];
endmodule
