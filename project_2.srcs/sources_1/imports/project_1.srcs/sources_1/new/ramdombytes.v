`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 10:34:48 PM
// Design Name: 
// Module Name: ramdombytes
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


module ramdombytes(
        input wire CLK,
        input wire RST,
        input wire start_in,
        input wire [127:0] x_in, 
        input wire [31:0] loop_in, // ko su xnor
        input wire [255:0] key_in,
        input wire [127:0] V_in,
        output reg [255:0] key_out,
        output reg [127:0] V_out,
        output reg [127:0] x_out,
        output reg         valid_exe,
        output reg         valid_out
    );
    //wire start_in_wr;
    //wire [127:0] x_in_wr;
    wire [127:0] V_in_wr;
    wire [127:0] V_out_wr_process;
    wire [127:0] x_out_wr;
    wire valid_out_wr;
    reg [127:0] V_out_reg;
    wire check_loop;
    
    reg [31:0] loop_reg;
    wire start_in_wr_1;
    reg start_in_reg_1;
    assign start_in_wr_1 = start_in_reg_1;
    assign check_loop = (loop_reg == 32'b1);
    assign V_in_wr = V_out_reg;
    //assign valid_exe = valid_out_wr;
    processing_randombytes provessing_ramdom(.CLK(CLK),
                           .RST(RST),
                           .start_in(start_in_wr_1),
                           //.x_in(x_in_wr),
                           .key_in(key_in),
                           .V_in(V_in_wr),
                           .V_out(V_out_wr_process),
                           .x_out(x_out_wr),
                           .valid_out(valid_out_wr));
    wire start_in_wr_2;
    reg start_in_reg_2;
    wire valid_out_wr_update;
    wire [255:0] key_out_wr;
    assign start_in_wr_2 = start_in_reg_2;
    wire [127:0] V_out_wr;
    AES256_CTR_DRBG_Update_NULL Update_ramdombytes (.start_in(start_in_wr_2),
                                                    .CLK(CLK),
                                                    .RST(RST),
                                                    .key_in(key_in),
                                                    .V_in(V_out_wr_process),
                                                    .key_out(key_out_wr),
                                                    .V_out(V_out_wr),
                                                    .valid_out(valid_out_wr_update));
    //Controller
    always @(posedge CLK or negedge RST) begin   //process x
        if (!RST) begin
            x_out <= 128'b0;
            valid_out <= 1'b0;
            valid_exe <= 1'b0;
            V_out_reg <= 128'b0;
            loop_reg <= 32'b0;
            //start_in_reg_2 <= 1'b0;
        end
        else if(start_in) begin
            loop_reg <= loop_in;
            valid_exe <= 1'b0;
            x_out <= 128'b0;
            valid_out <= 1'b0;
            V_out_reg <= V_in;
            start_in_reg_1 = 1'b1; // khoi dong bo process, o cac xung ke se chinh ve 0
            /// start_in & ~check_loop === valid_out_wr & ~check_loop  
        end
        else if (valid_out_wr & ~check_loop) begin
            loop_reg <= loop_reg - 32'd1;//
            V_out_reg <= V_out_wr_process;
            x_out <= x_out_wr;
            start_in_reg_1 = 1'b1;
            valid_exe <= 1'b1;
            //valid_out <= 1'b0;
        end
        else if (valid_out_wr & check_loop) begin //check_loop == 1 --> het vong lap
            x_out <= x_out_wr;
            V_out_reg <= V_out_wr_process;
            loop_reg <= loop_reg;
            //valid_out <= 1'b1;
            valid_exe <= 1'b1;
            start_in_reg_1 <= 1'b0;
            start_in_reg_2 <= 1'b1; // khoi dong bo update;
        end 
        else begin
            x_out <= 127'b0;
            valid_out <= 1'b0;
            valid_exe <= 1'b0;
            V_out_reg <= V_out_reg;
            //loop_reg <= 32'b0;
            start_in_reg_1 = 1'b0;
            start_in_reg_2 <= 1'b0;
        end
    end
    always @(posedge CLK or negedge RST) begin // process V,Key
        if (!RST) begin
            key_out <= 256'b0;
            V_out <= 128'b0;
            start_in_reg_2 <= 1'b0;
            //valid_exe <= 1'b0;
        end 
        else if (start_in_reg_2 == 1'b1) begin
            
        end
        else if(valid_out_wr_update) begin
            valid_out <= 1'b1;
            //valid_exe <= 1'b1;
            key_out <= key_out_wr;
            V_out <= V_out_wr;
        end
        else begin
            key_out <= 256'b0;
            //valid_exe <= 1'b0;
            V_out <= 128'b0;
        end
    end
    
    
    endmodule
