`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 10:13:46 AM
// Design Name: 
// Module Name: RTL_store_bigendian_32
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


module RTL_store_bigendian_32(value,bytes);
input wire [31:0]value;
output wire [31:0] bytes;
assign bytes[7:0] = value[7:0];
assign bytes[15:8] = value[15:8];
assign bytes[23:16] = value[23:16];
assign bytes[31:24] = value[31:24];
endmodule
