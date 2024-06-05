`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2024 10:46:15 AM
// Design Name: 
// Module Name: cal_loop
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


module cal_loop(
        input   wire                CLK,
        input   wire                RST,
        input   wire                start_in,
        input   wire    [31:0]      mlen,
        output  reg     [31:0]      loop_out, 
        output  reg                 valid_out    
    );
    wire    [31:0] loop_wr;
    wire    [31:0] mlen_wr;
    reg     [31:0] mlen_reg;
    reg     [31:0] loop_reg;
    reg            flag_reg;
    assign  mlen_wr = (mlen_reg > 32'd63 & !mlen_reg[31])? mlen_reg - 32'd64 : mlen_reg;
    assign  loop_wr = (mlen_reg > 32'd63 & !mlen_reg[31])? (loop_reg + 1'b1) : loop_reg; 
    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            loop_out    <=32'b0;
            valid_out   <=1'b0;
            mlen_reg    <=32'b0;
            loop_reg    <=32'b0;
            flag_reg    <= 1'b0;
        end
        else if (start_in) begin
            mlen_reg    <=mlen;
            loop_out    <=32'b0;
            valid_out   <=1'b0;
            loop_reg    <=32'b0;
            flag_reg    <=1'b1;
        end
        else if (mlen_reg == 64'd0 & flag_reg) begin
            loop_out    <= loop_reg;
            mlen_reg    <= 32'b0;
            loop_reg    <= 32'b0;
            valid_out   <= 1'b1;
            flag_reg    <= 1'b0;
        end
        else if (mlen_reg != 64'd0 & mlen_reg < 64'd56 & flag_reg) begin
            loop_out    <= loop_reg + 1'b1;
            mlen_reg    <= 32'b0;
            loop_reg    <= 32'b0;
            valid_out   <= 1'b1;
            flag_reg    <= 1'b0;
        end
        else if (mlen_reg != 64'd0 & mlen_reg > 64'd55 & mlen_reg <32'd64 & flag_reg) begin
            loop_out    <= loop_reg + 2'd2;
            mlen_reg    <= 32'b0;
            loop_reg    <= 32'b0;
            valid_out   <= 1'b1;
            flag_reg    <= 1'b0;
        end
        else begin
            loop_reg    <= loop_wr;
            mlen_reg    <= mlen_wr;
            loop_out    <= 32'b0;
            valid_out   <= 1'b0;
        end
    end
endmodule
