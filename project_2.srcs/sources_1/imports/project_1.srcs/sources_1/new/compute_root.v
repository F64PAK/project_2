`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2024 09:33:01 PM
// Design Name: 
// Module Name: compute_root
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

module compute_root(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] leaf,
             input  wire    [767:0] auth_path,
             input  wire    [31:0]  leaf_idx,
             input  wire    [31:0]  idx_offset,
             input  wire    [31:0]  tree_height,
             input	wire	[319:0]	state_seed,
             //input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	addr,
             output	reg	    [127:0]	root,
             output reg           	valid_out );
             // auth_path la chuoi dia chi dai truyen vao compute root de tinh toan
             // tree_height = 3 -> 128 * 3 = 384 bit
             // tree_height = 6 -> 128 * 6 = 768 bit 
    //wire [255:0] buffer_wr;
    wire [127:0] auth_path_wr;
    wire flag_if , flag, start_in_wr;
    wire [255:0] in_thash_wr;
    wire [127:0] out_thash_wr;
    wire         valid_out_thash_wr;
    wire [255:0] addr_wr;
    wire [7:0] count;
    wire [3:0] end_count;
    wire [31:0] sum;
    reg [255:0] buffer_reg;
    reg [767:0] auth_path_reg;
    reg [2:0] count_if;
    reg count_add;
    reg start_in_reg;
    reg next_loop;
    reg [31:0] leaf_idx_reg;
    reg [31:0] idx_offset_reg;
    //reg [63:0] addr_reg;
    wire check;
    assign count = (count_if == end_count) ? tree_height[7:0] : {5'b0,count_if} + 1'b1;
    assign flag_if = (leaf_idx_reg[0] == 0) ? 1'b1 : 1'b0;
    assign end_count = tree_height[3:0] - 1'b0;
    assign in_thash_wr = buffer_reg;
    assign start_in_wr = (start_in_reg | next_loop)? 1'b1:1'b0;
    assign sum = leaf_idx_reg + idx_offset_reg;
    assign addr_wr = {addr[255:128],sum[23:16],sum[31:24],count[7:0],addr[103:80],sum[7:0],sum[15:8],addr[63:0]};
    //assign addr_wr = addr_reg;
    //assign buffer_wr = (leaf_idx[0] == 1) ? {leaf,auth_path} : {auth_path,leaf};
    assign check = (count_if == tree_height - 1'b1) ? 1'b1 : 1'b0; 
    assign auth_path_wr = auth_path_reg[767:640];
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            buffer_reg <= 256'b0;
            auth_path_reg <= 768'b0;
            count_if <= 3'b0;
            count_add <= 1'b0;
            start_in_reg <= 1'b0;
            next_loop <= 1'b0;
            root <= 128'b0;
            valid_out <= 1'b0;
            leaf_idx_reg <= 32'b0;
            idx_offset_reg <= 32'b0;
        end
        else if (start_in) begin
            start_in_reg <= 1'b1;
            next_loop <= 1'b0;
            //if (leaf_idx[0] == 0) begin
            //    buffer_reg <= {leaf[127:0],auth_path_wr};
            //end else begin
            //    buffer_reg <= {auth_path_wr,leaf[127:0]};
            //end
            if (leaf_idx[0] == 0) begin
                if (tree_height == 32'd3)
                    buffer_reg <= {leaf[127:0],auth_path[383:256]};
                else 
                    buffer_reg <= {leaf[127:0],auth_path[767:640]};
            end else begin
                if (tree_height == 32'd3)
                    buffer_reg <= {auth_path[383:256],leaf[127:0]};
                else 
                    buffer_reg <= {auth_path[767:640],leaf[127:0]};
                
            end
            //buffer_reg <= 256'b0;
            if (tree_height == 32'd3) begin
                auth_path_reg <= {auth_path[255:0],512'b0};
            end
            else if (tree_height == 32'd6) begin
                auth_path_reg <= {auth_path[639:0],128'b0};
            end
            count_if <= 3'b0;
            count_add <= 1'b1;
            leaf_idx_reg <= {1'b0,leaf_idx[31:1]};
            idx_offset_reg <= {1'b0,idx_offset[31:1]}; 
            root <= 128'b0;
            valid_out <= 1'b0;
        end
        else if (valid_out_thash_wr & ~check) begin
            if (flag_if) begin
                buffer_reg <= {out_thash_wr,auth_path_wr};
            end else begin
                buffer_reg <= {auth_path_wr,out_thash_wr};
            end
            auth_path_reg <= {auth_path_reg[639:0],128'b0};     
            leaf_idx_reg <= {1'b0,leaf_idx_reg[31:1]};
            idx_offset_reg <= {1'b0,idx_offset_reg[31:1]};  
            count_if <= count_if + count_add;  
            next_loop <= 1'b1;    
        end
        else if (valid_out_thash_wr & check) begin
            root <= out_thash_wr;
            valid_out <= 1'b1;
            count_if <= 3'b0;
            count_add <= 1'b0;
            //buffer_reg <= 256'b0;
            //auth_path_reg <= 768'b0;
            start_in_reg <= 1'b0;
            next_loop <= 1'b0;
        end 
        else begin
            root <= 128'b0;
            valid_out <= 1'b0;
            start_in_reg <= 1'b0;
            next_loop <= 1'b0;
            
        end
        
    end
    thash thash_compute_root(.CLK(CLK),
                             .RST(RST),
                             .start_in(start_in_wr),
                             .in({4224'b0,in_thash_wr}),
                             .mode(2'b01),
                             .state_seed(state_seed),
                             .addr(addr_wr),
                             .out(out_thash_wr),
                             .valid_out(valid_out_thash_wr) );
    
    
endmodule
