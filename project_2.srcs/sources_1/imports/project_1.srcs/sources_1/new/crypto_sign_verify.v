`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 04:03:12 PM
// Design Name: 
// Module Name: crypto_sign_verify
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


module crypto_sign_verify(
    input   wire            	CLK,
    input   wire            	RST,
    input   wire            	start_in,
    input   wire    [895:0]	    in, //17088 bytes 
    input   wire    [511:0] 	m, //511 bit/loop
    input   wire    [31:0]  	mlen,
    input   wire    [255:0]  	pk,
    output  reg             	valid_done_message, // tinh xong m -> truyen them message moi
	///////////////////////////////////////////////////////
	// control input 
	output	reg					valid_done_hash_message,
	output	reg					valid_done_loop_fors,
	output	reg					valid_done_fors,
	output	reg					valid_done_loop_wots,
	output	reg					valid_done_thash,
	output	reg					valid_done_compute_root,
	////////////////////////////////////////////////////////
    output  reg                 valid_verify,
    output  reg             	valid_out			// thuc thi xong
    );
    ////////////////////////////////////////////////
	//DECLARCE//////////////////////////////////////
	///////////////////////////////////////////////
    parameter SPX_ADDR_TYPE_WOTS = 8'd0;
	parameter SPX_ADDR_TYPE_HASHTREE = 8'd2;
	parameter SPX_ADDR_TYPE_WOTSPK = 8'b1;
	reg		[4:0]		count_reg;
	reg					count_add;
	reg		[5:0]		count_fors_reg,
						count_wots_reg;
	reg					start_in_seed_state_reg,
						start_in_cal_loop_reg,
						start_in_hash_message_reg,
						start_in_fors_sign_reg,
						start_in_wots_sign_reg,
						start_in_thash_reg,
						start_in_compute_tree_reg;
	reg		[319:0]		state_reg;
	reg		[31:0]		loop_reg_hash;
	reg		[199:0]		mhash_reg;
	reg		[63:0]		tree_reg;
	reg		[31:0]		leaf_idx_reg;
	reg		[255:0]		tree_addr_reg;
	reg		[255:0]		wots_addr_reg;
	///////////////////////////////////////////////////////////
	reg		[895:0] 	buff_reg; // input_sig cho hash_message, fors_pk_from_sig, wots_pk_form_sig, compute_root
	///////////////////////////////////////////////////////////
	reg     [127:0]     pk_reg;
	reg		[4479:0]	wots_pk_reg; // tinh tu wots -> thash
	reg		[255:0]		wots_pk_addr_reg;
	reg		[127:0]		leaf_reg;
	
	/*
	17088 bytes:
		16 bytes : hash_message										bat dau truyen tu dau (khong quan tam valid_out)
		112*33 = 3696 bytes: fors_pk_from_sig (112 bytes/loop)		
		////22 loop
			wots_pk_from_sig : 16*35 = 560 bytes
			treehash : 48 bytes
		///////
		idea: tb dieu khien start_in theo valid_out 
	*/
	
	
	wire				valid_out_initial,
						valid_out_cal_loop_hash,
						valid_done_message_hash,
						valid_done_hash,
						valid_done_sig_fors,
						valid_out_fors,
						valid_done_sig_wots,
						valid_out_wots,
						//valid_out_treehash,
						valid_out_thash,
						valid_out_compute_tree;
	
	
	
	wire	[319:0]		state_out_initial;
	wire	[31:0]		mlen_wr_hash;
	wire	[31:0]		loop_wr_hash;
	wire	[199:0]		mhash_wr;
	wire	[63:0]		tree_wr;
	wire	[31:0]		leaf_idx_wr;
	wire	[255:0]		tree_addr_wr;
	wire	[255:0]		wots_addr_wr; // sau khi valid_out_hash_message
	//wire	[127:0]		root_wr_treehash;
	//wire	[767:0]		auth_path_wr;
	////////////////////////////////////////////////////////
	//wire    [127:0]     sig_hash_message_wr;
	//reg     [895:0]     sig_fors_wr;
	//reg	    [4863:0]	sig_loop_wr; // 560 + 48 = 608/loop
	//reg	    [127:0]		sig_wots_wr; // 128 bit x 35 / loop -> 560 (35loop)
	//wire        [895:0]     sig_fors_wr;
	//wire	    [4863:0]	sig_loop_wr; // 560 + 48 = 608/loop
	//wire	    [127:0]		sig_wots_wr; // 128 bit x 35 / loop -> 560 (35loop)
	//wire	[767:0]		sig_compute_root_wr; // 48 bytes -> 384 bit
	
	wire    [127:0]     pk_fors_wr,
						pk_wots_wr;
	wire	[255:0]		wots_pk_addr_wr;
	wire	[127:0]		leaf_wr;
	
	wire	[127:0]		root_compute_root_wr; // luu trong pk_reg;
	wire                verify_wr;
	
	assign  verify_wr = pk_reg == pk[127:0];
	
	//assign	sig_hash_message_wr = sig[136703:136576]; // 128 bit
	//assign	sig_compute_root_wr = {384'b0,sig_loop_wr[383:0]};
	
	assign	mlen_wr_hash = (mlen < 32'd16) ? (mlen + 32'd48) : (mlen - 32'd16);
	
	//set_type
	assign  wots_addr_wr[175:168] = SPX_ADDR_TYPE_WOTS;
    assign  wots_addr_wr[255:176] = 0;
	assign  wots_addr_wr[167:0]   = 0;
	
	//set_type
	assign  tree_addr_wr[175:168] = SPX_ADDR_TYPE_HASHTREE;
    assign  tree_addr_wr[255:176] = 0;
	assign  tree_addr_wr[167:0]   = 0;
	
	//set_type
	assign  wots_pk_addr_wr[175:168] = SPX_ADDR_TYPE_WOTSPK;
    assign  wots_pk_addr_wr[255:176] = 0;
	assign  wots_pk_addr_wr[167:0]   = 0;
	/////
	//FLAG//
	reg					flag_message,
						flag_state_cal_loop_hash,
						flag_state_initial_hash,
						flag_state_hash_message,
						flag_state_fors_sign,
						flag_state_wots_sign,
						//flag_state_thash,
						flag_state_compute_tree,
						flag_state_done;
			
    
    ////////////////////////////////////////////////
	//DATAPATH//////////////////////////////////////
	///////////////////////////////////////////////
	cal_loop cal_loop_crypto_verify_signature_hash(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_cal_loop_reg),
        .mlen(mlen_wr_hash),
        .loop_out(loop_wr_hash),  // luu trong loop_reg
        .valid_out(valid_out_cal_loop_hash)    
    );
    RTL_seed_state initialize_hash_function_crypto_sign_verify(
        .CLK(CLK),
        .RST(RST),
		.start_in(start_in_seed_state_reg),
        .pub_seed(pk[255:128]),
        .state_out(state_out_initial), //luu trong state_reg
        .valid_out(valid_out_initial)
    );
    ////////////////////////////////////////////////////////////////
    hash_message hash_message_crypto_sign_verify(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_hash_message_reg),
		.pk(pk),
		//.R(sig_hash_message_wr),   // sig : 16 bytes cao nhat
		.R(buff_reg[127:0]), //16bytes
		.loop_in(loop_reg_hash),
		.m(m), //511 bit/loop
		.mlen(mlen),
		.digest(mhash_wr), // luu trong mhash_reg
		.tree(tree_wr),			//co the truyen tiep khi valid_out
		.leaf_idx(leaf_idx_wr),	//co the truyen tiep khi valid_out
		.valid_done_message(valid_done_message_hash),
		.valid_out(valid_done_hash)
    );
    ////////////////////////////////////////////////////////////////
    fors_pk_from_sig fors_pk_from_sig_crypto_sign_verify(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_in_fors_sign_reg),
		.m(mhash_reg),
		//.sk_seed(sk_seed),
		.state_seed(state_reg),
    //input   wire    [383:0] pub_seed,
		.fors_addr(wots_addr_reg),
		//.sig(sig_fors_wr),
		.sig(buff_reg), // 112 bytes
		.pk(pk_fors_wr), // luu vao pk_reg;
		.valid_done_sig(valid_done_sig_fors),
		.valid_out(valid_out_fors)
    );
    ////////////////////////////////////////////////////////////////
    wots_pk_from_sig wots_pk_from_sig_crypto_verify_signature(
        .CLK(CLK),
		.RST(RST),
		.start_in(start_in_wots_sign_reg),
        .msg(pk_reg), // tinh tu fors // compute tree
        //.sig(sig_wots_wr),
		.sig(buff_reg[127:0]),
        .state_seed(state_reg),
        //input   wire    [383:0]     pub_seed,
        .addr(wots_addr_reg),
        .pk(pk_wots_wr), 
        .valid_out_en(valid_done_sig_wots),
		.valid_out(valid_out_wots)
    );
    ////////////////////////////////////////////////////////////////
    
	
	
	thash thash_crypto_sign_signature(
        .CLK(CLK),
		.RST(RST),
		.start_in(start_in_thash_reg),
        .in(wots_pk_reg),
        .mode(2'b11),
        .state_seed(state_reg), // pub_seed nay la state_seed
        //input  wire    [383:0] pub_seed, // khong su dung
        .addr(wots_pk_addr_reg),
        .out(leaf_wr),
        .valid_out(valid_out_thash) 
	);
	
	
	
	
    ////////////////////////////////////////////////////////////////         
    compute_root compute_root_crypto_sign_signature(
        .CLK(CLK),
		.RST(RST),
		.start_in(start_in_compute_tree_reg),
        .leaf(leaf_reg),
        //.auth_path(sig_compute_root_wr), //48 [48bytes0 - sig]
		.auth_path({384'b0,buff_reg[383:0]}),
        .leaf_idx(leaf_idx_reg),
        .idx_offset(32'b0),
        .tree_height(32'd3),
        .state_seed(state_reg),
        .addr(tree_addr_reg),
        .root(root_compute_root_wr), // pk_reg
        .valid_out(valid_out_compute_tree)
	);
	////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////
	//CONTROLER/////////////////////////////////////
	///////////////////////////////////////////////
	///STATE////
	always @(posedge CLK or negedge RST) begin
        if (!RST) begin
			valid_done_message				<=	1'b0;
			valid_out						<=	1'b0;
			valid_verify                    <=  1'b0;
			count_reg						<=	5'b0;
			count_fors_reg					<=	6'b0;
			count_wots_reg					<=	6'b0;
			count_add						<=	1'b0;
			start_in_seed_state_reg			<=	1'b0;
			start_in_cal_loop_reg           <=	1'b0;
			start_in_hash_message_reg       <=	1'b0;
			start_in_fors_sign_reg          <=	1'b0;
			start_in_wots_sign_reg          <=	1'b0;
			start_in_thash_reg              <=	1'b0;
			start_in_compute_tree_reg       <=	1'b0;
			state_reg						<=	320'b0;
			loop_reg_hash					<=	32'b0;
			mhash_reg						<=	200'b0;
			tree_reg						<=	64'b0;
			leaf_idx_reg					<=	32'b0;
			tree_addr_reg					<=	256'b0;
			wots_addr_reg					<=	256'b0;
			flag_message					<=	1'b0;		// sau start_in lan dau tien (initialize_hash_function,ramdombytes) thi flag_message bat len de xu li cho hash_message va gen_message
			flag_state_cal_loop_hash		<=	1'b0;
			flag_state_initial_hash			<=	1'b0;
			flag_state_hash_message			<=	1'b0;
			flag_state_fors_sign			<=	1'b0;
			flag_state_wots_sign			<=	1'b0;
			//flag_state_thash				<=	1'b0;
			flag_state_compute_tree	        <=	1'b0;
			flag_state_done					<=	1'b0;
			pk_reg							<=	128'b0;
			wots_pk_reg						<=	4480'b0; // tinh tu wots -> thash
			wots_pk_addr_reg				<=	256'b0;
			leaf_reg						<=	128'b0;
			////////////////////
			valid_done_hash_message			<=	1'b0;
			valid_done_loop_fors			<=	1'b0;
			valid_done_fors					<=	1'b0;
			valid_done_loop_wots			<=	1'b0;
			valid_done_thash				<=	1'b0;
			valid_done_compute_root			<=	1'b0;
			buff_reg						<= 	896'b0;
		end	
		else if (start_in & !flag_message ) begin // khoi chay song song || dong thoi tinh truoc loop_reg cho gen_message
			valid_done_message				<=	1'b0;
			valid_out						<=	1'b0;
			valid_verify                    <=  1'b0;
			count_reg						<=	5'b0;
			count_fors_reg					<=	6'b0;
			count_wots_reg					<=	6'b0;
			count_add						<=	1'b1;
			start_in_seed_state_reg			<=	1'b1;
			start_in_cal_loop_reg           <=	1'b1;
			//
			start_in_hash_message_reg       <=	1'b0;
			start_in_fors_sign_reg          <=	1'b0;
			start_in_wots_sign_reg          <=	1'b0;
			start_in_thash_reg              <=	1'b0;
			start_in_compute_tree_reg       <=	1'b0;
			state_reg						<=	320'b0;
			loop_reg_hash					<=	32'b0;
			mhash_reg						<=	200'b0;
			tree_reg						<=	64'b0;
			leaf_idx_reg					<=	32'b0;
			tree_addr_reg					<=	256'b0;
			wots_addr_reg					<=	256'b0;
			flag_message					<=	1'b1;		// sau start_in lan dau tien (initialize_hash_function,ramdombytes) thi flag_message bat len de xu li cho hash_message va gen_message
			flag_state_cal_loop_hash		<=	1'b0;
			flag_state_initial_hash			<=	1'b0;
			flag_state_hash_message			<=	1'b0;
			flag_state_fors_sign			<=	1'b0;
			flag_state_wots_sign			<=	1'b0;
			//flag_state_thash				<=	1'b0;
			flag_state_compute_tree	        <=	1'b0;
			flag_state_done					<=	1'b0;
			pk_reg							<=	128'b0;
			wots_pk_reg						<=	4480'b0; // tinh tu wots -> thash
			wots_pk_addr_reg				<=	256'b0;
			leaf_reg						<=	128'b0;
			///////////////////////////////////////////////
			valid_done_hash_message			<=	1'b0;
			valid_done_loop_fors			<=	1'b0;
			valid_done_fors					<=	1'b0;
			valid_done_loop_wots			<=	1'b0;
			valid_done_thash				<=	1'b0;
			valid_done_compute_root			<=	1'b0;
			buff_reg						<= 	896'b0;
			
		end	
		else if (start_in & flag_message & !valid_done_hash_message & !valid_done_loop_fors & !valid_done_fors &!valid_done_loop_wots & !valid_done_thash & !valid_done_compute_root) begin // khoi chay loop gen_message va hash_message
				start_in_hash_message_reg		<=	1'b1;
		end
		else if (valid_out_cal_loop_hash | valid_out_initial  | valid_done_hash ) begin 
		      if (valid_out_initial) begin 
				state_reg	<=	state_out_initial;
				flag_state_initial_hash <= 1'b1;
		      end
		      if (valid_out_cal_loop_hash) begin
				loop_reg_hash <= loop_wr_hash;
				flag_state_cal_loop_hash <= 1'b1; // nho reset sau khi dung xong de dung lan ke tiep
				//flag_mode	<=	1'b1; // giu nguyen den khi ket thuc
			 end
			 if (valid_done_hash) begin
				mhash_reg	<=	mhash_wr;
				//tree_reg	<=	{tree_wr[63:32],32'b0};*************************
				tree_reg	<=	tree_wr;
				leaf_idx_reg<=	leaf_idx_wr;
				flag_state_hash_message	<=	1'b1;
			end
		end
		
		else if (flag_state_cal_loop_hash & flag_state_initial_hash) begin // sau khi chyaj xong 3 Module dau se bat dau chay gen_message
				start_in_hash_message_reg		<=	1'b1; // ngam hieu start_in dau tien da kich hoat gen_message
				// reset flag
				buff_reg[127:0]					<=  in[127:0]; // 16bytes dau tien
				flag_state_cal_loop_hash		<=	1'b0; 
				flag_state_initial_hash			<=	1'b0;
				// suy nghi them cach tuong tu voi hash_message (dung bo dem luu lai) (kho khan trong top module)
		end
		/*
			Doi voi module top : se doc tinh hieu valid_out de dieu khien thanh ghi start_in truyen vao start_in
		*/
		else if (valid_done_message_hash) begin // signal truyen message moi de tinh
			valid_done_message				<= 	1'b1; // dem cal_loop o giua 2 gen hash ton time -> tao bo tinh
		end
		/////////////////////////////////////////////
		//HASH_MESSAGE//////
		////////////////////////////////////////////
		else if (flag_state_hash_message) begin // done gen hash -> xu li addr va start_in fors_sign
			flag_state_hash_message	<=	1'b0;
			tree_addr_reg					<=	tree_addr_wr;
			wots_pk_addr_reg				<=	wots_pk_addr_wr;
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
			
			
			//flag_message			<= 1'b0; // done_hash_message -> off flag -> xung dot
			valid_done_hash_message <= 1'b1;
			////////////////////////////////////////////////
			//start_in_fors_sign_reg 	<= 1'b1; // fors_sign
			//////////////////////////////////////////////
		end 
		///////////////////////////////////////////////////////////////////////////////
		///HASH_MESSAGE//////
		//////////////////////////////////////////////////////////////////////////////
		else if (start_in & (valid_done_hash_message | valid_done_loop_fors)) begin // start_in_fors && control input
			valid_done_hash_message	<= 1'b0;
			valid_done_loop_fors	<= 1'b0;
			
			buff_reg				<= in;
			start_in_fors_sign_reg 	<= 1'b1;
		end
		/*
		else if (start_in & valid_done_loop_fors) begin
			valid_done_loop_fors	<= 1'b0;
			buff_reg				<= in;
			start_in_fors_sign_reg	<= 1'b1;
		end
		*/
		else if (valid_done_sig_fors) begin // loop fors
			count_fors_reg <= count_fors_reg + count_add; // doi input sig
			valid_done_loop_fors	<= 1'b1;
			//////////////////////////////////////
			//start_in_fors_sign_reg <= 1'b1;
			////////////////////////////////////
		end
		else if (valid_out_fors) begin // done fors
			pk_reg   <= pk_fors_wr;
			flag_state_fors_sign <= 1'b1; // fors_pk_from_sig done -> vao loop {wots_sign,thash,compute_root}
			count_fors_reg <= 6'b0;
		end
		
		/////////////////////////////////////////////
		//FORS_PK//////
		////////////////////////////////////////////
		else if (flag_state_fors_sign | flag_state_compute_tree) begin // start and loop
			flag_state_fors_sign	<=	1'b0;
			flag_state_compute_tree	<= 	1'b0;
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
			
			//wots_pk_addr_reg [255:192[167:160][143:136]
			wots_pk_addr_reg[255:248] 	<= tree_reg[47:40];
			wots_pk_addr_reg[247:240] 	<= tree_reg[55:48];
			wots_pk_addr_reg[239:232] 	<= tree_reg[63:56];
			wots_pk_addr_reg[231:224] 	<= {3'b0,count_reg[4:0]}; 
									
			wots_pk_addr_reg[223:216] 	<= tree_reg[15:8];
			wots_pk_addr_reg[215:208] 	<= tree_reg[23:16];
			wots_pk_addr_reg[207:200] 	<= tree_reg[31:24];
			wots_pk_addr_reg[199:192] 	<= tree_reg[39:32];
									
			wots_pk_addr_reg[191:184] 	<= wots_pk_addr_reg[191:184];
			wots_pk_addr_reg[183:176] 	<= wots_pk_addr_reg[183:176];
			wots_pk_addr_reg[175:168] 	<= wots_pk_addr_reg[175:168];
			wots_pk_addr_reg[167:160] 	<= tree_reg[7:0];
			//copy_subtree_addr(wots_addr, tree_addr); [255:192] ...[167:160]
			
			wots_pk_addr_reg[159:152] 	<= wots_pk_addr_reg[159:152];
			wots_pk_addr_reg[151:144] 	<= wots_pk_addr_reg[151:144];
			wots_pk_addr_reg[143:136] 	<= leaf_idx_reg[7:0];
			wots_pk_addr_reg[135:128] 	<= wots_pk_addr_reg[135:128];
			//set_keypair_addr     	
			wots_pk_addr_reg[127:0]   	<= wots_pk_addr_reg[127:0];
			
			///
			///////////////////////////////////////////////
			///start_in_wots_sign_reg	<= 1'b1; 
			///////////////////////////////
			if (flag_state_fors_sign) begin
			     valid_done_fors			<= 1'b1;
			end
			if (flag_state_compute_tree) begin
			     valid_done_compute_root    <= 1'b1;
			end
			// 22 loop: wots (35 loop) ->  thash -> compute_root 
			
		end
		else if (start_in &(valid_done_fors | valid_done_loop_wots |valid_done_compute_root)) begin
			valid_done_fors				<= 1'b0; // start
			valid_done_loop_wots		<= 1'b0; // loop 35 
			valid_done_compute_root     <= 1'b0; // loop 22
			buff_reg					<= in; //16 bytes
			start_in_wots_sign_reg		<= 1'b1;
		end
		else if (valid_done_sig_wots) begin // tuong tu fors o tren // count_loop - count_wots
			// write wots_pk_reg
			wots_pk_reg = {wots_pk_reg[4351:0],pk_wots_wr}; // <<128
			
			if (valid_out_wots) begin
				//chay thash voiws wots_pk_reg
				count_wots_reg <= 6'b0;
				start_in_thash_reg <= 1'b1;
				
			end
			else begin
				valid_done_loop_wots	<=	1'b1;
				// doi input sig
				count_wots_reg <= count_wots_reg + count_add;
				// start_in
				///////////////////////////////////////
				///start_in_wots_sign_reg <= 1'b1;
				/////////////////////////////////
			end
		end
		else if (valid_out_thash) begin
			valid_done_thash			<= 1'b1;
			leaf_reg 					<= leaf_wr;
			///////////////////////////////////////
			//start_in_compute_tree_reg <= 1'b1;
			////////////////////////
		end
		else if (start_in & valid_done_thash) begin
			valid_done_thash			<=	1'b0;
			buff_reg 					<= 	in; // 48 bytes
			start_in_compute_tree_reg	<=	1'b1;
		end
		else if (valid_out_compute_tree) begin
			pk_reg	<=	root_compute_root_wr;
			if (count_reg == 5'd21) begin // 0->21 : <22
				flag_state_done		<=	1'b1; // done loop
				count_reg	        <=  5'b0; 
			end
			else begin
				flag_state_compute_tree	<=	1'b1; // 22 loop
				count_reg	        <= count_reg + count_add;
			end
			leaf_idx_reg <= {28'b0,tree_reg[2:0]};
			tree_reg	 <=	{3'b0,tree_reg[63:3]}; //[63:0]
		end
		else if (flag_state_done) begin
			valid_done_message				<=	1'b0;
			valid_out						<=	1'b1; //** compare pk
			valid_verify                    <=  verify_wr; // xu li them
			///////////////////////////////////
			count_reg						<=	5'b0;
			count_fors_reg					<=	6'b0;
			count_wots_reg					<=	6'b0;
			count_add						<=	1'b0;
			start_in_seed_state_reg			<=	1'b0;
			start_in_cal_loop_reg           <=	1'b0;
			start_in_hash_message_reg       <=	1'b0;
			start_in_fors_sign_reg          <=	1'b0;
			start_in_wots_sign_reg          <=	1'b0;
			start_in_thash_reg              <=	1'b0;
			start_in_compute_tree_reg       <=	1'b0;
			state_reg						<=	320'b0;
			loop_reg_hash					<=	32'b0;
			mhash_reg						<=	200'b0;
			tree_reg						<=	64'b0;
			leaf_idx_reg					<=	32'b0;
			tree_addr_reg					<=	256'b0;
			wots_addr_reg					<=	256'b0;
			flag_message					<=	1'b0;		// sau start_in lan dau tien (initialize_hash_function,ramdombytes) thi flag_message bat len de xu li cho hash_message va gen_message
			flag_state_cal_loop_hash		<=	1'b0;
			flag_state_initial_hash			<=	1'b0;
			flag_state_hash_message			<=	1'b0;
			flag_state_fors_sign			<=	1'b0;
			flag_state_wots_sign			<=	1'b0;
			//flag_state_thash				<=	1'b0;
			flag_state_compute_tree	        <=	1'b0;
			flag_state_done					<=	1'b0;
			pk_reg							<=	128'b0;
			wots_pk_reg						<=	4480'b0; // tinh tu wots -> thash
			wots_pk_addr_reg				<=	256'b0;
			leaf_reg						<=	128'b0;
		end
		else begin
			valid_done_message				<=	1'b0;
			valid_out						<=	1'b0;
			valid_verify                    <=  1'b0;
			start_in_seed_state_reg			<=	1'b0;
			start_in_cal_loop_reg           <=	1'b0;
			start_in_hash_message_reg       <=	1'b0;
			start_in_fors_sign_reg          <=	1'b0;
			start_in_wots_sign_reg          <=	1'b0;
			start_in_thash_reg              <=	1'b0;
			start_in_compute_tree_reg       <=	1'b0;
		end
    end
    
	
	/////////WRITE DATA//////
	/*
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
		end
		else begin
			
			if (valid_out_cal_loop_hash) begin
				loop_reg_hash <= loop_wr_hash;
				flag_state_cal_loop_hash <= 1'b1; // nho reset sau khi dung xong de dung lan ke tiep
				//flag_mode	<=	1'b1; // giu nguyen den khi ket thuc
			end
			
			if (valid_out_initial) begin 
				state_reg	<=	state_out_initial;
				flag_state_initial_hash <= 1'b1;
			end
			
			/////
			if (valid_done_hash) begin
				mhash_reg	<=	mhash_wr;
				tree_reg	<=	{tree_wr[63:32],32'b0};
				//tree_reg	<=	tree_wr;
				leaf_idx_reg<=	leaf_idx_wr;
				flag_state_hash_message	<=	1'b1;
			end
		end
	end
	*/
	//////////////////
	//DECODER////////
	////////////////
	//assign	sig_hash_message_wr = sig[136703:136576]; // 128 bit
	/*
	always @* ///sig_fors_wr[895:0] //112 bytes(896bit) / loop -> 33 loop 3696 bytes
    begin
        case(count_fors_reg)
			//(136575-107008+1)/8 = 3696 bytes
			6'd00: sig_fors_wr <= sig[136575:135680];
			6'd01: sig_fors_wr <= sig[135679:134784];
			6'd02: sig_fors_wr <= sig[134783:133888];
			6'd03: sig_fors_wr <= sig[133887:132992];
			6'd04: sig_fors_wr <= sig[132991:132096];
			6'd05: sig_fors_wr <= sig[132095:131200];
			6'd06: sig_fors_wr <= sig[131199:130304];
			6'd07: sig_fors_wr <= sig[130303:129408];
			6'd08: sig_fors_wr <= sig[129407:128512];
			6'd09: sig_fors_wr <= sig[128511:127616];
			6'd10: sig_fors_wr <= sig[127615:126720];
			6'd11: sig_fors_wr <= sig[126719:125824];
			6'd12: sig_fors_wr <= sig[125823:124928];
			6'd13: sig_fors_wr <= sig[124927:124032];
			6'd14: sig_fors_wr <= sig[124031:123136];
			6'd15: sig_fors_wr <= sig[123135:122240];
			6'd16: sig_fors_wr <= sig[122239:121344];
			6'd17: sig_fors_wr <= sig[121343:120448];
			6'd18: sig_fors_wr <= sig[120447:119552];
			6'd19: sig_fors_wr <= sig[119551:118656];
			6'd20: sig_fors_wr <= sig[118655:117760];
			6'd21: sig_fors_wr <= sig[117759:116864];
			6'd22: sig_fors_wr <= sig[116863:115968];
			6'd23: sig_fors_wr <= sig[115967:115072];
			6'd24: sig_fors_wr <= sig[115071:114176];
			6'd25: sig_fors_wr <= sig[114175:113280];
			6'd26: sig_fors_wr <= sig[113279:112384];
			6'd27: sig_fors_wr <= sig[112383:111488];
			6'd28: sig_fors_wr <= sig[111487:110592];
			6'd29: sig_fors_wr <= sig[110591:109696];
			6'd30: sig_fors_wr <= sig[109695:108800];
			6'd31: sig_fors_wr <= sig[108799:107904];
			6'd32: sig_fors_wr <= sig[107903:107008];
            default: sig_fors_wr <= 896'b0;
        endcase
    end
	
	//wire	[4863:0]	sig_loop_wr; // 560 + 48 = 608 bytes/loop -> 4864 bit
	// 608 * 22 = 13376 bytes
	
	always @* 
    begin
        case(count_reg)
			5'd00: sig_loop_wr <= sig[107007:102144];
			5'd01: sig_loop_wr <= sig[102143:97280];
			5'd02: sig_loop_wr <= sig[97279:92416];
			5'd03: sig_loop_wr <= sig[92415:87552];
			5'd04: sig_loop_wr <= sig[87551:82688];
			5'd05: sig_loop_wr <= sig[82687:77824];
			5'd06: sig_loop_wr <= sig[77823:72960];
			5'd07: sig_loop_wr <= sig[72959:68096];
			5'd08: sig_loop_wr <= sig[68095:63232];
			5'd09: sig_loop_wr <= sig[63231:58368];
			5'd10: sig_loop_wr <= sig[58367:53504];
			5'd11: sig_loop_wr <= sig[53503:48640];
			5'd12: sig_loop_wr <= sig[48639:43776];
			5'd13: sig_loop_wr <= sig[43775:38912];
			5'd14: sig_loop_wr <= sig[38911:34048];
			5'd15: sig_loop_wr <= sig[34047:29184];
			5'd16: sig_loop_wr <= sig[29183:24320];
			5'd17: sig_loop_wr <= sig[24319:19456];
			5'd18: sig_loop_wr <= sig[19455:14592];
			5'd19: sig_loop_wr <= sig[14591:9728];
			5'd20: sig_loop_wr <= sig[9727:4864];
			5'd21: sig_loop_wr <= sig[4863:0];
			//107008/8 = 13376 bytes
            default: sig_loop_wr <= 4864'b0;
        endcase
    end
    
	//assign	sig_compute_root_wr = {384'b0,sig_loop_wr[383:0]};
	//wire	[127:0]		sig_wots_wr; // 128 bit x 35 / loop -> 560 (35loop)
	
	always @* 
    begin
        case(count_wots_reg)
			6'd00: sig_wots_wr <= sig_loop_wr[4863:4736];
			6'd01: sig_wots_wr <= sig_loop_wr[4735:4608];
			6'd02: sig_wots_wr <= sig_loop_wr[4607:4480];
			6'd03: sig_wots_wr <= sig_loop_wr[4479:4352];
			6'd04: sig_wots_wr <= sig_loop_wr[4351:4224];
			6'd05: sig_wots_wr <= sig_loop_wr[4223:4096];
			6'd06: sig_wots_wr <= sig_loop_wr[4095:3968];
			6'd07: sig_wots_wr <= sig_loop_wr[3967:3840];
			6'd08: sig_wots_wr <= sig_loop_wr[3839:3712];
			6'd09: sig_wots_wr <= sig_loop_wr[3711:3584];
			6'd10: sig_wots_wr <= sig_loop_wr[3583:3456];
			6'd11: sig_wots_wr <= sig_loop_wr[3455:3328];
			6'd12: sig_wots_wr <= sig_loop_wr[3327:3200];
			6'd13: sig_wots_wr <= sig_loop_wr[3199:3072];
			6'd14: sig_wots_wr <= sig_loop_wr[3071:2944];
			6'd15: sig_wots_wr <= sig_loop_wr[2943:2816];
			6'd16: sig_wots_wr <= sig_loop_wr[2815:2688];
			6'd17: sig_wots_wr <= sig_loop_wr[2687:2560];
			6'd18: sig_wots_wr <= sig_loop_wr[2559:2432];
			6'd19: sig_wots_wr <= sig_loop_wr[2431:2304];
			6'd20: sig_wots_wr <= sig_loop_wr[2303:2176];
			6'd21: sig_wots_wr <= sig_loop_wr[2175:2048];
			6'd22: sig_wots_wr <= sig_loop_wr[2047:1920];
			6'd23: sig_wots_wr <= sig_loop_wr[1919:1792];
			6'd24: sig_wots_wr <= sig_loop_wr[1791:1664];
			6'd25: sig_wots_wr <= sig_loop_wr[1663:1536];
			6'd26: sig_wots_wr <= sig_loop_wr[1535:1408];
			6'd27: sig_wots_wr <= sig_loop_wr[1407:1280];
			6'd28: sig_wots_wr <= sig_loop_wr[1279:1152];
			6'd29: sig_wots_wr <= sig_loop_wr[1151:1024];
			6'd30: sig_wots_wr <= sig_loop_wr[1023:896];
			6'd31: sig_wots_wr <= sig_loop_wr[895:768];
			6'd32: sig_wots_wr <= sig_loop_wr[767:640];
			6'd33: sig_wots_wr <= sig_loop_wr[639:512];
			6'd34: sig_wots_wr <= sig_loop_wr[511:384];
            default: sig_wots_wr <= 128'b0;
        endcase
    end
    */
endmodule