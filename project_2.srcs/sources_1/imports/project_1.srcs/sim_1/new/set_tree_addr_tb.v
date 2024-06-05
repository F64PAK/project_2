`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 03:27:40 PM
// Design Name: 
// Module Name: set_tree_addr_tb
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


module set_tree_addr_tb();
reg [255:0] addr_in; // 8x8 = 64
reg [63:0]   tree;
wire [255:0] addr_out;
RTL_set_tree_addr std_tb(addr_in,tree,addr_out);
initial begin
addr_in <= 256'b0;
tree <= 64'h1122334455667788;
#20 
#60 
#50 
#50 $finish;
end
endmodule
