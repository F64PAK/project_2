`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 08:22:43 PM
// Design Name: 
// Module Name: randombyte_init_tb
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


module randombyte_init_tb();
        reg              start_in;
        reg              CLK;
        reg              RST;
        reg     [383:0]  entropy_input;
        reg     [383:0]  personalization_string;
        reg     [31:0]   security_strength;
        wire    [255:0]  key_out;
        wire    [127:0]  V_out;
        wire             valid_out;

parameter clock = 10;
always #(clock/2) CLK=~CLK;
randombytes_init ramdombytes_init_tb (
                      .start_in(start_in),
                      .CLK(CLK),
                      .RST(RST),
                      .entropy_input(entropy_input),
                      
                      .security_strength(security_strength),
                      .key_out(key_out),
                      .V_out(V_out),
                      .valid_out(valid_out)
    );
initial
    begin
    start_in <= 1'b0;
    CLK <=1'b0;
    RST <=1'b0;
    #clock
    RST <= 1'b1;
    entropy_input <= 384'h5468697320697320656e74726f7079000000000000000000000000000000000000000000000000000000000000000000;
    //personalization_string <= 384'h506572736f6e616c697a6174696f6e000000000000000000000000000000000000000000000000000000000000000000;
    security_strength <= 128;
    #clock
    start_in <= 1'b1;
    #clock
    start_in <= 1'b0;
    #(clock*60) $stop;
    end
endmodule
