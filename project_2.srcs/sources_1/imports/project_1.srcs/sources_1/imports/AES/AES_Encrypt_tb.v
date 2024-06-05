module AES_Encrypt_tb;
reg                 start_in;
reg                 CLK;
reg                 RST;
reg     [255:0]     key_in;
reg     [127:0]     plaintext;
wire    [127:0]     ciphertext;
wire                valid_out;


wire    [3:0]       check_round_reg;
wire    [127:0]     check_ciphertext;


    AES_Encrypt uut (
        .start_in(start_in),
        .CLK(CLK),
        .RST(RST),
        .key_in(key_in),
        .plaintext(plaintext),
        .ciphertext(ciphertext),
        .valid_out(valid_out)
    );
    
    assign check_round_reg = uut.round_reg;
    assign check_ciphertext = uut.outShiftRows;
     always #5 CLK = ~CLK;
    initial begin
    CLK = 0;
    RST <= 0;
    key_in = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    plaintext = 128'h00112233445566778899aabbccddeeff;
    
    #6 RST <= 1;
   start_in = 1; 
  #10  start_in = 0;
  #10000 $stop;
    end
endmodule
