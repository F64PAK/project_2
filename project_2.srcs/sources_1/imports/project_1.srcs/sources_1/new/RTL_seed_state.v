`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 05:06:41 PM
// Design Name: 
// Module Name: RTL_seed_state
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


module RTL_seed_state(
                input           CLK,
                input           RST,
                input [127:0]   pub_seed,
                //input [319:0]   state_seed,
                input           start_in,
                output reg [319:0] state_out,
                output reg         valid_out
    );
    wire [511:0] mess_in;
    wire [319:0] state_in,
                 state_out_wr; 
    wire valid_out_process;
    assign mess_in = {pub_seed[127:0],384'b0};
    assign state_in = {256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19 , 64'h0};
    //assign valid_out = valid_out_process;
    RTL_sha256_inc_blocks sha256_inc_blocks_seed_state(  .CLK(CLK),
                                                         .RST(RST),
                                                         .start_in(start_in),
                                                         .message_in(mess_in),
                                                         .digest_in(state_in),
                                                         .state_out(state_out_wr),
                                                         .valid_out(valid_out_process)
                                                         );
    
    always @(posedge CLK or negedge RST)	
	begin
		if(!RST) begin
		    state_out <= 320'b0;
			valid_out <= 1'b0;
		end
		else if(start_in) begin
		    state_out <= 320'b0;
			valid_out <= 1'b0;
		end
		else if (valid_out_process == 1) begin
		    valid_out <= 1'b1;
		    state_out <= state_out_wr;
		end
		else begin
		    valid_out <= 1'b0;
		end
	end
	
endmodule
