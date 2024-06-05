`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 10:15:52 AM
// Design Name: 
// Module Name: RTL_store_bigendian_64
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


module RTL_store_bigendian_64(value,bytes);
input wire [63:0] value; // 8 x 8 = 64
output wire [63:0] bytes;
assign bytes[7:0] = value[7:0];
assign bytes[15:8] = value[15:8];
assign bytes[23:16] = value[23:16];
assign bytes[31:24] = value[31:24];
assign bytes[39:32] = value[39:32];
assign bytes[47:40] = value[47:40];
assign bytes[55:48] = value[55:48];
assign bytes[63:56] = value[63:56];
endmodule
