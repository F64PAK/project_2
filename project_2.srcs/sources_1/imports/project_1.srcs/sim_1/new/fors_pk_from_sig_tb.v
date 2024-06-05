`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 10:45:18 PM
// Design Name: 
// Module Name: fors_pk_from_sig_tb
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


module fors_pk_from_sig_tb(

    );
    reg            CLK;
    reg            RST;
    reg            start_in;
    reg    [199:0] m;
    reg    [127:0] sk_seed;
    reg    [319:0] state_seed;
    reg    [383:0] pub_seed;
    reg    [255:0] fors_addr;
    reg    [895:0] sig;
    wire   [127:0] pk;
    wire           valid_done_sig;
    wire           valid_out;
    fors_pk_from_sig fors_pk_from_sig_tb(
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
    .valid_done_sig(valid_done_sig),
    .valid_out(valid_out)
    );
    //"C:\Users\phamkiet\Verilog\project_1\sig.txt"
    reg [895:0] sig_reg [0:99]; 
    reg [895:0] sig_in;
initial
begin
$readmemh("/usr/luan_home2/Kiet/project_2/project_2.srcs/sources_1/imports/project_1.srcs/sim_1/new/sig.mem", sig_reg); 
end

parameter delay = 10;
always #(delay/2) CLK = ~CLK;
integer i; 
initial begin
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    m <= 200'h030405060708090a0b0c0d0e0f101112131415161718191a1b;
	sk_seed <= 128'h0405060708090a0b0c0d0e0f10111213;
    state_seed <= 320'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c;
    fors_addr <= 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    sig <= 896'h9e92c2a68ba4498769a64d072facff8624b2389ccc1ab035cd74a148ef18480facbbe7aa0c5e96a9fdaaf80c7cbde54842ea7c4e1e7d512a67d2bae9d8e925cb17adcde49c907104927e226bb7944b9bfa516f3729c8b05c893ed5aba461dfc93823f1f1ca9f5f7cae82ced33c41b722;
    #delay
    RST = 1;
    #delay
    for (i=0; i<33; i=i+1) begin
    sig_in = sig_reg[i];
    sig = sig_reg[i];
    //key_in = key[i];
    
    start_in = 1;
    
    
    #delay start_in = 0;
    #(490*delay); //475,5
    end
    /*
    for (i=0; i<33; i=i+1) begin
    sig_in = sig_reg[i];
    sig = sig_reg[i];
    //key_in = key[i];
    
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    end
    */
    //start_in=1;
    //$monitor ("%h", sig);
    //#delay
    //start_in = 0;
    //#(500000*delay);
    //RST = 0;
    //$display("%h",fors_sign.indices_wr);
    //$display("%h",auth_path);
    //#delay;
    #(600*delay);
    $stop;
end

endmodule
