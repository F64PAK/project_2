`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 01:51:00 PM
// Design Name: 
// Module Name: wots_pk_from_sig_tb
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


module wots_pk_from_sig_tb(

    );
    reg            CLK;
    reg            RST;
    reg            start_in;
    reg    [127:0] msg;
    reg    [319:0] state_seed;
    reg    [383:0] pub_seed;
    reg    [255:0] addr;
    reg    [127:0] sig;
    wire   [127:0] pk;
    wire           valid_out_en;
    wire           valid_out;
    wots_pk_from_sig wots_pk_from_sig_tb(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in),
        .msg(msg),
        .sig(sig),
        .state_seed(state_seed),
        .pub_seed(pub_seed),
        .addr(addr),
        .pk(pk), 
        .valid_out_en(valid_out_en), // 1 loop
        .valid_out(valid_out)    //35 loop
    );
    //"C:\Users\phamkiet\Verilog\project_1\sig.txt"
    reg [127:0] sig_reg [0:35]; 
    reg [127:0] sig_in;
initial
begin
$readmemh("/usr/luan_home2/Kiet/project_2/project_2.srcs/sources_1/imports/project_1.srcs/sources_1/new/sig2.mem", sig_reg); 
end
always @(posedge valid_out_en) begin
    $monitor ("%h", pk);
end
parameter delay = 10;
always #(delay/2) CLK = ~CLK;
integer i; 
initial begin
    
    CLK = 1'b0;
    RST = 0;
    start_in = 0;
    pub_seed = 319'h02030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20212223242526272829;
    msg <= 128'h030405060708090a0b0c0d0e0f101112;
	state_seed <= 320'h05060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c;
    addr <= 256'h123456789abcdef013579bdf2468ace0feedfacecafebabedeadbeef8badf00d;
    #delay
    RST = 1;
    #delay
    for (i=0; i<35; i=i+1) begin
    sig_in = sig_reg[i];
    sig = sig_reg[i];
    //key_in = key[i];
    
    #delay  start_in = 1;
    
    
    #delay start_in = 0;
    #(50000*delay);
    end
    /*
    for (i=0; i<35; i=i+1) begin
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
    $stop;
end

endmodule
