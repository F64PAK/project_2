`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2024 03:23:31 PM
// Design Name: 
// Module Name: fors_wots_gen_sk
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


module fors_wots_gen_sk(
            input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] sk_seed,
             input  wire    [255:0] addr,
             input  wire            mode, // 0: wots || 1: fors
             output	reg 	[127:0]	sk_out,
             output reg           	valid_out
    );
    wire [255:0] addr_wr;
    wire         valid_out_prf_addr;
    wand [127:0] out_wr;
    assign addr_wr[255:80] = addr[255:80];
    assign addr_wr[79:72] = (~mode) ? 8'b0 : addr[79:72];
    assign addr_wr[71:0] = addr[71:0];
    prf_addr prf_addr_gen_sk(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in),
             .key(sk_seed),
             .addr(addr_wr),
             .out(out_wr),
             .valid_out(valid_out_prf_addr) 
    );
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            valid_out <= 1'b0;
            sk_out <= 128'b0;
        end
        else if (valid_out_prf_addr ) begin
            sk_out <= out_wr;
            valid_out <= 1'b1;
        end
        else begin
            sk_out <= 128'b0;
            valid_out <= 1'b0;
        end
    end
endmodule
