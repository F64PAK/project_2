`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2024 04:44:04 PM
// Design Name: 
// Module Name: wots_gen_pk_8_core_sha256
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


module wots_gen_pk_8_core_sha256(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] sk_seed,
             input	wire	[319:0]	state_seed,
             //input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	addr,
             output	wire	[4479:0]pk_out, //4480
             output reg           	valid_out
    );
    reg	[4479:0] pk_out_reg;
    reg [5:0] count_reg;
	reg [4:0] count_reg_chain;
	reg [3:0] count_loop;
    reg count_add;
	
	assign pk_out = (valid_out) ? pk_out_reg : 4480'b0;
    
    wire 	check_gen_pk,
			check_gen_chain;
    wire [255:0] addr_wr;
    wire [127:0] gen_sk_out,
                 out_gen_chain;
    //set_chain_addr -> reg 
    //assign addr_wr[111:104] = count_reg;
    //assign addr_wr[255:112] = addr[255:112] ;
    //assign addr_wr[103:0] =  addr[103:0] ;
    assign check_gen_pk = (count_loop == 6'd5)? 1'b1 : 1'b0; // -> 35 -> 5 {8,8,8,8,3}(core)
	assign check_gen_chain = (count_reg_chain == 6'd15)? 1'b1 : 1'b0; // -> 35 -> 15 loop 
    /*
	fors_wots_gen_sk wots_gen_sk_wots_gen_pk(
            .CLK(CLK),
            .RST(RST),
            .start_in(start_in_gen_sk),
            .sk_seed(sk_seed),
            .addr(addr_wr),
            .mode(1'b0), // 0: wots || 1: fors
            .sk_out(gen_sk_out),
            .valid_out(valid_out_gen_sk)
    );
    gen_chain gen_chain_wots_gen_pk_0(
            .CLK(CLK),
            .RST(RST),
            .start_in(valid_out_gen_sk),
            .in(gen_sk_out),
            .state_seed(state_seed),
//            .pub_seed(pub_seed), // khong su dung
            .addr(addr_wr),
            .start(32'b0),
            .steps(32'd15),
            .out(out_gen_chain),
            .valid_out(valid_out_gen_chain)
    );
	*/
	////////////////////////////////////////////////////////////////////////////
	/*
		5 loop (set_chain_addr[111:104]){
			8 core gen_sk (set_hash_addr[i or in][79:72])
			15 loop {
				8 core gen_chain (set_hash_addr[i][79:72])
			}
		}
	*/
	/*
	////////////
	 //set_chain_addr for gen_sk & gen_chain
    assign addr_wr[111:104] = count_reg; /// theo 5 loop 
    assign addr_wr[255:112] = addr[255:112] ;
    assign addr_wr[103:0] =  addr[103:0] ;
	////////////////
	
	////////////////// gen_sk
	////set_hash_addr
	assign addr_wr[255:80] = addr[255:80];
    assign addr_wr[79:72] = (~mode) ? 8'b0 : addr[79:72]; // 0 -> wots || 1-> fors
    assign addr_wr[71:0] = addr[71:0];
	
	////
	
	/////////////////22 bytes_addr
    assign addr_wr = {addr[231:224],addr[239:232],addr[247:240],addr[255:248],
                      addr[199:192],addr[207:200],addr[215:208],addr[223:216],
                      addr[167:160],addr[175:168],addr[183:176],addr[191:184],
                      addr[135:128],addr[143:136],addr[151:144],addr[159:152],
                      addr[103:96],addr[111:104],addr[119:112],addr[127:120],
                      addr[71:64],addr[79:72]};
	///////////////////
	//set_hash_addr
    assign addr_wr[255:80] = addr[255:80] ;
    assign addr_wr[79:72] = count_reg ;
    assign addr_wr[71:0] =  addr[71:0] ;
	//////////////////gen_chain
	//set_hash_addr
    assign addr_wr[255:80] = addr[255:80] ;
    assign addr_wr[79:72] = count_reg ;
    assign addr_wr[71:0] =  addr[71:0] ;
	*/
	///////////////
	reg	start_in_reg_core_0,
		start_in_reg_core_1,
		start_in_reg_core_2,
		start_in_reg_core_3,
		start_in_reg_core_4,
		start_in_reg_core_5,
		start_in_reg_core_6,
		start_in_reg_core_7;
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
	reg				flag_done_gen_sk,
					flag_done_gen_chain,
					flag_delay,
					flag_update;
					
	wire	[7:0]	chain_addr_wr;
	wire	[7:0]	count_wr_0,
					count_wr_1,
					count_wr_2,
					count_wr_3,
					count_wr_4,
					count_wr_5,
					count_wr_6,
					count_wr_7;
	wire [255:0] state_initial;
	assign state_initial[255:0] = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
	wire [63:0] bytes;
	assign bytes = state_seed[63:0] + 64'd38;
	wire [63:0] bytes_initial;
	assign bytes_initial = 64'd38;
	assign	count_wr_0 = count_reg;
	assign	count_wr_1 = count_reg + 8'd1;
	assign	count_wr_2 = count_reg + 8'd2;
	assign	count_wr_3 = count_reg + 8'd3;
	assign	count_wr_4 = count_reg + 8'd4;
	assign	count_wr_5 = count_reg + 8'd5;
	assign	count_wr_6 = count_reg + 8'd6;
	assign	count_wr_7 = count_reg + 8'd7;
	// [79:72] = 0 (wots) || [79:72]addr(fors) || count_reg_chain(chain)
	assign chain_addr_wr = count_reg_chain;
		
	// reg : count_wr_[n] | chain_addr_wr
	get_22_bytes_addr addr_0( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_0,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_0)
    );
	get_22_bytes_addr addr_1( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_1,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_1)
    );
	get_22_bytes_addr addr_2( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_2,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_2)
    );
	get_22_bytes_addr addr_3( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_3,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_3)
    );
	get_22_bytes_addr addr_4( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_4,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_4)
    );
	get_22_bytes_addr addr_5( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_5,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_5)
    );
	get_22_bytes_addr addr_6( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_6,addr[103:80],chain_addr_wr,addr[71:0]}),
							.addr_out(addr_wr_6)
    );
	get_22_bytes_addr addr_7( ///for_mess_in_reg
							.addr({addr[255:112],count_wr_7,addr[103:80],chain_addr_wr,addr[71:0]}),
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
	
	//prf {sk_seed[127:0],addr_wr_0,8'h80,136'b0,{bytes[60:0],3'b000}
	//thash {addr_wr_1,in[127:0],8'h80,136'b0,{64'd38[60:0],3'b000}}
	always @(posedge CLK or negedge RST) begin
		if (!RST) begin
			pk_out_reg					<= 4480'b0;
			count_reg					<= 6'b0;
			count_reg_chain				<= 5'b0;
			count_loop                  <= 4'b0;
			count_add					<= 1'b0;
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
			flag_done_gen_chain			<= 1'b0;
			flag_delay					<= 1'b0;
			flag_update					<= 1'b0;
			valid_out 					<= 1'b0;
		end
		else if (start_in) begin 
			pk_out_reg					<= 4480'b0;
			count_reg					<= 6'b0;
			count_loop                  <= 4'b0;
			count_reg_chain				<= 5'b0;
			count_add					<= 1'b1;
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
			flag_done_gen_chain			<= 1'b0;
			flag_delay					<= 1'b1;
			flag_update					<= 1'b0;
			valid_out 					<= 1'b0;
		end
		else if (flag_delay & !flag_done_gen_sk) begin // start_prf
			pk_out_reg					<= pk_out_reg;
			count_reg					<= count_reg;
			count_loop                  <= count_loop;
			count_reg_chain				<= count_reg_chain;
			count_add					<= count_add;
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
			flag_done_gen_sk			<= 1'b0;
			flag_done_gen_chain			<= 1'b0;
			flag_delay					<= 1'b0;
			valid_out 					<= 1'b0;
		end
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// done prf -> start gen_chain (count reg[0->35/8] & count_reg_chain[0->15])
		else if (!flag_done_gen_sk & !flag_delay & valid_out_wr_0 & valid_out_wr_1 & valid_out_wr_2 & valid_out_wr_3 & valid_out_wr_4 & valid_out_wr_5 & valid_out_wr_6 & valid_out_wr_7) begin
			pk_out_reg					<= pk_out_reg;
			//pk_out_reg					<= {pk_out_reg[3455:0],state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128],state_out_wr_3[255:128],state_out_wr_4[255:128],state_out_wr_5[255:128],state_out_wr_6[255:128],state_out_wr_7[255:128]};
			count_reg					<= count_reg; // prf -> gen_chain : giu nguyen
			count_loop                  <= count_loop;
			count_reg_chain				<= count_reg_chain; // prf -> gen_chain : giu nguyen =0
			count_add					<= count_add;
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
			flag_done_gen_sk			<= 1'b1;
			flag_done_gen_chain			<= 1'b0;
			flag_delay					<= 1'b1;
			//need delay 1 cycles for update count_reg_chain -> mess_in_reg_[n]
		end
		else if (flag_done_gen_sk & flag_delay) begin
			count_reg_chain <= count_reg_chain + 1'b1; // update sau khi sha256 da chay : khong lam anh huong den sha256 ???
			flag_delay					<= 1'b0;
			start_in_reg_core_0			<= 1'b0;
				start_in_reg_core_1			<= 1'b0;
				start_in_reg_core_2			<= 1'b0;
				start_in_reg_core_3			<= 1'b0;
				start_in_reg_core_4			<= 1'b0;
				start_in_reg_core_5			<= 1'b0;
				start_in_reg_core_6			<= 1'b0;
				start_in_reg_core_7			<= 1'b0;
		end
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if (flag_done_gen_sk & !flag_delay & valid_out_wr_0 & valid_out_wr_1 & valid_out_wr_2 & valid_out_wr_3 & valid_out_wr_4 & valid_out_wr_5 & valid_out_wr_6 & valid_out_wr_7) begin 
			if (~check_gen_chain) begin // 15 loop 
				pk_out_reg					<= pk_out_reg;
				count_reg					<= count_reg; // prf -> gen_chain : giu nguyen
				count_loop                  <= count_loop;
				count_reg_chain				<= count_reg_chain; // prf -> gen_chain : giu nguyen =0
				count_add					<= count_add;
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
				state_reg_0					<= state_reg_0;
				state_reg_1					<= state_reg_1;
				state_reg_2					<= state_reg_2;
				state_reg_3					<= state_reg_3;
				state_reg_4					<= state_reg_4;
				state_reg_5					<= state_reg_5;
				state_reg_6					<= state_reg_6;
				state_reg_7					<= state_reg_7;
				flag_done_gen_sk			<= 1'b1;
				flag_done_gen_chain			<= 1'b0;
				flag_delay					<= 1'b1;
			end
			else begin // done 15 loop -> check 5 loop if {0,1,2,3} -> start_prf || {5} -> stop
				if (count_loop[2] == 1'b0) begin //{0,1,2,3 -> 8 core}
				pk_out_reg					<= {pk_out_reg[3455:0],state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128],state_out_wr_3[255:128],state_out_wr_4[255:128],state_out_wr_5[255:128],state_out_wr_6[255:128],state_out_wr_7[255:128]};
				count_reg					<= count_reg + 8'd8; // gen_chain -> prf : tang len
				count_loop                  <= count_loop + 1'b1;
				count_reg_chain				<= 1'b0; // gen_chain -> prf : reset = 0
				count_add					<= count_add;
				flag_done_gen_sk			<= 1'b0;
				flag_done_gen_chain			<= 1'b1;
				flag_delay					<= 1'b1;
				end
				else if (count_loop[2] == 1'b1) begin // 3 core stop 
				pk_out_reg					<= {pk_out_reg[4095:0],state_out_wr_0[255:128],state_out_wr_1[255:128],state_out_wr_2[255:128]};
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
				flag_done_gen_chain			<= 1'b0;
				flag_delay					<= 1'b0;
				flag_update					<= 1'b0;
				valid_out 					<= 1'b1; // done
				count_reg					<= 6'b0;
				count_loop                  <= 4'b0;
				end
			end
		end
		else begin
			pk_out_reg					<= pk_out_reg;
			count_reg					<= count_reg; // prf -> gen_chain : giu nguyen
			count_loop                  <= count_loop;
			count_reg_chain				<= count_reg_chain; // prf -> gen_chain : giu nguyen =0
			count_add					<= count_add;
			start_in_reg_core_0			<= 1'b0;
			start_in_reg_core_1			<= 1'b0;
			start_in_reg_core_2			<= 1'b0;
			start_in_reg_core_3			<= 1'b0;
			start_in_reg_core_4			<= 1'b0;
			start_in_reg_core_5			<= 1'b0;
			start_in_reg_core_6			<= 1'b0;
			start_in_reg_core_7			<= 1'b0;
			mess_in_reg_0				<= mess_in_reg_0;
			mess_in_reg_1				<= mess_in_reg_1;
			mess_in_reg_2				<= mess_in_reg_2;
			mess_in_reg_3				<= mess_in_reg_3;
			mess_in_reg_4				<= mess_in_reg_4;
			mess_in_reg_5				<= mess_in_reg_5;
			mess_in_reg_6				<= mess_in_reg_6;
			mess_in_reg_7				<= mess_in_reg_7;
			state_reg_0					<= state_reg_0;
			state_reg_1					<= state_reg_1;
			state_reg_2					<= state_reg_2;
			state_reg_3					<= state_reg_3;
			state_reg_4					<= state_reg_4;
			state_reg_5					<= state_reg_5;
			state_reg_6					<= state_reg_6;
			state_reg_7					<= state_reg_7;
			flag_done_gen_sk			<= flag_done_gen_sk;
			flag_done_gen_chain			<= flag_done_gen_chain;
			flag_delay					<= flag_delay;
			valid_out 					<= 1'b0;
		end
	end
	
	
	
	/*
	
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            count_reg <= 6'b0;
            count_add <= 1'b0;
            start_in_gen_sk <= 1'b0;
            start_in_gen_chain <=1'b0;
            pk_out <= 4480'b0;
            pk_out_reg <= 4480'b0;
            valid_out <= 1'b0;
        end
        else if (start_in) begin
            count_reg <= 6'b0;
            count_add <= 1'b1;
            start_in_gen_sk <= 1'b1;
            start_in_gen_chain <=1'b0;
            pk_out <= 4480'b0;
            pk_out_reg <= 4480'b0;
            valid_out <= 1'b0;
        end
        else if (valid_out_gen_sk) begin
            start_in_gen_sk <= 1'b0;
            start_in_gen_chain <=1'b1;
        end
        else if (valid_out_gen_chain) begin
            //pk_out <= {pk_out_reg[4351:0],out_gen_chain};
            //pk_out_reg <= {pk_out_reg[4351:0],out_gen_chain};
            //count_reg <= count_reg + count_add;
            //start_in_gen_sk <= 1'b1;
            start_in_gen_chain <=1'b0;
            if (check) begin
            pk_out_reg <= 0;
            pk_out <= {pk_out_reg[4351:0],out_gen_chain};
            count_reg <= 6'b0;
            start_in_gen_sk <= 1'b0;
            valid_out <= 1'b1;
            end 
            else if (~check) begin
            pk_out_reg <= {pk_out_reg[4351:0],out_gen_chain};
            count_reg <= 
            
            
             + count_add;
            start_in_gen_sk <= 1'b1;
            valid_out <= 1'b0;
            end
        end
        else begin
            pk_out <= 4480'b0;
            start_in_gen_sk <= 1'b0;
            start_in_gen_chain <=1'b0;            
            valid_out <= 1'b0;
        end
    end
	*/
endmodule
// 8 core gen_chain && not sharing sha256 prf vs gen_chain