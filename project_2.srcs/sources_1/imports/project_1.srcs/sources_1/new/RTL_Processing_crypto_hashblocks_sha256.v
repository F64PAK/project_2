`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 07:37:36 PM
// Design Name: 
// Module Name: RTL_Processing_crypto_hashblocks_sha256
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


module RTL_Processing_crypto_hashblocks_sha256(
    input CLK,RST,start_in,
    input [511:0] in,
    input [255:0] state_in,
    input [31:0] a,b,c,d,e,f,g,h,
    input [63:0] inlen,
    output reg [255:0] state_out,
    output reg [31:0] a_out,b_out,c_out,d_out,e_out,f_out,g_out,h_out,
    output reg valid_out,
    output reg [63:0] inlen_out);
   
    
    /*wire [31:0] l0,l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15;
    //load value w[15:0] -> l[15:0]
    RTL_load_bigendian_32 lb32_P_0(.bytes(in[511:480]),.result(l0));
    assign w0 = l0;
    RTL_load_bigendian_32 lb32_P_1(.bytes(in[479:448]),.result(l0));
    assign w1 = l1;
    RTL_load_bigendian_32 lb32_P_2(.bytes(in[447:416]),.result(l0));
    assign w2 = l2;
    RTL_load_bigendian_32 lb32_P_3(.bytes(in[415:384]),.result(l0));
    assign w3 = l3;
    RTL_load_bigendian_32 lb32_P_4(.bytes(in[383:352]),.result(l0));
    assign w4 = l4;
    RTL_load_bigendian_32 lb32_P_5(.bytes(in[351:320]),.result(l0));
    assign w5 = l5;
    RTL_load_bigendian_32 lb32_P_6(.bytes(in[319:288]),.result(l0));
    assign w6 = l6;
    RTL_load_bigendian_32 lb32_P_7(.bytes(in[287:256]),.result(l0));
    assign w7 = l7;
    RTL_load_bigendian_32 lb32_P_8(.bytes(in[255:224]),.result(l0));
    assign w8 = l8;
    RTL_load_bigendian_32 lb32_P_9(.bytes(in[223:192]),.result(l0));
    assign w9 = l9;
    RTL_load_bigendian_32 lb32_P_10(.bytes(in[191:160]),.result(l0));
    assign w10 = l10;
    RTL_load_bigendian_32 lb32_P_11(.bytes(in[159:128]),.result(l0));
    assign w11 = l11;
    RTL_load_bigendian_32 lb32_P_12(.bytes(in[127:96]),.result(l0));
    assign w12 = l12;
    RTL_load_bigendian_32 lb32_P_13(.bytes(in[95:64]),.result(l0));
    assign w13 = l13;
    RTL_load_bigendian_32 lb32_P_14(.bytes(in[63:32]),.result(l0));
    assign w14 = l14;
    RTL_load_bigendian_32 lb32_P_15(.bytes(in[31:0]),.result(l0));
    assign w15 = l15;
    */
    wire [31:0] a_in,b_in,c_in,d_in,e_in,f_in,g_in,h_in;
    wire [31:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;
    
    reg [511:0] expand_reg;
    reg [31:0] a_reg,b_reg,c_reg,d_reg,e_reg,f_reg,g_reg,h_reg;
    
    reg flag_done;
    
    assign w0 = (start_in) ? in[31:0] : expand_reg[31:0];
    assign w1 = (start_in) ? in[63:32] : expand_reg[63:32];
    assign w2 = (start_in) ? in[95:64] : expand_reg[95:64];
    assign w3 = (start_in) ? in[127:96] : expand_reg[127:96];
    assign w4 = (start_in) ? in[159:128] : expand_reg[159:128];
    assign w5 = (start_in) ? in[191:160] : expand_reg[191:160];
    assign w6 = (start_in) ? in[223:192] : expand_reg[223:192];
    assign w7 = (start_in) ? in[255:224] : expand_reg[255:224];
    assign w8 = (start_in) ? in[287:256] : expand_reg[287:256];
    assign w9 = (start_in) ? in[319:288] : expand_reg[319:288];
    assign w10 = (start_in) ? in[351:320] : expand_reg[351:320];
    assign w11 = (start_in) ? in[383:352] : expand_reg[383:352];
    assign w12 = (start_in) ? in[415:384] : expand_reg[415:384];
    assign w13 = (start_in) ? in[447:416] : expand_reg[447:416];
    assign w14 = (start_in) ? in[479:448] : expand_reg[479:448];
    assign w15 = (start_in) ? in[511:480] : expand_reg[511:480];
    
    assign a_in = (start_in) ? a : a_reg;
    assign b_in = (start_in) ? b : b_reg;
    assign c_in = (start_in) ? c : c_reg;
    assign d_in = (start_in) ? d : d_reg;
    assign e_in = (start_in) ? e : e_reg;
    assign f_in = (start_in) ? f : f_reg;
    assign g_in = (start_in) ? g : g_reg;
    assign h_in = (start_in) ? h : h_reg;
    
    
    
    // F - stage 1
    // F32_0 noi tiep tin hiee a,b,c,..,h den F32_1 ,.....
    /*wire [31:0] a_0,b_0,c_0,d_0,e_0,f_0,g_0,h_0;
    wire [31:0] a_1,b_1,c_1,d_1,e_1,f_1,g_1,h_1;
    wire [31:0] a_2,b_2,c_2,d_2,e_0,f_2,g_2,h_2;
    wire [31:0] a_3,b_3,c_3,d_3,e_0,f_3,g_3,h_3;
    wire [31:0] a_4,b_4,c_4,d_4,e_0,f_4,g_4,h_4;
    wire [31:0] a_5,b_5,c_5,d_5,e_0,f_5,g_5,h_5;
    wire [31:0] a_6,b_0,c_6,d_6,e_0,f_6,g_6,h_6;
    wire [31:0] a_7,b_0,c_7,d_7,e_0,f_7,g_7,h_7;
    wire [31:0] a_8,b_0,c_8,d_8,e_0,f_8,g_8,h_8;
    wire [31:0] a_9,b_0,c_9,d_9,e_0,f_9,g_9,h_9;
    wire [31:0] a_10,b_0,c_10,d_10,e_10,f_10,g_10,h_10;
    wire [31:0] a_11,b_0,c_11,d_11,e_11,f_11,g_11,h_11;
    wire [31:0] a_12,b_0,c_12,d_12,e_12,f_12,g_12,h_12;
    wire [31:0] a_13,b_0,c_13,d_13,e_13,f_13,g_13,h_13;
    wire [31:0] a_14,b_0,c_14,d_14,e_14,f_14,g_14,h_14;
    wire [31:0] a_15,b_0,c_15,d_15,e_15,f_15,g_15,h_15;*/
    wire [31:0] a_s1,b_s1,c_s1,d_s1,e_s1,f_s1,g_s1,h_s1 [15:0];
    //RTL_F_32 F32_stage1(w,k,a,b,c,d,e,f,g,h,a_out,b_out,c_out,d_out,e_out,f_out,g_out,h_out);
    RTL_F_32 F32_stage1_0(.w(w0),.k(32'h428a2f98),.a(a_in),.b(b_in),.c(c_in),.d(d_in),.e(e_in),.f(f_in),.g(g_in),.h(h_in),.a_out(a_s1[0]),.b_out(b_s1[0]),.c_out(c_s1[0]),.d_out(d_s1[0]),.e_out(e_s1[0]),.f_out(f_s1[0]),.g_out(g_s1[0]),.h_out(h_s1[0]));
    RTL_F_32 F32_stage1_1(.w(w1),.k(32'h71374491),.a(a_s1[0]),.b(b_s1[0]),.c(c_s1[0]),.d(d_s1[0]),.e(e_s1[0]),.f(f_s1[0]),.g(g_s1[0]),.h(h_s1[0]),.a_out(a_s1[1]),.b_out(b_s1[1]),.c_out(c_s1[1]),.d_out(d_s1[1]),.e_out(e_s1[1]),.f_out(f_s1[1]),.g_out(g_s1[1]),.h_out(h_s1[1]));
    RTL_F_32 F32_stage1_2(.w(w2),.k(32'hb5c0fbcf),.a(a_s1[1]),.b(b_s1[1]),.c(c_s1[1]),.d(d_s1[1]),.e(e_s1[1]),.f(f_s1[1]),.g(g_s1[1]),.h(h_s1[1]),.a_out(a_s1[2]),.b_out(b_s1[2]),.c_out(c_s1[2]),.d_out(d_s1[2]),.e_out(e_s1[2]),.f_out(f_s1[2]),.g_out(g_s1[2]),.h_out(h_s1[2]));
    RTL_F_32 F32_stage1_3(.w(w3),.k(32'he9b5dba5),.a(a_s1[2]),.b(b_s1[2]),.c(c_s1[2]),.d(d_s1[2]),.e(e_s1[2]),.f(f_s1[2]),.g(g_s1[2]),.h(h_s1[2]),.a_out(a_s1[3]),.b_out(b_s1[3]),.c_out(c_s1[3]),.d_out(d_s1[3]),.e_out(e_s1[3]),.f_out(f_s1[3]),.g_out(g_s1[3]),.h_out(h_s1[3]));
    RTL_F_32 F32_stage1_4(.w(w4),.k(32'h3956c25b),.a(a_s1[3]),.b(b_s1[3]),.c(c_s1[3]),.d(d_s1[3]),.e(e_s1[3]),.f(f_s1[3]),.g(g_s1[3]),.h(h_s1[3]),.a_out(a_s1[4]),.b_out(b_s1[4]),.c_out(c_s1[4]),.d_out(d_s1[4]),.e_out(e_s1[4]),.f_out(f_s1[4]),.g_out(g_s1[4]),.h_out(h_s1[4]));
    RTL_F_32 F32_stage1_5(.w(w5),.k(32'h59f111f1),.a(a_s1[4]),.b(b_s1[4]),.c(c_s1[4]),.d(d_s1[4]),.e(e_s1[4]),.f(f_s1[4]),.g(g_s1[4]),.h(h_s1[4]),.a_out(a_s1[5]),.b_out(b_s1[5]),.c_out(c_s1[5]),.d_out(d_s1[5]),.e_out(e_s1[5]),.f_out(f_s1[5]),.g_out(g_s1[5]),.h_out(h_s1[5]));
    RTL_F_32 F32_stage1_6(.w(w6),.k(32'h923f82a4),.a(a_s1[5]),.b(b_s1[5]),.c(c_s1[5]),.d(d_s1[5]),.e(e_s1[5]),.f(f_s1[5]),.g(g_s1[5]),.h(h_s1[5]),.a_out(a_s1[6]),.b_out(b_s1[6]),.c_out(c_s1[6]),.d_out(d_s1[6]),.e_out(e_s1[6]),.f_out(f_s1[6]),.g_out(g_s1[6]),.h_out(h_s1[6]));
    RTL_F_32 F32_stage1_7(.w(w7),.k(32'hab1c5ed5),.a(a_s1[6]),.b(b_s1[6]),.c(c_s1[6]),.d(d_s1[6]),.e(e_s1[6]),.f(f_s1[6]),.g(g_s1[6]),.h(h_s1[6]),.a_out(a_s1[7]),.b_out(b_s1[7]),.c_out(c_s1[7]),.d_out(d_s1[7]),.e_out(e_s1[7]),.f_out(f_s1[7]),.g_out(g_s1[7]),.h_out(h_s1[7]));
    RTL_F_32 F32_stage1_8(.w(w8),.k(32'hd807aa98),.a(a_s1[7]),.b(b_s1[7]),.c(c_s1[7]),.d(d_s1[7]),.e(e_s1[7]),.f(f_s1[7]),.g(g_s1[7]),.h(h_s1[7]),.a_out(a_s1[8]),.b_out(b_s1[8]),.c_out(c_s1[8]),.d_out(d_s1[8]),.e_out(e_s1[8]),.f_out(f_s1[8]),.g_out(g_s1[8]),.h_out(h_s1[8]));
    RTL_F_32 F32_stage1_9(.w(w9),.k(32'h12835b01),.a(a_s1[8]),.b(b_s1[8]),.c(c_s1[8]),.d(d_s1[8]),.e(e_s1[8]),.f(f_s1[8]),.g(g_s1[8]),.h(h_s1[8]),.a_out(a_s1[9]),.b_out(b_s1[9]),.c_out(c_s1[9]),.d_out(d_s1[9]),.e_out(e_s1[9]),.f_out(f_s1[9]),.g_out(g_s1[9]),.h_out(h_s1[9]));
    RTL_F_32 F32_stage1_10(.w(w10),.k(32'h243185be),.a(a_s1[9]),.b(b_s1[9]),.c(c_s1[9]),.d(d_s1[9]),.e(e_s1[9]),.f(f_s1[9]),.g(g_s1[9]),.h(h_s1[9]),.a_out(a_s1[10]),.b_out(b_s1[10]),.c_out(c_s1[10]),.d_out(d_s1[10]),.e_out(e_s1[10]),.f_out(f_s1[10]),.g_out(g_s1[10]),.h_out(h_s1[10]));
    RTL_F_32 F32_stage1_11(.w(w11),.k(32'h550c7dc3),.a(a_s1[10]),.b(b_s1[10]),.c(c_s1[10]),.d(d_s1[10]),.e(e_s1[10]),.f(f_s1[10]),.g(g_s1[10]),.h(h_s1[10]),.a_out(a_s1[11]),.b_out(b_s1[11]),.c_out(c_s1[11]),.d_out(d_s1[11]),.e_out(e_s1[11]),.f_out(f_s1[11]),.g_out(g_s1[11]),.h_out(h_s1[11]));
    RTL_F_32 F32_stage1_12(.w(w12),.k(32'h72be5d74),.a(a_s1[11]),.b(b_s1[11]),.c(c_s1[11]),.d(d_s1[11]),.e(e_s1[11]),.f(f_s1[11]),.g(g_s1[11]),.h(h_s1[11]),.a_out(a_s1[12]),.b_out(b_s1[12]),.c_out(c_s1[12]),.d_out(d_s1[12]),.e_out(e_s1[12]),.f_out(f_s1[12]),.g_out(g_s1[12]),.h_out(h_s1[12]));
    RTL_F_32 F32_stage1_13(.w(w13),.k(32'h80deb1fe),.a(a_s1[12]),.b(b_s1[12]),.c(c_s1[12]),.d(d_s1[12]),.e(e_s1[12]),.f(f_s1[12]),.g(g_s1[12]),.h(h_s1[12]),.a_out(a_s1[13]),.b_out(b_s1[13]),.c_out(c_s1[13]),.d_out(d_s1[13]),.e_out(e_s1[13]),.f_out(f_s1[13]),.g_out(g_s1[13]),.h_out(h_s1[13]));
    RTL_F_32 F32_stage1_14(.w(w14),.k(32'h9bdc06a7),.a(a_s1[13]),.b(b_s1[13]),.c(c_s1[13]),.d(d_s1[13]),.e(e_s1[13]),.f(f_s1[13]),.g(g_s1[13]),.h(h_s1[13]),.a_out(a_s1[14]),.b_out(b_s1[14]),.c_out(c_s1[14]),.d_out(d_s1[14]),.e_out(e_s1[14]),.f_out(f_s1[14]),.g_out(g_s1[14]),.h_out(h_s1[14]));
    RTL_F_32 F32_stage1_15(.w(w15),.k(32'hc19bf174),.a(a_s1[14]),.b(b_s1[14]),.c(c_s1[14]),.d(d_s1[14]),.e(e_s1[14]),.f(f_s1[14]),.g(g_s1[14]),.h(h_s1[14]),.a_out(a_s1[15]),.b_out(b_s1[15]),.c_out(c_s1[15]),.d_out(d_s1[15]),.e_out(e_s1[15]),.f_out(f_s1[15]),.g_out(g_s1[15]),.h_out(h_s1[15]));
     /*  
        F_32(w0, 0x428a2f98)
        F_32(w1, 0x71374491)
        F_32(w2, 0xb5c0fbcf)
        F_32(w3, 0xe9b5dba5)
        F_32(w4, 0x3956c25b)
        F_32(w5, 0x59f111f1)
        F_32(w6, 0x923f82a4)
        F_32(w7, 0xab1c5ed5)
        F_32(w8, 0xd807aa98)
        F_32(w9, 0x12835b01)
        F_32(w10, 0x243185be)
        F_32(w11, 0x550c7dc3)
        F_32(w12, 0x72be5d74)
        F_32(w13, 0x80deb1fe)
        F_32(w14, 0x9bdc06a7)
        F_32(w15, 0xc19bf174)
    */
    // EXPAND - stage 1 
    wire [31:0] w_s1 [15:0];
    RTL_EXPAND_32 Expand_stage1(.w0(w0),.w1(w1),.w2(w2),.w3(w3),.w4(w4),.w5(w5),.w6(w6),.w7(w7),.w8(w8),.w9(w9),.w10(w10),.w11(w11),.w12(w12),.w13(w13),.w14(w14),.w15(w15),
    .w0_out(w_s1[0]),.w1_out(w_s1[1]),.w2_out(w_s1[2]),.w3_out(w_s1[3]),.w4_out(w_s1[4]),.w5_out(w_s1[5]),.w6_out(w_s1[6]),.w7_out(w_s1[7]),.w8_out(w_s1[8]),.w9_out(w_s1[9]),.w10_out(w_s1[10]),.w11_out(w_s1[11]),.w12_out(w_s1[12]),.w13_out(w_s1[13]),.w14_out(w_s1[14]),.w15_out(w_s1[15]));
    
    
    // F - stage 2
    
        wire [31:0] a_s2,b_s2,c_s2,d_s2,e_s2,f_s2,g_s2,h_s2 [15:0];
    //RTL_F_32 F32_stage1(w,k,a,b,c,d,e,f,g,h,a_out,b_out,c_out,d_out,e_out,f_out,g_out,h_out);
    RTL_F_32 F32_stage2_0(.w(w_s1[0]),.k(32'he49b69c1),.a(a_s1[15]),.b(b_s1[15]),.c(c_s1[15]),.d(d_s1[15]),.e(e_s1[15]),.f(f_s1[15]),.g(g_s1[15]),.h(h_s1[15]),.a_out(a_s2[0]),.b_out(b_s2[0]),.c_out(c_s2[0]),.d_out(d_s2[0]),.e_out(e_s2[0]),.f_out(f_s2[0]),.g_out(g_s2[0]),.h_out(h_s2[0]));
    RTL_F_32 F32_stage2_1(.w(w_s1[1]),.k(32'hefbe4786),.a(a_s2[0]),.b(b_s2[0]),.c(c_s2[0]),.d(d_s2[0]),.e(e_s2[0]),.f(f_s2[0]),.g(g_s2[0]),.h(h_s2[0]),.a_out(a_s2[1]),.b_out(b_s2[1]),.c_out(c_s2[1]),.d_out(d_s2[1]),.e_out(e_s2[1]),.f_out(f_s2[1]),.g_out(g_s2[1]),.h_out(h_s2[1]));
    RTL_F_32 F32_stage2_2(.w(w_s1[2]),.k(32'h0fc19dc6),.a(a_s2[1]),.b(b_s2[1]),.c(c_s2[1]),.d(d_s2[1]),.e(e_s2[1]),.f(f_s2[1]),.g(g_s2[1]),.h(h_s2[1]),.a_out(a_s2[2]),.b_out(b_s2[2]),.c_out(c_s2[2]),.d_out(d_s2[2]),.e_out(e_s2[2]),.f_out(f_s2[2]),.g_out(g_s2[2]),.h_out(h_s2[2]));
    RTL_F_32 F32_stage2_3(.w(w_s1[3]),.k(32'h240ca1cc),.a(a_s2[2]),.b(b_s2[2]),.c(c_s2[2]),.d(d_s2[2]),.e(e_s2[2]),.f(f_s2[2]),.g(g_s2[2]),.h(h_s2[2]),.a_out(a_s2[3]),.b_out(b_s2[3]),.c_out(c_s2[3]),.d_out(d_s2[3]),.e_out(e_s2[3]),.f_out(f_s2[3]),.g_out(g_s2[3]),.h_out(h_s2[3]));
    RTL_F_32 F32_stage2_4(.w(w_s1[4]),.k(32'h2de92c6f),.a(a_s2[3]),.b(b_s2[3]),.c(c_s2[3]),.d(d_s2[3]),.e(e_s2[3]),.f(f_s2[3]),.g(g_s2[3]),.h(h_s2[3]),.a_out(a_s2[4]),.b_out(b_s2[4]),.c_out(c_s2[4]),.d_out(d_s2[4]),.e_out(e_s2[4]),.f_out(f_s2[4]),.g_out(g_s2[4]),.h_out(h_s2[4]));
    RTL_F_32 F32_stage2_5(.w(w_s1[5]),.k(32'h4a7484aa),.a(a_s2[4]),.b(b_s2[4]),.c(c_s2[4]),.d(d_s2[4]),.e(e_s2[4]),.f(f_s2[4]),.g(g_s2[4]),.h(h_s2[4]),.a_out(a_s2[5]),.b_out(b_s2[5]),.c_out(c_s2[5]),.d_out(d_s2[5]),.e_out(e_s2[5]),.f_out(f_s2[5]),.g_out(g_s2[5]),.h_out(h_s2[5]));
    RTL_F_32 F32_stage2_6(.w(w_s1[6]),.k(32'h5cb0a9dc),.a(a_s2[5]),.b(b_s2[5]),.c(c_s2[5]),.d(d_s2[5]),.e(e_s2[5]),.f(f_s2[5]),.g(g_s2[5]),.h(h_s2[5]),.a_out(a_s2[6]),.b_out(b_s2[6]),.c_out(c_s2[6]),.d_out(d_s2[6]),.e_out(e_s2[6]),.f_out(f_s2[6]),.g_out(g_s2[6]),.h_out(h_s2[6]));
    RTL_F_32 F32_stage2_7(.w(w_s1[7]),.k(32'h76f988da),.a(a_s2[6]),.b(b_s2[6]),.c(c_s2[6]),.d(d_s2[6]),.e(e_s2[6]),.f(f_s2[6]),.g(g_s2[6]),.h(h_s2[6]),.a_out(a_s2[7]),.b_out(b_s2[7]),.c_out(c_s2[7]),.d_out(d_s2[7]),.e_out(e_s2[7]),.f_out(f_s2[7]),.g_out(g_s2[7]),.h_out(h_s2[7]));
    RTL_F_32 F32_stage2_8(.w(w_s1[8]),.k(32'h983e5152),.a(a_s2[7]),.b(b_s2[7]),.c(c_s2[7]),.d(d_s2[7]),.e(e_s2[7]),.f(f_s2[7]),.g(g_s2[7]),.h(h_s2[7]),.a_out(a_s2[8]),.b_out(b_s2[8]),.c_out(c_s2[8]),.d_out(d_s2[8]),.e_out(e_s2[8]),.f_out(f_s2[8]),.g_out(g_s2[8]),.h_out(h_s2[8]));
    RTL_F_32 F32_stage2_9(.w(w_s1[9]),.k(32'ha831c66d),.a(a_s2[8]),.b(b_s2[8]),.c(c_s2[8]),.d(d_s2[8]),.e(e_s2[8]),.f(f_s2[8]),.g(g_s2[8]),.h(h_s2[8]),.a_out(a_s2[9]),.b_out(b_s2[9]),.c_out(c_s2[9]),.d_out(d_s2[9]),.e_out(e_s2[9]),.f_out(f_s2[9]),.g_out(g_s2[9]),.h_out(h_s2[9]));
    RTL_F_32 F32_stage2_10(.w(w_s1[10]),.k(32'hb00327c8),.a(a_s2[9]),.b(b_s2[9]),.c(c_s2[9]),.d(d_s2[9]),.e(e_s2[9]),.f(f_s2[9]),.g(g_s2[9]),.h(h_s2[9]),.a_out(a_s2[10]),.b_out(b_s2[10]),.c_out(c_s2[10]),.d_out(d_s2[10]),.e_out(e_s2[10]),.f_out(f_s2[10]),.g_out(g_s2[10]),.h_out(h_s2[10]));
    RTL_F_32 F32_stage2_11(.w(w_s1[11]),.k(32'hbf597fc7),.a(a_s2[10]),.b(b_s2[10]),.c(c_s2[10]),.d(d_s2[10]),.e(e_s2[10]),.f(f_s2[10]),.g(g_s2[10]),.h(h_s2[10]),.a_out(a_s2[11]),.b_out(b_s2[11]),.c_out(c_s2[11]),.d_out(d_s2[11]),.e_out(e_s2[11]),.f_out(f_s2[11]),.g_out(g_s2[11]),.h_out(h_s2[11]));
    RTL_F_32 F32_stage2_12(.w(w_s1[12]),.k(32'hc6e00bf3),.a(a_s2[11]),.b(b_s2[11]),.c(c_s2[11]),.d(d_s2[11]),.e(e_s2[11]),.f(f_s2[11]),.g(g_s2[11]),.h(h_s2[11]),.a_out(a_s2[12]),.b_out(b_s2[12]),.c_out(c_s2[12]),.d_out(d_s2[12]),.e_out(e_s2[12]),.f_out(f_s2[12]),.g_out(g_s2[12]),.h_out(h_s2[12]));
    RTL_F_32 F32_stage2_13(.w(w_s1[13]),.k(32'hd5a79147),.a(a_s2[12]),.b(b_s2[12]),.c(c_s2[12]),.d(d_s2[12]),.e(e_s2[12]),.f(f_s2[12]),.g(g_s2[12]),.h(h_s2[12]),.a_out(a_s2[13]),.b_out(b_s2[13]),.c_out(c_s2[13]),.d_out(d_s2[13]),.e_out(e_s2[13]),.f_out(f_s2[13]),.g_out(g_s2[13]),.h_out(h_s2[13]));
    RTL_F_32 F32_stage2_14(.w(w_s1[14]),.k(32'h06ca6351),.a(a_s2[13]),.b(b_s2[13]),.c(c_s2[13]),.d(d_s2[13]),.e(e_s2[13]),.f(f_s2[13]),.g(g_s2[13]),.h(h_s2[13]),.a_out(a_s2[14]),.b_out(b_s2[14]),.c_out(c_s2[14]),.d_out(d_s2[14]),.e_out(e_s2[14]),.f_out(f_s2[14]),.g_out(g_s2[14]),.h_out(h_s2[14]));
    RTL_F_32 F32_stage2_15(.w(w_s1[15]),.k(32'h14292967),.a(a_s2[14]),.b(b_s2[14]),.c(c_s2[14]),.d(d_s2[14]),.e(e_s2[14]),.f(f_s2[14]),.g(g_s2[14]),.h(h_s2[14]),.a_out(a_s2[15]),.b_out(b_s2[15]),.c_out(c_s2[15]),.d_out(d_s2[15]),.e_out(e_s2[15]),.f_out(f_s2[15]),.g_out(g_s2[15]),.h_out(h_s2[15]));
    
    /*
        F_32(w0, 0xe49b69c1)
        F_32(w1, 0xefbe4786)
        F_32(w2, 0x0fc19dc6)
        F_32(w3, 0x240ca1cc)
        F_32(w4, 0x2de92c6f)
        F_32(w5, 0x4a7484aa)
        F_32(w6, 0x5cb0a9dc)
        F_32(w7, 0x76f988da)
        F_32(w8, 0x983e5152)
        F_32(w9, 0xa831c66d)
        F_32(w10, 0xb00327c8)
        F_32(w11, 0xbf597fc7)
        F_32(w12, 0xc6e00bf3)
        F_32(w13, 0xd5a79147)
        F_32(w14, 0x06ca6351)
        F_32(w15, 0x14292967)
    */
    // EXPAND - stage 2
    
    wire [31:0] w_s2 [15:0];
    RTL_EXPAND_32 Expand_stage2(.w0(w_s1[0]),.w1(w_s1[1]),.w2(w_s1[2]),.w3(w_s1[3]),.w4(w_s1[4]),.w5(w_s1[5]),.w6(w_s1[6]),.w7(w_s1[7]),.w8(w_s1[8]),.w9(w_s1[9]),.w10(w_s1[10]),.w11(w_s1[11]),.w12(w_s1[12]),.w13(w_s1[13]),.w14(w_s1[14]),.w15(w_s1[15]),
    .w0_out(w_s2[0]),.w1_out(w_s2[1]),.w2_out(w_s2[2]),.w3_out(w_s2[3]),.w4_out(w_s2[4]),.w5_out(w_s2[5]),.w6_out(w_s2[6]),.w7_out(w_s2[7]),.w8_out(w_s2[8]),.w9_out(w_s2[9]),.w10_out(w_s2[10]),.w11_out(w_s2[11]),.w12_out(w_s2[12]),.w13_out(w_s2[13]),.w14_out(w_s2[14]),.w15_out(w_s2[15]));
    
    // F - stage 3
    
        wire [31:0] a_s3,b_s3,c_s3,d_s3,e_s3,f_s3,g_s3,h_s3 [15:0];
    //RTL_F_32 F32_stage1(w,k,a,b,c,d,e,f,g,h,a_out,b_out,c_out,d_out,e_out,f_out,g_out,h_out);
    RTL_F_32 F32_stage3_0(.w(w_s2[0]),.k(32'h27b70a85),.a(a_s2[15]),.b(b_s2[15]),.c(c_s2[15]),.d(d_s2[15]),.e(e_s2[15]),.f(f_s2[15]),.g(g_s2[15]),.h(h_s2[15]),.a_out(a_s3[0]),.b_out(b_s3[0]),.c_out(c_s3[0]),.d_out(d_s3[0]),.e_out(e_s3[0]),.f_out(f_s3[0]),.g_out(g_s3[0]),.h_out(h_s3[0]));
    RTL_F_32 F32_stage3_1(.w(w_s2[1]),.k(32'h2e1b2138),.a(a_s3[0]),.b(b_s3[0]),.c(c_s3[0]),.d(d_s3[0]),.e(e_s3[0]),.f(f_s3[0]),.g(g_s3[0]),.h(h_s3[0]),.a_out(a_s3[1]),.b_out(b_s3[1]),.c_out(c_s3[1]),.d_out(d_s3[1]),.e_out(e_s3[1]),.f_out(f_s3[1]),.g_out(g_s3[1]),.h_out(h_s3[1]));
    RTL_F_32 F32_stage3_2(.w(w_s2[2]),.k(32'h4d2c6dfc),.a(a_s3[1]),.b(b_s3[1]),.c(c_s3[1]),.d(d_s3[1]),.e(e_s3[1]),.f(f_s3[1]),.g(g_s3[1]),.h(h_s3[1]),.a_out(a_s3[2]),.b_out(b_s3[2]),.c_out(c_s3[2]),.d_out(d_s3[2]),.e_out(e_s3[2]),.f_out(f_s3[2]),.g_out(g_s3[2]),.h_out(h_s3[2]));
    RTL_F_32 F32_stage3_3(.w(w_s2[3]),.k(32'h53380d13),.a(a_s3[2]),.b(b_s3[2]),.c(c_s3[2]),.d(d_s3[2]),.e(e_s3[2]),.f(f_s3[2]),.g(g_s3[2]),.h(h_s3[2]),.a_out(a_s3[3]),.b_out(b_s3[3]),.c_out(c_s3[3]),.d_out(d_s3[3]),.e_out(e_s3[3]),.f_out(f_s3[3]),.g_out(g_s3[3]),.h_out(h_s3[3]));
    RTL_F_32 F32_stage3_4(.w(w_s2[4]),.k(32'h650a7354),.a(a_s3[3]),.b(b_s3[3]),.c(c_s3[3]),.d(d_s3[3]),.e(e_s3[3]),.f(f_s3[3]),.g(g_s3[3]),.h(h_s3[3]),.a_out(a_s3[4]),.b_out(b_s3[4]),.c_out(c_s3[4]),.d_out(d_s3[4]),.e_out(e_s3[4]),.f_out(f_s3[4]),.g_out(g_s3[4]),.h_out(h_s3[4]));
    RTL_F_32 F32_stage3_5(.w(w_s2[5]),.k(32'h766a0abb),.a(a_s3[4]),.b(b_s3[4]),.c(c_s3[4]),.d(d_s3[4]),.e(e_s3[4]),.f(f_s3[4]),.g(g_s3[4]),.h(h_s3[4]),.a_out(a_s3[5]),.b_out(b_s3[5]),.c_out(c_s3[5]),.d_out(d_s3[5]),.e_out(e_s3[5]),.f_out(f_s3[5]),.g_out(g_s3[5]),.h_out(h_s3[5]));
    RTL_F_32 F32_stage3_6(.w(w_s2[6]),.k(32'h81c2c92e),.a(a_s3[5]),.b(b_s3[5]),.c(c_s3[5]),.d(d_s3[5]),.e(e_s3[5]),.f(f_s3[5]),.g(g_s3[5]),.h(h_s3[5]),.a_out(a_s3[6]),.b_out(b_s3[6]),.c_out(c_s3[6]),.d_out(d_s3[6]),.e_out(e_s3[6]),.f_out(f_s3[6]),.g_out(g_s3[6]),.h_out(h_s3[6]));
    RTL_F_32 F32_stage3_7(.w(w_s2[7]),.k(32'h92722c85),.a(a_s3[6]),.b(b_s3[6]),.c(c_s3[6]),.d(d_s3[6]),.e(e_s3[6]),.f(f_s3[6]),.g(g_s3[6]),.h(h_s3[6]),.a_out(a_s3[7]),.b_out(b_s3[7]),.c_out(c_s3[7]),.d_out(d_s3[7]),.e_out(e_s3[7]),.f_out(f_s3[7]),.g_out(g_s3[7]),.h_out(h_s3[7]));
    RTL_F_32 F32_stage3_8(.w(w_s2[8]),.k(32'ha2bfe8a1),.a(a_s3[7]),.b(b_s3[7]),.c(c_s3[7]),.d(d_s3[7]),.e(e_s3[7]),.f(f_s3[7]),.g(g_s3[7]),.h(h_s3[7]),.a_out(a_s3[8]),.b_out(b_s3[8]),.c_out(c_s3[8]),.d_out(d_s3[8]),.e_out(e_s3[8]),.f_out(f_s3[8]),.g_out(g_s3[8]),.h_out(h_s3[8]));
    RTL_F_32 F32_stage3_9(.w(w_s2[9]),.k(32'ha81a664b),.a(a_s3[8]),.b(b_s3[8]),.c(c_s3[8]),.d(d_s3[8]),.e(e_s3[8]),.f(f_s3[8]),.g(g_s3[8]),.h(h_s3[8]),.a_out(a_s3[9]),.b_out(b_s3[9]),.c_out(c_s3[9]),.d_out(d_s3[9]),.e_out(e_s3[9]),.f_out(f_s3[9]),.g_out(g_s3[9]),.h_out(h_s3[9]));
    RTL_F_32 F32_stage3_10(.w(w_s2[10]),.k(32'hc24b8b70),.a(a_s3[9]),.b(b_s3[9]),.c(c_s3[9]),.d(d_s3[9]),.e(e_s3[9]),.f(f_s3[9]),.g(g_s3[9]),.h(h_s3[9]),.a_out(a_s3[10]),.b_out(b_s3[10]),.c_out(c_s3[10]),.d_out(d_s3[10]),.e_out(e_s3[10]),.f_out(f_s3[10]),.g_out(g_s3[10]),.h_out(h_s3[10]));
    RTL_F_32 F32_stage3_11(.w(w_s2[11]),.k(32'hc76c51a3),.a(a_s3[10]),.b(b_s3[10]),.c(c_s3[10]),.d(d_s3[10]),.e(e_s3[10]),.f(f_s3[10]),.g(g_s3[10]),.h(h_s3[10]),.a_out(a_s3[11]),.b_out(b_s3[11]),.c_out(c_s3[11]),.d_out(d_s3[11]),.e_out(e_s3[11]),.f_out(f_s3[11]),.g_out(g_s3[11]),.h_out(h_s3[11]));
    RTL_F_32 F32_stage3_12(.w(w_s2[12]),.k(32'hd192e819),.a(a_s3[11]),.b(b_s3[11]),.c(c_s3[11]),.d(d_s3[11]),.e(e_s3[11]),.f(f_s3[11]),.g(g_s3[11]),.h(h_s3[11]),.a_out(a_s3[12]),.b_out(b_s3[12]),.c_out(c_s3[12]),.d_out(d_s3[12]),.e_out(e_s3[12]),.f_out(f_s3[12]),.g_out(g_s3[12]),.h_out(h_s3[12]));
    RTL_F_32 F32_stage3_13(.w(w_s2[13]),.k(32'hd6990624),.a(a_s3[12]),.b(b_s3[12]),.c(c_s3[12]),.d(d_s3[12]),.e(e_s3[12]),.f(f_s3[12]),.g(g_s3[12]),.h(h_s3[12]),.a_out(a_s3[13]),.b_out(b_s3[13]),.c_out(c_s3[13]),.d_out(d_s3[13]),.e_out(e_s3[13]),.f_out(f_s3[13]),.g_out(g_s3[13]),.h_out(h_s3[13]));
    RTL_F_32 F32_stage3_14(.w(w_s2[14]),.k(32'hf40e3585),.a(a_s3[13]),.b(b_s3[13]),.c(c_s3[13]),.d(d_s3[13]),.e(e_s3[13]),.f(f_s3[13]),.g(g_s3[13]),.h(h_s3[13]),.a_out(a_s3[14]),.b_out(b_s3[14]),.c_out(c_s3[14]),.d_out(d_s3[14]),.e_out(e_s3[14]),.f_out(f_s3[14]),.g_out(g_s3[14]),.h_out(h_s3[14]));
    RTL_F_32 F32_stage3_15(.w(w_s2[15]),.k(32'h106aa070),.a(a_s3[14]),.b(b_s3[14]),.c(c_s3[14]),.d(d_s3[14]),.e(e_s3[14]),.f(f_s3[14]),.g(g_s3[14]),.h(h_s3[14]),.a_out(a_s3[15]),.b_out(b_s3[15]),.c_out(c_s3[15]),.d_out(d_s3[15]),.e_out(e_s3[15]),.f_out(f_s3[15]),.g_out(g_s3[15]),.h_out(h_s3[15]));
    
    /*
        F_32(w0, 0x27b70a85)
        F_32(w1, 0x2e1b2138)
        F_32(w2, 0x4d2c6dfc)
        F_32(w3, 0x53380d13)
        F_32(w4, 0x650a7354)
        F_32(w5, 0x766a0abb)
        F_32(w6, 0x81c2c92e)
        F_32(w7, 0x92722c85)
        F_32(w8, 0xa2bfe8a1)
        F_32(w9, 0xa81a664b)
        F_32(w10, 0xc24b8b70)
        F_32(w11, 0xc76c51a3)
        F_32(w12, 0xd192e819)
        F_32(w13, 0xd6990624)
        F_32(w14, 0xf40e3585)
        F_32(w15, 0x106aa070)
    */
    // EXPAND - stage 3
    
    wire [31:0] w_s3 [15:0];
    RTL_EXPAND_32 Expand_stage3(.w0(w_s2[0]),.w1(w_s2[1]),.w2(w_s2[2]),.w3(w_s2[3]),.w4(w_s2[4]),.w5(w_s2[5]),.w6(w_s2[6]),.w7(w_s2[7]),.w8(w_s2[8]),.w9(w_s2[9]),.w10(w_s2[10]),.w11(w_s2[11]),.w12(w_s2[12]),.w13(w_s2[13]),.w14(w_s2[14]),.w15(w_s2[15]),
    .w0_out(w_s3[0]),.w1_out(w_s3[1]),.w2_out(w_s3[2]),.w3_out(w_s3[3]),.w4_out(w_s3[4]),.w5_out(w_s3[5]),.w6_out(w_s3[6]),.w7_out(w_s3[7]),.w8_out(w_s3[8]),.w9_out(w_s3[9]),.w10_out(w_s3[10]),.w11_out(w_s3[11]),.w12_out(w_s3[12]),.w13_out(w_s3[13]),.w14_out(w_s3[14]),.w15_out(w_s3[15]));
    
    // F - stage 4
    
        wire [31:0] a_s4,b_s4,c_s4,d_s4,e_s4,f_s4,g_s4,h_s4 [15:0];
    //RTL_F_32 F32_stage1(w,k,a,b,c,d,e,f,g,h,a_out,b_out,c_out,d_out,e_out,f_out,g_out,h_out);
    RTL_F_32 F32_stage4_0(.w(w_s3[0]),.k(32'h19a4c116),.a(a_s3[15]),.b(b_s3[15]),.c(c_s3[15]),.d(d_s3[15]),.e(e_s3[15]),.f(f_s3[15]),.g(g_s3[15]),.h(h_s3[15]),.a_out(a_s4[0]),.b_out(b_s4[0]),.c_out(c_s4[0]),.d_out(d_s4[0]),.e_out(e_s4[0]),.f_out(f_s4[0]),.g_out(g_s4[0]),.h_out(h_s4[0]));
    RTL_F_32 F32_stage4_1(.w(w_s3[1]),.k(32'h1e376c08),.a(a_s4[0]),.b(b_s4[0]),.c(c_s4[0]),.d(d_s4[0]),.e(e_s4[0]),.f(f_s4[0]),.g(g_s4[0]),.h(h_s4[0]),.a_out(a_s4[1]),.b_out(b_s4[1]),.c_out(c_s4[1]),.d_out(d_s4[1]),.e_out(e_s4[1]),.f_out(f_s4[1]),.g_out(g_s4[1]),.h_out(h_s4[1]));
    RTL_F_32 F32_stage4_2(.w(w_s3[2]),.k(32'h2748774c),.a(a_s4[1]),.b(b_s4[1]),.c(c_s4[1]),.d(d_s4[1]),.e(e_s4[1]),.f(f_s4[1]),.g(g_s4[1]),.h(h_s4[1]),.a_out(a_s4[2]),.b_out(b_s4[2]),.c_out(c_s4[2]),.d_out(d_s4[2]),.e_out(e_s4[2]),.f_out(f_s4[2]),.g_out(g_s4[2]),.h_out(h_s4[2]));
    RTL_F_32 F32_stage4_3(.w(w_s3[3]),.k(32'h34b0bcb5),.a(a_s4[2]),.b(b_s4[2]),.c(c_s4[2]),.d(d_s4[2]),.e(e_s4[2]),.f(f_s4[2]),.g(g_s4[2]),.h(h_s4[2]),.a_out(a_s4[3]),.b_out(b_s4[3]),.c_out(c_s4[3]),.d_out(d_s4[3]),.e_out(e_s4[3]),.f_out(f_s4[3]),.g_out(g_s4[3]),.h_out(h_s4[3]));
    RTL_F_32 F32_stage4_4(.w(w_s3[4]),.k(32'h391c0cb3),.a(a_s4[3]),.b(b_s4[3]),.c(c_s4[3]),.d(d_s4[3]),.e(e_s4[3]),.f(f_s4[3]),.g(g_s4[3]),.h(h_s4[3]),.a_out(a_s4[4]),.b_out(b_s4[4]),.c_out(c_s4[4]),.d_out(d_s4[4]),.e_out(e_s4[4]),.f_out(f_s4[4]),.g_out(g_s4[4]),.h_out(h_s4[4]));
    RTL_F_32 F32_stage4_5(.w(w_s3[5]),.k(32'h4ed8aa4a),.a(a_s4[4]),.b(b_s4[4]),.c(c_s4[4]),.d(d_s4[4]),.e(e_s4[4]),.f(f_s4[4]),.g(g_s4[4]),.h(h_s4[4]),.a_out(a_s4[5]),.b_out(b_s4[5]),.c_out(c_s4[5]),.d_out(d_s4[5]),.e_out(e_s4[5]),.f_out(f_s4[5]),.g_out(g_s4[5]),.h_out(h_s4[5]));
    RTL_F_32 F32_stage4_6(.w(w_s3[6]),.k(32'h5b9cca4f),.a(a_s4[5]),.b(b_s4[5]),.c(c_s4[5]),.d(d_s4[5]),.e(e_s4[5]),.f(f_s4[5]),.g(g_s4[5]),.h(h_s4[5]),.a_out(a_s4[6]),.b_out(b_s4[6]),.c_out(c_s4[6]),.d_out(d_s4[6]),.e_out(e_s4[6]),.f_out(f_s4[6]),.g_out(g_s4[6]),.h_out(h_s4[6]));
    RTL_F_32 F32_stage4_7(.w(w_s3[7]),.k(32'h682e6ff3),.a(a_s4[6]),.b(b_s4[6]),.c(c_s4[6]),.d(d_s4[6]),.e(e_s4[6]),.f(f_s4[6]),.g(g_s4[6]),.h(h_s4[6]),.a_out(a_s4[7]),.b_out(b_s4[7]),.c_out(c_s4[7]),.d_out(d_s4[7]),.e_out(e_s4[7]),.f_out(f_s4[7]),.g_out(g_s4[7]),.h_out(h_s4[7]));
    RTL_F_32 F32_stage4_8(.w(w_s3[8]),.k(32'h748f82ee),.a(a_s4[7]),.b(b_s4[7]),.c(c_s4[7]),.d(d_s4[7]),.e(e_s4[7]),.f(f_s4[7]),.g(g_s4[7]),.h(h_s4[7]),.a_out(a_s4[8]),.b_out(b_s4[8]),.c_out(c_s4[8]),.d_out(d_s4[8]),.e_out(e_s4[8]),.f_out(f_s4[8]),.g_out(g_s4[8]),.h_out(h_s4[8]));
    RTL_F_32 F32_stage4_9(.w(w_s3[9]),.k(32'h78a5636f),.a(a_s4[8]),.b(b_s4[8]),.c(c_s4[8]),.d(d_s4[8]),.e(e_s4[8]),.f(f_s4[8]),.g(g_s4[8]),.h(h_s4[8]),.a_out(a_s4[9]),.b_out(b_s4[9]),.c_out(c_s4[9]),.d_out(d_s4[9]),.e_out(e_s4[9]),.f_out(f_s4[9]),.g_out(g_s4[9]),.h_out(h_s4[9]));
    RTL_F_32 F32_stage4_10(.w(w_s3[10]),.k(32'h84c87814),.a(a_s4[9]),.b(b_s4[9]),.c(c_s4[9]),.d(d_s4[9]),.e(e_s4[9]),.f(f_s4[9]),.g(g_s4[9]),.h(h_s4[9]),.a_out(a_s4[10]),.b_out(b_s4[10]),.c_out(c_s4[10]),.d_out(d_s4[10]),.e_out(e_s4[10]),.f_out(f_s4[10]),.g_out(g_s4[10]),.h_out(h_s4[10]));
    RTL_F_32 F32_stage4_11(.w(w_s3[11]),.k(32'h8cc70208),.a(a_s4[10]),.b(b_s4[10]),.c(c_s4[10]),.d(d_s4[10]),.e(e_s4[10]),.f(f_s4[10]),.g(g_s4[10]),.h(h_s4[10]),.a_out(a_s4[11]),.b_out(b_s4[11]),.c_out(c_s4[11]),.d_out(d_s4[11]),.e_out(e_s4[11]),.f_out(f_s4[11]),.g_out(g_s4[11]),.h_out(h_s4[11]));
    RTL_F_32 F32_stage4_12(.w(w_s3[12]),.k(32'h90befffa),.a(a_s4[11]),.b(b_s4[11]),.c(c_s4[11]),.d(d_s4[11]),.e(e_s4[11]),.f(f_s4[11]),.g(g_s4[11]),.h(h_s4[11]),.a_out(a_s4[12]),.b_out(b_s4[12]),.c_out(c_s4[12]),.d_out(d_s4[12]),.e_out(e_s4[12]),.f_out(f_s4[12]),.g_out(g_s4[12]),.h_out(h_s4[12]));
    RTL_F_32 F32_stage4_13(.w(w_s3[13]),.k(32'ha4506ceb),.a(a_s4[12]),.b(b_s4[12]),.c(c_s4[12]),.d(d_s4[12]),.e(e_s4[12]),.f(f_s4[12]),.g(g_s4[12]),.h(h_s4[12]),.a_out(a_s4[13]),.b_out(b_s4[13]),.c_out(c_s4[13]),.d_out(d_s4[13]),.e_out(e_s4[13]),.f_out(f_s4[13]),.g_out(g_s4[13]),.h_out(h_s4[13]));
    RTL_F_32 F32_stage4_14(.w(w_s3[14]),.k(32'hbef9a3f7),.a(a_s4[13]),.b(b_s4[13]),.c(c_s4[13]),.d(d_s4[13]),.e(e_s4[13]),.f(f_s4[13]),.g(g_s4[13]),.h(h_s4[13]),.a_out(a_s4[14]),.b_out(b_s4[14]),.c_out(c_s4[14]),.d_out(d_s4[14]),.e_out(e_s4[14]),.f_out(f_s4[14]),.g_out(g_s4[14]),.h_out(h_s4[14]));
    RTL_F_32 F32_stage4_15(.w(w_s3[15]),.k(32'hc67178f2),.a(a_s4[14]),.b(b_s4[14]),.c(c_s4[14]),.d(d_s4[14]),.e(e_s4[14]),.f(f_s4[14]),.g(g_s4[14]),.h(h_s4[14]),.a_out(a_s4[15]),.b_out(b_s4[15]),.c_out(c_s4[15]),.d_out(d_s4[15]),.e_out(e_s4[15]),.f_out(f_s4[15]),.g_out(g_s4[15]),.h_out(h_s4[15]));
    
    /*
            stage 4
        F_32(w0, 0x19a4c116)
        F_32(w1, 0x1e376c08)
        F_32(w2, 0x2748774c)
        F_32(w3, 0x34b0bcb5)
        F_32(w4, 0x391c0cb3)
        F_32(w5, 0x4ed8aa4a)
        F_32(w6, 0x5b9cca4f)
        F_32(w7, 0x682e6ff3)
        F_32(w8, 0x748f82ee)
        F_32(w9, 0x78a5636f)
        F_32(w10, 0x84c87814)
        F_32(w11, 0x8cc70208)
        F_32(w12, 0x90befffa)
        F_32(w13, 0xa4506ceb)
        F_32(w14, 0xbef9a3f7)
        F_32(w15, 0xc67178f2)
    */
    //F_32
    	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			//message_reg			<= 256'b0;
			a_reg    <= 32'b0;
			b_reg    <= 32'b0;
			c_reg    <= 32'b0;
			d_reg    <= 32'b0;
			e_reg    <= 32'b0;
			f_reg    <= 32'b0;
			g_reg    <= 32'b0;
			h_reg    <= 32'b0;
		end
		else begin
			//message_reg			<= message_loop_out_wr;
			a_reg    <= a_s4[15] + state_in[31:0];
			b_reg    <= b_s4[15] + state_in[63:32];
			c_reg    <= c_s4[15] + state_in[95:64];
			d_reg    <= d_s4[15] + state_in[127:96];
			e_reg    <= e_s4[15] + state_in[159:128];
			f_reg    <= f_s4[15] + state_in[191:160];
			g_reg    <= g_s4[15] + state_in[223:192];
			h_reg    <= h_s4[15] + state_in[255:224];
		end
	end
	assign inlen_reg = inlen;
	//Expand
		always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			inlen_out 			<= 64'b0;
			//round_add_reg 		<= 1'b0;
			flag_done        <= 1'b0;
		end
		else begin
			if(start_in) begin
				inlen_out 			<= inlen;
				flag_done           <= 1'b0;
				//round_add_reg 		<= 1'b1;
			end
			else if (inlen < 64) begin
			     inlen_out <= inlen;
			     flag_done <= 1'b1;
				//round_reg 			<= 7'b0;
				//round_add_reg 		<= 1'b0;
			end
			else begin
			     inlen_out <= inlen_out - 64;
			     flag_done <= 1'b1;
				//round_reg 			<= round_reg + round_add_reg;
				//round_add_reg 		<= round_add_reg;
			end
		end
	end
	
		always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			state_out 			<= 256'b0;
			valid_out 			<= 1'b0;
		end
		else begin
			if(start_in) begin
				state_out 			<= 256'b0;
				valid_out 			<= 1'b0;
			end
			else if (flag_done == 1) begin
				state_out 			<= {h,g,f,e,d,c,b,a};
				valid_out 			<= 1'b1;
			end
			else begin
				state_out 			<= state_out;
				valid_out 			<= valid_out;
			end
		end
	end
    //while process
    /*
    while (inlen >= 64) {
        //load value
        //Increase Variable
        a += state[0];
        b += state[1];
        c += state[2];
        d += state[3];
        e += state[4];
        f += state[5];
        g += state[6];
        h += state[7];
        //Store Value
        state[0] = a;
        state[1] = b;
        state[2] = c;
        state[3] = d;
        state[4] = e;
        state[5] = f;
        state[6] = g;
        state[7] = h;
        // Condition
        in += 64;
        inlen -= 64;
    }
    */
endmodule
/*
        uint32_t w0  = load_bigendian_32(in + 0);
        uint32_t w1  = load_bigendian_32(in + 4);
        uint32_t w2  = load_bigendian_32(in + 8);
        uint32_t w3  = load_bigendian_32(in + 12);
        uint32_t w4  = load_bigendian_32(in + 16);
        uint32_t w5  = load_bigendian_32(in + 20);
        uint32_t w6  = load_bigendian_32(in + 24);
        uint32_t w7  = load_bigendian_32(in + 28);
        uint32_t w8  = load_bigendian_32(in + 32);
        uint32_t w9  = load_bigendian_32(in + 36);
        uint32_t w10 = load_bigendian_32(in + 40);
        uint32_t w11 = load_bigendian_32(in + 44);
        uint32_t w12 = load_bigendian_32(in + 48);
        uint32_t w13 = load_bigendian_32(in + 52);
        uint32_t w14 = load_bigendian_32(in + 56);
        uint32_t w15 = load_bigendian_32(in + 60);
        //Process
        stage 1
        F_32(w0, 0x428a2f98)
        F_32(w1, 0x71374491)
        F_32(w2, 0xb5c0fbcf)
        F_32(w3, 0xe9b5dba5)
        F_32(w4, 0x3956c25b)
        F_32(w5, 0x59f111f1)
        F_32(w6, 0x923f82a4)
        F_32(w7, 0xab1c5ed5)
        F_32(w8, 0xd807aa98)
        F_32(w9, 0x12835b01)
        F_32(w10, 0x243185be)
        F_32(w11, 0x550c7dc3)
        F_32(w12, 0x72be5d74)
        F_32(w13, 0x80deb1fe)
        F_32(w14, 0x9bdc06a7)
        F_32(w15, 0xc19bf174)

        EXPAND_32
        
        
        stage 2
        F_32(w0, 0xe49b69c1)
        F_32(w1, 0xefbe4786)
        F_32(w2, 0x0fc19dc6)
        F_32(w3, 0x240ca1cc)
        F_32(w4, 0x2de92c6f)
        F_32(w5, 0x4a7484aa)
        F_32(w6, 0x5cb0a9dc)
        F_32(w7, 0x76f988da)
        F_32(w8, 0x983e5152)
        F_32(w9, 0xa831c66d)
        F_32(w10, 0xb00327c8)
        F_32(w11, 0xbf597fc7)
        F_32(w12, 0xc6e00bf3)
        F_32(w13, 0xd5a79147)
        F_32(w14, 0x06ca6351)
        F_32(w15, 0x14292967)

        EXPAND_32

        stage 3
        F_32(w0, 0x27b70a85)
        F_32(w1, 0x2e1b2138)
        F_32(w2, 0x4d2c6dfc)
        F_32(w3, 0x53380d13)
        F_32(w4, 0x650a7354)
        F_32(w5, 0x766a0abb)
        F_32(w6, 0x81c2c92e)
        F_32(w7, 0x92722c85)
        F_32(w8, 0xa2bfe8a1)
        F_32(w9, 0xa81a664b)
        F_32(w10, 0xc24b8b70)
        F_32(w11, 0xc76c51a3)
        F_32(w12, 0xd192e819)
        F_32(w13, 0xd6990624)
        F_32(w14, 0xf40e3585)
        F_32(w15, 0x106aa070)

        EXPAND_32

        stage 4
        F_32(w0, 0x19a4c116)
        F_32(w1, 0x1e376c08)
        F_32(w2, 0x2748774c)
        F_32(w3, 0x34b0bcb5)
        F_32(w4, 0x391c0cb3)
        F_32(w5, 0x4ed8aa4a)
        F_32(w6, 0x5b9cca4f)
        F_32(w7, 0x682e6ff3)
        F_32(w8, 0x748f82ee)
        F_32(w9, 0x78a5636f)
        F_32(w10, 0x84c87814)
        F_32(w11, 0x8cc70208)
        F_32(w12, 0x90befffa)
        F_32(w13, 0xa4506ceb)
        F_32(w14, 0xbef9a3f7)
        F_32(w15, 0xc67178f2)
        //Increase Variable
        a += state[0];
        b += state[1];
        c += state[2];
        d += state[3];
        e += state[4];
        f += state[5];
        g += state[6];
        h += state[7];
        //Store Value
        state[0] = a;
        state[1] = b;
        state[2] = c;
        state[3] = d;
        state[4] = e;
        state[5] = f;
        state[6] = g;
        state[7] = h;
*/