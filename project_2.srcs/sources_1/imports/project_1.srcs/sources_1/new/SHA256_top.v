`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 10:38:02 PM
// Design Name: 
// Module Name: SHA256_top
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


module SHA256_Top(  
                    input 	wire 			CLK,
                    input	wire			RST,
                    input	wire			start_in,
                    input   wire    [31:0]  loop_in,
                    input	wire	[511:0]	message_in,
                    input	wire	[255:0]	digest_in,
                    output	reg		[255:0]	digest_out,
                    output  reg            	valid_out );
                    
    wire [255:0] 	digest_in_w;                
    wire [255:0] 	digest_out_w;
    wire            valid_out_w, check_loop;                
                    
    reg  [31:0] 	loop_reg;
    reg  [6:0] 		round_reg;
    reg				round_add;
    reg [255:0] 	digest_reg;	
    
    
    
    
  
    // Controller
    always @ (posedge CLK or negedge RST)
    begin 
        if(RST == 1'b0) begin
            round_reg 			<= 7'b0;
            round_add			<= 1'b0;
            loop_reg            <= 32'b0;
            digest_reg 	         <= 256'b0;
            digest_out 	         <= 256'b0;
			valid_out 	         <= 1'b0;
        end
        /*
        else if (valid_out_w) begin
		    digest_reg 	         <= digest_out_w;
		end
		*/
		else if(start_in) begin
			digest_out 	         <= 256'b0;
			valid_out 	         <= 1'b0;
			if(check_loop) begin
                    loop_reg            <= loop_in;
                end
                round_add			<= 1'b1;
                round_reg 			<= round_reg + 1'b1;
		end 
		else if (valid_out_w) begin
		    if (check_loop) begin
		        digest_out 	         <= digest_out_w;
			    valid_out 	         <= 1'b1;
			//them
			    loop_reg             <= 32'b0;
                round_reg            <= 7'b0;
                round_add            <= 1'b0;
                digest_reg           <= 256'b0;	
		    end
		    digest_reg 	         <= digest_out_w;
						
		end
		/*
        else if(start_in) begin
                if(check_loop) begin
                    loop_reg            <= loop_in;
                end
                round_add			<= 1'b1;
                round_reg 			<= round_reg + 1'b1;
            end
        */
        else if (round_reg == 7'd65) begin
                round_reg  		<= 7'b0;
                round_add		<= 1'b0;
            end
        else if((~check_loop) & (round_reg == 7'd64)) begin
                    loop_reg            <= loop_reg - 32'b1;
                    round_reg           <= 1'b0;
                end
        else begin
                //if((~check_loop) & (round_reg == 7'd64)) begin
                //    loop_reg            <= loop_reg - 32'b1;
                //end
                round_add			<= round_add;
                round_reg 			<= round_reg + round_add;
                digest_out 	         <= 256'b0;
			    valid_out 	         <= 1'b0;
         end
	end
	
    assign check_loop = (loop_reg == 32'b0);
    assign digest_in_w = (start_in & check_loop) ? digest_in : digest_reg;
    RTL_crypto_hashblocks_sha256 uut(.CLK(CLK),
                                     .RST(RST),
                                     .start_in(start_in),
                                     .message_in(message_in),
                                     .digest_in(digest_in_w),
                                     .digest_out(digest_out_w),
                                     .valid_out(valid_out_w));
    
    /*
    always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			//digest_reg 	         <= 256'b0;
		end		
		else if (valid_out_w) begin
		   // digest_reg 	         <= digest_out_w;
		end

	end
    */
   /*
   always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			digest_out 	         <= 256'b0;
			valid_out 	         <= 1'b0;
		end 
		else if(start_in) begin
			digest_out 	         <= 256'b0;
			valid_out 	         <= 1'b0;
		end 
		else if (check_loop & valid_out_w) begin
			digest_out 	         <= digest_out_w;
			valid_out 	         <= 1'b1;
			//them
			loop_reg             <= 32'b0;
            round_reg            <= 7'b0;
            round_add            <= 1'b0;
            digest_reg           <= 256'b0;				
		end
		else begin				
			digest_out 	         <= 256'b0;
			valid_out 	         <= 1'b0;
			end	
	end
	*/
endmodule
