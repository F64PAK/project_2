`timescale 1ns / 1ps
module crypto_sign_keypair(
        input wire CLK,
        input wire RST,
        input wire start_in,
        input wire [255:0] key_in,
        input wire [127:0] V_in,
        //input wire [319:0] state_seed,
        output reg [255:0] key_out, //suy nghi ve wire 
        output reg [127:0] V_out,   //suy nghi ve wire
        output reg [511:0] sk,      //suy nghi ve wire
        output reg [255:0] pk,      //suy nghi ve wire
        output reg valid_out
    );
    wire valid_rd_wr,
         valid_v_k_wr;
    wire [127:0] rd_out_wr;
    wire [255:0] key_out_wr; 
    wire [127:0] V_out_wr;
    
    wire valid_out_seed_keypair;
    wire [511:0] sk_wr;
    wire [255:0] pk_wr;
    reg [383:0] seed_reg;
	reg [1:0] count_reg;
	/////
	reg start_in_rd,
	    start_in_keypair;
	reg [255:0] key_reg;
    reg [127:0] V_reg;
    ramdombytes ramdombytes_cryto_sign_keypair(
        .CLK(CLK),
        .RST(RST),
        .start_in(start_in_rd),
        .loop_in(32'd3), // 48 bytes = 16*3
        .key_in(key_reg),
        .V_in(V_reg),
        .key_out(key_out_wr),
        .V_out(V_out_wr),
        .x_out(rd_out_wr),
        .valid_exe(valid_rd_wr),
        .valid_out(valid_v_k_wr)
    );
    crypto_sign_seed_keypair crypto_sign_seed_keypair_crypto_sign_keypair(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_keypair),
             .seed(seed_reg), 
             .sk(sk_wr),
             .pk(pk_wr), 
             .valid_out(valid_out_seed_keypair)
    );
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
			key_reg <= 0;
			V_reg   <= 0;
			seed_reg    <= 0;
			count_reg   <= 0;
			start_in_rd <= 0;
	        start_in_keypair <= 0;
        end
		else if (start_in) begin
		    start_in_rd <= 1'b1;
	        start_in_keypair <= 0;
	        key_reg <= key_in;
	        V_reg <= V_in;
			seed_reg   <= 0;
			count_reg  <= 0;
			valid_out <= 1'b0;
		    key_out <= 0;
		    V_out <= 0;
		    sk <= 0;
		    pk <= 0;
		end 
		else if (valid_rd_wr) begin
			seed_reg <= {seed_reg[255:0],rd_out_wr};
			count_reg <= count_reg + 1'b1;
		end
		else if (valid_v_k_wr) begin
			key_out <= key_out_wr;
			V_out <= V_out_wr;
		end
		else if (count_reg == 2'd3) begin
		    start_in_keypair <= 1'b1;
			count_reg <= 0;
		end
		else if (valid_out_seed_keypair) begin
		    valid_out <= 1'b1;
		    key_out <= key_out ;
		    V_out <= V_out ;
		    sk <= sk_wr;
		    pk <= pk_wr;
			seed_reg   <= 0;
			count_reg  <= 0;
		end
		else begin
		    start_in_rd <= 0;
	        start_in_keypair <= 0;
		    valid_out <= 1'b0;
		    //key_out <= 0;
		    //V_out <= 0;
		    sk <= 0;
		    pk <= 0;
		end
    end
endmodule
