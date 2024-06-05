module RTL_ull_to_bytes(ull,byte);
input wire [63:0] ull; // 8x8 = 64
//input   wire            CLK;
//input   wire            RST;
//input   wire            start_in;
output  [63:0] byte;
//output  reg valid_out;

//always @(posedge CLK or negedge RST)	
//	begin
//		if(RST == 1'b0) begin
//			byte 			<= 64'b0;
//			valid_out 			<= 1'b0;
//		end
//		else begin
//			if(start_in) begin
assign 			 byte[63:56] = ull[7:0] ;
assign 			 byte[55:48] = ull[15:8];
assign 			 byte[47:40] = ull[23:16];
assign 			 byte[39:32] = ull[31:24];
assign 			 byte[31:24] = ull[39:32];
assign 			 byte[23:16] = ull[47:40];
assign 			 byte[15:8] = ull[55:48];
assign 			 byte[7:0] = ull[63:56];    
//				valid_out 			<= 1'b1;
//			end
//			else begin
//				byte			<= ull;
//				valid_out 			<= valid_out;
//			end
//		end
//	end

endmodule