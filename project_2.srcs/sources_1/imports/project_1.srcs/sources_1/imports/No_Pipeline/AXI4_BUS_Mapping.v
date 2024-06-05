//-------------------------------------------------------------------------------------------------//
//  File name	: AXI4_BUS_Mapping.v									                           //
//  Project		: BLAKE																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: mapping for AXI4 Bus 			    		                                       //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

module	AXI_BUS_Mapping (
	input	wire				CLK,
	input	wire				RST,
	/////Write Channel
	input   wire	[  5:0]		address_wr_in,
	input   wire	[ 31:0]		data_wr_in,
	input   wire				valid_wr_in,
	/////Read Channel
	input   wire	[  5:0]		address_rd_in,
	input   wire				valid_rd_in,
	output	reg		[ 31:0]		data_rd_out,
	/////
	input	wire  		 		hash_in_valid,	
	input	wire  	[255:0] 	hash_in,
	///
	output 	reg 				start_out,
	output  reg 	[255:0] 	hash_out,
	output  reg 	[511:0] 	message_out
		);
		
	//***Write Memory***//
	
	//H buffers
	reg		[ 31:0]  H_BUFF 	[0:7];	
	//W buffers
	reg		[ 31:0]  W_BUFF 	[0:15];
	//Config memory
	reg		[ 31:0]	 CONFIG_MEM;
	//***Read Memory***//	
	//Response Memory
	reg		[ 31:0]  HO_BUFF 	[0:7];	
	reg		[ 31:0]	 H_final_valid;	
		
	//***Write Channel***//
	
	integer i;
	
	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			for(i=0; i < 8; i=i+1) begin
				H_BUFF[i] 	<= 32'h0;
			end
			for(i=0; i < 16; i=i+1) begin
				W_BUFF[i] 	<= 32'h0;
			end
			
			CONFIG_MEM  	<= 32'h0;
		end
		else begin
			if(valid_wr_in) begin
				if(address_wr_in[5:4] == 2'b00) begin
					W_BUFF[address_wr_in[3:0]] 	<= data_wr_in;
				end
				else if(address_wr_in[5:4] == 2'b01) begin
					H_BUFF[address_wr_in[2:0]] 	<= data_wr_in;
				end
				else if(address_wr_in[5:4] == 2'b10) begin
					CONFIG_MEM <= data_wr_in;
				end
			end
			else begin
				CONFIG_MEM  <= 32'h0;
			end
		end
	end
	
	wire [31:0]		config_mem1;
	wire			start;
	
	assign config_mem1 = CONFIG_MEM;
	assign start = config_mem1[0:0];
		
	
	//***Read Channel***//
		
	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			data_rd_out		<= 32'd0;
		end
		else begin
			if(valid_rd_in) begin
				if(address_rd_in[5:4] == 2'b00) begin
					data_rd_out <= HO_BUFF[address_rd_in[2:0]];
				end
				else if(address_rd_in[5:4] == 2'b01) begin
					data_rd_out <= H_final_valid;
				end
			end
			else begin
					data_rd_out		<= data_rd_out;
			end
		end
	end
	
	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			hash_out	<= 256'h0;
			message_out	<= 512'h0;
			start_out	<= 1'b0;
		end
		else begin
		   if(start) begin 
				hash_out	<= {H_BUFF[0],H_BUFF[1],H_BUFF[2],H_BUFF[3],H_BUFF[4],H_BUFF[5],H_BUFF[6],H_BUFF[7]};
				message_out	<= {W_BUFF[0],W_BUFF[1],W_BUFF[2],W_BUFF[3],W_BUFF[4],W_BUFF[5],W_BUFF[6],W_BUFF[7],W_BUFF[8],W_BUFF[9],W_BUFF[10],W_BUFF[11],W_BUFF[12],W_BUFF[13],W_BUFF[14],W_BUFF[15]};
				start_out	<= start;
			end
			else begin
				hash_out	<= hash_out;
				message_out	<= message_out;
				start_out	<= 1'b0;
			end
		end
	end
	
	always @(posedge CLK or negedge RST)	
	begin
		if(RST == 1'b0) begin
			for(i=0; i < 8; i=i+1) begin
				HO_BUFF[i] 	<= 32'h0;
			end
			H_final_valid	<= 32'b0;
		end
		else begin
			if(start) begin
				for(i=0; i < 8; i=i+1) begin
				HO_BUFF[i] 	<= 32'h0;
				end
				H_final_valid	<= 32'b0;
			end
			else if(hash_in_valid) begin
				{HO_BUFF[0],HO_BUFF[1],HO_BUFF[2],HO_BUFF[3],HO_BUFF[4],HO_BUFF[5],HO_BUFF[6],HO_BUFF[7]}	<= hash_in;
				H_final_valid	<= 32'b1;
			end
		end
	end
endmodule