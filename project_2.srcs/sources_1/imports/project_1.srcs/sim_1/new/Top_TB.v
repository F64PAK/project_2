`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2024 12:25:47 AM
// Design Name: 
// Module Name: Top_TB
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

module Top_TB();

reg CLK;
reg RST;
reg start_in;
reg [511:0]	message_in;
reg [255:0]	digest_in;
reg [31:0]  loop_in;
wire [255:0]	digest_out;
wire  valid_out;
//wire [31:0] check;
wire [6:0] check_round_reg;
wire [255:0]	check_digest_out;

assign check_round_reg = dut.round_reg;
assign check_digest_out = dut.digest_reg;
SHA256_Top dut (
    .CLK(CLK),
    .RST(RST),
    .start_in(start_in),
    .message_in(message_in),
    .loop_in(loop_in),
    .digest_in(digest_in),
    .digest_out(digest_out),
    .valid_out(valid_out)
  );
  // Clock generation
  
  always #5 CLK = ~CLK;
  integer i;
  initial  begin
  CLK = 0;
  RST <= 0;
  digest_in = 256'h0;
  message_in = 512'b0;
  //message_in = 512'h00000000000000000000000000000000000000000000abcdabcdabcdabcdabcdabcdabcdabcd8000000000000000000000000000000000000000000000000130;
  loop_in = 32'd1;
  #6 RST <= 1;
   start_in = 1; 
  #10  start_in = 0;
  
 /*
  for(i = 31; i >= 0; i = i - 1)
  digest_in[i*8 +: 8] = 32 - i;
  loop_in = 32'd3;
  
  
  for(i = 63; i >= 0; i = i - 1)
  message_in[i*8 +: 8] = 64 - i;
  #6 RST <= 1;
   start_in = 1; 
  #10  start_in = 0;
  
  #900  for(i = 127; i >= 0; i = i - 1)
  message_in[i*8 +: 8] = 128 - i;
   start_in = 1; 
  #10  start_in = 0;
  
  #900  for(i = 191; i >= 0; i = i - 1)
  message_in[i*8 +: 8] = 192 - i;
   start_in = 1; 
  #10  start_in = 0;
  */
  #900 $stop;
  end
  
  

endmodule

