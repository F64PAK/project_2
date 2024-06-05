`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2024 11:15:03 PM
// Design Name: 
// Module Name: treehash_fors_gen_leaf_8_core_sha256_height_6
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


module treehash_fors_gen_leaf_8_core_sha256_height_6(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             //input  wire            mode,
             input  wire    [127:0] sk_seed,
             input	wire	[319:0]	state_seed,
             input	wire	[255:0]	tree_addr,
             input  wire    [31:0]  leaf_idx,
             input  wire    [31:0]  idx_offset,
             input  wire    [31:0]  tree_height,
             output reg     [767:0] auth_path_out,
             output	wire    [127:0] root, 
             output reg           	valid_out
    );
    
	parameter SPX_ADDR_TYPE_FORSTREE = 8'd3;
    reg [15:0] count_reg;
	//reg [7:0] count_loop;
    reg count_add;
	reg 	[31:0]	leaf_idx_reg;
	reg		[31:0]  max_node_reg; //tree_height
	reg		[31:0]	idx_reg; // idx of node || sau 1 looop cung 1 tang thi tang len 8 || tang len tang moi thi reset lai = 0 
	reg 	[31:0] 	idx_offset_reg; // idx_offset >> height // qua moi tang moi thi >> 1 
	reg		[255:0]	addr_reg;
	wire  	[31:0] 	idx_0, // idx of node = idx>>heigth + offset >> height
					idx_1,
					idx_2,
					idx_3,
					idx_4,
					idx_5,
					idx_6,
					idx_7;
	assign	idx_0 = idx_reg + 32'd0 + idx_offset_reg; // idx of node in height
	assign	idx_1 = idx_reg + 32'd1 + idx_offset_reg;
	assign	idx_2 = idx_reg + 32'd2 + idx_offset_reg;
	assign	idx_3 = idx_reg + 32'd3 + idx_offset_reg;
	assign	idx_4 = idx_reg + 32'd4 + idx_offset_reg;
	assign	idx_5 = idx_reg + 32'd5 + idx_offset_reg;
	assign	idx_6 = idx_reg + 32'd6 + idx_offset_reg;
	assign	idx_7 = idx_reg + 32'd7 + idx_offset_reg;
	
	wire [31:0]	 max_node_wr;
	assign max_node_wr = (tree_height == 32'd6) ? 32'd64 : 320'd0; // mo rong them sau nay
	

    reg	start_in_reg_core_0,
		start_in_reg_core_1,
		start_in_reg_core_2,
		start_in_reg_core_3,
		start_in_reg_core_4,
		start_in_reg_core_5,
		start_in_reg_core_6,
		start_in_reg_core_7;
	reg 	[8191:0]	node_reg; // 128 * 64 = 8192 (256*8 = 1024) 64*128
	reg		[511:0] mess_in_reg_0,
					mess_in_reg_1,
					mess_in_reg_2,
					mess_in_reg_3,
					mess_in_reg_4,
					mess_in_reg_5,
					mess_in_reg_6,
					mess_in_reg_7;
	reg		[255:0]	state_reg_0,
					state_reg_1,
					state_reg_2,
					state_reg_3,
					state_reg_4,
					state_reg_5,
					state_reg_6,
					state_reg_7;
	wire 	[255:0]	state_out_wr_0,
                    state_out_wr_1,
                    state_out_wr_2,
                    state_out_wr_3,
                    state_out_wr_4,
                    state_out_wr_5,
                    state_out_wr_6,
                    state_out_wr_7;
	wire			valid_out_wr_0,
					valid_out_wr_1,
					valid_out_wr_2,
					valid_out_wr_3,
					valid_out_wr_4,
					valid_out_wr_5,
					valid_out_wr_6,
					valid_out_wr_7;
	wire	[175:0]	addr_wr_0,
					addr_wr_1,
					addr_wr_2,
					addr_wr_3,
					addr_wr_4,
					addr_wr_5,
					addr_wr_6,
					addr_wr_7;
	reg				flag_start_gen_leaf,
					flag_done_gen_sk,
					flag_done_sk_to_leaf,
					flag_done_gen_leaf,
					flag_start_gen_thash, //gen full leaf
					flag_done_thash,
					flag_update_reg;
	wire 	[63:0]	bytes_2;	
	assign bytes_2 = state_seed[63:0] + 64'd54;
	wire [255:0] state_initial;
	assign state_initial[255:0] = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
	wire [63:0] bytes;
	assign bytes = state_seed[63:0] + 64'd38;
	wire [63:0] bytes_initial;
	assign bytes_initial = 64'd38;

	wire	[255:0]	addr_gen_leaf_0,
					addr_gen_leaf_1,
					addr_gen_leaf_2,
					addr_gen_leaf_3,
					addr_gen_leaf_4,
					addr_gen_leaf_5,
					addr_gen_leaf_6,
					addr_gen_leaf_7,
					addr_gen_thash_0,
					addr_gen_thash_1,
					addr_gen_thash_2,
					addr_gen_thash_3,
					addr_gen_thash_4,
					addr_gen_thash_5,
					addr_gen_thash_6,
					addr_gen_thash_7,
					addr_in_wr_0,
					addr_in_wr_1,
					addr_in_wr_2,
					addr_in_wr_3,
					addr_in_wr_4,
					addr_in_wr_5,
					addr_in_wr_6,
					addr_in_wr_7;
	wire            check_end_layer_1,
	                check_end_layer_2,
	                check_end_layer_3,
	                check_end_layer_4,
	                check_end_layer_5;
	assign check_end_layer_1 = (max_node_reg == 32'd32)? 1'b1 : 1'b0;
	assign check_end_layer_2 = (max_node_reg == 32'd16)? 1'b1 : 1'b0;
	assign check_end_layer_3 = (max_node_reg == 32'd8)? 1'b1 : 1'b0;
	assign check_end_layer_4 = (max_node_reg == 32'd4)? 1'b1 : 1'b0;
	assign check_end_layer_5 = (max_node_reg == 32'd2)? 1'b1 : 1'b0;
	/*
			if (start_in_gen_leaf_reg) begin
				tree_addr_reg <= {tree_addr[255:128],tree_index[23:16],tree_index[31:24],tree_addr_idx,tree_addr[103:80],
                          tree_index[7:0],tree_index[15:8],tree_addr[63:0]};
                
            end
            if (start_in_thash_reg && (offset_reg - 1'd1) > 4'd1 && ((height_2 + 1'b1) == (height_3))) begin
				tree_addr_reg <= {tree_addr[255:128],tree_index_thash[23:16],tree_index_thash[31:24],tree_addr_idx_thash,tree_addr[103:80],
                          tree_index_thash[7:0],tree_index_thash[15:8],tree_addr[63:0]};
            end
	*/
	reg	[7:0]	height_reg;
	//////gen_sk sk_to_leaf/////////////////////////////////////////////////////////////////////
	/*
	copy_keypair_addr(fors_leaf_addr, fors_tree_addr);//[255:192]       [167:160] [143:136]
    set_type(fors_leaf_addr, SPX_ADDR_TYPE_FORSTREE); //[175:168]
    set_tree_index(fors_leaf_addr, addr_idx); //[127:120]-2 [119:112]-1  [79:72]-4 [71:64]-3
	
	//copy_keypair_addr
	assign  addr[255:192] = tree_addr[255:192];
	assign  addr[167:160] = tree_addr[167:160];
	assign  addr[143:136] = tree_addr[143:136];
	//set_type
	assign  addr[175:168] = SPX_ADDR_TYPE_FORSTREE;
	//set_tree_index
	assign  addr[127:120] = idx_0[23:16];
	assign  addr[119:112] = idx_0[31:24];
	assign  addr[79:72]   = idx_0[7:0];
	assign  addr[71:64]   = idx_0[15:8]; 
	// assign 0
	assign  addr[191:176] = 0;
	assign  addr[159:144] = 0;
	assign  addr[135:128] = 0;
	assign  addr[111:80] = 0;
	assign  addr[63:0] = 0;	
	*/
	assign	addr_gen_leaf_0[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_0[23:16],idx_0[31:24],32'b0,idx_0[7:0],idx_0[15:8],64'b0};
	assign	addr_gen_leaf_1[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_1[23:16],idx_1[31:24],32'b0,idx_1[7:0],idx_1[15:8],64'b0};
	assign	addr_gen_leaf_2[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_2[23:16],idx_2[31:24],32'b0,idx_2[7:0],idx_2[15:8],64'b0};
	assign	addr_gen_leaf_3[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_3[23:16],idx_3[31:24],32'b0,idx_3[7:0],idx_3[15:8],64'b0};
	assign	addr_gen_leaf_4[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_4[23:16],idx_4[31:24],32'b0,idx_4[7:0],idx_4[15:8],64'b0};
	assign	addr_gen_leaf_5[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_5[23:16],idx_5[31:24],32'b0,idx_5[7:0],idx_5[15:8],64'b0};
	assign	addr_gen_leaf_6[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_6[23:16],idx_6[31:24],32'b0,idx_6[7:0],idx_6[15:8],64'b0};
	assign	addr_gen_leaf_7[255:0] = {tree_addr[255:192],16'b0,SPX_ADDR_TYPE_FORSTREE,tree_addr[167:160],16'b0,tree_addr[143:136],8'b0,idx_7[23:16],idx_7[31:24],32'b0,idx_7[7:0],idx_7[15:8],64'b0};
	//////gen_sk sk_to_leaf/////////////////////////////////////////////////////////////////////
	/*
	/////////thash////////////////////
			set_tree_height(tree_addr, heights[offset - 1] + 1); ////////[111:104]
            set_tree_index(tree_addr,
                           tree_idx + (idx_offset >> (heights[offset - 1] + 1)));[127:120]=[23:16] || [119:112]=[31:24] ||  [79:72]=[7:0]  ||  [71:64]= [15:8]
	assign  addr[255:128] = tree_addr[255:128];
	//set_tree_index
	assign  addr[127:120] = idx_0[23:16];
	assign  addr[119:112] = idx_0[31:24];
	assign  addr[79:72]   = idx_0[7:0];
	assign  addr[71:64]   = idx_0[15:8]; 
	// set_tree_height
	assign  addr[111:104] = height_reg;
	assign  addr[103:80] = tree_addr[143:136];
	assign  addr[63:0] = tree_addr[143:136];	
	*/
	
	assign addr_gen_thash_0 = {tree_addr[255:128],idx_0[23:16],idx_0[31:24],height_reg,tree_addr[103:80],idx_0[7:0],idx_0[15:8],64'b0};
	assign addr_gen_thash_1 = {tree_addr[255:128],idx_1[23:16],idx_1[31:24],height_reg,tree_addr[103:80],idx_1[7:0],idx_1[15:8],64'b0};
	assign addr_gen_thash_2 = {tree_addr[255:128],idx_2[23:16],idx_2[31:24],height_reg,tree_addr[103:80],idx_2[7:0],idx_2[15:8],64'b0};
	assign addr_gen_thash_3 = {tree_addr[255:128],idx_3[23:16],idx_3[31:24],height_reg,tree_addr[103:80],idx_3[7:0],idx_3[15:8],64'b0};
	assign addr_gen_thash_4 = {tree_addr[255:128],idx_4[23:16],idx_4[31:24],height_reg,tree_addr[103:80],idx_4[7:0],idx_4[15:8],64'b0};
	assign addr_gen_thash_5 = {tree_addr[255:128],idx_5[23:16],idx_5[31:24],height_reg,tree_addr[103:80],idx_5[7:0],idx_5[15:8],64'b0};
	assign addr_gen_thash_6 = {tree_addr[255:128],idx_6[23:16],idx_6[31:24],height_reg,tree_addr[103:80],idx_6[7:0],idx_6[15:8],64'b0};
	assign addr_gen_thash_7 = {tree_addr[255:128],idx_7[23:16],idx_7[31:24],height_reg,tree_addr[103:80],idx_7[7:0],idx_7[15:8],64'b0};
	///////////////////////////////////////////////////////////////////////////////
	assign addr_in_wr_0 = (flag_done_gen_leaf)? addr_gen_thash_0 : addr_gen_leaf_0;
	assign addr_in_wr_1 = (flag_done_gen_leaf)? addr_gen_thash_1 : addr_gen_leaf_1;
	assign addr_in_wr_2 = (flag_done_gen_leaf)? addr_gen_thash_2 : addr_gen_leaf_2;
	assign addr_in_wr_3 = (flag_done_gen_leaf)? addr_gen_thash_3 : addr_gen_leaf_3;
	assign addr_in_wr_4 = (flag_done_gen_leaf)? addr_gen_thash_4 : addr_gen_leaf_4;
	assign addr_in_wr_5 = (flag_done_gen_leaf)? addr_gen_thash_5 : addr_gen_leaf_5;
	assign addr_in_wr_6 = (flag_done_gen_leaf)? addr_gen_thash_6 : addr_gen_leaf_6;
	assign addr_in_wr_7 = (flag_done_gen_leaf)? addr_gen_thash_7 : addr_gen_leaf_7;
	
	// reg : count_wr_[n] | chain_addr_wr
	//memcpy(buf + n, addr, SPX_SHA256_ADDR_BYTES);
	get_22_bytes_addr addr_0( ///for_mess_in_reg
							.addr(addr_in_wr_0),
							.addr_out(addr_wr_0)
    );
	get_22_bytes_addr addr_1( ///for_mess_in_reg
							.addr(addr_in_wr_1),
							.addr_out(addr_wr_1)
    );
	get_22_bytes_addr addr_2( ///for_mess_in_reg
							.addr(addr_in_wr_2),
							.addr_out(addr_wr_2)
    );
	get_22_bytes_addr addr_3( ///for_mess_in_reg
							.addr(addr_in_wr_3),
							.addr_out(addr_wr_3)
    );
	get_22_bytes_addr addr_4( ///for_mess_in_reg
							.addr(addr_in_wr_4),
							.addr_out(addr_wr_4)
    );
	get_22_bytes_addr addr_5( ///for_mess_in_reg
							.addr(addr_in_wr_5),
							.addr_out(addr_wr_5)
    );
	get_22_bytes_addr addr_6( ///for_mess_in_reg
							.addr(addr_in_wr_6),
							.addr_out(addr_wr_6)
    );
	get_22_bytes_addr addr_7( ///for_mess_in_reg
							.addr(addr_in_wr_7),
							.addr_out(addr_wr_7)
    );
    RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_0(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_0),
													  .message_in(mess_in_reg_0),
													  .digest_in(state_reg_0),
													  .digest_out(state_out_wr_0),
													  .valid_out(valid_out_wr_0));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_1(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_1),
													  .message_in(mess_in_reg_1),
													  .digest_in(state_reg_1),
													  .digest_out(state_out_wr_1),
													  .valid_out(valid_out_wr_1));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_2(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_2),
													  .message_in(mess_in_reg_2),
													  .digest_in(state_reg_2),
													  .digest_out(state_out_wr_2),
													  .valid_out(valid_out_wr_2));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_3(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_3),
													  .message_in(mess_in_reg_3),
													  .digest_in(state_reg_3),
													  .digest_out(state_out_wr_3),
													  .valid_out(valid_out_wr_3));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_4(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_4),
													  .message_in(mess_in_reg_4),
													  .digest_in(state_reg_4),
													  .digest_out(state_out_wr_4),
													  .valid_out(valid_out_wr_4));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_5(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_5),
													  .message_in(mess_in_reg_5),
													  .digest_in(state_reg_5),
													  .digest_out(state_out_wr_5),
													  .valid_out(valid_out_wr_5));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_6(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_6),
													  .message_in(mess_in_reg_6),
													  .digest_in(state_reg_6),
													  .digest_out(state_out_wr_6),
													  .valid_out(valid_out_wr_6));
	RTL_crypto_hashblocks_sha256 gen_pk_core_sha256_7(.CLK(CLK),
													  .RST(RST),
													  .start_in(start_in_reg_core_7),
													  .message_in(mess_in_reg_7),
													  .digest_in(state_reg_7),
													  .digest_out(state_out_wr_7),
													  .valid_out(valid_out_wr_7));
	/* flow data
			height = 0 : gen_leaf (64 node -> 64/8 = 8 loop) 
				//copy_keypair_addr(fors_leaf_addr, fors_tree_addr);//[255:192]       [167:160] [143:136]
				//set_type(fors_leaf_addr, SPX_ADDR_TYPE_FORSTREE); //[175:168]
				//set_tree_index(fors_leaf_addr, addr_idx); //[127:120]-2 [119:112]-1  [79:72]-4 [71:64]-3
							gen_sk
								prf
							sk_to_leaf
								thash
			height = {1,2,3,4,5,6,...}thash 
				//set_tree_height(tree_addr, heights[offset - 1] + 1); // 17
				//set_tree_index(tree_addr,   // 18
                           tree_idx + (idx_offset >> (heights[offset-1] + 1)));
							thash
				1: 32 node -> 4 loop 
				2: 16 node -> 2 loop 
				3: 8  node -> 1 loop 
				4: 4  node -> 1 loop 
				5: 2  node -> 1 loop 
				6: 1  node -> 1 loop  
		start_in -> n_loop gen full leaf -> height++ || idx reset || idx_offset >> 1 || leaf_idx >> 1 || max_node >> 1 -> thash to gen new node next layer -> loop until max_node = 1
	*/
	wire	[255:0] node_wr_0,node_wr_1,node_wr_2,node_wr_3,node_wr_4,node_wr_5,node_wr_6,node_wr_7,
					node_wr_8,node_wr_9,node_wr_10,node_wr_11,node_wr_12,node_wr_13,node_wr_14,node_wr_15,
					node_wr_16,node_wr_17,node_wr_18,node_wr_19,node_wr_20,node_wr_21,node_wr_22,node_wr_23,
					node_wr_24,node_wr_25,node_wr_26,node_wr_27,node_wr_28,node_wr_29,node_wr_30,node_wr_31;
	assign node_wr_0  = node_reg[8191:7936];
	assign node_wr_1  = node_reg[7935:7680];
	assign node_wr_2  = node_reg[7679:7424];
	assign node_wr_3  = node_reg[7423:7168];
	assign node_wr_4  = node_reg[7167:6912];
	assign node_wr_5  = node_reg[6911:6656];
	assign node_wr_6  = node_reg[6655:6400];
	assign node_wr_7  = node_reg[6399:6144];
	assign node_wr_8  = node_reg[6143:5888];
	assign node_wr_9  = node_reg[5887:5632];
	assign node_wr_10 = node_reg[5631:5376];
	assign node_wr_11 = node_reg[5375:5120];
	assign node_wr_12 = node_reg[5119:4864];
	assign node_wr_13 = node_reg[4863:4608];
	assign node_wr_14 = node_reg[4607:4352];
	assign node_wr_15 = node_reg[4351:4096];
	assign node_wr_16 = node_reg[4095:3840];
	assign node_wr_17 = node_reg[3839:3584];
	assign node_wr_18 = node_reg[3583:3328];
	assign node_wr_19 = node_reg[3327:3072];
	assign node_wr_20 = node_reg[3071:2816];
	assign node_wr_21 = node_reg[2815:2560];
	assign node_wr_22 = node_reg[2559:2304];
	assign node_wr_23 = node_reg[2303:2048];
	assign node_wr_24 = node_reg[2047:1792];
	assign node_wr_25 = node_reg[1791:1536];
	assign node_wr_26 = node_reg[1535:1280];
	assign node_wr_27 = node_reg[1279:1024];
	assign node_wr_28 = node_reg[1023:768];
	assign node_wr_29 = node_reg[767:512];
	assign node_wr_30 = node_reg[511:256];
	assign node_wr_31 = node_reg[255:0];

	assign root = node_reg[8191:8064];
	
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			count_reg					<= 32'b0; // tang khi start_in || check tai valid_out || reset khi qua layer ke
			//count_loop                  <= 8'b0;
			count_add					<= 1'b0;
			idx_reg						<= 32'b0; // idx of node || sau 1 looop cung 1 tang thi tang len 8 || tang len tang moi thi reset lai = 0 
			leaf_idx_reg				<= 32'b0;
			idx_offset_reg				<= 32'b0; // idx_offset >> height // qua moi tang moi thi >> 1 
			max_node_reg				<= 32'd0; // >> 1 sau khi qua layer ke tiep
			start_in_reg_core_0			<= 1'b0;
			start_in_reg_core_1			<= 1'b0;
			start_in_reg_core_2			<= 1'b0;
			start_in_reg_core_3			<= 1'b0;
			start_in_reg_core_4			<= 1'b0;
			start_in_reg_core_5			<= 1'b0;
			start_in_reg_core_6			<= 1'b0;
			start_in_reg_core_7			<= 1'b0;
			mess_in_reg_0				<= 512'b0;
			mess_in_reg_1				<= 512'b0;
			mess_in_reg_2				<= 512'b0;
			mess_in_reg_3				<= 512'b0;
			mess_in_reg_4				<= 512'b0;
			mess_in_reg_5				<= 512'b0;
			mess_in_reg_6				<= 512'b0;
			mess_in_reg_7				<= 512'b0;
			state_reg_0					<= 256'b0;
			state_reg_1					<= 256'b0;
			state_reg_2					<= 256'b0;
			state_reg_3					<= 256'b0;
			state_reg_4					<= 256'b0;
			state_reg_5					<= 256'b0;
			state_reg_6					<= 256'b0;
			state_reg_7					<= 256'b0;
			flag_done_gen_sk			<= 1'b0;
			flag_done_sk_to_leaf		<= 1'b0;
			flag_done_gen_leaf			<= 1'b0;
			flag_start_gen_leaf			<= 1'b0;
			flag_start_gen_thash		<= 1'b0;
			flag_done_thash				<= 1'b0;
			valid_out 					<= 1'b0;
			addr_reg					<= 256'b0;
			height_reg					<= 8'b0;  // tinh xong 1 height se tang len (Luu y khi chieu cao input tang co the thay doi vi tri trong addr 12 or 13) 
			node_reg					<= 8192'b0; // phu thuoc vao height
			flag_update_reg				<= 1'b0;
		end
		else if (start_in | flag_start_gen_leaf) begin 		// start_prf tu start_in or loop
			////////////////////////////////////////////////////////////////////////////////////////////////////////
			start_in_reg_core_0			<= 1'b1;
			start_in_reg_core_1			<= 1'b1;
			start_in_reg_core_2			<= 1'b1;
			start_in_reg_core_3			<= 1'b1;
			start_in_reg_core_4			<= 1'b1;
			start_in_reg_core_5			<= 1'b1;
			start_in_reg_core_6			<= 1'b1;
			start_in_reg_core_7			<= 1'b1;
			mess_in_reg_0				<= {sk_seed[127:0],addr_wr_0,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_1				<= {sk_seed[127:0],addr_wr_1,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_2				<= {sk_seed[127:0],addr_wr_2,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_3				<= {sk_seed[127:0],addr_wr_3,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_4				<= {sk_seed[127:0],addr_wr_4,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_5				<= {sk_seed[127:0],addr_wr_5,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_6				<= {sk_seed[127:0],addr_wr_6,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			mess_in_reg_7				<= {sk_seed[127:0],addr_wr_7,8'h80,136'b0,{bytes_initial[60:0],3'b000}};
			state_reg_0					<= state_initial;
			state_reg_1					<= state_initial;
			state_reg_2					<= state_initial;
			state_reg_3					<= state_initial;
			state_reg_4					<= state_initial;
			state_reg_5					<= state_initial;
			state_reg_6					<= state_initial;
			state_reg_7					<= state_initial;
			/////////////////////////////////////////////////////////////////////////////////////////////////////////

			///////////////////////////////////////////////////////////////////////
			if (start_in) begin
				count_add					<= 1'b1;
				idx_reg						<= 32'b0;
				leaf_idx_reg				<= leaf_idx;
				idx_offset_reg				<= idx_offset; 
				max_node_reg				<= 32'd64;
				addr_reg					<= tree_addr;
				height_reg					<= 8'b0;
				node_reg					<= 8192'b0;
				count_reg					<= 32'd8; // phu thuoc vao so core
			end 
			else if (flag_start_gen_leaf) begin
				count_add					<= count_add;
				idx_reg						<= idx_reg;
				leaf_idx_reg				<= leaf_idx_reg;
				idx_offset_reg				<= idx_offset_reg; 
				max_node_reg				<= max_node_reg;
				addr_reg					<= addr_reg;
				height_reg					<= height_reg;
				node_reg					<= node_reg;
				//count_reg					<= count_reg + 32'd8;
				count_reg					<= count_reg; //test
			end
				flag_done_gen_sk			<= 1'b1; 
				flag_done_sk_to_leaf		<= 1'b0;
				flag_done_gen_leaf			<= 1'b0;
				valid_out 					<= 1'b0;
				flag_start_gen_leaf			<= 1'b0;
				flag_start_gen_thash		<= 1'b0;
				flag_done_thash				<= 1'b0;
				flag_update_reg				<= 1'b0;
		end
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// done prf -> start sk_to_leaf
		else if (flag_done_gen_sk & valid_out_wr_0) begin
			//count_reg					<= count_reg; // prf -> gen_chain : giu nguyen
			//count_loop                  <= count_loop;
			//count_reg_chain				<= count_reg_chain; // prf -> gen_chain : giu nguyen =0
			//count_add					<= count_add;
			start_in_reg_core_0			<= 1'b1;
			start_in_reg_core_1			<= 1'b1;
			start_in_reg_core_2			<= 1'b1;
			start_in_reg_core_3			<= 1'b1;
			start_in_reg_core_4			<= 1'b1;
			start_in_reg_core_5			<= 1'b1;
			start_in_reg_core_6			<= 1'b1;
			start_in_reg_core_7			<= 1'b1;
			mess_in_reg_0				<= {addr_wr_0,state_out_wr_0[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_1				<= {addr_wr_1,state_out_wr_1[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_2				<= {addr_wr_2,state_out_wr_2[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_3				<= {addr_wr_3,state_out_wr_3[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_4				<= {addr_wr_4,state_out_wr_4[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_5				<= {addr_wr_5,state_out_wr_5[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_6				<= {addr_wr_6,state_out_wr_6[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			mess_in_reg_7				<= {addr_wr_7,state_out_wr_7[255:128],8'h80,136'b0,{bytes[60:0],3'b000}};
			state_reg_0					<= state_seed[319:64];
			state_reg_1					<= state_seed[319:64];
			state_reg_2					<= state_seed[319:64];
			state_reg_3					<= state_seed[319:64];
			state_reg_4					<= state_seed[319:64];
			state_reg_5					<= state_seed[319:64];
			state_reg_6					<= state_seed[319:64];
			state_reg_7					<= state_seed[319:64];
			flag_done_gen_sk			<= 1'b0;
			flag_done_sk_to_leaf		<= 1'b1;
			flag_done_gen_leaf			<= 1'b0;
			flag_start_gen_leaf			<= 1'b0;
			flag_start_gen_thash		<= 1'b0;
			flag_done_thash				<= 1'b0;
			//need delay 1 cycles for update count_reg_chain -> mess_in_reg_[n]
		end
		else if (flag_done_sk_to_leaf & valid_out_wr_0) begin // done gen 8 leaf -> check loop or next layer || tang bien , >> 1
				node_reg					<= {node_reg[7167:0],state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128],state_out_wr_3[255:128],
																state_out_wr_4[255:128],state_out_wr_5[255:128],state_out_wr_6[255:128],state_out_wr_7[255:128]}; // write data vao 
			if (count_reg == max_node_reg) begin // gen du node -> next layer
				count_add					<= count_add;
				idx_reg						<= 32'b0; // reset idx
				leaf_idx_reg				<= {1'b0,leaf_idx_reg[31:1]};
				idx_offset_reg				<= {1'b0,idx_offset_reg[31:1]}; 
				max_node_reg				<= {1'b0,max_node_reg[31:1]};
				addr_reg					<= addr_reg;
				height_reg					<= height_reg + count_add; // tang len layer ke tiep
				count_reg					<= 32'b0;
				flag_done_gen_sk			<= 1'b0; 
				flag_done_sk_to_leaf		<= 1'b0;
				flag_done_gen_leaf			<= 1'b1;
				valid_out 					<= 1'b0;
				flag_start_gen_leaf			<= 1'b0;
				flag_start_gen_thash		<= 1'b1;
				flag_done_thash				<= 1'b0;
				flag_update_reg				<= 1'b0;
			end
			else begin // loop gen_sk (prf) 
				count_add					<= count_add;
				idx_reg						<= idx_reg + 32'd8; // tang index
				leaf_idx_reg				<= leaf_idx_reg;
				idx_offset_reg				<= idx_offset_reg; 
				max_node_reg				<= max_node_reg;
				addr_reg					<= addr_reg;
				height_reg					<= height_reg;
				count_reg					<= count_reg + 32'd8;
				flag_done_gen_sk			<= 1'b0; // bat khi start_in
				flag_done_sk_to_leaf		<= 1'b0;
				flag_done_gen_leaf			<= 1'b0;
				valid_out 					<= 1'b0;
				flag_start_gen_leaf			<= 1'b1;
				flag_start_gen_thash		<= 1'b0;
				flag_done_thash				<= 1'b0;
				flag_update_reg				<= 1'b0;
			end
		end
		else if (flag_start_gen_thash) begin //start_thash
			// lay output luu trong node ra nap vao mess_reg
			////////////////////////////////////////////////////////////////////////////////////////////////////////
			// thash 2 = addr_wr,in[255:0],8'h80,8'b0,{bytes[60:0],3'b000}};
			start_in_reg_core_0			<= 1'b1;
			start_in_reg_core_1			<= 1'b1;
			start_in_reg_core_2			<= 1'b1;
			start_in_reg_core_3			<= 1'b1;
			start_in_reg_core_4			<= 1'b1;
			start_in_reg_core_5			<= 1'b1;
			start_in_reg_core_6			<= 1'b1;
			start_in_reg_core_7			<= 1'b1;
			mess_in_reg_0				<= {addr_wr_0,node_reg[8191:7936],8'h80,8'b0,{bytes_2[60:0],3'b000}}; // 256 bit 
			mess_in_reg_1				<= {addr_wr_1,node_reg[7935:7680],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			mess_in_reg_2				<= {addr_wr_2,node_reg[7679:7424],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			mess_in_reg_3				<= {addr_wr_3,node_reg[7423:7168],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			mess_in_reg_4				<= {addr_wr_4,node_reg[7167:6912],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			mess_in_reg_5				<= {addr_wr_5,node_reg[6911:6656],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			mess_in_reg_6				<= {addr_wr_6,node_reg[6655:6400],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			mess_in_reg_7				<= {addr_wr_7,node_reg[6399:6144],8'h80,8'b0,{bytes_2[60:0],3'b000}};
			state_reg_0					<= state_seed[319:64];
			state_reg_1					<= state_seed[319:64];
			state_reg_2					<= state_seed[319:64];
			state_reg_3					<= state_seed[319:64];
			state_reg_4					<= state_seed[319:64];
			state_reg_5					<= state_seed[319:64];
			state_reg_6					<= state_seed[319:64];
			state_reg_7					<= state_seed[319:64];
			/////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			count_add					<= count_add;
			idx_reg						<= idx_reg;
			leaf_idx_reg				<= leaf_idx_reg;
			idx_offset_reg				<= idx_offset_reg; 
			max_node_reg				<= max_node_reg;
			addr_reg					<= addr_reg;
			height_reg					<= height_reg;
			//node_reg					<= {node_reg[6143:0],2048'b0}; // day 256*8 bit ra ngoai
			node_reg[8191:2048]			<= {node_reg[6143:0]}; // day 256*8 bit ra ngoai // 56 bytes
			//node_reg[2047:1024]			<= node_reg[1023:0];
			//node_reg[1023:0]			<= node_reg[1023:0];
			//////////////
			if (max_node_reg == 32'd4) begin
				count_reg					<= count_reg + 32'd4;
			end
			else if (max_node_reg == 32'd2) begin
				count_reg					<= count_reg + 32'd2;
			end
			else if (max_node_reg == 32'd1) begin
				count_reg					<= count_reg + 32'd1;
			end
			else begin
				count_reg					<= count_reg + 32'd8;
			end
			/////////////
			flag_done_gen_sk			<= 1'b0; 
			flag_done_sk_to_leaf		<= 1'b0;
			flag_done_gen_leaf			<= 1'b1;
			valid_out 					<= 1'b0;
			flag_start_gen_leaf			<= 1'b0;
			flag_start_gen_thash		<= 1'b0;
			flag_done_thash				<= 1'b1;
		end
		else if (flag_done_thash & valid_out_wr_0) begin // done thash
				// write data vao va khong dich bit
				if (max_node_reg == 32'd1) begin
					node_reg					<= {state_out_wr_0[255:128],8064'b0}; // write data vao 
					//root 						<= state_out_wr_0;
					
				end
				else if (max_node_reg == 32'd2) begin
					node_reg					<= {state_out_wr_0[255:128],state_out_wr_1[255:128],7936'b0}; // write data vao 
				end
				else if (max_node_reg == 32'd4) begin
					node_reg					<= {state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128],state_out_wr_3[255:128],7680'b0}; // write data vao 
				end
				else if (max_node_reg == 32'd8) begin
					node_reg					<= {state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128],state_out_wr_3[255:128],
													state_out_wr_4[255:128],state_out_wr_5[255:128],state_out_wr_6[255:128],state_out_wr_7[255:128],7168'b0}; // write data vao 
				end
				else begin
					//{out,1024'b0]}
					node_reg[2047:0]				<= {state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128],state_out_wr_3[255:128],
													state_out_wr_4[255:128],state_out_wr_5[255:128],state_out_wr_6[255:128],state_out_wr_7[255:128],1024'b0}; // write data vao 
					
				end
				
				if (count_reg == max_node_reg) begin //next layer
					count_add					<= count_add;
					idx_reg						<= 32'b0; // reset idx
					leaf_idx_reg				<= {1'b0,leaf_idx_reg[31:1]};
					idx_offset_reg				<= {1'b0,idx_offset_reg[31:1]}; 
					//max_node_reg				<= {1'b0,max_node_reg[31:1]};
					addr_reg					<= addr_reg;
					height_reg					<= height_reg + count_add; // tang len layer ke tiep
					count_reg					<= 32'b0;
					flag_done_gen_sk			<= 1'b0; 
					flag_done_sk_to_leaf		<= 1'b0;
					flag_done_gen_leaf			<= flag_done_gen_leaf;
					valid_out 					<= 1'b0;
					flag_start_gen_leaf			<= 1'b0;
					//flag_start_gen_thash		<= 1'b0; 
					flag_done_thash				<= 1'b0;
					//flag_update_reg				<= 1'b1;
					if ((max_node_reg == 32'd1)|(max_node_reg == 32'd2)|(max_node_reg == 32'd4)|(max_node_reg == 32'd8)) begin // 1 2 4 8 
						flag_start_gen_thash		<= 1'b1;
						flag_update_reg				<= 1'b0;
						max_node_reg				<= {1'b0,max_node_reg[31:1]};
					end
					else begin // 16 32 
						flag_start_gen_thash		<= 1'b0;
						flag_update_reg				<= 1'b1;
						max_node_reg				<= max_node_reg;
					end
				end //in loop 
				else begin
					count_add					<= count_add;
					idx_reg						<= idx_reg + 32'd8; // tang index
					leaf_idx_reg				<= leaf_idx_reg;
					idx_offset_reg				<= idx_offset_reg; 
					max_node_reg				<= max_node_reg;
					addr_reg					<= addr_reg;
					height_reg					<= height_reg;
					count_reg					<= count_reg;
					flag_done_gen_sk			<= 1'b0; 
					flag_done_sk_to_leaf		<= 1'b0;
					flag_done_gen_leaf			<= flag_done_gen_leaf;
					valid_out 					<= 1'b0;
					flag_start_gen_leaf			<= 1'b0;
					flag_start_gen_thash		<= 1'b1; 
					flag_done_thash				<= 1'b0;
					flag_update_reg				<= 1'b0;
					
				end
				
				if (max_node_reg == 32'd1) begin
					flag_done_gen_sk			<= 1'b0;
					flag_done_sk_to_leaf		<= 1'b0;
					flag_done_gen_leaf			<= flag_done_gen_leaf;
					valid_out 					<= 1'b1;
					flag_start_gen_leaf			<= 1'b0;
					flag_start_gen_thash		<= 1'b0;
					flag_done_thash				<= 1'b0;
					
				end
		end
		else if (flag_update_reg) begin
			max_node_reg				<= {1'b0,max_node_reg[31:1]};
			flag_done_gen_sk			<= 1'b0; 
			flag_done_sk_to_leaf		<= 1'b0;
			flag_done_gen_leaf			<= flag_done_gen_leaf;
			valid_out 					<= 1'b0;
			flag_start_gen_leaf			<= 1'b0;
			flag_done_thash				<= 1'b0;
			flag_update_reg				<= 1'b0;
			if (check_end_layer_1) begin //32 node 
				flag_start_gen_thash		<= 1'b1;
				// 64 = {[out_0,1024'b0],[out_1,1024'b0],[out_2,1024'b0],[out_3,1024'b0]}
				node_reg 					<= {node_wr_0,node_wr_1,node_wr_2,node_wr_3,node_wr_8,node_wr_9,node_wr_10,node_wr_11
												,node_wr_16,node_wr_17,node_wr_18,node_wr_19,node_wr_24,node_wr_25,node_wr_26,node_wr_27,4096'b0};
			end
			else if (check_end_layer_2) begin //16 
				flag_start_gen_thash		<= 1'b1;
				node_reg 					<= {node_wr_16,node_wr_17,node_wr_18,node_wr_19,node_wr_24,node_wr_25,node_wr_26,node_wr_27,6144'b0};
			end
			else begin
				flag_start_gen_thash		<= 1'b0;
				node_reg 					<= node_reg;
			end
		end
		else begin
			start_in_reg_core_0			<= 1'b0;
			start_in_reg_core_1			<= 1'b0;
			start_in_reg_core_2			<= 1'b0;
			start_in_reg_core_3			<= 1'b0;
			start_in_reg_core_4			<= 1'b0;
			start_in_reg_core_5			<= 1'b0;
			start_in_reg_core_6			<= 1'b0;
			start_in_reg_core_7			<= 1'b0;
			count_add					<= count_add;
			idx_reg						<= idx_reg;
			leaf_idx_reg				<= leaf_idx_reg;
			idx_offset_reg				<= idx_offset_reg; 
			max_node_reg				<= max_node_reg;
			addr_reg					<= addr_reg;
			height_reg					<= height_reg;
			node_reg					<= node_reg;
			count_reg					<= count_reg;
			flag_done_gen_sk			<= flag_done_gen_sk;	
			flag_done_sk_to_leaf		<= flag_done_sk_to_leaf;
			flag_done_gen_leaf			<= flag_done_gen_leaf;	
			valid_out 					<= 1'b0;		
			flag_start_gen_leaf			<= flag_start_gen_leaf;	
			flag_start_gen_thash		<= flag_start_gen_thash;
			flag_done_thash				<= flag_done_thash;		
			flag_update_reg				<= flag_update_reg;		
		end
    end
		// auth_path
	always @(posedge CLK or negedge RST) begin
		if(!RST) begin
			auth_path_out <= 768'b0;
		end
		else if ((flag_done_sk_to_leaf | flag_done_thash) & valid_out_wr_0 & !(max_node_reg==32'd1)) begin
			if ((leaf_idx_reg ^ 1'b1) == idx_0) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_0[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_1) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_1[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_2) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_2[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_3) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_3[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_4) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_4[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_5) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_5[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_6) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_6[255:128]};
			end
			else if ((leaf_idx_reg ^ 1'b1) == idx_7) begin
				auth_path_out <= {auth_path_out[639:0],state_out_wr_7[255:128]};
			end
			else begin
				auth_path_out <= auth_path_out;
			end
			end
		else begin
		auth_path_out <= auth_path_out;
		end
	end
		
endmodule
