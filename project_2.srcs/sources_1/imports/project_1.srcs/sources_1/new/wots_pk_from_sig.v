`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 01:18:53 PM
// Design Name: 
// Module Name: wots_pk_from_sig
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


module wots_pk_from_sig(
        
        input   wire                CLK,
        input   wire                RST,
        input   wire                start_in,
        input   wire    [127:0]     msg,
        input   wire    [127:0]     sig,
        input	wire	[319:0]	    state_seed,
        //input   wire    [383:0]     pub_seed,
        input   wire    [255:0]     addr,
        output  reg     [127:0]     pk, 
        output  reg                 valid_out_en, // 1 loop
        output  reg                 valid_out    //35 loop
        
    );
    //sig la in
    //pk output
    parameter   SPX_WOTS_W  = 32'd15; //SPX_WOTS_W - 1
    reg                 start_in_wots_gen_sk;
    reg     [1119:0]    lenght_reg;
    reg     [7:0]       count_reg;
    reg                 count_add;
    reg                 flag_loop;
    wire                start_in_chain_length;
	wire                valid_out_chain_lengths;
    wire    [1119:0]    lenght_wr;
    wire    [255:0]     addr_wr;
    wire    [31:0]      length_wr_loop;
    wire 				check_loop;
	wire    [31:0]      step_wr;
	wire    [127:0]     pk_wr;
	wire                valid_out_gen;
	//assign valid_out = valid_out_en && check_loop;
	assign check_loop = (count_reg == 8'd34)? 1'b1 : 1'b0;
    assign length_wr_loop = lenght_reg[1119:1088];
    assign addr_wr[255:112] = addr[255:112]; // xu li chain_addr
    assign addr_wr[103:0] = addr[103:0];
    assign addr_wr[111:104] = count_reg;
    assign step_wr = SPX_WOTS_W - length_wr_loop;
    assign start_in_chain_length = start_in & !flag_loop;
    chain_lengths chain_lengths_wots_sign(
			 .start_in(start_in_chain_length),
			 .CLK(CLK),
			 .RST(RST),
			 .msg(msg),
			 .out_lenghts(lenght_wr),
			 .valid_out(valid_out_chain_lengths)
    );
    /*
    fors_wots_gen_sk fors_wots_gen_sk_wots_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_wots_gen_sk),
             .sk_seed(sk_seed), // bo
             .addr(addr_wr),
             .mode(1'b0), // 0: wots || 1: fors
             .sk_out(sk_wr),
             .valid_out(valid_out_wots_gen_sk)
    );
    */
    gen_chain gen_chain_wots_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_wots_gen_sk),             
			 .in(sig),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .addr(addr_wr),
             .start(length_wr_loop),//length_wr_loop
             .steps(step_wr),//SPX_WOTS_W - 1 - lengths[i]
             .out(pk_wr),
             .valid_out(valid_out_gen)
             //.out(pk),
             //.valid_out(valid_out_en)
    );
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            start_in_wots_gen_sk<=1'b0;
			lenght_reg			<=1120'b0;
			count_reg			<=8'b0;
			count_add			<=1'b0;
			flag_loop           <=1'b0;
			valid_out_en        <=1'b0;
		    pk                  <=128'b0;
		    valid_out           <=1'b0;
			//start_in_chain_length <= 1'b0;
        end
		else if (start_in & !flag_loop) begin
		    valid_out_en        <=1'b0;
		    pk                  <=128'b0;
		    valid_out           <=1'b0;
            start_in_wots_gen_sk<=1'b0;
			lenght_reg			<=1120'b0;
			count_reg			<=8'b0;
			count_add			<=1'b1;
			//valid_out			<=1'b0;
			flag_loop           <=1'b1;
			//start_in_chain_length <= 1'b1;
		end
		else if (start_in & flag_loop) begin
		if (~check_loop) begin // loop
		    //start_in_chain_length <= 1'b0;
			start_in_wots_gen_sk<=1'b1;
			//valid_out			<=1'b0;
			lenght_reg			<= {lenght_reg[1087:0],32'b0};
			count_reg			<= count_reg + count_add;
			end
		end
		else if (valid_out_chain_lengths) begin
			start_in_wots_gen_sk<=1'b1;
			lenght_reg			<=lenght_wr;
			count_reg			<=8'b0;
			//valid_out			<=1'b0;
		end 
		else if (valid_out_gen) begin
		    valid_out_en <= 1'b1;
		    pk <= pk_wr;
			/*
			if (~check_loop) begin // loop
			start_in_wots_gen_sk<=1'b1;
			//valid_out			<=1'b0;
			lenght_reg			<= {lenght_reg[1087:0],32'b0};
			count_reg			<= count_reg + count_add;
			end
			else begin
			*/
			if (check_loop) begin
			valid_out			<=1'b1;
			//start_in_wots_gen_sk<=1'b0;
			lenght_reg			<= 1120'b0;
			//count_reg			<=8'b0;
			flag_loop           <=1'b0;
			end
	   end
	   else begin
	        valid_out_en <= 1'b0;
		    pk <= 128'b0;
		    valid_out <= 1'b0;
			start_in_wots_gen_sk<=1'b0;
			//start_in_chain_length<= 1'b1;
			//valid_out			<=1'b0;
			//lenght_reg			<=1120'b0;
			//count_reg			<=8'b0;
			//count_add			<=1'b0;
			end
		end
		
endmodule
//oke