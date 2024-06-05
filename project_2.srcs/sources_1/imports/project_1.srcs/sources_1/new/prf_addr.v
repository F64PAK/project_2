`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 01:37:17 PM
// Design Name: 
// Module Name: prf_addr
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


module prf_addr(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] key,
             input  wire    [255:0] addr,
             output	reg 	[127:0]	out,
             output reg           	valid_out 
    );
    // use sha256 : co padded
    wire [319:0] state;
    wire [511:0] buffer;
    wire [63:0] bytes;
    wire [255:0] out_wr;
    wire [175:0] addr_wr;
    wire valid_out_sha256;
    assign state[319:64] = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
    assign state[63:0] = 64'b0;
    // done sha256_inc_init
    assign bytes = 64'd38;
    /////////////////22 bytes_addr
    assign addr_wr = {addr[231:224],addr[239:232],addr[247:240],addr[255:248],
                      addr[199:192],addr[207:200],addr[215:208],addr[223:216],
                      addr[167:160],addr[175:168],addr[183:176],addr[191:184],
                      addr[135:128],addr[143:136],addr[151:144],addr[159:152],
                      addr[103:96],addr[111:104],addr[119:112],addr[127:120],
                      addr[71:64],addr[79:72]};
    assign buffer = {key[127:0],addr_wr,8'h80,136'b0,{bytes[60:0],3'b000}};
    //// inblocks = 1 -> buf = {576 bytes Z, 22,16 ,26 bytes paddeed} (38 bytes = 304 bit)
    //            buf_reg <= {5608'b0,addr_wr,in[127:0],8'h80,136'b0,{bytes[60:0],3'b000}}; // padded 1 block 64 bytes tu addr -> loop 1 lan
    //assign out = out_wr[255:128];
    RTL_crypto_hashblocks_sha256 sha256_prf_addr(.CLK(CLK),
                                    .RST(RST),
                                    .start_in(start_in),
                                    .message_in(buffer),
                                    .digest_in(state[319:64]),
                                    .digest_out(out_wr),
                                    .valid_out(valid_out_sha256));
    
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            out <= 128'b0;
            valid_out <= 1'b0;
        end
        else if(valid_out_sha256) begin
            out <= out_wr[255:128];
            valid_out <= 1'b1;
        end
        else begin 
            out <= 128'b0;
            valid_out <= 1'b0;
        end
    end
endmodule
