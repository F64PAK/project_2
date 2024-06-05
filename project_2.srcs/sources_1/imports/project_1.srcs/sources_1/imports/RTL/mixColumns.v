module mixColumns(input  wire [127:0] in,
                  output wire [127:0] out);
                  
    wire [31:0] mb2_0,mb2_1,mb2_2,mb2_3,mb2_4,mb2_5,mb2_6,mb2_7,mb2_8,mb2_9,mb2_10,mb2_11,mb2_12,mb2_13,mb2_14,mb2_15;
    wire [31:0] mb3_0,mb3_1,mb3_2,mb3_3,mb3_4,mb3_5,mb3_6,mb3_7,mb3_8,mb3_9,mb3_10,mb3_11,mb3_12,mb3_13,mb3_14,mb3_15;

    mb2 RTL_mb2_0 (.in(in[24+:8]),.out(mb2_0));
    mb2 RTL_mb2_1 (.in(in[16+:8]),.out(mb2_1));
    mb2 RTL_mb2_2 (.in(in[8+:8]),.out(mb2_2));
    mb2 RTL_mb2_3 (.in(in[0+:8]),.out(mb2_3));
    mb2 RTL_mb2_4 (.in(in[56+:8]),.out(mb2_4));
    mb2 RTL_mb2_5 (.in(in[48+:8]),.out(mb2_5));
    mb2 RTL_mb2_6 (.in(in[40+:8]),.out(mb2_6));
    mb2 RTL_mb2_7 (.in(in[32+:8]),.out(mb2_7));
    mb2 RTL_mb2_8 (.in(in[88+:8]),.out(mb2_8));
    mb2 RTL_mb2_9 (.in(in[80+:8]),.out(mb2_9));
    mb2 RTL_mb2_10 (.in(in[72+:8]),.out(mb2_10));
    mb2 RTL_mb2_11 (.in(in[64+:8]),.out(mb2_11));
    mb2 RTL_mb2_12 (.in(in[120+:8]),.out(mb2_12));
    mb2 RTL_mb2_13 (.in(in[112+:8]),.out(mb2_13));
    mb2 RTL_mb2_14 (.in(in[104+:8]),.out(mb2_14));
    mb2 RTL_mb2_15 (.in(in[96+:8]),.out(mb2_15));
    
    mb3 RTL_mb3_0 (.in(in[16+:8]),.out(mb3_0));
    mb3 RTL_mb3_1 (.in(in[8+:8]),.out(mb3_1));
    mb3 RTL_mb3_2 (.in(in[0+:8]),.out(mb3_2));
    mb3 RTL_mb3_3 (.in(in[24+:8]),.out(mb3_3));
    mb3 RTL_mb3_4 (.in(in[48+:8]),.out(mb3_4));
    mb3 RTL_mb3_5 (.in(in[40+:8]),.out(mb3_5));
    mb3 RTL_mb3_6 (.in(in[32+:8]),.out(mb3_6));
    mb3 RTL_mb3_7 (.in(in[56+:8]),.out(mb3_7));
    mb3 RTL_mb3_8 (.in(in[80+:8]),.out(mb3_8));
    mb3 RTL_mb3_9 (.in(in[72+:8]),.out(mb3_9));
    mb3 RTL_mb3_10 (.in(in[64+:8]),.out(mb3_10));
    mb3 RTL_mb3_11 (.in(in[88+:8]),.out(mb3_11));
    mb3 RTL_mb3_12 (.in(in[112+:8]),.out(mb3_12));
    mb3 RTL_mb3_13 (.in(in[104+:8]),.out(mb3_13));
    mb3 RTL_mb3_14 (.in(in[96+:8]),.out(mb3_14));
    mb3 RTL_mb3_15 (.in(in[120+:8]),.out(mb3_15));

    //[31:0] 24 16 8 0 
    assign out[24+:8]= mb2_0 ^ mb3_0 ^ in[8+:8] ^ in[0+:8];
	assign out[16+:8]= in[24+:8] ^ mb2_1 ^ mb3_1 ^ in[0+:8];
	assign out[8+:8]= in[24+:8] ^ in[16+:8] ^ mb2_2 ^ mb3_2;
    assign out[0+:8]= mb3_3 ^ in[16+:8] ^ in[8+:8] ^ mb2_3;
    //[63:32] 56 48 40 32 
    assign out[56+:8]= mb2_4 ^ mb3_4 ^ in[40+:8] ^ in[32+:8];
	assign out[48+:8]= in[56+:8] ^ mb2_5 ^ mb3_5 ^ in[32+:8];
	assign out[40+:8]= in[56+:8] ^ in[48+:8] ^ mb2_6 ^ mb3_6;
    assign out[32+:8]= mb3_7 ^ in[48+:8] ^ in[40+:8] ^ mb2_7;
    
    //[95:64] 88 80 72 64
    assign out[88+:8]= mb2_8 ^ mb3_8 ^ in[72+:8] ^ in[64+:8];
	assign out[80+:8]= in[88+:8] ^ mb2_9 ^ mb3_9 ^ in[64+:8];
	assign out[72+:8]= in[88+:8] ^ in[80+:8] ^ mb2_10 ^ mb3_10;
    assign out[64+:8]= mb3_11 ^ in[80+:8] ^ in[72+:8] ^ mb2_11;
    
    //[127:96] 120 112 104 96
    assign out[120+:8]= mb2_12 ^ mb3_12 ^ in[104+:8] ^ in[96+:8];
	assign out[112+:8]= in[120+:8] ^ mb2_13 ^ mb3_13 ^ in[96+:8];
	assign out[104+:8]= in[120+:8] ^ in[112+:8] ^ mb2_14 ^ mb3_14;
    assign out[96+:8]= mb3_15 ^ in[112+:8] ^ in[104+:8] ^ mb2_15;
 
endmodule
