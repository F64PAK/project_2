`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 03:39:19 PM
// Design Name: 
// Module Name: processing_randombytes
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


module processing_randombytes(
        input wire CLK,
        input wire RST,
        input wire start_in,
        //input wire [127:0] x_in,
        input wire [255:0] key_in,
        input wire [127:0] V_in,
        output reg [127:0] V_out,
        output reg [127:0] x_out,
        output reg valid_out
    );

    wire [127:0] V_wr;
    wire [127:0] block;
    wire valid_out_wr;
    reg [127:0] V_reg;
    ///// Processing V_in
    assign V_wr = V_in + 128'd1;
    /*
    assign V_wr [7:0] = (V_in [7:0] == 8'hff) ? 8'h00 : (V_in[7:0] + 1);
    assign V_wr [15:8] = (V_in [15:8] == 8'hff) ? 8'h00 : (V_in[15:8] + 1);
    assign V_wr [23:16] = (V_in [23:16] == 8'hff) ? 8'h00 : (V_in[23:16] + 1);
    assign V_wr [31:24] = (V_in [31:24] == 8'hff) ? 8'h00 : (V_in[31:24] + 1);
    assign V_wr [39:32] = (V_in [39:32] == 8'hff) ? 8'h00 : (V_in[39:32] + 1);
    assign V_wr [47:40] = (V_in [47:40] == 8'hff) ? 8'h00 : (V_in[47:40] + 1);
    assign V_wr [55:48] = (V_in [55:48] == 8'hff) ? 8'h00 : (V_in[55:48] + 1);
    assign V_wr [63:56] = (V_in [63:56] == 8'hff) ? 8'h00 : (V_in[63:56] + 1);
    assign V_wr [71:64] = (V_in [71:64] == 8'hff) ? 8'h00 : (V_in[71:64] + 1);
    assign V_wr [79:72] = (V_in [79:72] == 8'hff) ? 8'h00 : (V_in[79:72] + 1);
    assign V_wr [87:80] = (V_in [87:80] == 8'hff) ? 8'h00 : (V_in[87:80] + 1);
    assign V_wr [95:88] = (V_in [95:88] == 8'hff) ? 8'h00 : (V_in[95:88] + 1);
    assign V_wr [103:96] = (V_in [103:96] == 8'hff) ? 8'h00 : (V_in[103:96] + 1);
    assign V_wr [111:104] = (V_in [111:104] == 8'hff) ? 8'h00 : (V_in[111:104] + 1);
    assign V_wr [119:112] = (V_in [119:112] == 8'hff) ? 8'h00 : (V_in[119:112] + 1);
    assign V_wr [127:120] = (V_in [127:120] == 8'hff) ? 8'h00 : (V_in[127:120] + 1);
    */
    AES_Encrypt AES_randombyte(.CLK(CLK),
                               .start_in(start_in),
                               .RST(RST),
                               .key_in(key_in),
                               .plaintext(V_wr),
                               .ciphertext(block),
                               .valid_out(valid_out_wr));
    //assign valid_out = valid_out_wr; 
    //Controller
    always @(posedge CLK)
        begin
            if(!RST) begin
                //key_out <= 256'b0;
                V_out <= 128'b0;
                x_out <= 128'b0;
                //valid_out <= 1'b0;
                valid_out <= 1'b0;
            end 
            else if (start_in) begin
                V_reg <= V_wr;
                valid_out <= 1'b0;
            end
            else if (valid_out_wr ==1'b1) begin
                
                x_out <= block;
                valid_out <= 1'b1;
            end
            else begin
                V_out <= V_reg;
                valid_out <= 1'b0;
            end
        end
    
    
    
    
endmodule
