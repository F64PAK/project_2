`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 04:06:44 PM
// Design Name: 
// Module Name: set_type
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


module set_type();
reg [255:0] addr_in; // 8x8 = 64
reg  [31:0]   type;
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
wire [255:0] addr_out;
//output  reg valid_out;
RTL_set_type st_tb(addr_in,type,addr_out);
initial begin
addr_in <= 256'b0;
type <= 32'h12345678;
#20 

#50 $finish;
end
endmodule

