module mb3(input  wire [7:0] in,
           output wire [7:0] out);
           
    wire [7:0] out_mb2;      
    mb2 mb2_0(.in(in),.out(out_mb2));
    assign out = out_mb2 ^ in;
endmodule
