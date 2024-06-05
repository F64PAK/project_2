`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 03:02:19 PM
// Design Name: 
// Module Name: set_layer_addr_tb
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


module set_layer_addr_tb();

reg [255:0] addr_in; // 8x8 = 64
reg [31:0]   layer;
//reg            CLK;
//reg            RST;
//reg            start_in;
wire [255:0] addr_out;
//wire valid_out;
RTL_set_layer_addr sla_tb(addr_in,layer,addr_out);

initial begin
addr_in <= 256'h1122334455667788;
layer <= 32'h99001234;
#20 

#50 $finish;
end
endmodule
