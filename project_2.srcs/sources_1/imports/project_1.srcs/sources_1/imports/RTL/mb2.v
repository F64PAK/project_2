module mb2(input  wire [7:0] in,
           output wire [7:0] out);
           
           
    assign out = in[7] ? ({in[6:0],1'b0} ^ 8'h1b) : {in[6:0],1'b0};

endmodule
