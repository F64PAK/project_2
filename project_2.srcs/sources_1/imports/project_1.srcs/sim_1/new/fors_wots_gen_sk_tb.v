`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2024 03:50:51 PM
// Design Name: 
// Module Name: fors_wots_gen_sk_tb
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


module fors_wots_gen_sk_tb(

    );
             reg 			CLK;
             reg			RST;
             reg			start_in;
             reg    [127:0] sk_seed;
             reg    [255:0] addr;
             reg            mode;
             wire	[127:0]	sk_out;
             wire           valid_out;
fors_wots_gen_sk fors_wots_gen_sk_tb(
             CLK,
             RST,
             start_in,
             sk_seed,
             addr,
             mode,
             sk_out,
             valid_out );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
initial begin
    CLK=0;
    
    RST = 0;
    start_in=0;
    mode = 1'b0;
    sk_seed = 128'h2122232425262728292a2b2c2d2e2f30;
    addr = 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(100*delay);
    mode = 1'b1;
    sk_seed = 128'h2122232425262728292a2b2c2d2e2f30;
    addr = 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(100*delay);
    $stop;
end
endmodule
