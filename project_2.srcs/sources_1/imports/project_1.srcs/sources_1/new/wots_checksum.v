`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2024 08:21:46 AM
// Design Name: 
// Module Name: wots_checksum
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


module wots_checksum(
        input wire start_in,
        input wire CLK,
        input wire RST,
        input wire [1023:0] msg_base_w,
        output reg [95:0] csum_base_w,
        output reg valid_out
    );
    reg [31:0] csum_reg;
    wire [31:0] csum_wire;
    wire [95:0] csum_base_w_wr;
    reg [5:0] count_reg; 
    reg count_add;   
    reg [1023:0] msg_base_w_reg;
    assign csum_wire = (count_reg == 6'd32) ?  csum_reg << 4: (csum_reg + 16-1-msg_base_w_reg[1023:992]) ;
    base_w_3 base_w_3_wots_checksum (csum_wire[15:4],csum_base_w_wr);
    always @(posedge CLK) begin
        if (!RST) begin
        csum_base_w <= 96'b0;
        valid_out <= 1'b0;
        csum_reg <= 32'b0;
        count_reg <= 6'b0;
        msg_base_w_reg <= 1024'b0;
        count_add <= 1'b0;
        end
        else if (start_in) begin
        csum_base_w <= 96'b0;
        valid_out <= 1'b0;
        csum_reg <= 32'b0;
        count_reg <= 6'b0;
        msg_base_w_reg <= msg_base_w;
        count_add <= 1'b1;
        end
        else if (count_reg == 6'd32) begin
        count_add <= 1'b0;
        count_reg <= 6'b0;
        valid_out <= 1'b1;
        csum_base_w <= csum_base_w_wr;
        csum_reg <= 32'b0;
        end
        else begin 
        count_reg <= count_reg + count_add;
        msg_base_w_reg <= msg_base_w_reg << 32;
        csum_reg <= csum_wire;
        valid_out <= 1'b0;
        csum_base_w <= 96'b0;
        end
    end
    
endmodule
