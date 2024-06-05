//-------------------------------------------------------------------------------------------------//
//  File name	: TB_SHA2_Top.v									                           //
//  Project		: SHA-2																		       //
//  Author		: Pham Hoai Luan                                                                   //
//  Description	: The test bench file of SHA-512                                                   //
//  Referents	: none.																		       //
//-------------------------------------------------------------------------------------------------//

`timescale 1 ns/10 ps

module tb_SHA256_Accelerator();

	
	reg				tb_CLK;
	reg				tb_RST;
	reg	 [5:0]		tb_address_in;
	reg	 [31:0]		tb_data_in;
	reg				tb_valid_in;
	reg  [5:0]		tb_address_out;
	reg				tb_valid_out;
	wire [31:0]		tb_data_out;
		
	parameter HALF_PERIOD_CLOCK = 10;
	parameter WAIT_CYCLES = 10;

	SHA256_Accelerator SHA256_accelerator(	
			.CLK(tb_CLK), 
			.RST(tb_RST),
			.address_wr_in(tb_address_in),
			.data_wr_in(tb_data_in),
			.valid_wr_in(tb_valid_in),
			///Read Channel
			.address_rd_in(tb_address_out),
			.valid_rd_in(tb_valid_out),
			.data_rd_out(tb_data_out)
		);
	
	always @(*) 
	begin: clock_generator
		#(HALF_PERIOD_CLOCK) tb_CLK <= ~tb_CLK;
		
	end
	
	task reset_module(input reg[5:0] num_delay);
		begin
			tb_RST <= 1'b0;
			#(HALF_PERIOD_CLOCK*2*num_delay) tb_RST <= 1'b1;
		end
	endtask
	

	task WRITE(input reg[5:0] addr, input reg[31:0] data);
		begin
		#20	tb_address_in =  addr;
			tb_data_in    = data;
		#80	
			tb_valid_in   = 1'b1;	
		#20 tb_valid_in   = 1'b0;			
		end
	endtask
	
	task READ(input reg[5:0] addr);
		begin
		#20	tb_address_out =  addr;
		#80	
			tb_valid_out   = 1'b1;	
		#20 tb_valid_out   = 1'b0;			
		end
	endtask
	
	task init_data();
		begin
			$display("Test started!!");
			tb_CLK <= 1'b0;
			reset_module(5'd2);			
		end
	endtask

	
	initial begin: main_test
	#1000;
		init_data();
		# 80 tb_RST <= 1'b1;
		#100;
		READ(7'd0);
		//WRITE W_HB
		WRITE({2'b00,4'd0}, 32'h61626380); //W0[0]
		WRITE({2'b00,4'd1}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd2}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd3}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd4}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd5}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd6}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd7}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd8}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd9}, 32'h00000000); //W0[0]
		WRITE({2'b00,4'd10},32'h00000000); //W0[0]
		WRITE({2'b00,4'd11},32'h00000000); //W0[0]
		WRITE({2'b00,4'd12},32'h00000000); //W0[0]
		WRITE({2'b00,4'd13},32'h00000000); //W0[0]
		WRITE({2'b00,4'd14},32'h00000000); //W0[0]
		WRITE({2'b00,4'd15},32'h00000018); //W0[0]
		
		//WRITE H_HB
		WRITE({2'b01,4'd0},32'h6a09e667); //a_HB[0]
		WRITE({2'b01,4'd1},32'hbb67ae85); //b_HB[0]
		WRITE({2'b01,4'd2},32'h3c6ef372); //c_HB[0]
		WRITE({2'b01,4'd3},32'ha54ff53a); //d_HB[0]
		WRITE({2'b01,4'd4},32'h510e527f); //e_HB[0]
		WRITE({2'b01,4'd5},32'h9b05688c); //f_HB[0]
		WRITE({2'b01,4'd6},32'h1f83d9ab); //g_HB[0]
		WRITE({2'b01,4'd7},32'h5be0cd19); //h_HB[0]

		
		
		WRITE({2'b10,4'd0},32'h000000001); //CONFIG	
		
		#2000;
	end
endmodule
