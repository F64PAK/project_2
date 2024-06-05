`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2024 11:26:33 AM
// Design Name: 
// Module Name: wots_gen_pk
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


module wots_gen_pk(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] sk_seed,
             input	wire	[319:0]	state_seed,
             input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	addr,
             output	reg	    [4479:0]pk_out, //4480
             output reg           	valid_out
    );
    reg	[4479:0] pk_out_reg;
    reg [5:0] count_reg;
    reg count_add;
    reg start_in_gen_sk,
        start_in_gen_chain;
        
    wire valid_out_gen_sk,
         valid_out_gen_chain,
         check;
    wire [255:0] addr_wr;
    wire [127:0] gen_sk_out,
                 out_gen_chain;
    //set_chain_addr
    assign addr_wr[111:104] = count_reg;
    assign addr_wr[255:112] = addr[255:112] ;
    assign addr_wr[103:0] =  addr[103:0] ;
    assign check = (count_reg == 6'd34)? 1'b1 : 1'b0;
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
    gen_chain gen_chain_wots_gen_pk(
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
            count_reg <= count_reg + count_add;
            start_in_gen_sk <= 1'b1;
            valid_out <= 1'b0;
            end
        end
        /*else if (valid_out_gen_chain & check) begin 
            pk_out <= {pk_out[4351:0],out_gen_chain};
            count_reg <= 6'b0;
            start_in_gen_sk <= 1'b0;
            start_in_gen_chain <=1'b0;
        end*/
        else begin
            pk_out <= 4480'b0;
            start_in_gen_sk <= 1'b0;
            start_in_gen_chain <=1'b0;            
            valid_out <= 1'b0;
        end
    end
endmodule
