`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2024 09:23:21 AM
// Design Name: 
// Module Name: crypto_sign_seed_keypair_tb
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


module crypto_sign_seed_keypair_tb(

    );
	 	reg 			CLK;
        reg				RST;
        reg				start_in;
        reg		[319:0]	state_seed;// state_seed da tinh ra khong can truyen vao
        reg 	[383:0] seed; 
        wire    [511:0] sk;
        wire	[255:0] pk; 
        wire           	valid_out;
    crypto_sign_seed_keypair crypto_sign_seed_keypair_tb(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in),
             .state_seed(state_seed),
             .seed(seed), 
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
    seed = 512'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031;
    state_seed = 320'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a;
    #delay
    RST = 1;
    #delay
    start_in=1;
    #delay
    start_in = 0;
    #(400000*delay);
    //RST = 0;
    start_in = 0;
    seed = 512'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f3031;
    state_seed = 320'h030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a;
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
