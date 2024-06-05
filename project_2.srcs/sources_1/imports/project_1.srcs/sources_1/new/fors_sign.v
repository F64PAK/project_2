`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 10:53:07 PM
// Design Name: 
// Module Name: fors_sign
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


module fors_sign(
    input   wire            CLK,
    input   wire            RST,
    input   wire            start_in,
    input   wire    [199:0] m,
    input   wire    [127:0] sk_seed,
    input   wire    [319:0] state_seed,
    //input   wire    [383:0] pub_seed,
    input   wire    [255:0] fors_addr,
    output  reg     [895:0] sig, 
    output  reg     [127:0] pk,
    output  reg             valid_out_sig,
    output  reg             valid_out
    );
    parameter SPX_ADDR_TYPE_FORSTREE = 8'd3;
    parameter SPX_ADDR_TYPE_FORSPK = 8'd4;
	parameter SPX_FORS_HEIGHT = 8'd6;
    reg    [1055:0] indices_reg;
    reg    [4223:0] root_reg;
    reg    [5:0]    count_reg;
    reg             count_add;
    reg	            start_in_thash_reg;
    wire   [255:0]  fors_pk_addr_wr,
                    fors_tree_addr_wr;
    wire   [1055:0] indices_wr;
	reg    [31:0]   idx_offset_reg;
	wire	[31:0]	sum,sum2;
    wire	[127:0]	out_gen_sk,
					root_wr;
	reg				start_in_gen_sk;
	wire			valid_out_gen_sk,
					valid_out_treehash;
	wire	[767:0]	auth_path_wr;
	wire			check_loop;
	wire    [31:0]  indices_1,
	                indices_2;
	wire    [127:0] pk_wr;
	wire            valid_out_thash;
	assign indices_1 = indices_reg[1055:1024];
	assign indices_2 = indices_reg[1023:992];
	assign	check_loop = (count_reg == 6'd32)? 1'b1 : 1'b0;
	assign	sum = indices_wr[1055:1024] + idx_offset_reg;
	assign	sum2 = indices_1 + idx_offset_reg;
	
    //copy_keypair_addr
	assign  fors_pk_addr_wr[255:192] = fors_addr[255:192];
	assign  fors_pk_addr_wr[167:160] = fors_addr[167:160];
	assign  fors_pk_addr_wr[143:136] = fors_addr[143:136];
    //set_type
	assign  fors_pk_addr_wr[175:168] = SPX_ADDR_TYPE_FORSPK;
    assign  fors_pk_addr_wr[191:176] = 0;
	assign  fors_pk_addr_wr[159:144] = 0;
	assign  fors_pk_addr_wr[135:0] = 0;
	//fors_tree_addr_reg 	<= {fors_tree_addr_wr[255:128],sum2[23:16],sum2[31:24],8'b0,fors_tree_addr_wr[103:80],sum2[7:0],sum2[15:8],fors_tree_addr_wr[63:0]};
    //copy_keypair_addr
	assign  fors_tree_addr_wr[255:192] = fors_addr[255:192];
	assign  fors_tree_addr_wr[191:176] = 0;
	assign  fors_tree_addr_wr[167:160] = fors_addr[167:160];
	assign  fors_tree_addr_wr[143:136] = fors_addr[143:136];
    //set_type
	assign  fors_tree_addr_wr[175:168] = SPX_ADDR_TYPE_FORSTREE;   
	//
	assign  fors_tree_addr_wr[127:118] = sum2[23:16];
	assign  fors_tree_addr_wr[119:112] = sum2[31:24];
	assign  fors_tree_addr_wr[111:104] = 8'b0;
	assign  fors_tree_addr_wr[103:80] = 24'b0; 
	assign  fors_tree_addr_wr[79:72] = sum2[7:0];
	assign  fors_tree_addr_wr[71:64] = sum2[15:8];
	assign  fors_tree_addr_wr[63:0]  = 64'b0; 
	assign  fors_tree_addr_wr[159:144] = 0;
	assign  fors_tree_addr_wr[135:128] = 0;
    // tree_height || set_type
    //assign addr_wr = {addr[255:128],sum[23:16],sum[31:24],count[7:0],addr[103:80],sum[7:0],sum[15:8],addr[63:0]};
    /*
	//set_tree_index
	assign  addr[127:120] = addr_idx[23:16];
	assign  addr[119:112] = addr_idx[31:24];
	assign  addr[79:72]   = addr_idx[7:0];
	assign  addr[71:64]   = addr_idx[15:8];
    */  
    message_to_indices message_to_indices_fors_sign(.m(m),.indices(indices_wr));             
	
	//assign 	start_in_treehash = valid_out_gen_sk;
    prf_addr fors_gen_sk_fors_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_gen_sk),
             .key(sk_seed),
             .addr(fors_tree_addr_wr),
             .out(out_gen_sk),
             .valid_out(valid_out_gen_sk) 
    );

    /*
    treehash treehash_fors_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_treehash_reg),
             .mode(1'b1),
             .sk_seed(sk_seed),
             .state_seed(state_seed),
             .pub_seed(pub_seed), // khong su dung
             .tree_addr(fors_tree_addr_wr),
             .leaf_idx(indices_1),//bytes cao nhat
             .idx_offset(idx_offset_reg),
             .tree_height(32'd6),
             .auth_path_out(auth_path_wr),
             .root(root_wr), 
             .valid_out(valid_out_treehash)
    );
    */
    //test
    treehash treehash_fors_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(valid_out_gen_sk),
             .mode(1'b1),
             .sk_seed(sk_seed),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .tree_addr(fors_tree_addr_wr),
             //.tree_addr(256'h123456789abcdef0000003df0000ac0000000000000003000000000000000000),
             //.leaf_idx(32'h00000010),//bytes cao nhat
             .leaf_idx(indices_1),//bytes cao nhat
             //.idx_offset(32'h00000040),
             .idx_offset(idx_offset_reg),
             .tree_height(32'd6),
             .auth_path_out(auth_path_wr),
             .root(root_wr), 
             .valid_out(valid_out_treehash)
    );
    thash thash_fors_sign(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_thash_reg),
             .in(root_reg),
             .mode(2'b10),
             .state_seed(state_seed), // pub_seed nay la state_seed
             //.pub_seed(pub_seed), // khong su dung
             .addr(fors_pk_addr_wr),
             .out(pk_wr),
             .valid_out(valid_out_thash));
    
	always @(posedge CLK or negedge RST) begin
	   if(!RST) begin
			sig                      <=896'b0;
			valid_out_sig            <=1'b0;
			indices_reg              <=1056'b0;
			root_reg                 <=4224'b0;
			count_reg                <=6'b0;
			count_add                <=1'b0;
			start_in_thash_reg       <=1'b0;
			idx_offset_reg           <=32'b0;
			start_in_gen_sk          <=1'b0;
	   end
	   else if(start_in) begin
	        sig                      <=896'b0;
			valid_out_sig            <=1'b0;
			indices_reg              <=indices_wr;
			root_reg                 <=4224'b0;
			count_reg                <=6'b0;
			count_add                <=1'b1;
			start_in_thash_reg       <=1'b0;//
			idx_offset_reg           <=32'b0;//
			start_in_gen_sk          <=1'b1;
	   end
	   else if(valid_out_gen_sk) begin
	        sig[895:768] <= out_gen_sk;
	   end
	   else if(valid_out_treehash) begin
	        root_reg <= {root_reg[4095:0],root_wr};
	        sig[767:0] <= auth_path_wr;
	        valid_out_sig            <=1'b1;
	        
	        if(~check_loop) begin
	           count_reg <= count_reg + count_add;
	           start_in_gen_sk          <=1'b1;
			   indices_reg <= {indices_reg[1023:0],32'b0};
	        end
	        else begin
	           start_in_thash_reg    <= 1'b1;
	           count_reg             <=6'b0;
			   count_add             <=1'b0;
	        end
	        //indices_reg <= {indices}
	   end //// reset cac thanh ghi khi valid_out 
	   else if (valid_out_thash) begin
	        pk                       <=pk_wr;
	        valid_out                <=1'b1;
	        
	        sig                      <=896'b0; //
			valid_out_sig            <=1'b0;
			indices_reg              <=1056'b0;
			root_reg                 <=4224'b0; //
			count_reg                <=6'b0;
			count_add                <=1'b0;
			start_in_thash_reg       <=1'b0;
			idx_offset_reg           <=32'b0;
			start_in_gen_sk          <=1'b0;
	   end
	   else begin 
	        pk                       <=128'b0;
	        valid_out                <=1'b0;
	        //sig[896:768]             <=128'b0;
			valid_out_sig            <=1'b0;
			start_in_thash_reg       <=1'b0;
			start_in_gen_sk          <=1'b0;
	   end
	end
    
    always @*
    begin
        case(count_reg)
            6'd00: idx_offset_reg <= 32'h00000000;
            6'd01: idx_offset_reg <= 32'h00000040;
            6'd02: idx_offset_reg <= 32'h00000080;
            6'd03: idx_offset_reg <= 32'h000000c0;
            6'd04: idx_offset_reg <= 32'h00000100;
            6'd05: idx_offset_reg <= 32'h00000140;
            6'd06: idx_offset_reg <= 32'h00000180;
            6'd07: idx_offset_reg <= 32'h000001c0;
            6'd08: idx_offset_reg <= 32'h00000200;
            6'd09: idx_offset_reg <= 32'h00000240;
            6'd10: idx_offset_reg <= 32'h00000280;
            6'd11: idx_offset_reg <= 32'h000002c0;
            6'd12: idx_offset_reg <= 32'h00000300;
            6'd13: idx_offset_reg <= 32'h00000340;
            6'd14: idx_offset_reg <= 32'h00000380;
            6'd15: idx_offset_reg <= 32'h000003c0;
            6'd16: idx_offset_reg <= 32'h00000400;
            6'd17: idx_offset_reg <= 32'h00000440;
            6'd18: idx_offset_reg <= 32'h00000480;
            6'd19: idx_offset_reg <= 32'h000004c0;
            6'd20: idx_offset_reg <= 32'h00000500;
            6'd21: idx_offset_reg <= 32'h00000540;
            6'd22: idx_offset_reg <= 32'h00000580;
            6'd23: idx_offset_reg <= 32'h000005c0;
            6'd24: idx_offset_reg <= 32'h00000600;
            6'd25: idx_offset_reg <= 32'h00000640;
            6'd26: idx_offset_reg <= 32'h00000680;
            6'd27: idx_offset_reg <= 32'h000006c0;
            6'd28: idx_offset_reg <= 32'h00000700;
            6'd29: idx_offset_reg <= 32'h00000740;
            6'd30: idx_offset_reg <= 32'h00000780;
            6'd31: idx_offset_reg <= 32'h000007c0;
            6'd32: idx_offset_reg <= 32'h00000800;
            default: idx_offset_reg <= 32'b0;
        endcase
    end
endmodule
