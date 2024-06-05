`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2023 04:37:38 PM
// Design Name: 
// Module Name: randombytes_tb2
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


module randombytes_tb2();
reg CLK;
reg RST;
reg start_in;
reg [127:0] x_in;
reg [31:0] loop_in;
reg [255:0] key_in;
reg [127:0] V_in;
wire [127:0] V_out;
wire [127:0] x_out;
wire [255:0] key_out;
wire valid_out,
     valid_exe;
ramdombytes ramdombytes_tb(CLK,RST,
                    start_in,
                    x_in,
                    loop_in,
                    key_in,
                    V_in,
                    key_out,
                    V_out,
                    x_out,
                    valid_exe,
                    valid_out);
parameter clock = 10;
always #(clock/2) CLK = ~CLK;
initial begin
    CLK =0;
    RST = 0;
    start_in = 1'b0;
    #clock
    RST = 1;
    loop_in <= 4; //loop = 4
    x_in = 128'b0;
    key_in <= 256'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122;
    V_in <= 128'h0405060708090a0b0c0d0e0f10111213;
    #clock
    start_in <= 1'b1;
    #clock
    start_in = 1'b0;
    #(117*clock) $stop;
    //check x,key,v;
end
endmodule

