`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 04:47:04 PM
// Design Name: 
// Module Name: set_key_pair_tb
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


module set_key_pair_tb(

    );

reg [255:0] addr_in; // 8x8 = 64
reg [31:0]   keypair;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
wire [255:0] addr_out;
RTL_set_keypair_addr skp_tb(addr_in,keypair,addr_out);

initial begin
addr_in <= 256'b0;
keypair <= 32'h12345678;
#20 $finish;
end
endmodule
