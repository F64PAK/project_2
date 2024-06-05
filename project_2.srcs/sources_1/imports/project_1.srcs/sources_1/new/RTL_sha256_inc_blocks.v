`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 01:35:59 PM
// Design Name: 
// Module Name: RTL_sha256_inc_blocks
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


module RTL_sha256_inc_blocks(
						input 	wire 			CLK,
						input	wire			RST,
						input	wire			start_in,
						input	wire	[511:0]	message_in,
						input	wire	[319:0]	digest_in, //[319:64] data , [63:0] len_executed
						output	reg	    [319:0]	state_out,
						output  reg            	valid_out
						);
wire valid_out_process;
wire [255:0] digest_out_wr;
//reg [63:0] bytes;
RTL_crypto_hashblocks_sha256 process_tb(.CLK(CLK),
                                        .RST(RST),
                                        .start_in(start_in),
                                        .message_in(message_in),
                                        .digest_in(digest_in[319:64]),
                                        //.digest_out(state_out[319:64]),
                                        .digest_out(digest_out_wr),
                                        .valid_out(valid_out_process));
//assign state_out[63:0] = 64'd64;
//assign valid_out = valid_out_process;

always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
		    state_out     <= 320'b0;
			//bytes			<= 64'b0;
			valid_out	  <= 1'b0;
		end
		else if(start_in) begin
		      //bytes <= bytes + 64;
		    state_out     <= 320'b0;
			valid_out	  <= 1'b0;
		end
		else if (valid_out_process == 1) begin
		      valid_out <= 1'b1;
		      state_out <= {digest_out_wr,64'd64};
		end
		else begin
		      valid_out <= 1'b0;
		      state_out <= 320'b0;
		end
	end

endmodule
