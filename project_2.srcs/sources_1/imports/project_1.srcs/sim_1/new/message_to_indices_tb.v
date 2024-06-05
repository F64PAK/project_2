`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 10:42:42 PM
// Design Name: 
// Module Name: message_to_indices_tb
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


module message_to_indices_tb;


  reg [199:0] m;


  wire [1055:0] indices;
    wire [127:0] check0,check1,check2,check3,check4,check5,check6,check7;
    wire [31:0] check8;
  message_to_indices uut (
    .m(m), 
    .indices(indices));
    initial begin
    m <= 200'haabbccddeeaabbccddeeaabbccddeeaabbccddeeaabbccddee;
    #20 $display("%h",indices);
    m <= 200'h02030405060708090a0b0c0d0e0f101112131415161718191a;
    #20 $display("%h",indices);
    $stop;
    
    end
    /*
    integer i;
    assign check0 = indices[928 +: 128];
    assign check1 = indices[800 +: 128];
    assign check2 = indices[672 +: 128];
    assign check3 = indices[544 +: 128];
    assign check4 = indices[416 +: 128];
    assign check5 = indices[288 +: 128];
    assign check6 = indices[160 +: 128];
    assign check7 = indices[32 +: 128];
    assign check8 = indices[0 +: 32];
    initial begin
     $monitor("indices = %0x",indices );
    for (i = 0; i < 25; i = i + 1)
        m[i*8 +:8] = i + 25;
    

    end
    */
endmodule 