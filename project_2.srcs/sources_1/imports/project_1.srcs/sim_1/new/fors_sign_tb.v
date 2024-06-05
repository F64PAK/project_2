`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2024 08:52:59 AM
// Design Name: 
// Module Name: fors_sign_tb
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


module fors_sign_tb(
    
    );
    reg            CLK;
    reg            RST;
    reg            start_in;
    reg    [199:0] m;
    reg    [127:0] sk_seed;
    reg    [319:0] state_seed;
    reg    [383:0] pub_seed;
    reg    [255:0] fors_addr;
    wire   [895:0] sig;
    wire   [127:0] pk;
    wire           valid_out_sig;
    wire           valid_out;
    fors_sign fors_sign_tb(
    .CLK(CLK),
    .RST(RST),
    .start_in(start_in),
    .m(m),
    .sk_seed(sk_seed),
    .state_seed(state_seed),
    .pub_seed(pub_seed),
    .fors_addr(fors_addr),
    .sig(sig),
    .pk(pk),
    .valid_out_sig(valid_out_sig),
    .valid_out(valid_out)
    );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
always @(posedge valid_out_sig) begin
    $monitor ("%h", sig);
end
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    m <= 200'h030405060708090a0b0c0d0e0f101112131415161718191a1b;
	sk_seed <= 128'h0405060708090a0b0c0d0e0f10111213;
    state_seed <= 320'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c;
    fors_addr <= 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    RST = 1;
    #delay
    start_in=1;
    //$monitor ("%h", sig);
    #delay
    start_in = 0;
    #(500000*delay);
    //RST = 0;
    //$display("%h",fors_sign.indices_wr);
    //$display("%h",auth_path);
    //#delay;
    $stop;
end

endmodule
