`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2023 01:30:31 PM
// Design Name: 
// Module Name: tb_AES256_CTR_DRBG_Update
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


module tb_AES256_CTR_DRBG_Update;
    reg start_in;
    reg CLK;
    reg RST;
    reg [255:0] key_in;
    reg [383:0] provided_data;
    reg [127:0] V_in;

    // Outputs
    wire [255:0] key_out;
    wire [127:0] V_out;
    wire valid_out;

    // Instantiate the Unit Under Test (UUT)
    AES256_CTR_DRBG_Update uut (
        .start_in(start_in), 
        .CLK(CLK), 
        .RST(RST), 
        .key_in(key_in), 
        .provided_data(provided_data), 
        .V_in(V_in), 
        .key_out(key_out), 
        .V_out(V_out), 
        .valid_out(valid_out)
    );

    wire [5:0] check_round;
    wire check_st;
    wire [127:0] check_cipher;
    wire [384:0] check_temp;
    assign check_round = uut.round_reg;
    assign check_st = uut.start_in_w;
    assign check_cipher = uut.cipher_w;
    assign check_temp = uut.temp_r;

    wire [127:0] V_w;

    assign V_w = uut.V_w;
 

    // Clock generation
    always #5 CLK = ~CLK;
    initial 
    begin
    CLK = 1'b0;
    #3 RST = 1'b0;
    #5 RST = 1'b1;
    start_in = 1'b1;
    key_in <= 256'hd1719e44_e6dca25f_7d194a8f_306497c8_ac35a069_fabf9fb2_3b639ec7_0892cadc;
    provided_data <= 384'hbce4a4f1_e8f590cb_32fd6099_e4793bd2_487b87f3_30b1f874_6bfcd438_af0b02e5_31463fca_0bc9ef1e_32d7de56_c2593ab6;
    V_in <= 128'h61234a54_99fda28c_a4a4a6b9_c9c322f9;
    #10 start_in = 1'b0;
    
    end
endmodule

