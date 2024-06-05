`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2024 04:14:56 PM
// Design Name: 
// Module Name: crypto_sign_signature
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


module crypto_sign_signature(
    input   wire            CLK,
    input   wire            RST,
    input   wire            start_in,
    //input   wire    [31:0]  loop_in, xu li bang module ben trong
    input   wire    [511:0] sk,
    input   wire    [511:0] m, //511 bit/loop
    input   wire    [31:0]  mlen,
    input   wire    [255:0] key_in,              //randombyte
    input   wire    [127:0] V_in,                //randombyte
    output  reg     [255:0] key_out,             //randombyte 
    output  reg     [127:0] V_out,               //randombyte
    output  reg     [511:0] sig,
    output  reg     [63:0]  siglen,
    output  reg             valid_done_message, // tinh xong m -> truyen them message moi
	output	reg				valid_out_loop,		// xuat ra 512 bit ket qua
    output  reg             valid_out			// thuc thi xong
    );
    // gen_message: loop = [(loop_in-48)/64 ](module) + 1 (+1 la tinh chung)  (TH mlen >= 16)
    // hass_message: loop = [(loop_in-16)]/64](module)                        (TH mlen >=48) 
    parameter SPX_ADDR_TYPE_WOTS = 8'd0;
	parameter SPX_ADDR_TYPE_HASHTREE = 8'd2;
	
	reg		[4:0]		count_reg;
	reg					count_add;
	
	reg					start_in_seed_state_reg,
						start_in_randombytes_reg,
						start_in_cal_loop_reg,
						start_in_gen_message_reg,
						start_in_hash_message_reg,
						start_in_fors_sign_reg,
						start_in_wots_sign_reg,
						start_in_treehash_reg;
	reg		[319:0]		state_reg;
	reg 	[255:0] 	key_reg; // luu truc tiep len output ko can phai dem lai
    reg 	[127:0] 	V_reg;   //	luu truc tiep len output 	
	reg		[127:0]		optrand_reg;
	reg		[31:0]		loop_reg_gen,
						loop_reg_hash;
	reg		[127:0]		R_reg;
	reg		[199:0]		mhash_reg;
	reg		[63:0]		tree_reg;
	reg		[31:0]		leaf_idx_reg;
	reg		[127:0]		root_reg;
	reg		[255:0]		tree_addr_reg;
	reg		[255:0]		wots_addr_reg;
	reg		[1279:0]	buff_out_reg;
	reg		[7:0]		len_buff_reg;
	wire				valid_out_initial,
						valid_out_randombytes,
						valid_out_loop_randombytes,
						valid_out_cal_loop_gen,
						valid_out_cal_loop_hash,
						valid_done_message_gen,
						valid_done_gen,
						valid_done_message_hash,
						valid_done_hash,
						valid_out_loop_fors_sign,
						valid_out_fors_sign,
						valid_out_loop_wots_sign,
						valid_out_wots_sign,
						valid_out_treehash;
	wire	[127:0]		sk_seed,
						sk_prf;
	wire	[255:0]		pk;
	wire	[319:0]		state_out_initial;
	wire 	[255:0] 	key_wr;
    wire 	[127:0] 	V_wr;
	wire	[127:0]		optrand_wr;
	//wire	[31:0]		mlen_wr;
	wire	[31:0]		mlen_wr_gen;
	wire	[31:0]		mlen_wr_hash;
	wire	[31:0]		loop_wr_gen;
	wire	[31:0]		loop_wr_hash;
	wire	[127:0]		R_wr;
	wire	[199:0]		mhash_wr;
	wire	[63:0]		tree_wr;
	wire	[31:0]		leaf_idx_wr;
	wire	[127:0]		root_wr_fors_sign;
	wire	[255:0]		tree_addr_wr;
	wire	[255:0]		wots_addr_wr; // sau khi valid_out_hash_message
	wire	[895:0]		sign_fors_wr;
	wire	[127:0]		wots_sign_wr;
	wire	[127:0]		root_wr_treehash;
	wire	[767:0]		auth_path_wr;
	wire 				check_len_buff;
	
	assign	check_len_buff = (len_buff_reg > 8'd63) ? 1'b1 : 1'b0;
	assign	sk_seed = sk[511:384];
	assign	sk_prf  = sk[383:256];
	assign	pk		= sk[255:0];
	
	assign	mlen_wr_gen = (mlen < 32'd48) ? (mlen + 32'd16) : (mlen - 32'd48);
	assign	mlen_wr_hash = (mlen < 32'd16) ? (mlen + 32'd48) : (mlen - 32'd16);
	//assign	mlen_wr = flag_mode ? mlen_wr_hash : mlen_wr_gen;
	
	//set_type
	assign  wots_addr_wr[175:168] = SPX_ADDR_TYPE_WOTS;
    assign  wots_addr_wr[255:176] = 0;
	assign  wots_addr_wr[167:0]   = 0;
	
	//set_type
	assign  tree_addr_wr[175:168] = SPX_ADDR_TYPE_HASHTREE;
    assign  tree_addr_wr[255:176] = 0;
	assign  tree_addr_wr[167:0]   = 0;
	
	/////
	//FLAG//
	reg					flag_message,
						flag_mode, // 0: gen || 1: hash
						///FLAG_STATE: control thu tu thuc hien (state machine)
						flag_state_cal_loop_gen,
						flag_state_cal_loop_hash,
						flag_state_initial_hash,
						flag_state_randombytes,
						flag_state_gen_message,
						flag_state_hash_message,
						flag_state_fors_sign,
						flag_state_wots_sign,
						flag_state_treehash,
						flag_state_done;
						
	/////
	////////////////////////////////////////////////
	//DATAPATH//////////////////////////////////////
	///////////////////////////////////////////////
	cal_loop cal_loop_crypto_sign_signature_gen(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_cal_loop_reg),
        .mlen(mlen_wr_gen),
        .loop_out(loop_wr_gen),  // luu trong loop_reg
        .valid_out(valid_out_cal_loop_gen)    
    );
	cal_loop cal_loop_crypto_sign_signature_hash(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_cal_loop_reg),
        .mlen(mlen_wr_hash),
        .loop_out(loop_wr_hash),  // luu trong loop_reg
        .valid_out(valid_out_cal_loop_hash)    
    );
    RTL_seed_state initialize_hash_function_crypto_sign_signature(
        .CLK(CLK),
        .RST(RST),
		.start_in(start_in_seed_state_reg),
        .pub_seed(pk[255:128]),
        .state_out(state_out_initial), //luu trong state_reg
        .valid_out(valid_out_initial)
    );
    
    ramdombytes ramdombytes_crypto_sign_signature(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_randombytes_reg),
        .loop_in(32'd1), // 1 loop
        .key_in(key_in),
        .V_in(V_in),
        .key_out(key_wr),
        .V_out(V_wr),
        .x_out(optrand_wr), //output Luu trong optrand_reg
        .valid_exe(valid_out_loop_randombytes),
        .valid_out(valid_out_randombytes)
    ); // 16 bytes/loop -> 1 loop
    
    gen_message_random gen_message_random_crypto_sign_signature(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_gen_message_reg),
		.loop_in(loop_reg_gen),
		.sk_prf(sk_prf),
		.optrand(optrand_reg),
		.m(m), //511 bit/loop
		.mlen(mlen),
		.R(R_wr),	// luu trong R_reg
		.valid_done_message(valid_done_message_gen),
		.valid_out(valid_done_gen)
    );
    
    hash_message hash_message_crypto_sign_signature(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_hash_message_reg),
		.pk(pk),
		.R(R_reg),
		.loop_in(loop_reg_hash),
		.m(m), //511 bit/loop
		.mlen(mlen),
		.digest(mhash_wr), // luu trong mhash_reg
		.tree(tree_wr),			//co the truyen tiep khi valid_out
		.leaf_idx(leaf_idx_wr),	//co the truyen tiep khi valid_out
		.valid_done_message(valid_done_message_hash),
		.valid_out(valid_done_hash)
    );
    
    fors_sign fors_sign_crypto_sign_signature(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_fors_sign_reg),
		.m(mhash_reg),
		.sk_seed(sk_seed),
		.state_seed(state_reg),
    //input   wire    [383:0] pub_seed(pub_seed),
		.fors_addr(wots_addr_reg),
		.sig(sign_fors_wr), // doc vao buffer / output
		.pk(root_wr_fors_sign), // luu trong root_reg
		.valid_out_sig(valid_out_loop_fors_sign),
		.valid_out(valid_out_fors_sign)
    );
    
    wots_sign wots_sign_crypto_sign_signature(
        .CLK(CLK),
		.RST(RST),
		.start_in(start_in_wots_sign_reg),
        .msg(root_reg),
        .sk_seed(sk_seed),
        .state_seed(state_reg),
        //input   wire    [383:0]     pub_seed, //don't care
        .addr(wots_addr_reg),
        .sig(wots_sign_wr),
        .valid_out_en(valid_out_loop_wots_sign), // 1 loop
        .valid_out(valid_out_wots_sign)    //35 loop
    );
    
    treehash treehash_crypto_sign_signature(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_treehash_reg),
        .mode(1'b0),
        .sk_seed(sk_seed),
        .state_seed(state_reg),
        //input  wire    [383:0] pub_seed, // khong su dung
        .tree_addr(tree_addr_reg),
        .leaf_idx(leaf_idx_reg),
        .idx_offset(32'b0),
        .tree_height(32'd3),
        .auth_path_out(auth_path_wr), //tree_height = 3 -> auth_path_out = 48 bytes = 384
        .root(root_wr_treehash), 
        .valid_out(valid_out_treehash)
    );
    ////////////////////////////////////////////////
	//CONTROLER/////////////////////////////////////
	///////////////////////////////////////////////
	///STATE////
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            key_out							<= 	256'b0;             //randombyte 
			V_out							<=	128'b0;               //randombyte
			sig								<=	512'b0;
			siglen							<=	64'b0;
			valid_done_message				<=	1'b0;
			valid_out_loop					<=	1'b0;
			valid_out						<=	1'b0;
			count_reg						<=	5'b0;
			count_add						<=	1'b0;
			start_in_seed_state_reg			<=	1'b0;
			start_in_randombytes_reg		<=	1'b0;
			start_in_cal_loop_reg			<=	1'b0;
			start_in_gen_message_reg		<=	1'b0;
			start_in_hash_message_reg		<=	1'b0;
			start_in_fors_sign_reg			<=	1'b0;
			start_in_wots_sign_reg			<=	1'b0;
			start_in_treehash_reg			<=	1'b0;
			state_reg						<=	320'b0;
			key_reg							<=	256'b0; // luu truc tiep len output ko can phai dem lai
			V_reg							<=	128'b0;   //	luu truc tiep len output 	
			optrand_reg						<=	128'b0;
			loop_reg_gen					<=	32'b0;
			loop_reg_hash					<=	32'b0;
			R_reg							<=	128'b0;
			mhash_reg						<=	200'b0;
			tree_reg						<=	64'b0;
			leaf_idx_reg					<=	32'b0;
			root_reg						<=	128'b0;
			tree_addr_reg					<=	256'b0;
			wots_addr_reg					<=	256'b0;
			flag_message					<=	1'b0;		// sau start_in lan dau tien (initialize_hash_function,ramdombytes) thi flag_message bat len de xu li cho hash_message va gen_message
			flag_mode						<=	1'b0;
			flag_state_cal_loop_gen			<=	1'b0;
			flag_state_cal_loop_hash		<=	1'b0;
			flag_state_initial_hash			<=	1'b0;
			flag_state_randombytes			<=	1'b0;
			flag_state_gen_message			<=	1'b0;
			flag_state_hash_message			<=	1'b0;
			flag_state_fors_sign			<=	1'b0;
			flag_state_wots_sign			<=	1'b0;
			flag_state_treehash				<=	1'b0;
			flag_state_done					<=	1'b0;
			buff_out_reg					<=	1280'b0;
			len_buff_reg					<=	8'b0;
		end
		else if (start_in & !flag_message) begin // khoi chay song song || dong thoi tinh truoc loop_reg cho gen_message
			key_out							<= 	256'b0;             //randombyte 
			V_out							<=	128'b0;               //randombyte
			sig								<=	512'b0;
			siglen							<=	64'b0;
			valid_done_message				<=	1'b0;
			valid_out_loop					<=	1'b0;
			valid_out						<=	1'b0;
			count_reg						<=	5'b0;
			count_add						<=	1'b1;
			start_in_seed_state_reg			<=	1'b1;
			start_in_randombytes_reg		<=	1'b1;
			start_in_cal_loop_reg			<=	1'b1;
			// song song 3 module
			start_in_gen_message_reg		<=	1'b0;
			start_in_hash_message_reg		<=	1'b0;
			start_in_fors_sign_reg			<=	1'b0;
			start_in_wots_sign_reg			<=	1'b0;
			start_in_treehash_reg			<=	1'b0;
			state_reg						<=	320'b0;
			key_reg							<=	256'b0; // luu truc tiep len output ko can phai dem lai
			V_reg							<=	128'b0;   //	luu truc tiep len output 	
			optrand_reg						<=	128'b0;
			loop_reg_gen					<=	32'b0;
			loop_reg_hash					<=	32'b0;
			R_reg							<=	128'b0;
			mhash_reg						<=	200'b0;
			tree_reg						<=	64'b0;
			leaf_idx_reg					<=	32'b0;
			root_reg						<=	128'b0;
			tree_addr_reg					<=	256'b0;
			wots_addr_reg					<=	256'b0;
			flag_message					<=	1'b1;
			flag_mode						<=	1'b0;
			flag_state_cal_loop_gen			<=	1'b0;
			flag_state_cal_loop_hash		<=	1'b0;
			flag_state_initial_hash			<=	1'b0;
			flag_state_randombytes			<=	1'b0;
			flag_state_gen_message			<=	1'b0;
			flag_state_hash_message			<=	1'b0;
			flag_state_fors_sign			<=	1'b0;
			flag_state_wots_sign			<=	1'b0;
			flag_state_treehash				<=	1'b0;
			flag_state_done					<=	1'b0;
			buff_out_reg					<=	1280'b0;
			len_buff_reg					<=	8'b0;
		end	
		else if (start_in & flag_message) begin // khoi chay loop gen_message va hash_message
			if(!flag_mode) begin // gen_message
				start_in_gen_message_reg		<=	1'b1;
			end
			else begin
				start_in_hash_message_reg		<=	1'b1;
			end
		end
		else if (flag_state_cal_loop_gen & flag_state_randombytes & flag_state_initial_hash) begin // sau khi chyaj xong 3 Module dau se bat dau chay gen_message
				start_in_gen_message_reg		<=	1'b1; // ngam hieu start_in dau tien da kich hoat gen_message
				// reset flag
				flag_state_cal_loop_gen			<=	1'b0; 
				flag_state_initial_hash			<=	1'b0;
				flag_state_randombytes			<=	1'b0;
				// suy nghi them cach tuong tu voi hash_message (dung bo dem luu lai) (kho khan trong top module)
		end
		/*
			Doi voi module top : se doc tinh hieu valid_out de dieu khien thanh ghi start_in truyen vao start_in
		*/
		else if (valid_done_message_gen | valid_done_message_hash) begin // signal truyen message moi de tinh
			valid_done_message				<= 	1'b1; // dem cal_loop o giua 2 gen hash ton time -> tao bo tinh
		end
		else if (flag_state_gen_message & flag_state_hash_message) begin // done gen hash -> xu li addr va start_in fors_sign
			flag_state_gen_message	<=	1'b0;
			flag_state_hash_message	<=	1'b0;
			
			tree_addr_reg					<=	tree_addr_wr;
			//wots_addr_reg					<=	256'b0;
			wots_addr_reg[255:248] 	<= tree_reg[47:40];
			wots_addr_reg[247:240] 	<= tree_reg[55:48];
			wots_addr_reg[239:232] 	<= tree_reg[63:56];
			wots_addr_reg[231:224] 	<= wots_addr_wr[231:224];
									
			wots_addr_reg[223:216] 	<= tree_reg[15:8];
			wots_addr_reg[215:208] 	<= tree_reg[23:16];
			wots_addr_reg[207:200] 	<= tree_reg[31:24];
			wots_addr_reg[199:192] 	<= tree_reg[39:32];
									
			wots_addr_reg[191:184] 	<= wots_addr_wr[191:184];
			wots_addr_reg[183:176] 	<= wots_addr_wr[183:176];
			wots_addr_reg[175:168] 	<= wots_addr_wr[175:168];
			wots_addr_reg[167:160] 	<= tree_reg[7:0];
			//set_tree_addr        	
			wots_addr_reg[159:152] 	<= wots_addr_wr[159:152];
			wots_addr_reg[151:144] 	<= wots_addr_wr[151:144];
			wots_addr_reg[143:136] 	<= leaf_idx_reg[7:0];
			wots_addr_reg[135:128] 	<= wots_addr_wr[135:128];
			//set_keypair_addr     	
			wots_addr_reg[127:0]   	<= wots_addr_wr[127:0];
			
			start_in_fors_sign_reg 	<= 1'b1; // fors_sign
			
		end 
		else if (valid_out_loop_fors_sign) begin
			valid_out_loop	<=	1'b1;
			if (len_buff_reg == 8'd16) begin
				//output data - signal
				sig				<=	{buff_out_reg[127:0],sign_fors_wr[895:512]}; //64 {16-48} con lai 48 (+16 tu hash:loop1) 
				//valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd64 ; // x + 112 - 64 = x + 48 
				buff_out_reg[511:0]	<=	sign_fors_wr[511:0];	
			end
			else if (len_buff_reg == 8'd0) begin
				//output data - signal
				sig				<=	{sign_fors_wr[895:384]}; //64 {64} con lai 48
				//valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd48 ; // x + 112 - 64 = x + 48 
				buff_out_reg[383:0]	<=	sign_fors_wr[383:0];	
			end
			else if (len_buff_reg == 8'd48) begin
				//output data - signal
				sig				<=	{buff_out_reg[383:0],sign_fors_wr[895:768]}; //64 {48 - 16} con lai 96 {64 - 32}
				//valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd96 ; // x + 112 - 64 = x + 48 = 96 
				buff_out_reg[767:0]	<=	sign_fors_wr[767:0]; 	//96
			end
			else if (len_buff_reg == 8'd32) begin
				//output data - signal
				sig				<=	{buff_out_reg[255:0],sign_fors_wr[895:640]}; //64 {32 - 32} con lai 80 {64 - 16}
				//valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd80 ; // x + 112 - 64 = x + 48 = 80
				buff_out_reg[639:0]	<=	sign_fors_wr[639:0]; 	//96
			end
		end
		else if (check_len_buff) begin
			if (len_buff_reg == 8'd64) begin
				sig				<=	{buff_out_reg[511:0]}; //64 
				valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd0 ; //64-64
				buff_out_reg[511:0]	<=	512'b0;	
			end
			else if (len_buff_reg == 8'd96) begin
				sig				<=	{buff_out_reg[767:256]}; // 96-64 = 32 
				valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd32 ; //64-64
				buff_out_reg[767:256]	<=	512'b0;	
			end
			else if (len_buff_reg == 8'd80) begin
				sig				<=	{buff_out_reg[639:128]}; // 80-64 = 16 
				valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd16 ; //80-64
				buff_out_reg[639:128]	<=	512'b0;	
			end
		end
		else if (valid_out_loop_wots_sign) begin
				if (len_buff_reg == 8'd0) begin
					//cap nhat len - buff
					len_buff_reg	<=	8'd16 ; // x + 112 - 64 = x + 48 
					buff_out_reg[127:0]	<=	wots_sign_wr;	
				end
				else if (len_buff_reg == 8'd16) begin
					//cap nhat len - buff
					len_buff_reg	<=	8'd32 ; // x + 112 - 64 = x + 48 
					buff_out_reg[255:0]	<=	{buff_out_reg[127:0],wots_sign_wr};	
				end
				else if (len_buff_reg == 8'd32) begin
					//cap nhat len - buff
					len_buff_reg	<=	8'd48 ; // x + 112 - 64 = x + 48 
					buff_out_reg[383:0]	<=	{buff_out_reg[255:0],wots_sign_wr};	
				end
				else if (len_buff_reg == 8'd48) begin
					//output data - signal
					sig				<=	{buff_out_reg[383:0],wots_sign_wr}; //64 {16-48} con lai 48 (+16 tu hash:loop1) 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd0 ; // x + 112 - 64 = x + 48 
					buff_out_reg[383:0]	<=	384'b0;	
				end
			end
		else if (flag_state_fors_sign | flag_state_treehash) begin // start and loop
			flag_state_fors_sign	<=	1'b0;
			flag_state_treehash		<= 	1'b0;
			//bat dau loop: addr -> wots_sign -> tree_hash idx_leaf tree
			/////////////////xu li addr/////
			//tree_addr_reg
			tree_addr_reg[255:248] 	<= tree_reg[47:40];
			tree_addr_reg[247:240] 	<= tree_reg[55:48];
			tree_addr_reg[239:232] 	<= tree_reg[63:56];
			tree_addr_reg[231:224] 	<= {3'b0,count_reg[4:0]}; //set_layer_addr
									
			tree_addr_reg[223:216] 	<= tree_reg[15:8];
			tree_addr_reg[215:208] 	<= tree_reg[23:16];
			tree_addr_reg[207:200] 	<= tree_reg[31:24];
			tree_addr_reg[199:192] 	<= tree_reg[39:32];
									
			tree_addr_reg[191:184] 	<= tree_addr_reg[191:184];
			tree_addr_reg[183:176] 	<= tree_addr_reg[183:176];
			tree_addr_reg[175:168] 	<= tree_addr_reg[175:168];
			tree_addr_reg[167:160] 	<= tree_reg[7:0];
			//set_tree_addr(tree_addr, tree);
			
			tree_addr_reg[127:0]   	<= tree_addr_reg[127:0];
			
			wots_addr_reg[255:248] 	<= tree_reg[47:40];
			wots_addr_reg[247:240] 	<= tree_reg[55:48];
			wots_addr_reg[239:232] 	<= tree_reg[63:56];
			wots_addr_reg[231:224] 	<= {3'b0,count_reg[4:0]}; 
									
			wots_addr_reg[223:216] 	<= tree_reg[15:8];
			wots_addr_reg[215:208] 	<= tree_reg[23:16];
			wots_addr_reg[207:200] 	<= tree_reg[31:24];
			wots_addr_reg[199:192] 	<= tree_reg[39:32];
									
			wots_addr_reg[191:184] 	<= wots_addr_reg[191:184];
			wots_addr_reg[183:176] 	<= wots_addr_reg[183:176];
			wots_addr_reg[175:168] 	<= wots_addr_reg[175:168];
			wots_addr_reg[167:160] 	<= tree_reg[7:0];
			//copy_subtree_addr(wots_addr, tree_addr); [255:192] ...[167:160]
			
			wots_addr_reg[159:152] 	<= wots_addr_reg[159:152];
			wots_addr_reg[151:144] 	<= wots_addr_reg[151:144];
			wots_addr_reg[143:136] 	<= leaf_idx_reg[7:0];
			wots_addr_reg[135:128] 	<= wots_addr_reg[135:128];
			//set_keypair_addr     	
			wots_addr_reg[127:0]   	<= wots_addr_reg[127:0];
			
			///
			start_in_wots_sign_reg	<= 1'b1;
			
			
		end
		else if (valid_out_treehash)	begin
			if (count_reg == 5'd21) begin // 0->21 : <22
				flag_state_done		<=	1'b1; // done loop
				count_reg	        <=  5'b0; 
			end
			else begin
				flag_state_treehash	<=	1'b1; // 22 loop
				count_reg	        <= count_reg + count_add;
			end
			
			// {64;64;64;64;64;64;64;64;48 - 16; 32(dem lai)} : i=0;
			// {32(hold) - 32; 64;64;64;64;64;64;64;64 ; 16 - 48} : i=1;
			if (len_buff_reg == 8'd48) begin
				//output data - signal
				sig				<=	{buff_out_reg[383:0],auth_path_wr[767:640]}; //64 {48-16} con lai 32 
				valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd32 ; // x + 112 - 64 = x + 48 
				buff_out_reg[383:256]	<=	128'b0;
				buff_out_reg[255:0]		<=	auth_path_wr[639:384];	
			end
			else if (len_buff_reg == 8'd16) begin
				//output data - signal
				sig				<=	{buff_out_reg[127:0],auth_path_wr[767:384]}; //64 {16-48} con lai 0 (+16 tu hash:loop1) 
				valid_out_loop	<=	1'b1;
				//cap nhat len - buff
				len_buff_reg	<=	8'd0 ; // x + 112 - 64 = x + 48 
				buff_out_reg[127:0]	<=	128'b0;	
			end
			leaf_idx_reg <= {28'b0,tree_reg[2:0]};
			tree_reg	 <=	{3'b0,tree_reg[63:3]}; //[63:0]
			root_reg     <= root_wr_treehash;
		end	
		else if (flag_state_done) begin
			key_out							<= 	key_reg;             //randombyte 
			V_out							<=	V_reg;               //randombyte
			sig								<=	512'b0;
			siglen							<=	64'd17088;
			valid_done_message				<=	1'b0;
			valid_out_loop					<=	1'b0;
			valid_out						<=	1'b1;
			///////////////////////////////////////////
			//REG///
			///////////////////////////////////////////
			count_reg						<=	5'b0;
			count_add						<=	1'b0;
			start_in_seed_state_reg			<=	1'b0;
			start_in_randombytes_reg		<=	1'b0;
			start_in_cal_loop_reg			<=	1'b0;
			start_in_gen_message_reg		<=	1'b0;
			start_in_hash_message_reg		<=	1'b0;
			start_in_fors_sign_reg			<=	1'b0;
			start_in_wots_sign_reg			<=	1'b0;
			start_in_treehash_reg			<=	1'b0;
			state_reg						<=	320'b0;
			key_reg							<=	256'b0;
			V_reg							<=	128'b0;  
			optrand_reg						<=	128'b0;
			loop_reg_gen					<=	32'b0;
			loop_reg_hash					<=	32'b0;
			R_reg							<=	128'b0;
			mhash_reg						<=	200'b0;
			tree_reg						<=	64'b0;
			leaf_idx_reg					<=	32'b0;
			root_reg						<=	128'b0;
			tree_addr_reg					<=	256'b0;
			wots_addr_reg					<=	256'b0;
			flag_message					<=	1'b0;		// sau start_in lan dau tien (initialize_hash_function,ramdombytes) thi flag_message bat len de xu li cho hash_message va gen_message
			flag_mode						<=	1'b0;
			flag_state_cal_loop_gen			<=	1'b0;
			flag_state_cal_loop_hash		<=	1'b0;
			flag_state_initial_hash			<=	1'b0;
			flag_state_randombytes			<=	1'b0;
			flag_state_gen_message			<=	1'b0;
			flag_state_hash_message			<=	1'b0;
			flag_state_fors_sign			<=	1'b0;
			flag_state_wots_sign			<=	1'b0;
			flag_state_treehash				<=	1'b0;
			flag_state_done					<=	1'b0;
			buff_out_reg					<=	1280'b0;
			len_buff_reg					<=	8'b0;
		end
		else begin
			start_in_seed_state_reg			<=	1'b0;
			start_in_randombytes_reg		<=	1'b0;
			start_in_cal_loop_reg			<=	1'b0;
			start_in_gen_message_reg		<=	1'b0;
			start_in_hash_message_reg		<=	1'b0;
			start_in_fors_sign_reg			<=	1'b0;
			start_in_wots_sign_reg			<=	1'b0;
			start_in_treehash_reg			<=	1'b0;
			valid_done_message				<= 	1'b0;
			sig								<=	512'b0;
			valid_out_loop					<=	1'b0;
			key_out							<= 	256'b0;             //randombyte 
			V_out							<=	128'b0;               //randombyte
			siglen							<=	64'b0;
			valid_out						<=	1'b0;
		end
    end
    
	
	/////////WRITE DATA//////
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
		end
		else begin
			if (valid_out_cal_loop_gen) begin //gen_message
				if(mlen<32'd48) begin
				    loop_reg_gen <= loop_wr_gen;
				end
				else begin
				    loop_reg_gen <= loop_wr_gen + 32'd1;
				end
				
				flag_state_cal_loop_gen <= 1'b1;
				//flag_mode	<=	1'b0; 
			end
			//if (valid_out_cal_loop_hash & flag_mode) begin
			if (valid_out_cal_loop_hash) begin
				loop_reg_hash <= loop_wr_hash;
				flag_state_cal_loop_hash <= 1'b1; // nho reset sau khi dung xong de dung lan ke tiep
				//flag_mode	<=	1'b1; // giu nguyen den khi ket thuc
			end
			if (valid_out_loop_randombytes) begin
				optrand_reg	<= optrand_wr;
			end
			if	(valid_out_randombytes) begin
				key_reg	<= key_wr;
				V_reg	<= V_wr;
				flag_state_randombytes	<=	1'b1;
			end
			if (valid_out_initial) begin 
				state_reg	<=	state_out_initial;
				flag_state_initial_hash <= 1'b1;
			end
			/////
			if (valid_done_gen) begin
				buff_out_reg[127:0]	<=	R_wr; //luu 16 bytes cho du buffer
				len_buff_reg	<=	8'd16;
				R_reg	<=	R_wr;
				flag_state_gen_message	<=	1'b1;
				flag_mode	<=	1'b1;	// chuyen sang hash_message
				
			end
			if (valid_done_hash) begin
				mhash_reg	<=	mhash_wr;
				//tree_reg	<=	{tree_wr[63:32],32'b0};//test***********************************************
				tree_reg	<=	tree_wr;//test
				leaf_idx_reg<=	leaf_idx_wr;
				flag_state_hash_message	<=	1'b1;
			end
			/*
			if (valid_out_loop_fors_sign) begin // done 1 loop fors_sign
			//output {16}48-64}||{64-48}{16-64-32}{32-64-16}{48-64}||{}{}{}{}||{}{}{}{}||.....||{}{}{}{} : 8       : dung bien mlen + flag de xu li output	
				valid_out_loop	<=	1'b1;
				if (len_buff_reg == 8'd16) begin
					//output data - signal
					sig				<=	{buff_out_reg[127:0],sign_fors_wr[895:512]}; //64 {16-48} con lai 48 (+16 tu hash:loop1) 
					//valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd64 ; // x + 112 - 64 = x + 48 
					buff_out_reg[511:0]	<=	sign_fors_wr[511:0];	
				end
				else if (len_buff_reg == 8'd0) begin
					//output data - signal
					sig				<=	{sign_fors_wr[895:384]}; //64 {64} con lai 48
					//valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd48 ; // x + 112 - 64 = x + 48 
					buff_out_reg[383:0]	<=	sign_fors_wr[383:0];	
				end
				else if (len_buff_reg == 8'd48) begin
					//output data - signal
					sig				<=	{buff_out_reg[383:0],sign_fors_wr[895:768]}; //64 {48 - 16} con lai 96 {64 - 32}
					//valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd96 ; // x + 112 - 64 = x + 48 = 96 
					buff_out_reg[767:0]	<=	sign_fors_wr[767:0]; 	//96
				end
				else if (len_buff_reg == 8'd32) begin
					//output data - signal
					sig				<=	{buff_out_reg[255:0],sign_fors_wr[895:640]}; //64 {32 - 32} con lai 80 {64 - 16}
					//valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd80 ; // x + 112 - 64 = x + 48 = 80
					buff_out_reg[639:0]	<=	sign_fors_wr[639:0]; 	//96
				end
			end
			else if (!valid_out_loop_fors_sign) begin // valid= 1 valid = 0
				if (len_buff_reg == 8'd64) begin
					sig				<=	{buff_out_reg[511:0]}; //64 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd0 ; //64-64
					buff_out_reg[511:0]	<=	512'b0;	
				end
				else if (len_buff_reg == 8'd96) begin
					sig				<=	{buff_out_reg[767:256]}; // 96-64 = 32 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd32 ; //64-64
					buff_out_reg[767:256]	<=	512'b0;	
				end
				else if (len_buff_reg == 8'd80) begin
					sig				<=	{buff_out_reg[639:128]}; // 80-64 = 16 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd16 ; //80-64
					buff_out_reg[639:128]	<=	512'b0;	
				end
				
			end
			*/
			if (valid_out_fors_sign) begin
				flag_state_fors_sign	<=	1'b1;
				root_reg				<=	root_wr_fors_sign;
				//(112*33+16)/64 = 58 -> reset buff + mlen;
				buff_out_reg			<=	1120'b0; //max 768 bit
				len_buff_reg			<=	8'b0;
			end
			/*
			if (valid_out_loop_wots_sign) begin
				if (len_buff_reg == 8'd0) begin
					//cap nhat len - buff
					len_buff_reg	<=	8'd16 ; // x + 112 - 64 = x + 48 
					buff_out_reg[127:0]	<=	wots_sign_wr;	
				end
				else if (len_buff_reg == 8'd16) begin
					//cap nhat len - buff
					len_buff_reg	<=	8'd32 ; // x + 112 - 64 = x + 48 
					buff_out_reg[255:0]	<=	{buff_out_reg[127:0],wots_sign_wr};	
				end
				else if (len_buff_reg == 8'd32) begin
					//cap nhat len - buff
					len_buff_reg	<=	8'd48 ; // x + 112 - 64 = x + 48 
					buff_out_reg[383:0]	<=	{buff_out_reg[255:0],wots_sign_wr};	
				end
				else if (len_buff_reg == 8'd48) begin
					//output data - signal
					sig				<=	{buff_out_reg[383:0],wots_sign_wr}; //64 {16-48} con lai 48 (+16 tu hash:loop1) 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd0 ; // x + 112 - 64 = x + 48 
					buff_out_reg[383:0]	<=	384'b0;	
				end
			end
			*/
			if (valid_out_wots_sign) begin			// start_in treehash
				start_in_treehash_reg	<= 	1'b1;
			end
			/*
			if (valid_out_treehash)	begin
				if (count_reg == 5'd21) begin // 0->21 : <22
					flag_state_done		<=	1'b1; // done loop
					count_reg	        <=  5'b0; 
				end
				else begin
					flag_state_treehash	<=	1'b1; // 22 loop
					count_reg	        <= count_reg + count_add;
				end
				
				// {64;64;64;64;64;64;64;64;48 - 16; 32(dem lai)} : i=0;
				// {32(hold) - 32; 64;64;64;64;64;64;64;64 ; 16 - 48} : i=1;
				if (len_buff_reg == 8'd48) begin
					//output data - signal
					sig				<=	{buff_out_reg[383:0],auth_path_wr[767:640]}; //64 {48-16} con lai 32 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd32 ; // x + 112 - 64 = x + 48 
					buff_out_reg[383:256]	<=	128'b0;
					buff_out_reg[255:0]		<=	auth_path_wr[639:384];	
				end
				else if (len_buff_reg == 8'd16) begin
					//output data - signal
					sig				<=	{buff_out_reg[127:0],auth_path_wr[767:384]}; //64 {16-48} con lai 0 (+16 tu hash:loop1) 
					valid_out_loop	<=	1'b1;
					//cap nhat len - buff
					len_buff_reg	<=	8'd0 ; // x + 112 - 64 = x + 48 
					buff_out_reg[127:0]	<=	128'b0;	
				end
				leaf_idx_reg <= {28'b0,tree_reg[2:0]};
				tree_reg	 <=	{3'b0,tree_reg[63:3]}; //[63:0]
				root_reg     <= root_wr_treehash;
			end	
			*/
		end
	end
endmodule
