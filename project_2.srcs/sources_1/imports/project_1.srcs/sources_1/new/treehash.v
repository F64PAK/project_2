`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 08:32:39 AM
// Design Name: 
// Module Name: treehash
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


module treehash(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire            mode,
             input  wire    [127:0] sk_seed,
             input	wire	[319:0]	state_seed,
             //input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	tree_addr,
             input  wire    [31:0]  leaf_idx,
             input  wire    [31:0]  idx_offset,
             input  wire    [31:0]  tree_height,
             output reg     [767:0] auth_path_out,
             output	reg	    [127:0] root, 
             output reg           	valid_out
    );
    // stack [895:768][767:640][639:512][511:384][383:256][255:128][127:0]
    //[20:18][17:15][14:12][11:9][8:6][5:3][2:0]
    //[27:24][23:20][19:16][15:12][11:8][7:4][3:0]
    reg [767:0] auth_path;
    reg [895:0] stack_reg;
    reg [27:0] height_reg;
    reg [6:0] idx; //count_reg
    reg [3:0] offset_reg;
    reg count_add;
    reg start_in_gen_leaf_reg,
        start_in_thash_reg;
    reg [255:0] tree_addr_reg;
    reg flag;
    wire [127:0] stack_0,stack_1,stack_2;
    wire [2:0] height_0,height_1, height_2,height_3 ; 
    wire [127:0] auth_path_0,auth_path_1;
    wire [6:0] end_count;
    wire check_loop ;
    wire check_authpath;
    wire check_while;
    wire [6:0] tree_idx;
    wire check_authpath_while ;
    wire [31:0] addr_idx_gen_leaf_wr, tree_index, tree_index_thash;
    wire [255:0] tree_addr_wr;
    wire [127:0] stack_0_out_wr,
                 stack_2_out_thash_wr;
    wire valid_out_gen_leaf_wr,
         valid_out_thash_wr;
    wire check_next_loop;
    wire [7:0] tree_addr_idx,tree_addr_idx_thash;
    reg check_condition_loop;
    //stack [895:768][767:640][639:512][511:384][383:256][255:128][127:0]
    assign tree_addr_idx = height_1 + 1'b1;
    assign tree_addr_idx_thash = height_2 + 2'd2;
    assign stack_0 = (offset_reg == 4'd0) ? stack_reg[895:768] :
                     ((offset_reg == 4'd1)? stack_reg[767:640] : 
                     ((offset_reg == 4'd2)? stack_reg[639:512] : 
                     ((offset_reg == 4'd3)? stack_reg[511:384] :
                     ((offset_reg == 4'd4)? stack_reg[383:256] :
                     ((offset_reg == 4'd5)? stack_reg[255:128] :
                     ((offset_reg == 4'd6)? stack_reg[127:0] :
                     128'd0))))));
    assign stack_1 = (offset_reg == 4'd0) ? 128'd0 :
                     ((offset_reg == 4'd1)? stack_reg[895:768] : 
                     ((offset_reg == 4'd2)? stack_reg[767:640] : 
                     ((offset_reg == 4'd3)? stack_reg[639:512] :
                     ((offset_reg == 4'd4)? stack_reg[511:384] :
                     ((offset_reg == 4'd5)? stack_reg[383:256] :
                     ((offset_reg == 4'd6)? stack_reg[255:128]   :
                     ((offset_reg == 4'd7)? stack_reg[127:0] :
                     128'd0
                     )))))));
    assign stack_2 = (offset_reg == 4'd0) ? 128'd9997 :
                     ((offset_reg == 4'd1)? 128'd9997 : 
                     ((offset_reg == 4'd2)? stack_reg[895:768] : 
                     ((offset_reg == 4'd3)? stack_reg[767:640] :
                     ((offset_reg == 4'd4)? stack_reg[639:512] :
                     ((offset_reg == 4'd5)? stack_reg[511:384] :
                     ((offset_reg == 4'd6)? stack_reg[383:256] :
                     ((offset_reg == 4'd7)? stack_reg[255:128] :
                     ((offset_reg == 4'd8)? stack_reg[127:0]   :
                     128'd0))
                     ))))));
    
    assign auth_path_0 = (offset_reg == 4'd0) ? auth_path[767:640] :
                     ((offset_reg == 4'd1)? auth_path[639:512] : 
                     ((offset_reg == 4'd2)? auth_path[511:384] : 
                     ((offset_reg == 4'd3)? auth_path[383:256] :
                     ((offset_reg == 4'd4)? auth_path[255:128] :
                     ((offset_reg == 4'd5)? auth_path[127:0] :
                     128'd0)))));
    assign auth_path_1 = (offset_reg == 4'd0) ? 128'd0 :
                     ((offset_reg == 4'd1)? auth_path[767:640] : 
                     ((offset_reg == 4'd2)? auth_path[639:512] : 
                     ((offset_reg == 4'd3)? auth_path[511:384] :
                     ((offset_reg == 4'd4)? auth_path[383:256] :
                     ((offset_reg == 4'd5)? auth_path[255:128] :
                     ((offset_reg == 4'd6)? auth_path[127:0]   :
                     128'd0
                     ))))));
    /*
	[27:24]
	[23:20]
	[19:16]
	[15:12]
	[11:8]
	[7:4]
	[3:0] 
	*/
	assign height_0 = (offset_reg == 4'd0)? height_reg[27:24] : 
                     ((offset_reg == 4'd1)? height_reg[23:20] :  
                     ((offset_reg == 4'd2)? height_reg[19:16] : 
                     ((offset_reg == 4'd3)? height_reg[15:12] :
                     ((offset_reg == 4'd4)? height_reg[11:8]  :
                     ((offset_reg == 4'd5)? height_reg[7:4]   :
                     ((offset_reg == 4'd6)? height_reg[3:0]   :                     
                     3'd4
                     ))))));
    assign height_1 = (offset_reg == 4'd0) ? 4'h5 :
                     ((offset_reg == 4'd1)? height_reg[27:24] : 
                     ((offset_reg == 4'd2)? height_reg[23:20] : 
                     ((offset_reg == 4'd3)? height_reg[19:16] :
                     ((offset_reg == 4'd4)? height_reg[15:12] :
                     ((offset_reg == 4'd5)? height_reg[11:8]  :
                     ((offset_reg == 4'd6)? height_reg[7:4]   :
                     ((offset_reg == 4'd7)? height_reg[3:0]   :
                     3'd5
                     ))))))); 
    assign height_2 = (offset_reg == 4'd0) ? 4'd6 :
                     ((offset_reg == 4'd1)? 4'd6 : 
                     ((offset_reg == 4'd2)? height_reg[27:24] : 
                     ((offset_reg == 4'd3)? height_reg[23:20] :
                     ((offset_reg == 4'd4)? height_reg[19:16] :
                     ((offset_reg == 4'd5)? height_reg[15:12] :
                     ((offset_reg == 4'd6)? height_reg[11:8]  :
                     ((offset_reg == 4'd7)? height_reg[7:4]   :
                     ((offset_reg == 4'd8)? height_reg[3:0]   :
                     3'h6))
                     ))))));
	assign height_3 = (offset_reg == 4'd0) ?4'd7 :
                     ((offset_reg == 4'd1)? 4'd7 : 
                     ((offset_reg == 4'd2)? 4'd7 : 
                     ((offset_reg == 4'd3)? height_reg[27:24] :
                     ((offset_reg == 4'd4)? height_reg[23:20] :
                     ((offset_reg == 4'd5)? height_reg[19:16] :
                     ((offset_reg == 4'd6)? height_reg[15:12] :
                     ((offset_reg == 4'd7)? height_reg[11:8]  :
                     ((offset_reg == 4'd8)? height_reg[7:4]   :
					 ((offset_reg == 4'd9)? height_reg[3:0]   :
                     3'h7)))
                     ))))));					 
   // height thieu bit
    //assign end_count = (tree_height == 32'd3) ? 7'd8 : 7'd64;
    wire [31:0] value_check_authpath;
    assign value_check_authpath = (leaf_idx ^ 1'd1);
    assign end_count = ((tree_height==32'd3)? 7'd7 : ((tree_height==32'd6) ? 7'd63 : 7'd0));
    assign check_loop = (idx > end_count)? 1'b1 : 1'b0; // check vong lap if ben ngoai
    assign check_authpath = (value_check_authpath == idx)? 1'b1 : 1'b0; // check auth path
    assign check_while = (offset_reg > 4'd1 && height_2 == height_1) ? 1'b1 : 1'b0; //check_while
    assign tree_idx = idx >> (height_1 + 1'b1);
    //assign check_authpath_while = (( (leaf_idx >> height_1) ^ 1'b1) == tree_idx);
    assign check_authpath_while = (( (leaf_idx >> (height_2 + 1'b1)) ^ 1'b1) == tree_idx);
    assign addr_idx_gen_leaf_wr = idx_offset + idx;
    assign tree_index = (tree_idx + (idx_offset >> (height_1 + 1'b1)));
    assign tree_index_thash = ((idx >> (height_2 + 2'd2)) + (idx_offset >> (height_2 + 2'd2)));
    assign tree_addr_wr = tree_addr_reg; // xu li trong tree_addr
    assign check_next_loop = ((~check_while && valid_out_gen_leaf_wr) || (check_while && valid_out_thash_wr )) ? 1'b1 : 1'b0;
    
    // gen_leaf || gen_leaf && thash
    /*
    assign tree_addr_wr[255:128] = tree_addr[255:128] ;
    assign tree_addr_wr[103:73] =  tree_addr[103:73] ;
    assign tree_addr_wr[63:0] = tree_addr[63:0] ;
    assign tree_addr_wr[127:120] = tree_index[23:16] ;
    assign tree_addr_wr[119:112] = tree_index[31:24] ;
    assign tree_addr_wr[79:72] = tree_index[7:0] ;
    assign tree_addr_wr[71:64] = tree_index[15:8] ;
    assign tree_addr_wr[111:104] = height_1 + 1'b1;
    */
    // xu li start_in || out_wr || out_valid
    wire start_in_gen_leaf_wots,
         start_in_gen_leaf_fors,
         valid_out_wots,
         valid_out_fors;
    wire [127:0] leaf_wots,
                 leaf_fors;     
    assign start_in_gen_leaf_wots = (!mode)? start_in_gen_leaf_reg : 1'b0;
    assign start_in_gen_leaf_fors = (mode)? start_in_gen_leaf_reg : 1'b0;
    assign stack_0_out_wr = (mode)?  leaf_fors : leaf_wots;
    assign valid_out_gen_leaf_wr = (mode)?  valid_out_fors : valid_out_wots;
    wots_gen_leaf wots_gen_leaf_treehash(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_gen_leaf_wots),
             .sk_seed(sk_seed),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .tree_addr(tree_addr_wr),
             .addr_idx(addr_idx_gen_leaf_wr),
             .leaf(leaf_wots), //4480
             .valid_out(valid_out_wots)
    );
    fors_gen_leaf fors_gen_leaf_treehash(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_gen_leaf_fors),
             .sk_seed(sk_seed),
             .state_seed(state_seed),
             //.pub_seed(pub_seed), // khong su dung
             .tree_addr(tree_addr_wr),
             .addr_idx(addr_idx_gen_leaf_wr),
             .leaf(leaf_fors), //4480
             .valid_out(valid_out_fors)
    );
    thash thash_treehash(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_thash_reg),
             .in({stack_2,stack_1}),
             .mode(2'b01),
             .state_seed(state_seed), // pub_seed nay la state_seed
             //.pub_seed(pub_seed), // khong su dung
             .addr(tree_addr_wr),
             .out(stack_2_out_thash_wr),
             .valid_out(valid_out_thash_wr) );
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            stack_reg <= 0;
            height_reg <= 28'habcdefa;
            idx <= 0; //count_reg
            offset_reg <= 0;
            count_add <= 0;
            start_in_gen_leaf_reg <= 0; // suy nghi ve 2 start_in
            start_in_thash_reg <= 0;
            tree_addr_reg <= 0;
            auth_path <= 0;
            auth_path_out <=0;
            root <= 0;
            valid_out<= 0;
            check_condition_loop <= 0;
            flag <=0;
        end
        else if (start_in) begin // thuc thi gen_leaf
            stack_reg <= 0;
            height_reg <= 28'habcdefa;
            idx <= 0; //count_reg //test
            offset_reg <= 0;
            count_add <= 1;
            start_in_gen_leaf_reg <= 1; // suy nghi ve 2 start_in
            start_in_thash_reg <= 0;
            tree_addr_reg <= tree_addr;
            auth_path <= 0;
            auth_path_out <= 0;
            root <= 0;
            valid_out<= 0;
            check_condition_loop <= 0;
            flag <= 1;
        end
        else if (check_loop) begin
            idx <= 0; //count_reg
            offset_reg <= 0;
            count_add <= 0;
            start_in_gen_leaf_reg <= 0; // suy nghi ve 2 start_in
            start_in_thash_reg <= 0;
            //tree_addr_reg <= 0;
            auth_path_out <= auth_path;
            root <= stack_reg[895:768];
            valid_out <= 1;
            check_condition_loop <= 0;
            //
            flag = 0;
            stack_reg <= 0;
            tree_addr_reg <=0;
            auth_path <= 0;
            height_reg <=28'habcdefa;
            //
        end

        else if (idx[0] == 0 && flag == 1'b1) begin // gen_leaf
		valid_out<= 0;
		auth_path_out <=0;
        root <= 0;
        if (valid_out_gen_leaf_wr) begin //valid_out_gen_leaf
            offset_reg <= offset_reg + count_add;
            if      (offset_reg == 4'd0) height_reg[27:24] <= 3'd0;
            else if (offset_reg == 4'd1) height_reg[23:20] <= 3'd0;
            else if (offset_reg == 4'd2) height_reg[19:16] <= 3'd0;
            else if (offset_reg == 4'd3) height_reg[15:12] <= 3'd0;
            else if (offset_reg == 4'd4) height_reg[11:8]  <= 3'd0;
            else if (offset_reg == 4'd5) height_reg[7:4]   <= 3'd0;
            else if (offset_reg == 4'd6) height_reg[3:0]   <= 3'd0;
            // stack [895:768][767:640][639:512][511:384][383:256][255:128][127:0]
            if      (offset_reg == 4'd0) stack_reg <= {stack_0_out_wr,stack_reg[767:0]};
            else if (offset_reg == 4'd1) stack_reg <= {stack_reg[895:768],stack_0_out_wr,stack_reg[639:0]};
            else if (offset_reg == 4'd2) stack_reg <= {stack_reg[895:640],stack_0_out_wr,stack_reg[511:0]};
            else if (offset_reg == 4'd3) stack_reg <= {stack_reg[895:512],stack_0_out_wr,stack_reg[383:0]};
            else if (offset_reg == 4'd4) stack_reg <= {stack_reg[895:384],stack_0_out_wr,stack_reg[255:0]};
            else if (offset_reg == 4'd5) stack_reg <= {stack_reg[895:256],stack_0_out_wr,stack_reg[127:0]};
            else if (offset_reg == 4'd6) stack_reg <= {stack_reg[895:128],stack_0_out_wr};   
        
            if (check_authpath) begin
                auth_path[767:640] <= stack_0_out_wr;
            end
            idx <= idx + count_add;
            start_in_gen_leaf_reg <= 1;
            start_in_thash_reg <= 0;
            check_condition_loop <= 0;
            end
        else begin
            start_in_gen_leaf_reg <= 0; // suy nghi ve 2 start_in
            start_in_thash_reg <= 0;
            root <= 0;
            valid_out<= 0;
            end
        end
        else if (idx[0] == 1 && flag == 1'b1) begin
		auth_path_out <=0;
        root <= 0;
        valid_out<= 0;
            if (start_in_gen_leaf_reg) begin
            tree_addr_reg <= {tree_addr[255:128],tree_index[23:16],tree_index[31:24],tree_addr_idx,tree_addr[103:80],
                          tree_index[7:0],tree_index[15:8],tree_addr[63:0]};
                
            end
            if (start_in_thash_reg && (offset_reg - 1'd1) > 4'd1 && ((height_2 + 1'b1) == (height_3))) begin
            tree_addr_reg <= {tree_addr[255:128],tree_index_thash[23:16],tree_index_thash[31:24],tree_addr_idx_thash,tree_addr[103:80],
                          tree_index_thash[7:0],tree_index_thash[15:8],tree_addr[63:0]};
            end
            if (valid_out_gen_leaf_wr) begin //valid_out_gen_leaf
                offset_reg <= offset_reg + count_add;
                //[20:18][17:15][14:12][11:9][8:6][5:3][2:0]
                if      (offset_reg == 4'd0) height_reg[27:24] <= 3'd0;
                else if (offset_reg == 4'd1) height_reg[23:20] <= 3'd0;
                else if (offset_reg == 4'd2) height_reg[19:16] <= 3'd0;
                else if (offset_reg == 4'd3) height_reg[15:12] <= 3'd0;
                else if (offset_reg == 4'd4) height_reg[11:8]  <= 3'd0;
                else if (offset_reg == 4'd5) height_reg[7:4]   <= 3'd0;
                else if (offset_reg == 4'd6) height_reg[3:0]   <= 3'd0;
                // stack [895:768][767:640][639:512][511:384][383:256][255:128][127:0]
                if      (offset_reg == 4'd0) stack_reg <= {stack_0_out_wr,stack_reg[767:0]};
                else if (offset_reg == 4'd1) stack_reg <= {stack_reg[895:768],stack_0_out_wr,stack_reg[639:0]};
                else if (offset_reg == 4'd2) stack_reg <= {stack_reg[895:640],stack_0_out_wr,stack_reg[511:0]};
                else if (offset_reg == 4'd3) stack_reg <= {stack_reg[895:512],stack_0_out_wr,stack_reg[383:0]};
                else if (offset_reg == 4'd4) stack_reg <= {stack_reg[895:384],stack_0_out_wr,stack_reg[255:0]};
                else if (offset_reg == 4'd5) stack_reg <= {stack_reg[895:256],stack_0_out_wr,stack_reg[127:0]};
                else if (offset_reg == 4'd6) stack_reg <= {stack_reg[895:128],stack_0_out_wr};   
                
                if (check_authpath) begin
                    auth_path[767:640] <= stack_0_out_wr;
                end
                //tree_addr_reg <= {tree_addr[255:128],tree_index[23:16],tree_index[31:24],tree_addr_idx,tree_addr[103:80],
                //          tree_index[7:0],tree_index[15:8],tree_addr[63:0]};
                start_in_gen_leaf_reg <= 0;
                start_in_thash_reg <= 1;
                check_condition_loop <= 1;
            end
            else if (valid_out_thash_wr) begin
                offset_reg <= offset_reg - count_add;
            // stack [895:768][767:640][639:512][511:384][383:256][255:128][127:0]
                if      (offset_reg == 4'd2) stack_reg <= {stack_2_out_thash_wr,stack_reg[767:0]};
                else if (offset_reg == 4'd3) stack_reg <= {stack_reg[895:768],stack_2_out_thash_wr,stack_reg[639:0]};
                else if (offset_reg == 4'd4) stack_reg <= {stack_reg[895:640],stack_2_out_thash_wr,stack_reg[511:0]};
                else if (offset_reg == 4'd5) stack_reg <= {stack_reg[895:512],stack_2_out_thash_wr,stack_reg[383:0]};
                else if (offset_reg == 4'd6) stack_reg <= {stack_reg[895:384],stack_2_out_thash_wr,stack_reg[255:0]};
                else if (offset_reg == 4'd7) stack_reg <= {stack_reg[895:256],stack_2_out_thash_wr,stack_reg[127:0]};
                else if (offset_reg == 4'd8) stack_reg <= {stack_reg[895:128],stack_2_out_thash_wr}; 
                //[20:18][17:15][14:12][11:9][8:6][5:3][2:0]
                if (check_condition_loop) begin
                    if      (offset_reg == 4'd2) height_reg[27:24] <= height_reg[27:24] + 1'b1;
                    else if (offset_reg == 4'd3) height_reg[23:20] <= height_reg[23:20] + 1'b1;
                    else if (offset_reg == 4'd4) height_reg[19:16] <= height_reg[19:16] + 1'b1;
                    else if (offset_reg == 4'd5) height_reg[15:12] <= height_reg[15:12] + 1'b1;
                    else if (offset_reg == 4'd6) height_reg[11:8]  <= height_reg[11:8]  + 1'b1;
                    else if (offset_reg == 4'd7) height_reg[7:4]   <= height_reg[7:4]   + 1'b1;
                    else if (offset_reg == 4'd8) height_reg[3:0]   <= height_reg[3:0]   + 1'b1;
                    else height_reg <= height_reg;
                end else begin
                    if      (offset_reg == 4'd2) height_reg[27:24] <= height_reg[27:24] + 1'b1;
                    else if (offset_reg == 4'd3) height_reg[23:20] <= height_reg[23:20] + 1'b1;
                    else if (offset_reg == 4'd4) height_reg[19:16] <= height_reg[19:16] + 1'b1;
                    else if (offset_reg == 4'd5) height_reg[15:12] <= height_reg[15:12] + 1'b1;
                    else if (offset_reg == 4'd6) height_reg[11:8]  <= height_reg[11:8]  + 1'b1;
                    else if (offset_reg == 4'd7) height_reg[7:4]   <= height_reg[7:4]   + 1'b1;
                    else if (offset_reg == 4'd8) height_reg[3:0]   <= height_reg[3:0]   + 1'b1;
                    else height_reg <= height_reg;
                end
                
                if (check_authpath_while) begin
                //auth_path [767:640][639:512][511:384][383:256][255:128][127:0]
                //if (height_2 == 3'd0) auth_path <= {stack_2,auth_path[639:0]};
                if (height_2 == 3'd0) auth_path <= {auth_path[767:640],stack_2_out_thash_wr,auth_path[511:0]};
                else if (height_2 == 3'd1) auth_path <= {auth_path[767:512],stack_2_out_thash_wr,auth_path[383:0]};
                else if (height_2 == 3'd2) auth_path <= {auth_path[767:384],stack_2_out_thash_wr,auth_path[255:0]};
                else if (height_2 == 3'd3) auth_path <= {auth_path[767:256],stack_2_out_thash_wr,auth_path[127:0]};
                else if (height_2 == 3'd4) auth_path <= {auth_path[767:128],stack_2_out_thash_wr};
                end
                if (offset_reg > 4'd1 && ((height_2) == (height_1)) && check_condition_loop) begin // check sau gen_leaf
                    start_in_gen_leaf_reg <= 0;
                    //start_in_thash_reg <= 1;
                    check_condition_loop <= 0;
                    if ( (offset_reg - 1'd1) > 4'd1 && ((height_2 + 1'b1) == (height_3)) ) begin
                        start_in_thash_reg <= 1;
                    end
                    else begin
                    idx <= idx + count_add;
                    if (!(idx == end_count))start_in_gen_leaf_reg <= 1;////
                    end
                end
                else if (offset_reg > 4'd1 && ((height_2) == (height_1)) && ~check_condition_loop) begin // check sau gen_leaf
                    start_in_gen_leaf_reg <= 0;
                    //start_in_thash_reg <= 1;
                    check_condition_loop <= 0;
                    if ( (offset_reg - 1'd1) > 4'd1 && ((height_2 + 1'b1) == (height_3)) ) begin // doan truoc
                        start_in_thash_reg <= 1;
                    end
                    else begin
                    idx <= idx + count_add;
                    if (!(idx == end_count))start_in_gen_leaf_reg <= 1;/////
                    end
                end 
                else begin
                    idx <= idx + count_add;
                    if (!(idx == end_count))start_in_gen_leaf_reg <= 1;
                    start_in_thash_reg <= 0;
                    
                end
                
            end  
            
            else begin
            start_in_gen_leaf_reg <= 0; // suy nghi ve 2 start_in
            start_in_thash_reg <= 0;
            root <= 0;
            valid_out<= 0;
            end
        end 
		else begin
		    auth_path_out <=0;
            root <= 0;
            valid_out<= 0;
		end

        end
endmodule
// doi auth_path sang auth_reg (hien tai co the khong anh huong khi start_in lan nua da dc set bang 0)