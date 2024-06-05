`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 10:27:37 PM
// Design Name: 
// Module Name: message_to_indices
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

module message_to_indices(  input  wire  [199:0]    m,
                            output wire  [1055:0]   indices );

    
	
    assign indices[0 +: 32]    = {26'b0,m[5:0]};
    
    assign indices[32 +: 32]   = {26'b0,m[15:10]};
    assign indices[64 +: 32]   = {26'b0,m[9:8],m[23:20]};
    assign indices[96 +: 32]   = {26'b0,m[19:16],m[31:30]};
    assign indices[128 +: 32]  = {26'b0,m[29:24]};
    
    assign indices[160 +: 32]  = {26'b0,m[39:34]};
    assign indices[192 +: 32]  = {26'b0,m[33:32],m[47:44]};
    assign indices[224 +: 32]  = {26'b0,m[43:40],m[55:54]};
    assign indices[256 +: 32]  = {26'b0,m[53:48]};
    
    assign indices[288 +: 32]  = {26'b0,m[63:58]};
    assign indices[320 +: 32]  = {26'b0,m[57:56],m[71:68]};
    assign indices[352 +: 32]  = {26'b0,m[67:64],m[79:78]};
    assign indices[384 +: 32]  = {26'b0,m[77:72]};
    
    assign indices[416 +: 32]  = {26'b0,m[87:82]};
    assign indices[448 +: 32]  = {26'b0,m[81:80],m[95:92]};
    assign indices[480 +: 32]  = {26'b0,m[91:88],m[103:102]};
    assign indices[512 +: 32]  = {26'b0,m[101:96]};
    
    assign indices[544 +: 32]  = {26'b0,m[111:106]};
    assign indices[576 +: 32]  = {26'b0,m[105:104],m[119:116]};
    assign indices[608 +: 32]  = {26'b0,m[115:112],m[127:126]};
    assign indices[640 +: 32]  = {26'b0,m[125:120]};
    
    assign indices[672 +: 32]  = {26'b0,m[135:130]};
    assign indices[704 +: 32]  = {26'b0,m[129:128],m[143:140]};
    assign indices[736 +: 32]  = {26'b0,m[139:136],m[151:150]};
    assign indices[768 +: 32]  = {26'b0,m[149:144]};
    
    assign indices[800 +: 32]  = {26'b0,m[159:154]};
    assign indices[832 +: 32]  = {26'b0,m[153:152],m[167:164]};
    assign indices[864 +: 32]  = {26'b0,m[163:160],m[175:174]};
    assign indices[896 +: 32]  = {26'b0,m[173:168]};
    
    assign indices[928 +: 32]  = {26'b0,m[183:178]};
    assign indices[960 +: 32]  = {26'b0,m[177:176],m[191:188]};
    assign indices[992 +: 32]  = {26'b0,m[187:184],m[199:198]}; 
    assign indices[1024 +: 32] = {26'b0,m[197:192]}; 


	
		
endmodule

