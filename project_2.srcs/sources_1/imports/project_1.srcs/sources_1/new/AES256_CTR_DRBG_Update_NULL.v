`timescale 1ns / 1ps

module AES256_CTR_DRBG_Update_NULL(  input   wire                start_in,
                                     input   wire                CLK,
                                     input   wire                RST,
                                     input   wire    [255:0]     key_in,
                                     //input   wire    [383:0]     provided_data,
                                     input   wire    [127:0]     V_in,
                                     output  reg     [255:0]     key_out,
                                     output  reg     [127:0]     V_out,
                                     output  reg                 valid_out  );
 
    reg [5:0] 		round_reg;
    reg				round_add;     
    reg             valid_out_r;
    reg [127:0]     V_add_r;
    reg [383:0]     temp_r;
    
    wire [127:0]    V_w, V, cipher_w;
    wire [255:0]    key_in_w, key_out_w;
    wire            RST_w, valid_out_w, start_in_w;
    wire [383:0]    temp_w;

    // Controller
    always @ (posedge CLK)
    begin 
        if(RST == 1'b0) begin
            round_reg 			<= 6'b0;
            round_add			<= 1'b0;
        end
        else begin
            if(start_in) begin
                round_add			<= 1'b1;
                round_reg 			<= round_reg + 1'b1;
            end
            else if (round_reg == 6'd49) begin
                round_reg  		    <= 6'b0;
                round_add		    <= 1'b0;
            end
            else begin
                round_add			<= round_add;
                round_reg 			<= round_reg + round_add;
            end
        end
	end   
    assign V = start_in ? V_in : V_add_r; 
    assign V_w = V + 128'd1;
    assign start_in_w = valid_out_r | start_in; 

    AES_Encrypt ins(.CLK(CLK),.start_in(start_in_w),.RST(RST),.key_in(key_in),.plaintext(V_w),.ciphertext(cipher_w),.valid_out(valid_out_w));
    assign temp_w = temp_r ;

    always @ (posedge CLK)
    begin 
        if(RST == 1'b0) begin
            valid_out_r             <= 1'b0;
            V_add_r                 <= 128'h0;
            temp_r                  <= 384'h0;
        end
        else begin
            valid_out_r             <= valid_out_w;
        end
        
        if (valid_out_w) begin
            temp_r                  <= {temp_r[255:0],cipher_w};
        end
        
        if(start_in) begin
            key_out                 <= 256'h0;
            V_out                   <= 128'h0;
            valid_out               <= 1'h0;
            V_add_r                 <= V_in;
        end
        else if (round_reg == 6'd48) begin
            key_out                 <= temp_w[383:128];
            V_out                   <= temp_w[127:0];
            valid_out               <= 1'h1;
        end 
        else if (round_reg[3:0] == 4'hf) begin
            V_add_r                 <= V_w;
        end 
        else begin
            key_out                 <= 256'h0;
            V_out                   <= 128'h0;
            valid_out               <= 1'h0;
        end
    end
endmodule

