`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:36:23 PM
// Design Name: 
// Module Name: RTL_EXPAND_32
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


module RTL_EXPAND_32(
w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,
w0_out,w1_out,w2_out,w3_out,w4_out,w5_out,w6_out,w7_out,w8_out,w9_out,w10_out,w11_out,w12_out,w13_out,w14_out,w15_out);

input wire [31:0] w0,w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15;
output wire [31:0] w0_out,w1_out,w2_out,w3_out,w4_out,w5_out,w6_out,w7_out,w8_out,w9_out,w10_out,w11_out,w12_out,w13_out,w14_out,w15_out;
   
    RTL_M_32 M_32_0(w0, w14, w9, w1, w0_out);
    RTL_M_32 M_32_1(w1, w15, w10, w2, w1_out);
    RTL_M_32 M_32_2(w2, w0_out, w11, w3, w2_out);
    RTL_M_32 M_32_3(w3, w1_out, w12, w4, w3_out);
    RTL_M_32 M_32_4(w4, w2_out, w13, w5, w4_out);
    RTL_M_32 M_32_5(w5, w3_out, w14, w6, w5_out);
    RTL_M_32 M_32_6(w6, w4_out, w15, w7, w6_out);
    RTL_M_32 M_32_7(w7, w5_out, w0_out, w8, w7_out);
    RTL_M_32 M_32_8(w8, w6_out, w1_out, w9, w8_out);
    RTL_M_32 M_32_9(w9, w7_out, w2_out, w10, w9_out);
    RTL_M_32 M_32_10(w10, w8_out, w3_out, w11, w10_out);
    RTL_M_32 M_32_11(w11, w9_out, w4_out, w12, w11_out);
    RTL_M_32 M_32_12(w12, w10_out, w5_out, w13, w12_out);
    RTL_M_32 M_32_13(w13, w11_out, w6_out, w14, w13_out);
    RTL_M_32 M_32_14(w14, w12_out, w7_out, w15, w14_out);
    RTL_M_32 M_32_15(w15, w13_out, w8_out, w0_out, w15_out);
    
endmodule
