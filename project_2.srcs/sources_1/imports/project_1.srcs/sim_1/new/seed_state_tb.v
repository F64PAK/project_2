`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 05:37:36 PM
// Design Name: 
// Module Name: seed_state_tb
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


module seed_state_tb();
                reg           CLK;
                reg           RST;
                reg [127:0]   pub_seed;
                //reg [319:0]   state_seed;
                reg           start_in;
                wire [319:0]  state_out;
                wire      valid_out;
RTL_seed_state seed_state_tb(
                           CLK,
                           RST,
                           pub_seed,
                           //state_seed,
                           start_in,
                           state_out,
                           valid_out
    );
    parameter clock = 5;
    always #clock CLK=~CLK;
    initial begin
    CLK <= 0;
    RST <= 0;
    start_in <= 0;
    pub_seed <= 128'h01020300000000000000000000000000;
    //pub_seed <= 128'h16151413121110090807060504030201;
    //state_seed <= 320'b0;
    #(2*clock)   
    RST <= 1;
    start_in <= 1;
    #(2*clock)
    start_in <= 0;
    #(500*clock) $stop;
end
endmodule
