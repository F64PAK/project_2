`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2024 08:20:45 AM
// Design Name: 
// Module Name: base_w_3
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


module base_w_3(input wire [11:0] in,
             output wire [95:0] out);
assign out[31:0] = in[3:0];
assign out[63:32] = in[7:4];
assign out[95:64] = in[11:8];
endmodule
