//-------------------------------------------------------------------------------------------------//
//  File name	: SHA512_Core_Pipeline.v									                       //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Pipeline technique-based SHA256 Core for Blockchain 				    		   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module sha256(
						input 	wire 			CLK,
						input	wire			RST,
						input	wire			start_in,
						input	wire	[511:0]	message_in,
						input	wire	[255:0]	digest_in,
						output	reg		[255:0]	digest_out,
						output  reg            	valid_out
);
	
	////// Signals
	
	reg  [6:0] 		round_reg;
	reg				round_add;
	
	reg [511:0] 	message_reg;	
	
	wire [31:0] 	W0_wr, W1_wr, W2_wr, W3_wr, W4_wr, W5_wr, W6_wr, W7_wr, W8_wr, W9_wr, W10_wr, W11_wr, W12_wr, W13_wr, W14_wr, W15_wr, W16_wr;
	wire [31:0] 	a_wr, b_wr, c_wr, d_wr, e_wr, f_wr, g_wr, h_wr, a_new_wr, e_new_wr;
	
	reg [255:0] 	digest_reg;	
	reg [255:0] 	digest_init_reg;
	
	wire [31:0] 	sigma0_wr;
	wire [31:0] 	sigma1_wr;
	
	wire [31:0] 	SIGMA0_wr;
	wire [31:0] 	SIGMA1_wr;
	
	wire [31:0]  	Ch_wr;
	wire [31:0]  	Maj_wr;
	reg	 [31:0]		K_reg;
	
	////// Controller
	
	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			round_reg 			<= 7'b0;
			round_add			<= 1'b0;
		end
		else begin
			if(start_in) begin
				round_add			<= 1'b1;
				round_reg 			<= round_reg + 1'b1;
			end
			else if (round_reg == 7'd65) begin
				round_reg  		<= 7'b0;
				round_add		<= 1'b0;
			end
			else begin
				round_add			<= round_add;
				round_reg 			<= round_reg + round_add;
			end
		end
	end
	
	//////Expander

	assign W0_wr = (start_in) ? message_in[511:480]:message_reg[511:480];
	assign W1_wr = (start_in) ? message_in[479:448]:message_reg[479:448];
	assign W2_wr = (start_in) ? message_in[447:416]:message_reg[447:416];
	assign W3_wr = (start_in) ? message_in[415:384]:message_reg[415:384];
	assign W4_wr = (start_in) ? message_in[383:352]:message_reg[383:352];
	assign W5_wr = (start_in) ? message_in[351:320]:message_reg[351:320];
	assign W6_wr = (start_in) ? message_in[319:288]:message_reg[319:288];
	assign W7_wr = (start_in) ? message_in[287:256]:message_reg[287:256];
	assign W8_wr = (start_in) ? message_in[255:224]:message_reg[255:224];
	assign W9_wr = (start_in) ? message_in[223:192]:message_reg[223:192];
	assign W10_wr = (start_in) ? message_in[191:160]:message_reg[191:160];
	assign W11_wr = (start_in) ? message_in[159:128]:message_reg[159:128];
	assign W12_wr = (start_in) ? message_in[127:96]:message_reg[127:96];
	assign W13_wr = (start_in) ? message_in[95:64]:message_reg[95:64];
	assign W14_wr = (start_in) ? message_in[63:32]:message_reg[63:32];
	assign W15_wr = (start_in) ? message_in[31:0]:message_reg[31:0];
	
	assign sigma0_wr = {W1_wr[6:0],W1_wr[31:7],W1_wr[6:0],W1_wr[31:7]}^{W1_wr[17:0],W1_wr[31:18],W1_wr[17:0],W1_wr[31:18]}^{3'b000,W1_wr[31:3],3'b000,W1_wr[31:3]};
	assign sigma1_wr = {W14_wr[16:0],W14_wr[31:17],W14_wr[16:0],W14_wr[31:17]}^{W14_wr[18:0],W14_wr[31:19],W14_wr[18:0],W14_wr[31:19]}^{10'b0000000000,W14_wr[31:10],10'b0000000000,W14_wr[31:10]};

	assign W16_wr = sigma0_wr + sigma1_wr + W0_wr + W9_wr; 
	

	///// Control message_reg
	always @(posedge CLK or negedge RST) 
	begin
		if(RST == 1'b0) begin
			message_reg 	<= 512'b0;
		end
		else begin
			// hang doi. Khi w0 dc tinh toan xong W1 thay the leen gia tri w0 new se nam cuoi hang doi Exe: w0 w1 w2 ... w15 w1 new .... w15 new...
			message_reg <= {W1_wr, W2_wr, W3_wr, W4_wr, W5_wr, W6_wr, W7_wr, W8_wr, W9_wr, W10_wr, W11_wr, W12_wr, W13_wr, W14_wr, W15_wr, W16_wr};
		end
	end
	
	
	///// Compressor

	assign a_wr = (start_in) ? digest_in[255:224]:digest_reg[255:224];
	assign b_wr = (start_in) ? digest_in[223:192]:digest_reg[223:192];
	assign c_wr = (start_in) ? digest_in[191:160]:digest_reg[191:160];
	assign d_wr = (start_in) ? digest_in[159:128]:digest_reg[159:128];
	assign e_wr = (start_in) ? digest_in[127:96 ]:digest_reg[127:96 ];
	assign f_wr = (start_in) ? digest_in[95:64  ]:digest_reg[95:64  ];
	assign g_wr = (start_in) ? digest_in[63:32  ]:digest_reg[63:32  ];
	assign h_wr = (start_in) ? digest_in[31:0   ]:digest_reg[31:0   ];
	
	
	///////// define
	
	assign SIGMA1_wr 	= {e_wr[5:0],e_wr[31:6]} ^ {e_wr[10:0], e_wr[31:11]} ^ {e_wr[24:0], e_wr[31:25]};
	assign SIGMA0_wr 	= {a_wr[1:0], a_wr[31:2]} ^ {a_wr[12:0], a_wr[31:13]} ^ {a_wr[21:0], a_wr[31:22]};
	assign Ch_wr   	 	= (e_wr & f_wr) ^ ((~e_wr) & g_wr);
	assign Maj_wr	 	= (a_wr & b_wr) ^ (a_wr & c_wr) ^ (b_wr & c_wr);

	assign a_new_wr 		= SIGMA0_wr + Maj_wr + K_reg + W0_wr + h_wr + SIGMA1_wr + Ch_wr;
	assign e_new_wr 		= K_reg + W0_wr + h_wr + SIGMA1_wr + Ch_wr + d_wr;

	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			digest_reg			<= 256'h0;
			digest_init_reg		<= 256'h0;
			digest_out			<= 256'h0;
			valid_out			<= 1'b0;
		end
		else begin
			digest_reg		<= {a_new_wr,a_wr,b_wr,c_wr,e_new_wr,e_wr,f_wr,g_wr};
			
			if(start_in) begin								
				digest_init_reg	<= digest_in;
				digest_out			<= 256'h0;
				valid_out			<= 1'b0;
			end
			else if(round_reg == 7'd64) begin
				/// store value
				digest_out[255:224] <= digest_init_reg[255:224] + digest_reg[255:224];
				digest_out[223:192] <= digest_init_reg[223:192] + digest_reg[223:192];
				digest_out[191:160] <= digest_init_reg[191:160] + digest_reg[191:160];
				digest_out[159:128] <= digest_init_reg[159:128] + digest_reg[159:128];
				digest_out[127:96] 	<= digest_init_reg[127:96]  + digest_reg[127:96];
				digest_out[95:64] 	<= digest_init_reg[95:64]   + digest_reg[95:64];  
				digest_out[63:32]	<= digest_init_reg[63:32]   + digest_reg[63:32];  
				digest_out[31:0] 	<= digest_init_reg[31:0]    + digest_reg[31:0];   
				
				valid_out			<= 1'b1;
			end
			else begin				
				digest_init_reg	<= digest_init_reg;				
				digest_out			<= 256'h0;
				valid_out			<= 1'b0;
			end
		end
	end

	always @*
    begin 
      case(round_reg)
		//SHA_256//
		000: K_reg = 32'h428a2f98;
        001: K_reg = 32'h71374491;
        002: K_reg = 32'hb5c0fbcf;
        003: K_reg = 32'he9b5dba5;
        004: K_reg = 32'h3956c25b;
        005: K_reg = 32'h59f111f1;
        006: K_reg = 32'h923f82a4;
        007: K_reg = 32'hab1c5ed5;
        008: K_reg = 32'hd807aa98;
        009: K_reg = 32'h12835b01;
        010: K_reg = 32'h243185be;
        011: K_reg = 32'h550c7dc3;
        012: K_reg = 32'h72be5d74;
        013: K_reg = 32'h80deb1fe;
        014: K_reg = 32'h9bdc06a7;
        015: K_reg = 32'hc19bf174;
        016: K_reg = 32'he49b69c1;
        017: K_reg = 32'hefbe4786;
        018: K_reg = 32'h0fc19dc6;
        019: K_reg = 32'h240ca1cc;
        020: K_reg = 32'h2de92c6f;
        021: K_reg = 32'h4a7484aa;
        022: K_reg = 32'h5cb0a9dc;
        023: K_reg = 32'h76f988da;
        024: K_reg = 32'h983e5152;
        025: K_reg = 32'ha831c66d;
        026: K_reg = 32'hb00327c8;
        027: K_reg = 32'hbf597fc7;
        028: K_reg = 32'hc6e00bf3;
        029: K_reg = 32'hd5a79147;
        030: K_reg = 32'h06ca6351;
        031: K_reg = 32'h14292967;
        032: K_reg = 32'h27b70a85;
        033: K_reg = 32'h2e1b2138;
        034: K_reg = 32'h4d2c6dfc;
        035: K_reg = 32'h53380d13;
        036: K_reg = 32'h650a7354;
        037: K_reg = 32'h766a0abb;
        038: K_reg = 32'h81c2c92e;
        039: K_reg = 32'h92722c85;
        040: K_reg = 32'ha2bfe8a1;
        041: K_reg = 32'ha81a664b;
        042: K_reg = 32'hc24b8b70;
        043: K_reg = 32'hc76c51a3;
        044: K_reg = 32'hd192e819;
        045: K_reg = 32'hd6990624;
        046: K_reg = 32'hf40e3585;
        047: K_reg = 32'h106aa070;
        048: K_reg = 32'h19a4c116;
        049: K_reg = 32'h1e376c08;
        050: K_reg = 32'h2748774c;
        051: K_reg = 32'h34b0bcb5;
        052: K_reg = 32'h391c0cb3;
        053: K_reg = 32'h4ed8aa4a;
        054: K_reg = 32'h5b9cca4f;
        055: K_reg = 32'h682e6ff3;
        056: K_reg = 32'h748f82ee;
        057: K_reg = 32'h78a5636f;
        058: K_reg = 32'h84c87814;
        059: K_reg = 32'h8cc70208;
        060: K_reg = 32'h90befffa;
        061: K_reg = 32'ha4506ceb;
        062: K_reg = 32'hbef9a3f7;
        063: K_reg = 32'hc67178f2;
		default: K_reg = 32'b0;	
      endcase
    end	
	
endmodule
