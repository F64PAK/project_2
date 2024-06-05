`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2024 12:00:55 PM
// Design Name: 
// Module Name: chain_lengths
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


module chain_lengths(
        input wire start_in,
        input wire CLK,
        input wire RST,
        //input wire [1023:0] lengths,
        input wire [127:0] msg,
        output reg [1119:0] out_lenghts,
        output reg valid_out
    );
    wire [1023:0] base_w_out;
    wire [95:0] csum_out;
    wire valid_csum;
    base_w_32 base_w_chain_lengths(.in(msg),
                                   .out(base_w_out));
    wots_checksum wots_checksum_chain_lengths(.start_in(start_in),
                                              .CLK(CLK),
                                              .RST(RST),
                                              .msg_base_w(base_w_out),
                                              .csum_base_w(csum_out),
                                              .valid_out(valid_csum));

    always @(posedge CLK) begin
        if(!RST) begin 
            out_lenghts <= 1120'b0;
            valid_out <= 1'b0;
        end
        if (valid_csum) begin
            out_lenghts <= {base_w_out,csum_out};  
            valid_out <= 1'b1;
        end
        else begin
            out_lenghts <= 1120'b0;
            valid_out <= 1'b0;
        end
    end
endmodule
