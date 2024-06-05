module AES_Encrypt( input   wire                start_in,
                    input   wire                CLK,
                    input   wire                RST,
                    input   wire    [255:0]     key_in,
                    input   wire    [127:0]     plaintext,
                    output  reg     [127:0]     ciphertext,
                    output  reg                 valid_out );
                    

    reg [3:0] 		round_reg, round_rconx;
    reg				round_add;   
    reg [31:0]      temp_reg;  
    reg [255:0]     w_reg;
    reg [127:0]     ciphertext_reg;
    
    
    wire [127:0]    state0;
    wire [255:0]    w;
    wire [31:0]     rotword, subwordx,rconx;
    wire [31:0]     temp,temp_1,temp_2;
    wire [31:0]     W0,W1,W2,W3;
    wire [127:0]    inSubBytes,outSubBytes;
    wire [127:0]    outShiftRows;
    wire [127:0]    outMixColumns,inMixColumns;
    wire [127:0]    inAddroundKey_key,inAddroundKey_in,outAddroundKey;
    
    
    // Controller
    always @ (posedge CLK)
    begin 
        if(RST == 1'b0) begin
            round_reg 			<= 4'h0;
            round_add			<= 1'b0;
            round_rconx         <= 4'h1;
        end
        else begin
            if(start_in) begin
                round_add			<= 1'b1;
                round_reg 			<= round_reg + 1'b1;
                round_rconx         <= round_rconx + round_reg[0];
            end
            else if (round_reg == 4'd15) begin
                round_reg  		    <= 4'h0;
                round_add		    <= 1'b0;
                round_rconx         <= 1'b1;
            end
            else begin
                round_add			<= round_add;
                round_reg 			<= round_reg + round_add;
                round_rconx         <= round_rconx + round_reg[0];
            end
        end
	end  
	
    
    assign w = start_in ? key_in : w_reg;
    
	assign rotword = {w[23:0],w[31:24]};
    subwordx subwordx_0(.in(rotword),.out(subwordx));
    rconx rconx_0(.in(round_rconx),.out(rconx));
    assign temp_1 = subwordx ^ rconx;
    
    subwordx subwordx_1(.in(w[31:0]),.out(temp_2));
    
    assign temp = round_reg[0] ? temp_2 : temp_1;
      
    assign W0 = w[255:224] ^ temp;
    assign W1 = w[223:192] ^ W0;
    assign W2 = w[191:160] ^ W1;
    assign W3 = w[159:128] ^ W2;
    

	//Key_Expansion
	always @ (posedge CLK)
    begin 
        if(RST == 1'b0) begin
            temp_reg			<= 32'h0;
            w_reg               <= 256'h0;
        end
        else begin
            w_reg <= {w[127:0],W0,W1,W2,W3};
        end
    end
	// Addroundkey
    assign state0 = key_in[255:128] ^ plaintext;
    
    // Encrypt
    assign inSubBytes = start_in ? state0 : ciphertext_reg;
    subBytes subBytes_0(.in(inSubBytes),.out(outSubBytes));
    

    shiftRows shiftRows_0(.in(outSubBytes),.shifted(outShiftRows));
    
    mixColumns mixColumns_0(.in(outShiftRows),.out(outMixColumns));
    
    assign inAddroundKey_in = (round_reg == 4'd13) ? outShiftRows : outMixColumns;
    assign inAddroundKey_key = start_in ? key_in[127:0] : w_reg[127:0];
    assign outAddroundKey = inAddroundKey_in ^ inAddroundKey_key;
    
    always @ (posedge CLK)
    begin 
        if(RST == 1'b0) begin
            ciphertext_reg		<= 128'h0;
            ciphertext		    <= 128'h0;
            valid_out           <= 1'b0;
        end
        else begin
            ciphertext_reg      <= outAddroundKey;
        end
        
        if(start_in) begin								
            ciphertext          <= 128'h0;    
			valid_out			<= 1'b0;
			end
		else if (round_reg == 4'd14) begin
            ciphertext          <= ciphertext_reg;
            valid_out           <= 1'b1;
        end
        else begin
            ciphertext          <= 128'h0;
            valid_out           <= 1'b0;       

        end   
    end
    
   
    
endmodule
