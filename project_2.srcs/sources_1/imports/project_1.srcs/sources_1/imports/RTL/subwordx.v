module subwordx(input  wire     [31:0] in,
                output wire     [31:0] out);
                
subwordx_c subwordx_c_0(.a(in[31:24]),.c(out[31:24]));
subwordx_c subwordx_c_1(.a(in[23:16]),.c(out[23:16]));
subwordx_c subwordx_c_2(.a(in[15:8]),.c(out[15:8]));
subwordx_c subwordx_c_3(.a(in[7:0]),.c(out[7:0]));            

endmodule
