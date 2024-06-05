`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 04:31:53 PM
// Design Name: 
// Module Name: copy_sub_tree_tb
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


module copy_sub_tree_tb(

    );

reg [255:0] addr_in,sub_in; // 8x8 = 64
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
 wire [255:0] addr_out;
   RTL_copy_subtree_addr cst_tb(addr_in,sub_in,addr_out);
   initial begin
   addr_in <= 256'b0;
   sub_in <= 256'h1122334433445566555566667788123456781234112233443344556655556666;
   #50 $finish;
   end
endmodule
