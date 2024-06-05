//-------------------------------------------------------------------------------------------------//
//  File name	: Blake_Accelerator.v							                           		   //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: Blake top		 			    		                                           //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module	SHA256_Accelerator (
input	wire				CLK,
	input	wire				RST,
	/////Write Channel
	input   wire	[  5:0]		address_wr_in,
	input   wire	[ 31:0]		data_wr_in,
	input   wire				valid_wr_in,
	/////Read Channel
	input   wire	[  5:0]		address_rd_in,
	input   wire				valid_rd_in,
	output	wire	[ 31:0]		data_rd_out
	);

	wire  		 		hash_in_valid;	
	wire  	[255:0] 	hash_in;
	///
	wire 				start_out;
	wire 	[255:0] 	hash_out;
	wire 	[511:0] 	message_out;
	
	AXI_BUS_Mapping Mapping(
		.CLK(CLK),
		.RST(RST),
		////Write Channel
		.address_wr_in(address_wr_in),
		.data_wr_in(data_wr_in),
		.valid_wr_in(valid_wr_in),
		///////Read Channel
		.address_rd_in(address_rd_in),
		.valid_rd_in(valid_rd_in),
		.data_rd_out(data_rd_out),
		///////
		.hash_in_valid(hash_in_valid),	
		.hash_in(hash_in),
		///
		.start_out(start_out),
		.hash_out(hash_out),
		.message_out(message_out)
		);
	
	sha256 sha256(
		.CLK(CLK),
		.RST(RST),
		.start_in(start_out),
		.digest_in(hash_out),
		.message_in(message_out),
		.valid_out(hash_in_valid),	
		.digest_out(hash_in)
	);

	
endmodule