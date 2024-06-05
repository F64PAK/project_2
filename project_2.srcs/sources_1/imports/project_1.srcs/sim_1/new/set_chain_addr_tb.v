`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 07:30:27 PM
// Design Name: 
// Module Name: set_chain_addr_tb
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


module set_chain_addr_tb(

    );

reg [255:0] addr_in; // 8x8 = 64
reg [31:0]   chain;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
wire [255:0] addr_out;
RTL_set_chain_addr sca_tb (addr_in,chain,addr_out);
 initial begin
   addr_in <= 256'b0;
   chain <= 32'h12345678;
   #50 $finish;
   end
endmodule
