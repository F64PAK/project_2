`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2024 01:36:27 PM
// Design Name: 
// Module Name: gen_message_random
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


module gen_message_random(
    input   wire            CLK,
    input   wire            RST,
    input   wire            start_in,
    input   wire    [31:0]  loop_in,
    input   wire    [127:0] sk_prf,
    input   wire    [127:0] optrand,
    input   wire    [511:0] m, //511 bit/loop
    input   wire    [31:0]  mlen,
    output  reg     [127:0] R,
    output  reg             valid_done_message,
    output  reg             valid_out
    );
    reg  [127:0] m_reg; //lay 48 bytes || luu lai 16 byte
    reg          start_in_sha256_inc_block;
    reg  [511:0] mess_in_reg;
    //reg  [319:0] digest_in_reg; //same _state_reg
    reg  [319:0] state_reg;
    reg          start_in_sha256_reg;
    reg  [511:0] mess_sha256_reg;
    reg  [31:0]  count_reg;
    reg          count_add;
    //reg  [255:0] digest_in_sh256_reg; // state_reg
    wire [31:0]  mlen_2;
    wire [255:0] digest_out_sha256_wr;
    wire         valid_out_sha256_wr;
    wire [319:0] state_wr;
    wire [319:0] state_initial_wr;
    wire         valid_out_process;
    wire [127:0] digest_in_wr_1;
    wire [383:0] para_wr_1;
    assign digest_in_wr_1[127:120] = sk_prf[127:120] ^ 8'h36;
    assign digest_in_wr_1[119:112] = sk_prf[119:112] ^ 8'h36;
    assign digest_in_wr_1[111:104] = sk_prf[111:104] ^ 8'h36;
    assign digest_in_wr_1[103:96]  = sk_prf[103:96]  ^ 8'h36;
    assign digest_in_wr_1[95:88]   = sk_prf[95:88]   ^ 8'h36;
    assign digest_in_wr_1[87:80]   = sk_prf[87:80]   ^ 8'h36;
    assign digest_in_wr_1[79:72]   = sk_prf[79:72]   ^ 8'h36;
    assign digest_in_wr_1[71:64]   = sk_prf[71:64]   ^ 8'h36;
    assign digest_in_wr_1[63:56]   = sk_prf[63:56]   ^ 8'h36;
    assign digest_in_wr_1[55:48]   = sk_prf[55:48]   ^ 8'h36;
    assign digest_in_wr_1[47:40]   = sk_prf[47:40]   ^ 8'h36;
    assign digest_in_wr_1[39:32]   = sk_prf[39:32]   ^ 8'h36;
    assign digest_in_wr_1[31:24]   = sk_prf[31:24]   ^ 8'h36;
    assign digest_in_wr_1[23:16]   = sk_prf[23:16]   ^ 8'h36;
    assign digest_in_wr_1[15:8]    = sk_prf[17:8]    ^ 8'h36;
    assign digest_in_wr_1[7:0]     = sk_prf[7:0]     ^ 8'h36;
    assign para_wr_1 = 383'h363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636;
	
	wire [127:0] digest_in_wr_2;
    wire [383:0] para_wr_2;
    assign digest_in_wr_2[127:120] = sk_prf[127:120] ^ 8'h5c;
    assign digest_in_wr_2[119:112] = sk_prf[119:112] ^ 8'h5c;
    assign digest_in_wr_2[111:104] = sk_prf[111:104] ^ 8'h5c;
    assign digest_in_wr_2[103:96]  = sk_prf[103:96]  ^ 8'h5c;
    assign digest_in_wr_2[95:88]   = sk_prf[95:88]   ^ 8'h5c;
    assign digest_in_wr_2[87:80]   = sk_prf[87:80]   ^ 8'h5c;
    assign digest_in_wr_2[79:72]   = sk_prf[79:72]   ^ 8'h5c;
    assign digest_in_wr_2[71:64]   = sk_prf[71:64]   ^ 8'h5c;
    assign digest_in_wr_2[63:56]   = sk_prf[63:56]   ^ 8'h5c;
    assign digest_in_wr_2[55:48]   = sk_prf[55:48]   ^ 8'h5c;
    assign digest_in_wr_2[47:40]   = sk_prf[47:40]   ^ 8'h5c;
    assign digest_in_wr_2[39:32]   = sk_prf[39:32]   ^ 8'h5c;
    assign digest_in_wr_2[31:24]   = sk_prf[31:24]   ^ 8'h5c;
    assign digest_in_wr_2[23:16]   = sk_prf[23:16]   ^ 8'h5c;
    assign digest_in_wr_2[15:8]    = sk_prf[17:8]    ^ 8'h5c;
    assign digest_in_wr_2[7:0]     = sk_prf[7:0]     ^ 8'h5c;
    assign para_wr_2 = 383'h5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c;
    //sha256_inc_init
    assign mlen_2 = mlen + 32'd16;
    //assign state_initial_wr = {256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19 , 64'h0};
    assign state_initial_wr = 319'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd190000000000000000;
    //assign valid_out = valid_out_process;
    RTL_sha256_inc_blocks sha256_inc_blocks_gen_message_random(
                                                         .CLK(CLK),
                                                         .RST(RST),
                                                         .start_in(start_in_sha256_inc_block),
                                                         .message_in(mess_in_reg),
                                                         .digest_in(state_reg), //state
                                                         .state_out(state_wr),
                                                         .valid_out(valid_out_process)
                                                         );
    reg     flag_inc,
            flag_loop,
            flag_final,
            flag_done;
    wire    check_loop;
    wire    [63:0]  bytes;
    wire    [31:0]  loop_wr;
    assign loop_wr = loop_in - 32'd1;
    assign bytes = 64'd96;
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
   always @(posedge CLK or negedge RST) begin
        if(!RST) begin
			R   						<=  128'b0;
			valid_out  				 	<=  1'b0;
			valid_done_message  		<=  1'b0;
			start_in_sha256_inc_block  	<=  1'b0;
			mess_in_reg    				<=  512'b0;
			//digest_in_reg  				<=  256'b0; //same state_reg
			state_reg  					<=  320'b0;
			start_in_sha256_reg    		<=  1'b0;
			mess_sha256_reg    			<=  512'b0;
			m_reg                       <=  128'b0;
			//digest_in_sh256_reg    		<=  256'b0;
			flag_inc                    <=  1'b0;
			flag_loop                   <=  1'b0;
			flag_final                  <=  1'b0;
			flag_done                   <=  1'b0;
			count_reg                   <=  32'b0;
			count_add                   <=  1'b0;
        end
        else if (start_in & !flag_loop) begin 
            R   						<=  128'b0;
			valid_out  				 	<=  1'b0;
			start_in_sha256_inc_block  	<=  1'b1;
			// tinh state 1
			mess_in_reg    				<=  {digest_in_wr_1,para_wr_1}; //{buf^sk_prf(16bytes),0x36(48byteske)}
			//digest_in_reg  				<=  256'b0;
			state_reg  					<=  state_initial_wr;//320'b0; ||//sha256_inc_init
			start_in_sha256_reg    		<=  1'b0;
			mess_sha256_reg    			<=  512'b0;
			m_reg                       <=  128'b0;
			flag_inc                    <=  1'b0;
			count_reg                   <=  32'b0;
			count_add                   <=  1'b1;
			valid_done_message  		<=  1'b0;
			flag_loop                   <=  1'b1;
			flag_final                  <=  1'b0;
			flag_done                  <=  1'b0;
			//digest_in_sh256_reg    		<=  256'b0;
        end
        else if (start_in & flag_loop) begin
            start_in_sha256_inc_block  	<=  1'b0;
			mess_in_reg    				<=  512'b0;
			start_in_sha256_reg    		<=  1'b1;
			mess_sha256_reg    			<=  m;
			flag_final                  <=  1'b0;
        end
        else if (valid_out_process & !flag_inc) begin
			state_reg  					<=  state_wr;//320'b0; ||//sha256_inc_init (truyen cho sha256 hoac tinh tiep)
			if (mlen_2 < 32'd64) begin //if if (SPX_N + mlen < SPX_SHA256_BLOCK_BYTES) || tun_on sha256 || toi da tinh 2 lan
			     //neu mlen_2 <56 -> tinh 1 lan optrand|m(48bytes) da padded
			     //neu mlen_2 >56 -> tinh 2 lan 
			     //  optrand | m(48btyes da padded)
			     //  m (64 bytes da padded)
			     // tinh toan ve viec truyen 1 lan 64 bytes : 64 - 48 thay vi 48 64 -> them 1 reg (dung tranh lang phi mess_in_reg) 
			     // bo qua viec truyen 64-48 ma truyen theo dang 48- 64 64 64 ---- 64
			    // start_in_sha256_inc_block  	<=  1'b0;
			     start_in_sha256_reg    		<=  1'b1;
			     if (mlen_2 < 32'd56) begin // loop = 1 -> done
			         start_in_sha256_inc_block  	<=  1'b0;
			         mess_in_reg    				<=  512'b0; // phuc vu cho ssha256
			         mess_sha256_reg    			<=  {optrand,m[383:0]};////{optrand(16bytes),m()}
			     end
			     else if (mlen_2 > 32'd55) begin // loop = 2 -> lap 1 lan nua nho vao start_in
			         start_in_sha256_inc_block  	<=  1'b0;
			         //m_reg          				<=  m[127:0]; // phuc vu cho ssha256
			         mess_sha256_reg    			<=  {optrand,m[383:0]};////{optrand(16bytes),m(message)}
			     end
			     //mess_in_reg    				<=  m; // phuc vu cho ssha256
			     //mess_sha256_reg    			<=  {optrand,m[511:128]};////{optrand(16bytes),m(message)}
			     //digest_in_sh256_reg    		<=  256'b0;
			end
			else if (mlen_2 > 32'd63) begin // chay them sha256_inc_block 1 lan nua
			     R   						    <=  128'b0;
			     valid_out  				 	<=  1'b0;
			     start_in_sha256_inc_block  	<=  1'b1;
			     flag_inc                       <=  1'b1;
			// tinh state 1
			     //m_reg          				<=  m[127:0];
			     mess_in_reg    				<=  {optrand,m[383:0]}; //{buf^sk_prf(16bytes),0x36(48byteske)}
			     start_in_sha256_reg    		<=  1'b0;
			     mess_sha256_reg    			<=  512'b0;
			//digest_in_sh256_reg    		<=  256'b0;
			end
        end
        else if (valid_out_process & flag_inc) begin // tinh xong 2 lan inc
                R   	    					<=  128'b0;
			     valid_out  				 	<=  1'b0;
			     valid_done_message  		    <=  1'b1;
			     start_in_sha256_inc_block  	<=  1'b0;
			     flag_inc                       <=  1'b1;
			// tinh state 1
			     state_reg  					<=  state_wr;
			     //m_reg          				<=  m[127:0];
			     mess_in_reg    				<=  512'b0; //{buf^sk_prf(16bytes),0x36(48byteske)}
			     ////////
			     //start_in_sha256_reg    		<=  1'b1; khoi dong khi nhan start_in
			     //mess_sha256_reg    			<=  m;
        end
        else if (valid_out_sha256_wr & !flag_final) begin
            /*
            if (check_loop) begin // sha256 buf 96 byte (padded 128bytes) // sai dieu kien
                    flag_final                  <=  1'b1;
                    start_in_sha256_inc_block  	<=  1'b0;
                    //buf_reg <= {5608'b0,addr_wr,in[127:0],8'h80,136'b0,{bytes[60:0],3'b000}};
                    //512 = 256 _ 1 _ 64
                    mess_in_reg    				<=  {digest_out_sha256_wr,8'h80,184'b0,{bytes[60:0],3'b000}}; // luu 64 bytes_thap
                    state_reg[319:64]  			<=  digest_out_sha256_wr;
                    start_in_sha256_reg    		<=  1'b1;
                    mess_sha256_reg    			<=  {digest_in_wr_2,para_wr_2}; 
                    m_reg                       <=  128'b0;
                    //digest_in_sh256_reg    		<=  256'b0;
                    //flag_inc                    <=  1'b0;
                    //flag_loop                   <=  1'b0;
                    count_reg                   <=  32'b0;
                    count_add                   <=  1'b0;
            end
            */
            //else
             if (mlen_2 < 32'd64) begin        
                if (mlen_2 < 32'd56) begin
                    flag_final                  <=  1'b1;
                    //count_reg                   <=  count_reg + count_add;
                    valid_done_message  		<=  1'b1;
                    start_in_sha256_inc_block  	<=  1'b0;
                    //buf_reg <= {5608'b0,addr_wr,in[127:0],8'h80,136'b0,{bytes[60:0],3'b000}};
                    //512 = 256 _ 1 _ 64
                    mess_in_reg    				<=  {digest_out_sha256_wr,8'h80,184'b0,{bytes[60:0],3'b000}}; // luu 64 bytes_thap
                    //state_reg[319:64]  			<=  digest_out_sha256_wr;
                    state_reg[319:64]  			<= state_initial_wr;
                    //start_in_sha256_reg    		<=  1'b1;
                    mess_sha256_reg    			<=  {digest_in_wr_2,para_wr_2}; 
                    m_reg                       <=  128'b0;
                    //digest_in_sh256_reg    		<=  256'b0;
                    //flag_inc                    <=  1'b0;
                    //flag_loop                   <=  1'b0;
                    //count_reg                   <=  count_reg + count_add;
                    //count_add                   <=  1'b0;
                    count_reg                   <=  32'b0;
                    count_add                   <=  1'b0;
                end
                else if (mlen_2 > 32'd55) begin
                    valid_done_message  		<=  1'b1;
                    start_in_sha256_inc_block  	<=  1'b0;
                    
                    //
                    //start_in_sha256_reg    		<=  1'b0;
                    //mess_sha256_reg    			<=  512'b0;
                    //m_reg                       <=  128'b0;
                    //digest_in_sh256_reg    		<=  256'b0;
                    //flag_inc                    <=  1'b0;
                    //flag_loop                   <=  1'b0;
                    count_reg                   <=  count_reg + count_add;
                    if (count_reg + 1'b1 == loop_in) begin
                    //if (count_reg == loop_wr) begin
                        flag_final                  <=  1'b1;
                        mess_in_reg    				<=  {digest_out_sha256_wr,8'h80,184'b0,{bytes[60:0],3'b000}}; // luu 64 bytes_thap
                        //state_reg[319:64]  			<=  digest_out_sha256_wr;
                        state_reg[319:64]  			<= state_initial_wr;
                        //start_in_sha256_reg    		<=  1'b1;
                        mess_sha256_reg    			<=  {digest_in_wr_2,para_wr_2}; 
                        m_reg                       <=  128'b0;
                    end
                    else begin 
                        state_reg[319:64]  			<=  digest_out_sha256_wr;
                    end
                    //count_add                   <=  1'b0;
                end
            end
            else begin
                    valid_done_message  		<=  1'b1;
                    start_in_sha256_inc_block  	<=  1'b0;
                    state_reg[319:64]  			<=  digest_out_sha256_wr;
                    //
                    //start_in_sha256_reg    		<=  1'b0;
                    //mess_sha256_reg    			<=  512'b0;   
                    count_reg                   <=  count_reg + count_add;
                    mess_in_reg    				<=  {digest_out_sha256_wr,8'h80,184'b0,{bytes[60:0],3'b000}}; // luu 64 bytes_thap
                    mess_sha256_reg    			<=  {digest_in_wr_2,para_wr_2}; 
                    
            end
        end
        else if (check_loop & valid_done_message) begin    
                    flag_final                  <=  1'b1;
                    start_in_sha256_inc_block  	<=  1'b0;
                    state_reg  					<=  state_initial_wr;
                    //buf_reg <= {5608'b0,addr_wr,in[127:0],8'h80,136'b0,{bytes[60:0],3'b000}};
                    //512 = 256 _ 1 _ 64
                    //mess_in_reg    				<=  {digest_out_sha256_wr,8'h08,184'b0,{bytes[60:0],3'b000}}; // luu 64 bytes_thap
                    //state_reg[319:64]  			<=  digest_out_sha256_wr;
                    start_in_sha256_reg    		<=  1'b1;
                    //mess_sha256_reg    			<=  {digest_in_wr_2,para_wr_2}; 
                    m_reg                       <=  128'b0;
                    //digest_in_sh256_reg    		<=  256'b0;
                    //flag_inc                    <=  1'b0;
                    //flag_loop                   <=  1'b0;
                    count_reg                   <=  32'b0;
                    count_add                   <=  1'b0;
                    valid_done_message          <=  1'b0;

        end
        else if ((valid_out_sha256_wr & flag_final & !flag_done)) begin
                    //flag_final                  <=  1'b1;
                    start_in_sha256_inc_block  	<=  1'b0;
                    //buf_reg <= {5608'b0,addr_wr,in[127:0],8'h80,136'b0,{bytes[60:0],3'b000}};
                    //512 = 256 _ 1 _ 64
                    mess_in_reg    				<=  {digest_out_sha256_wr,8'h80,184'b0,{bytes[60:0],3'b000}}; // luu 64 bytes_thap
                    state_reg[319:64] 			<=  digest_out_sha256_wr;
                    start_in_sha256_reg    		<=  1'b1;
                    mess_sha256_reg    			<=  mess_in_reg; 
                    m_reg                       <=  128'b0;
                    flag_done                   <=  1'b1;
        end
        else if (valid_out_sha256_wr & flag_done & flag_final) begin
                    R   						<=  digest_out_sha256_wr[255:128];
                    valid_out  				 	<=  1'b1;
                    valid_done_message  		<=  1'b0;
                    start_in_sha256_inc_block  	<=  1'b0;
                    mess_in_reg    				<=  512'b0;
                    //digest_in_reg  				<=  256'b0; //same state_reg
                    state_reg  					<=  320'b0;
                    start_in_sha256_reg    		<=  1'b0;
                    mess_sha256_reg    			<=  512'b0;
                    m_reg                       <=  128'b0;
                    //digest_in_sh256_reg    		<=  256'b0;
                    flag_inc                    <=  1'b0;
                    flag_loop                   <=  1'b0;
                    flag_final                  <=  1'b0;
                    flag_done                   <=  1'b0;
                    count_reg                   <=  32'b0;
                    count_add                   <=  1'b0;
        end
        else begin
            valid_out  				 	<=  1'b0;
			valid_done_message  		<=  1'b0;
			start_in_sha256_inc_block  	<=  1'b0;
			start_in_sha256_reg    		<=  1'b0;
			R   						<=  128'b0;
        end
   end                                                         
                                                         
endmodule
