`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2024 01:31:23 PM
// Design Name: 
// Module Name: thash
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


module thash(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [4479:0]in,
             input	wire	[1:0]	mode,
             input	wire	[319:0]	state_seed, // pub_seed nay la state_seed
             //input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	addr,
             output	reg 	[127:0]	out,
             output reg           	valid_out );
    reg [5119:0] buf_reg;
    //reg [383:0] seed_reg;
    reg start_in_reg;
    wire [511:0] buf_wr;
    wire [175:0] addr_wr;
    wire [31:0] loop_wr;
    wire [255:0] out_wr;
    wire check , check_loop; 
    wire start_in_wr;
    reg next_loop;
    wire [63:0] bytes;
    wire valid_out_wr;
    //assign out = out_wr[255:128];
    //assign start_in_wr = (start_in | check)? 1'b1:1'b0;
    assign start_in_wr = (start_in_reg | next_loop)? 1'b1:1'b0;
    assign loop_wr = ((mode == 2'b00 | mode == 2'b01)? 32'd1 : ((mode==2'b10)? 32'd9 : 32'd10) );
    //assign buf_wr = buf_reg;
    assign buf_wr = ((mode == 2'b00 | mode == 2'b01)? buf_reg[511:0] : 
                    ((mode==2'b10)? buf_reg[4607:4096] : 
                                    buf_reg[5119:4608] ) );
    assign bytes[63:0] = (mode == 2'b00) ?  (state_seed[63:0] + 64'd38) :
                   (mode == 2'b01) ?  (state_seed[63:0] + 64'd54) :
                   (mode == 2'b10) ?  (state_seed[63:0] + 64'd550): 
                                      (state_seed[63:0] + 64'd582);
                                              
    //assign addr_wr = {addr[255:80]}; // lay 176 bit cao 
    assign addr_wr[175:0] = {addr[231:224],addr[239:232],addr[247:240],addr[255:248],
                      addr[199:192],addr[207:200],addr[215:208],addr[223:216],
                      addr[167:160],addr[175:168],addr[183:176],addr[191:184],
                      addr[135:128],addr[143:136],addr[151:144],addr[159:152],
                      addr[103:96],addr[111:104],addr[119:112],addr[127:120],
                      addr[71:64],addr[79:72]};
    assign check = sha256_thash.valid_out_w;
    assign check_loop = sha256_thash.check_loop;
    always @(posedge CLK) begin
        if(!RST) begin
            buf_reg <= 5120'b0;
            //seed_reg <= 384'b0;
            out <= 128'b0;
            next_loop <= 1'b0;
            start_in_reg <=1'b0;
            valid_out   <= 1'b0;
        end
        else if (start_in) begin
            start_in_reg <=1'b1;
            next_loop <=1'b0;
            //seed_reg <= pub_seed;
            if (mode == 2'b00) begin
            // inblocks = 1 -> buf = {576 bytes Z, 22,16 ,26 bytes paddeed} (38 bytes = 304 bit)
                buf_reg <= {5608'b0,addr_wr,in[127:0],8'h80,136'b0,{bytes[60:0],3'b000}}; // padded 1 block 64 bytes tu addr -> loop 1 lan
            end
            else if (mode == 2'b01) begin
            // inblocks = 2 -> buf = {576 bytes Z,22,32,10bytes padded} (54 bytes = 432 bit)
                buf_reg <= {5608'b0,addr_wr,in[255:0],8'h80,8'b0,{bytes[60:0],3'b000}}; // padded 1 block 64 bytes -> loop 1 lan
            end
            else if (mode == 2'b10) begin
            // inblocks = 33 -> buf = {64 bytes Z,22,528,26 bytes padded} (550 bytes = 4400 bit) -> 576 bytes -> 9 lan loop 
                buf_reg <= {512'b0,addr_wr,in[4223:0],8'h80,136'b0,{bytes[60:0],3'b000}};
            end
            else if (mode == 2'b11) begin
            // inblocks = 35 -> buf = {22,560,58 bytes padded} (582 bytes = 4656 bit -> 640 bytes = 5120 bit) -> 9 lan lop
                buf_reg <= {addr_wr,in[4479:0],8'h80,392'b0,{bytes[60:0],3'b000}};
            end
        end
        else if (valid_out_wr) begin
            out <= out_wr[255:128];
            valid_out <= 1'b1;
        end
        else if (check) begin
        buf_reg <= buf_reg << 512;
            if (~check_loop) next_loop <= 1'b1;
            else next_loop <= 1'b0;
        end
        else begin
            out <= 128'b0;
            next_loop <= 1'b0;
            start_in_reg <=1'b0;
            valid_out   <= 1'b0;
        end
    end
    
    
    //assign valid_out = valid_out_wr;
    SHA256_Top sha256_thash(.CLK(CLK),
                      .RST(RST),
                      .start_in(start_in_wr),
                      .loop_in(loop_wr),
                      .message_in(buf_wr),
                      .digest_in(state_seed[319:64]),
                      .digest_out(out_wr),
                      .valid_out(valid_out_wr));

    
endmodule
