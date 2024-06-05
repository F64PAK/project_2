`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 09:04:38 AM
// Design Name: 
// Module Name: gen_chain
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


module gen_chain(
             input 	wire 			CLK,
             input	wire			RST,
             input	wire			start_in,
             input  wire    [127:0] in,
             input	wire	[319:0]	state_seed,
             //input  wire    [383:0] pub_seed, // khong su dung
             input	wire	[255:0]	addr,
             input  wire    [31:0]  start,
             input  wire    [31:0]  steps,
             output	reg	    [127:0]	out,
             output reg           	valid_out
    );
    
    reg [127:0] buffer;
    reg [31:0] count_reg;
    //reg [255:0] addr_reg; // suy nghi ve viec dung wire hon nhung reg co the tien dung hon
    reg count_add;
    reg next_loop,
        start_in_reg;
    wire [255:0] addr_wr;
    wire [127:0] out_thash;
    wire start_in_wr,
         valid_out_wr,
         check_loop,
         check_if;
    wire [31:0] end_count,
                sum,
                sub;
    assign start_in_wr = (start_in_reg | next_loop)? 1'b1:1'b0;
    assign sum = start + steps;
    assign sub = sum - 32'd16; 
    // sub[31] = 1 -> sum < 16
    // sub[31] = 0 -> sum > 16 
    assign end_count = (sum ==32'b0) ? 32'd0 : ( (sub[31]) ? (sum - 1'b1) : 32'd15); 
    //assign end_count = (!sub[31] | sum==32'b0)? (sum - 1'b1) : 32'd15 ;
    assign check_loop = (count_reg == end_count) ? 1'b1 : 1'b0;
    //assign addr_wr[255:80] = (start_in)? addr[255:80] : addr_reg[255:80];
    //assign addr_wr[79:72] = (start_in | next_loop)?   count_reg : addr_reg[79:72] ;
    //assign addr_wr[71:0] = (start_in)?  addr[71:0] : addr_reg[71:0];
    //set_hash_addr
    assign addr_wr[255:80] = addr[255:80] ;
    assign addr_wr[79:72] = count_reg ;
    assign addr_wr[71:0] =  addr[71:0] ;
    //assign check_if = (start > 15 | sum==32'b0) ? 1'b1 : 1'b0;
    assign check_if = (start > 14 | sum==32'b0) ? 1'b1 : 1'b0; 
    thash thash_gen_chain(
             .CLK(CLK),
             .RST(RST),
             .start_in(start_in_wr),
             .in({4352'b0,buffer}),
             .mode(2'b00),
             .state_seed(state_seed),
             .addr(addr_wr),
             .out(out_thash),
             .valid_out(valid_out_wr) );
             
     always @(posedge CLK or negedge RST) begin
        if(!RST) begin 
            buffer <= 128'b0;
            //addr_reg <= 256'b0;
            count_reg <= 32'b0;
            count_add <= 1'b0;
            next_loop <= 1'b0;
            start_in_reg <= 1'b0;
            out <= 128'b0;
            valid_out <= 1'b0;
        end 
        else if (start_in & check_if) begin
            out <= in;
            valid_out <= 1'b1;
            count_reg <= 32'b0;
            count_add <= 1'b0;
            //buffer_reg <= 256'b0;
            //auth_path_reg <= 768'b0;
            start_in_reg <= 1'b0;
            next_loop <= 1'b0;
        end
        else if (start_in & ~check_if) begin
            buffer <= in;
            //addr_reg <= {addr[255:80],start,addr[71:0]};
            start_in_reg <= 1'b1;
            count_reg <= start;
            next_loop <= 1'b0;
            count_add <= 1'b1;
            out <= 128'b0;
            valid_out <= 1'b0;
        end
        
        else if (valid_out_wr & ~check_loop) begin
            buffer <= out_thash;
            //addr_reg <= addr_wr; 
            count_reg <= count_reg + count_add;  
            next_loop <= 1'b1;
            //addr_reg <= {addr[255:80],count_reg,addr[71:0]};  
              
        end
        else if (valid_out_wr & check_loop) begin
            out <= out_thash;
            valid_out <= 1'b1;
            count_reg <= 32'b0;
            count_add <= 1'b0;
            //buffer_reg <= 256'b0;
            //auth_path_reg <= 768'b0;
            start_in_reg <= 1'b0;
            next_loop <= 1'b0;
            buffer <= 128'b0;
        end //if (check_if) begin
            //out <= in;
            //valid_out <= 1'b1;
            //count_reg <= 32'b0;
            //count_add <= 1'b0;
            //start_in_reg <= 1'b0;
            //next_loop <= 1'b0;
        //end
        else begin
            out <= 128'b0;
            valid_out <= 1'b0;
            start_in_reg <= 1'b0;
            next_loop <= 1'b0;
            //addr_reg <= addr_reg;
        end
     end
endmodule
