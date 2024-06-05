`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 09:52:47 AM
// Design Name: 
// Module Name: load_bigedian_32_tb
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


module load_bigedian_32_tb(

    );
reg [31:0]bytes; //8 x 4 = 32 bit
wire [31:0] result;
RTL_load_bigendian_32 lb32_tb(bytes,result);
initial begin 
bytes <= 32'h01020304;
#20
bytes <= 32'h12345678;
#20
bytes <= 32'h11223344;


end
endmodule
