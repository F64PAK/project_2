`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 10:02:13 AM
// Design Name: 
// Module Name: load_bigendien_64_tb
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


module load_bigendien_64_tb(

    );
reg [63:0]bytes; //8 x 4 = 32 bit
wire [63:0] result;
RTL_load_bigendian_64 lb64_tb(bytes,result);
initial begin 
bytes <= 64'h0102030405060708;
#20
bytes <= 64'h1234567812345678;
#20
bytes <= 64'h1122334455667788;
end
endmodule
