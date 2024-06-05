`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2023 07:06:28 PM
// Design Name: 
// Module Name: seedexpander_init_tb
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


module seedexpander_init_tb();
reg CLK;
reg RST;
reg start_in;

    reg [255:0] seed;
    reg [63:0] diversifier;
    reg [31:0] maxlen;
    wire valid_out;
    wire [127:0] buffer;
    wire [31:0] buffer_pos;
    wire [31:0] length_remaining;
    wire [255:0] key;
    wire [127:0] ctr;
    seedexpander_init seedexpender_init_tb(CLK,RST,
                        start_in,
                        seed,
                        diversifier,
                        maxlen,
                        valid_out,
                        buffer,
                        buffer_pos,
                        length_remaining,
                        key,
                        ctr
    );
parameter clock = 10;
always #(clock/2) CLK = ~CLK;
initial begin
    CLK =0;
    RST = 0;
    start_in = 1'b0;
    #clock
    RST = 1;
    seed = 256'h0123456789abcdeffedcba987654321000112233445566778899aabbccddeeff;
    diversifier = 64'h123456789ABCDEF0;
    maxlen = 32'd100000;
    #clock
    start_in <= 1'b1;
    #clock
    start_in = 1'b0;
    #(100*clock) $stop;
    
end

endmodule
