`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2023 06:35:30 PM
// Design Name: 
// Module Name: seedexpander_init
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


module seedexpander_init(
    input wire CLK,
    input wire RST,
    input wire start_in,
    input wire [255:0] seed,
    input wire [63:0] diversifier,
    input wire [31:0] maxlen,
    output reg valid_out,
    //output reg invalid_out,
    output reg [127:0] buffer,
    output reg [31:0] buffer_pos,
    output reg [31:0] length_remaining,
    output reg [255:0] key,
    output reg [127:0] ctr
    );
    // key = seed
    // ctr[127:64] = diversifier
    // ctr[63:32] = maxlen
    // ctr[31:0] = 32'b0;
    // buffer_pos = 32'd16;
    // buffer[127:0] = 128'b0;
    always @(posedge CLK) begin
        if (!RST) begin
            valid_out <= 1'b0;
            //invalid_out <= 1'b0;
            buffer <= 128'b0;
            buffer_pos <= 32'b0;
            length_remaining <= 32'b0;
            key <= 256'b0;
            ctr <= 128'b0;
        end
        else if (start_in) begin
            key <= seed;
            ctr <= {diversifier ,maxlen, 32'b0 };
            buffer_pos <= 32'd16;
            buffer <= 128'b0;
            valid_out <= 1'b1;
        end
    end
endmodule
