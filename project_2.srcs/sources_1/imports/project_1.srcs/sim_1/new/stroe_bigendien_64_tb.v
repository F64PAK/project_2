`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 10:19:30 AM
// Design Name: 
// Module Name: stroe_bigendien_64_tb
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


module stroe_bigendien_64_tb(

    );

reg [63:0] value; // 8 x 8 = 64
wire [63:0] bytes;
RTL_store_bigendian_64 sb64_tb(value,bytes);
initial begin
value <= 64'h0102030405060708;
#20
value <= 64'h1234567812345678;
#20
value <= 64'h1122334455667788;

end
endmodule
