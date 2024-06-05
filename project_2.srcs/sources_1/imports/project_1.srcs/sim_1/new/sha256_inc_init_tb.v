`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2023 12:16:48 PM
// Design Name: 
// Module Name: sha256_inc_init_tb
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


module sha256_inc_init_tb();

wire [319:0] state_out;
RTL_sha256_inc_init sha256_inc_init_tb0(state_out);
initial 
begin
#10 $stop;
end
endmodule
