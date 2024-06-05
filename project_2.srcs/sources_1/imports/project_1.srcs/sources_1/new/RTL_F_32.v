`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 03:44:09 PM
// Design Name: 
// Module Name: RTL_F_32
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


module RTL_F_32(
    input [31:0] w,
    input [31:0] k,
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,
    input [31:0] e,
    input [31:0] f,
    input [31:0] g,
    input [31:0] h,
    output [31:0] a_out,
    output [31:0] b_out,
    output [31:0] c_out,
    output [31:0] d_out,
    output [31:0] e_out,
    output [31:0] f_out,
    output [31:0] g_out,
    output [31:0] h_out
    //output [31:0] T1,
    //output [31:0] T2
);

wire [31:0] T1;
wire [31:0] T2;
wire [31:0] result_S0,result_S1,result_Ch,result_Maj;
RTL_Sigma0_32 Sigma0_F32(.x(a),.result(result_S0));
RTL_Sigma1_32 Sigma1_F32(.x(e),.result(result_S1));
RTL_Ch Ch_F32(.x(e),.y(f),.z(g),.result(result_Ch));
RTL_Maj Maj_F32(.x(a),.y(b),.z(c),.result(result_Maj));
//always @(*) begin
assign     T1 = h + result_S1 + + result_Ch + (k) + (w);
assign     T2 = result_S0 + result_Maj;
assign     a_out = T1 + T2;
assign     b_out = a;
assign    c_out = b;
assign    d_out = c;
assign    e_out = d + T1;
assign    f_out = e;
assign    g_out = f;
assign    h_out = g;
///end
endmodule
//    T1 = h + Sigma1_32(e) + Ch(e, f, g) + (k) + (w); \
//    T2 = Sigma0_32(a) + Maj(a, b, c);                \
//    h = g;                                           \
//    g = f;                                           \
//    f = e;                                           \
//    e = d + T1;                                      \
//    d = c;                                           \
//    c = b;                                           \
//    b = a;                                           \
//    a = T1 + T2;
