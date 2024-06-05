`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2024 07:59:32 AM
// Design Name: 
// Module Name: base_w
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


module base_w_32(input wire [127:0] in,
             output wire [1023:0] out);
assign out[31:0] = {28'b0, in[3:0]};
assign out[63:32] = {28'b0, in[7:4]};
assign out[95:64] = {28'b0, in[11:8]};
assign out[127:96] = {28'b0, in[15:12]};
assign out[159:128] = {28'b0, in[19:16]};
assign out[191:160] = {28'b0, in[23:20]};
assign out[223:192] = {28'b0, in[27:24]};
assign out[255:224] = {28'b0, in[31:28]};
assign out[287:256] = {28'b0, in[35:32]};
assign out[319:288] = {28'b0, in[39:36]};
assign out[351:320] = {28'b0, in[43:40]};
assign out[383:352] = {28'b0, in[47:44]};
assign out[415:384] = {28'b0, in[51:48]};
assign out[447:416] = {28'b0, in[55:52]};
assign out[479:448] = {28'b0, in[59:56]};
assign out[511:480] = {28'b0, in[63:60]};
assign out[543:512] = {28'b0, in[67:64]};
assign out[575:544] = {28'b0, in[71:68]};
assign out[607:576] = {28'b0, in[75:72]};
assign out[639:608] = {28'b0, in[79:76]};
assign out[671:640] = {28'b0, in[83:80]};
assign out[703:672] = {28'b0, in[87:84]};
assign out[735:704] = {28'b0, in[91:88]};
assign out[767:736] = {28'b0, in[95:92]};
assign out[799:768] = {28'b0, in[99:96]};
assign out[831:800] = {28'b0, in[103:100]};
assign out[863:832] = {28'b0, in[107:104]};
assign out[895:864] = {28'b0, in[111:108]};
assign out[927:896] = {28'b0, in[115:112]};
assign out[959:928] = {28'b0, in[119:116]};
assign out[991:960] = {28'b0, in[123:120]};
assign out[1023:992] = {28'b0, in[127:124]};

endmodule
