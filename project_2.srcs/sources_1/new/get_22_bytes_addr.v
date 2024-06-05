`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2024 10:15:52 PM
// Design Name: 
// Module Name: get_22_bytes_addr
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


module get_22_bytes_addr(
        input  wire [255:0] addr,
        output wire [175:0] addr_out
    );
    assign addr_out[175:0] = {addr[231:224],addr[239:232],addr[247:240],addr[255:248],
                      addr[199:192],addr[207:200],addr[215:208],addr[223:216],
                      addr[167:160],addr[175:168],addr[183:176],addr[191:184],
                      addr[135:128],addr[143:136],addr[151:144],addr[159:152],
                      addr[103:96],addr[111:104],addr[119:112],addr[127:120],
                      addr[71:64],addr[79:72]};
endmodule
