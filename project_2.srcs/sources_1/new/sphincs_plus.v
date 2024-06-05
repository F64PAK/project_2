`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2024 12:01:55 AM
// Design Name: 
// Module Name: sphincs_plus
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


module sphincs_plus(
		input wire CLK,
        input wire RST,
        input wire start_in,
        input wire [255:0] key_in,
        input wire [127:0] V_in,
		input   wire    [511:0] m, //511 bit/loop
		input   wire    [31:0]  mlen,
		output  reg 			valid_out_keypair,
		output  reg             valid_done_message, // tinh xong m -> truyen them message moi
		output	reg				valid_out_loop,		// xuat ra 512 bit ket qua
		output  reg             valid_out_signature,		// thuc thi xong
		output  reg             valid_verify,
		output  reg             valid_out_verify	
    );
    reg				start_in_keypair_reg,
					start_in_signature_reg;
	reg		[255:0]	key_in_reg;
	reg		[127:0]	V_in_reg;
	reg		[511:0]	sk_reg;
	reg		[255:0]	pk_reg;
	reg		[511:0]	m_reg;
	reg		[31:0]	mlen_reg;
	reg     [136703:0]	sig_reg;
	wire	[255:0]	key_out_wr;
	wire	[127:0]	V_out_wr;
	wire	[511:0]	sk_wr;
	wire	[255:0]	pk_wr;
	wire			valid_out_verify_wr,
					valid_done_message_wr,
					valid_out_loop_wr,
					valid_out_signature_wr,
					valid_verify_wr,
					valid_out_keypair_wr;
	wire	[511:0]	sig_wr;
	wire	[63:0]	siglen_wr;
    crypto_sign_keypair crypto_sign_keypair_sphincs_plus(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_keypair_reg),
        .key_in(key_in_reg),
        .V_in(V_in_reg),
        .key_out(key_out_wr), //suy nghi ve wire 
        .V_out(V_out_wr),   //suy nghi ve wire
        .sk(sk_wr),      //suy nghi ve wire
        .pk(pk_wr),      //suy nghi ve wire
        .valid_out(valid_out_keypair_wr)
    );
	
	
	
    crypto_sign_signature crypto_sign_signature_sphincs_plus(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_signature_reg),
		.sk(sk_reg),
		.m(m_reg), //511 bit/loop
		.mlen(mlen_reg),
		.key_in(key_in_reg),              //randombyte
		.V_in(V_in_reg),                //randombyte
		.key_out(key_out_wr),             //randombyte 
		.V_out(V_out_wr),               //randombyte
		.sig(sig_wr),
		.siglen(siglen_wr),
		.valid_done_message(valid_done_message_wr), // tinh xong m -> truyen them message moi
		.valid_out_loop(valid_out_loop_wr),		// xuat ra 512 bit ket qua
		.valid_out(valid_out_signature_wr)			// thuc thi xong
    );
	
    crypto_sign_verify crypto_sign_verify_sphincs_plus(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_verify_reg),
		.sig(sig_reg), //17088 bytes
		.m(mlen_reg), //511 bit/loop
		.mlen(mlen_reg),
		.pk(pk_reg),
		.valid_done_message(valid_done_message_wr), // tinh xong m -> truyen them message moi
		.valid_verify(valid_verify_wr),
		.valid_out(valid_out_verify_wr)			// thuc thi xong
    );
endmodule
