`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 10:19:30 AM
// Design Name: 
// Module Name: stroe_bigendien_32_tb
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


module stroe_bigendien_32_tb(

    );

reg [31:0]value;
wire [31:0] bytes;
RTL_store_bigendian_32 sbb32_tb(value,bytes);
initial begin
value <= 32'h12345678;
#20
value <= 32'h11223344;
#20
value <= 32'h01020304;
end
endmodule
