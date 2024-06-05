module subBytes(input  wire  [127:0] in,
                output wire  [127:0] out );


sbox s0(in[0 +: 8], out[0 +: 8]);
sbox s1(in[8 +: 8], out[8 +: 8]);
sbox s2(in[16 +: 8], out[16 +: 8]);
sbox s3(in[24 +: 8], out[24 +: 8]);
sbox s4(in[32 +: 8], out[32 +: 8]);
sbox s5(in[40 +: 8], out[40 +: 8]);
sbox s6(in[48 +: 8], out[48 +: 8]);
sbox s7(in[56 +: 8], out[56 +: 8]);
sbox s8(in[64 +: 8], out[64 +: 8]);
sbox s9(in[72 +: 8], out[72 +: 8]);
sbox s10(in[80 +: 8], out[80 +: 8]);
sbox s11(in[88 +: 8], out[88 +: 8]);
sbox s12(in[96 +: 8], out[96 +: 8]);
sbox s13(in[104 +: 8], out[104 +: 8]);
sbox s14(in[112 +: 8], out[112 +: 8]);
sbox s15(in[120 +: 8], out[120 +: 8]);

endmodule
