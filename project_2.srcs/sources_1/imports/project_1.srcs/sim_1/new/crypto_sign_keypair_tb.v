`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2024 02:55:02 PM
// Design Name: 
// Module Name: crypto_sign_keypair_tb
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


module crypto_sign_keypair_tb(
        
    );
        reg CLK;
        reg RST;
        reg start_in;
        reg [255:0] key_in;
        reg [127:0] V_in;
        wire [255:0] key_out; //suy nghi ve wire 
        wire [127:0] V_out;   //suy nghi ve wire
        wire [511:0] sk;      //suy nghi ve wire
        wire [255:0] pk;      //suy nghi ve wire
        wire  valid_out;
    crypto_sign_keypair crypto_sign_keypair_tb(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in),
        .key_in(key_in),
        .V_in(V_in),
        .key_out(key_out), 
        .V_out(V_out),   
        .sk(sk),      
        .pk(pk),      
        .valid_out(valid_out)
    );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    key_in <= 256'h551adad88a50bae76036210fc02409aeb8d86e19814baf17d7d3430f204f60ff;
    V_in <= 128'h770a8fec5838d30a0127b455a7e7ca2f;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(400000*delay);
    //RST = 0;
    key_in <= 256'b0;
    V_in <= 128'b0;
    start_in = 0;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(400000*delay);
    //$display("%h",auth_path);
    //#delay;
    $stop;
end

endmodule
