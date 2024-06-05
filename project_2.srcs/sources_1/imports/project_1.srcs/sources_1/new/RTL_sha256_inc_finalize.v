`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2023 03:35:46 PM
// Design Name: 
// Module Name: RTL_sha256_inc_finalize
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

// The module use to exe with message which have inlen < 64
// We didn'd exe crypto before check lengh < 54 
module RTL_sha256_inc_finalize(CLK,RST,start_in,inlen,message_in,state_in,state_out,valid_out);
input 	wire 			CLK;
input	wire			RST;
input	wire			start_in;
input	wire			inlen;
input	wire	[511:0]	message_in;
input	wire	[319:0]	state_in; // 256 bit - 64 bit 
output	reg		[255:0]	state_out;
output  reg            	valid_out;

wire [1023:0] padded,in512bit ;
wire [255:0] in256bit,out256bit;
wire done_crypto;
wire [63:0] bytes;
reg  control_in,control_padded; // control_padded = 0 -> inlen <54 ; =1 inlen >54

assign bytes = state_in[63:0] + inlen;

assign in256bit = (start_in) ? state_in[319:64] : out256bit;
assign in512bit = (control_in ? padded[1023:512] : padded[511:0] ); 


//assign padded[1023:512] = message_in[511:0];
assign padded[1023:592] = message_in[511:80];
//assign padded[591:512] = (control_padded ? message_in [79:0] : {,})
//assign padded[511:0]


//RTL_crypto_hashblocks_sha256(.CLK(CLK),.RST(RST),.start_in(start_in),.message_in(in512bit),.digest_in(in256bit),.digest_out(out256bit),.valid_out(done_crypto));
endmodule
