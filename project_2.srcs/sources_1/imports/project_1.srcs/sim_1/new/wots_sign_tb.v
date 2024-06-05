`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 03:31:40 PM
// Design Name: 
// Module Name: wots_sign_tb
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


module wots_sign_tb(

    );
    reg            CLK;
    reg            RST;
    reg            start_in;
    reg    [127:0] msg;
    reg    [127:0] sk_seed;
    reg    [319:0] state_seed;
    reg    [383:0] pub_seed;
    reg    [255:0] addr;
    //wire   [895:0] out;
    wire   [127:0] sig;
    wire           valid_out_en;
    wire           valid_out;
    wots_sign wots_sign_tb(
    .CLK(CLK),
    .RST(RST),
    .start_in(start_in),
    .msg(msg),
    .sk_seed(sk_seed),
    .state_seed(state_seed),
    .pub_seed(pub_seed),
    .addr(addr),
    .sig(sig),
    .valid_out_en(valid_out_en),
    .valid_out(valid_out)
    );
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
always @(posedge valid_out_en) begin
    $monitor ("%h", sig);
end
//$monitor ("%h", wots_sign_tb.lenght_wr);
initial begin
    //$monitor ("%h", wots_sign_tb.lenght_wr);
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    msg <= 128'h501553745e12d7d1adbbd6e1aea83345;
	sk_seed <= 128'h0708090a0b0c0d0e0f10111213141516;
    state_seed <= 320'hcc997fd6f639c2de6e523479076bafb42131d8d6bf0feffe8440a62c43bbeda40000000000000040;
    addr <= 256'hce1a230061ac50d50000008c0000060000000000000000000000000000000000;
    #delay
    RST = 1;
    #delay
    start_in=1;
    //$monitor ("%h", sig);
    #delay
    start_in = 0;
    #(100000*delay);
    //RST = 0;
    //$display("%h",fors_sign.indices_wr);
    //$display("%h",auth_path);
    //#delay;
    msg <= 128'h501553745e12d7d1adbbd6e1aea83345;
	sk_seed <= 128'h0708090a0b0c0d0e0f10111213141516;
    state_seed <= 320'hcc997fd6f639c2de6e523479076bafb42131d8d6bf0feffe8440a62c43bbeda40000000000000040;
    addr <= 256'hce1a230061ac50d50000008c0000060000000000000000000000000000000000;
    start_in=1;
    //$monitor ("%h", sig);
    #delay
    start_in = 0;
    #(500000*delay);
    $stop;
end
endmodule
