`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 05:04:04 PM
// Design Name: 
// Module Name: copy_keypair_addr_tb
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


module copy_keypair_addr_tb(

    );
    
reg [255:0] addr_in,addr_sub; // 8x8 = 64
reg [31:0]   keypair;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in,start_in_sub;
wire [255:0] addr_out;
//output  reg valid_out;
//wire [255:0] out_copy_sub_tree;
RTL_copy_keypair_addr ckpa_tb(addr_in,addr_sub,keypair,addr_out);
 initial begin
   addr_in <= 256'b0;
   addr_sub <= 256'h1122334433445566555566667788123456781234112233443344556655556666;
   keypair <= 32'h12345678;
   #50 $finish;
   end
endmodule
