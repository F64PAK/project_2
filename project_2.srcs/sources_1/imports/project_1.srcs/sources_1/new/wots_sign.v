`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 09:43:46 AM
// Design Name: 
// Module Name: wots_sign
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


module wots_sign(
        input   wire                CLK,
        input   wire                RST,
        input   wire                start_in,
        input   wire    [127:0]     msg,
        input   wire    [127:0]     sk_seed,
        input	wire	[319:0]	    state_seed,
        //input   wire    [383:0]     pub_seed,
        input   wire    [255:0]     addr,
        output  reg     [127:0]     sig,
        output  reg                 valid_out_en, // 1 loop
        output  reg                 valid_out    //35 loop
    );
    
    reg                 start_in_wots_gen_sk;
    reg     [1119:0]    lenght_reg;
    reg     [7:0]       count_reg;
    reg                 count_add;
	wire                valid_out_chain_lengths;
    wire    [1119:0]    lenght_wr;
    wire    [127:0]     sk_wr;
    wire    [255:0]     addr_wr;
    wire                valid_out_wots_gen_sk;
    wire    [31:0]      length_wr_loop;
    wire 				check_loop;
	
	wire                valid_out_gen_chain;
	wire    [127:0]     sig_wr;
	//assign valid_out = valid_out_en && check_loop;
	assign check_loop = (count_reg == 8'd34)? 1'b1 : 1'b0;
    assign length_wr_loop = lenght_reg[1119:1088];
    assign addr_wr[255:112] = addr[255:112]; // xu li chain_addr
    assign addr_wr[103:0] = addr[103:0];
    assign addr_wr[111:104] = count_reg;
    
    chain_lengths chain_lengths_wots_sign(
			 .start_in(start_in),
			 .CLK(CLK),
			 .RST(RST),
			 .msg(msg),
			 .out_lenghts(lenght_wr),
			 .valid_out(valid_out_chain_lengths)
    );
    
    fors_wots_gen_sk fors_wots_gen_sk_wots_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_wots_gen_sk),
             .sk_seed(sk_seed),
             .addr(addr_wr),
             .mode(1'b0), // 0: wots || 1: fors
             .sk_out(sk_wr),
             .valid_out(valid_out_wots_gen_sk)
    );
    
    gen_chain gen_chain_wots_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(valid_out_wots_gen_sk),             
			 .in(sk_wr),
             .state_seed(state_seed),
//             .pub_seed(pub_seed), // khong su dung
             .addr(addr_wr),
             .start(32'b0),
             .steps(length_wr_loop),
             .out(sig_wr),
             .valid_out(valid_out_gen_chain)
    );
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            start_in_wots_gen_sk<=1'b0;
			lenght_reg			<=1120'b0;
			count_reg			<=8'b0;
			count_add			<=1'b0;
			valid_out			<=1'b0;
			valid_out_en		<=1'b0;
			sig                 <=128'b0;
        end
		else if (start_in) begin
            start_in_wots_gen_sk<=1'b0;
			lenght_reg			<=1120'b0;
			count_reg			<=8'b0;
			count_add			<=1'b1;
			valid_out			<=1'b0;
			valid_out_en		<=1'b0;
			sig                 <=128'b0;
		end
		else if (valid_out_chain_lengths) begin
			start_in_wots_gen_sk<=1'b1;
			lenght_reg			<=lenght_wr;
			count_reg			<=8'b0;
			//valid_out			<=1'b0;
		end 
		else if (valid_out_gen_chain) begin
		    sig   <=     sig_wr; 
			valid_out_en        <=1'b1;
			if (~check_loop) begin
			start_in_wots_gen_sk<=1'b1;
			valid_out			<=1'b0;
			lenght_reg			<= {lenght_reg[1087:0],32'b0};
			count_reg			<= count_reg + count_add;
			end
			else begin
			
			valid_out			<=1'b1;
			//start_in_wots_gen_sk<=1'b0;
			lenght_reg			<= 1120'b0;
			//count_reg			<=8'b0;
			count_reg        <=  8'b0;
            count_add        <=  1'b0;
			end
			/*
			if (valid_out) begin
			lenght_reg       <=  1120'b0;
            count_reg        <=  8'b0;
            count_add        <=  1'b0;
			end
			*/
	   end
	   else begin
			start_in_wots_gen_sk<=1'b0;
			valid_out			<=1'b0;
			sig                 <=128'b0;
			valid_out_en        <=1'b0;
			//lenght_reg			<=1120'b0;
			//count_reg			<=8'b0;
			//count_add			<=1'b0;
			end
		end
		
endmodule
