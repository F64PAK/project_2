`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 09:01:16 PM
// Design Name: 
// Module Name: hash_message
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


module hash_message(
    input   wire            CLK,
    input   wire            RST,
    input   wire            start_in,
    input   wire    [255:0] pk,
    input   wire    [127:0] R,
    input   wire    [31:0]  loop_in,
    input   wire    [511:0] m, //511 bit/loop
    input   wire    [31:0]  mlen,
    output  reg     [199:0] digest,
    output  reg     [63:0]  tree,
    output  reg     [31:0]  leaf_idx,
    output  reg             valid_done_message,
    output  reg             valid_out
    );
    reg          start_in_sha256_reg;
    reg  [511:0] mess_sha256_reg;
    reg  [319:0] state_reg;
    reg  [255:0] seed;
    reg  [271:0] bufp;
    
    reg  [31:0]  count_reg;
    reg          count_add;
    
    wire [31:0]  check_loop;
    wire [383:0] state_initial_wr;
    wire [255:0] digest_out_sha256_wr;
    wire         valid_out_sha256_wr;
    //wire [63:0]  tree_wr;
    assign state_initial_wr = 319'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd190000000000000000;
    assign check_loop = (count_reg == (loop_in - 1'b1))? 1'b1 : 1'b0;
    RTL_crypto_hashblocks_sha256 SHA256_gen_message_random(   
                    .CLK(CLK),
                    .RST(RST),
                    .start_in(start_in_sha256_reg),
                    //.loop_in(loop_in), // xu li ben ngoai
                    .message_in(mess_sha256_reg),
                    .digest_in(state_reg[319:64]),
                    .digest_out(digest_out_sha256_wr),
                    .valid_out(valid_out_sha256_wr)
                    );
    reg //flag_done_inc,
        flag_done_loop,         // =1 khi het 1 loop de nap message moi
        flag_done_if,           // sau khi su ly het
        flag_done_mgf1,           // xong mgf1
        flag_done_final;           // xong tinh toan output
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
			digest      		   <=  200'b0;
			tree        		   <=  64'b0;
			leaf_idx    		   <=  32'b0;
			valid_out   		   <=  1'b0;
			valid_done_message     <=  1'b0;
			start_in_sha256_reg    <=  1'b0;
			mess_sha256_reg        <=  512'b0;
			state_reg              <=  320'b0;
			seed                   <=  256'b0;
			count_reg              <=  32'b0;
            count_add              <=  1'b0;
            flag_done_loop         <=  1'b0;
            flag_done_if           <=  1'b0;
            //flag_done_inc          <=  1'b0;
            flag_done_mgf1         <=  1'b0;
            flag_done_final        <=  1'b0;
            bufp                   <=  272'b0;
		end
		else if (start_in & !flag_done_loop) begin
		    digest      		   <=  200'b0;
			tree        		   <=  64'b0;
			leaf_idx    		   <=  32'b0;
			valid_out   		   <=  1'b0;
			valid_done_message     <=  1'b0;
			seed                   <=  256'b0;
			count_reg              <=  32'b0;
            count_add              <=  1'b1;
            flag_done_loop         <=  1'b1; // lam bieng doi ten : phan biet voi start_in lan ke tiep
            flag_done_if           <=  1'b0;
            //flag_done_inc          <=  1'b0;
            flag_done_mgf1         <=  1'b0;
            flag_done_final        <=  1'b0;
            bufp                   <=  272'b0;
            //if (mlen < 8) { tinh 1 lan
            // if (mlen >7) tinh 2 lan
            // giong nhau 
            // else : tinh nhieu lan
            start_in_sha256_reg    <=  1'b1;
			mess_sha256_reg        <=  {R[127:0], pk[255:0], m[127:0]};
			state_reg              <=  state_initial_wr;
		end
		else if (start_in & flag_done_loop) begin
		    start_in_sha256_reg    <=  1'b1;
			mess_sha256_reg    	   <=  m; 
		end
		else if (valid_out_sha256_wr & !flag_done_if & !flag_done_mgf1) begin // tinh trong dieu kien if
		    if(mlen < 32'd8) begin // tinh xong 1 lan finalize -> chuyen sang tinh mgf1
		        state_reg       	   <=  state_initial_wr;
		        flag_done_if           <=  1'b1; // tin hieu chuyen sang mgf1
		        mess_sha256_reg        <=  {digest_out_sha256_wr,256'h0000000080000000000000000000000000000000000000000000000000000120}; // chuan bi cho mgf1
		        start_in_sha256_reg    <=  1'b1; //tinh mgf1
		        seed                   <=  digest_out_sha256_wr;
		    end
		    else if (mlen < 32'd16) begin  // tinh them 1 lan (dung check_loop)
                //start_in_sha256_reg    <=  1'b1; cho kich tu start_in hoac du 
                
                //state_reg[319:64]  	   <=  digest_out_sha256_wr;
                if (count_reg + 1'b1 == loop_in) begin
                    flag_done_if           <= 1'b1;
                    state_reg       	   <=  state_initial_wr;
                    count_reg              <=  1'b0;
                    start_in_sha256_reg    <=  1'b1; // tinh mgf1
                    mess_sha256_reg        <=  {digest_out_sha256_wr,256'h0000000080000000000000000000000000000000000000000000000000000120}; // chuan bi cho mgf1                end
                    seed                   <=  digest_out_sha256_wr;
                end
                else begin
                    count_reg              <=  count_reg + count_add;
                    //start_in_sha256_reg    <=  1'b1;
                    valid_done_message     <=  1'b1;
                    //flag_done_loop         <=  1'b1;
                    state_reg[319:64]  	   <=  digest_out_sha256_wr;
                end
		    end
		    else begin
                if (count_reg == loop_in) begin // nhieu hon binh thuong 1 vong lap do tinhs inc_block ton 16 bytes (mlen = mlen - 16 -> tinh seed)
                    flag_done_if           <= 1'b1;
                    state_reg       	   <=  state_initial_wr;
                    count_reg              <=  1'b0;
                    start_in_sha256_reg    <=  1'b1; // tinh mgf1 lsn 2
                    mess_sha256_reg        <=  {digest_out_sha256_wr,256'h0000000080000000000000000000000000000000000000000000000000000120}; // chuan bi cho mgf1                
                    seed                   <=  digest_out_sha256_wr;
                end
                else begin
                    count_reg              <=  count_reg + count_add;
                    //start_in_sha256_reg    <=  1'b1;
                    valid_done_message     <=  1'b1;
                    //flag_done_loop         <=  1'b1;
                    state_reg[319:64]  	   <=  digest_out_sha256_wr;
                end
		    end
		end
		else if (valid_out_sha256_wr & flag_done_if & !flag_done_mgf1) begin // tinh mgf1 lan 2
		    state_reg       	   <=  state_initial_wr;
		    flag_done_if           <=  1'b1; // tin hieu chuyen sang mgf1
            flag_done_mgf1         <=  1'b1;
            bufp[271:16]           <=  digest_out_sha256_wr;
		    mess_sha256_reg        <=  {seed,256'h0000000180000000000000000000000000000000000000000000000000000120}; // chuan bi cho mgf1
	        start_in_sha256_reg    <=  1'b1; //tinh mgf1
		end
		else if (valid_out_sha256_wr & flag_done_mgf1) begin
		    bufp[15:0]             <=  digest_out_sha256_wr[255:240];
		    bufp[271:16]           <=  bufp[271:16];
		    flag_done_final        <=  1'b1;
		    
		    //reset
			valid_out   		   <=  1'b0;
			start_in_sha256_reg    <=  1'b0;
			mess_sha256_reg        <=  512'b0;
			state_reg              <=  320'b0;
			seed                   <=  256'b0;
			count_reg              <=  32'b0;
            count_add              <=  1'b0;
            flag_done_loop         <=  1'b0;
            flag_done_if           <=  1'b0;
            //flag_done_inc          <=  1'b0;
            flag_done_mgf1         <=  1'b0;
		end
		else if (flag_done_final) begin
		    digest      		   <=  bufp[271:72];
			tree        		   <=  {1'b0,bufp[70:8]}; //bufp[71:8] mask
			leaf_idx    		   <=  {29'b0,bufp[2:0]}; //bufp[7:0]  mask
			bufp[271:0]            <=  272'b0;
		    flag_done_final        <=  1'b0;
		    valid_out   		   <=  1'b1;
		end
		else begin
		    digest      		   <=  200'b0;
			tree        		   <=  64'b0;
			leaf_idx    		   <=  32'b0;
			valid_out   		   <=  1'b0;
			valid_done_message     <=  1'b0;
			start_in_sha256_reg    <=  1'b0;
		end
    end
endmodule
