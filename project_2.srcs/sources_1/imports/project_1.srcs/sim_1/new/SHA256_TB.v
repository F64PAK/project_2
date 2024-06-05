`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2023 09:57:56 AM
// Design Name: 
// Module Name: SHA256_TB
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

//-------------------------------------------------------------------------------------------------//
//  File name	: TB_SHA2_Top.v									                           //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: The test bench file of SHA-512                                                   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

`timescale 1 ns/10 ps

module SHA256_TB();
reg CLK,RST,start_in;
reg [511:0] message_in;
reg [255:0] digest_in;
wire [255:0] digest_out;
wire valid_out;
/*
SHA256Mau SHA256Mau_tb(.CLK(CLK),
                        .RST(RST),
                        .start_in(start_in),
                        .message_in(message_in),
                        .digest_in(digest_in),
                        .digest_out(digest_out),
                        .valid_out(valid_out));
                        */

RTL_crypto_hashblocks_sha256 SHA256_tb(.CLK(CLK),
                        .RST(RST),
                        .start_in(start_in),
                        .message_in(message_in),
                        .digest_in(digest_in),
                        .digest_out(digest_out),
                        .valid_out(valid_out));            

parameter clock = 50;
always #clock CLK = ~CLK;
initial 
begin
    CLK <= 0;
    RST <= 0;
    start_in <= 0;
    #(100*clock)
    RST <=1;
    message_in <= 512'h01020304000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    digest_in <= 256'h0102030400000000000000000000000000000000000000000000000000000000;
    #(2*clock)   
    start_in <= 1;
    #(2*clock)
    start_in <= 0;
    #(500*clock) $stop;
end
endmodule
