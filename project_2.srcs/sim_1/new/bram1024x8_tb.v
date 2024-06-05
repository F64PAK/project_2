`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 07:45:59 PM
// Design Name: 
// Module Name: bram1024x8_tb
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


module bram1024x8_tb(

    );
    reg CLK;
    reg ena;
    reg wea;
    reg [2:0] addra;
    reg [1023:0] dina;
    reg [1023:0] douta;
    bram1024x8 bram1024x8_tb(.clka(CLK),
                             .ena(ena),
                             .wea(wea),
                             .addra(addra),
                             .dina(dina),
                             .douta(douta));
    
endmodule
