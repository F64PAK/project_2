`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2023 04:12:46 PM
// Design Name: 
// Module Name: randombytes_tb
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


module randombytes_tb();
reg CLK;
reg RST;
reg start_in;
reg [127:0] x_in;
reg [255:0] key_in;
reg [127:0] V_in;
wire [127:0] V_out;
wire [127:0] x_out;
wire valid_out;
processing_randombytes process_ramdom_tb(CLK,
                                        RST,
                                        start_in,
                                        //x_in,
                                        key_in,
                                        V_in,
                                        V_out,
                                        x_out,
                                        valid_out);
parameter clock = 10;
always #(clock/2) CLK = ~CLK;
initial begin
    CLK =0;
    RST = 0;
    start_in = 1'b0;
    #clock
    RST = 1;
    //x_in = 128'b0;
    key_in = 256'h09B08230DBA8CA38B733A9FF951C0BD5D9308D31AEB2E96422BD3F809052666F;
    V_in = 128'h66D017ABB7A871BF2E70BB846196DA78;
    #clock
    start_in <= 1'b1;
    #clock
    start_in = 1'b0;
    #(1000*clock) $stop;
    // true
end
endmodule
