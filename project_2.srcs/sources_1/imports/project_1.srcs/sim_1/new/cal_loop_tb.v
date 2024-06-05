`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2024 11:12:38 AM
// Design Name: 
// Module Name: cal_loop_tb
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


module cal_loop_tb(

    );
        reg                CLK;
        reg                RST;
        reg                start_in;
        reg    [31:0]      mlen;
        wire   [31:0]      loop_out; 
        wire               valid_out ;
    cal_loop cal_loop_wr(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in),
        .mlen(mlen),
        .loop_out(loop_out), 
        .valid_out(valid_out)    
    );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    mlen = 64'd16;
    #delay
    RST = 1;
    #delay
    start_in = 1;
    #delay
    start_in = 0;
    #(10*delay)
    
    start_in = 0;
    mlen = 64'd120;
    #delay
    RST = 1;
    #delay
    start_in = 1;
    #delay
    start_in = 0;
    #(10*delay)
    
    start_in = 0;
    mlen = 64'd568;
    #delay
    RST = 1;
    #delay
    start_in = 1;
    #delay
    start_in = 0;
    #(10*delay)
    $stop;

end
endmodule
