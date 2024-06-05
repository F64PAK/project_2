`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 08:14:41 PM
// Design Name: 
// Module Name: bytes_to_ull_tb
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


module bytes_to_ull_tb(

    );

reg [63:0] byte; // 8x8 = 64
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
wire [63:0] ull;
    RTL_bytes_to_ull btull_tb (byte,ull);
    initial begin
    byte <= 64'h123456789ABCDEF0;    
    end
endmodule
