`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 09:20:18 AM
// Design Name: 
// Module Name: randombytes_init
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


module randombytes_init(
        input  wire              start_in,
        input  wire              CLK,
        input  wire              RST,
        input  wire     [383:0]  entropy_input,
        input  wire     [383:0]  personalization_string,
        input  wire     [31:0]   security_strength,
        output reg      [255:0]  key_out,
        output reg      [127:0]  V_out,
        output reg                valid_out
    );
    //reg [383:0] seed_material; /// same provide data
    reg [255:0] key_in;
    reg [127:0] V_in;
    
    reg ctr_condition;

    
    wire [383:0] seed_material_wr;
    
    wire start_in_wr;
    wire [255:0] key_out_wr;
    wire [127:0] V_out_wr;
    wire valid_out_wr;
    
    assign start_in_wr = start_in;
    //assign seed_material_wr = ctr_condition ? (entropy_input ^ personalization_string) : entropy_input;
    assign seed_material_wr = entropy_input;
    
    AES256_CTR_DRBG_Update Update_ramdombytes_init (.start_in(start_in_wr),
                                                    .CLK(CLK),
                                                    .RST(RST),
                                                    .key_in(key_in),
                                                    .provided_data(seed_material_wr),
                                                    .V_in(V_in),
                                                    .key_out(key_out_wr),
                                                    .V_out(V_out_wr),
                                                    .valid_out(valid_out_wr)  
                                                                                );
    always @ (posedge CLK)
    begin
        if (!RST) begin
            //seed_material <= 384'b0;
            key_in <= 256'b0;
            V_in <= 128'b0;
            valid_out <=1'b0; 
            key_out <= 256'b0;
            V_out <= 128'b0;
        end
        else begin 
            if (start_in) begin
                key_out <= 256'h0;
                V_out   <= 128'h0;
                valid_out <= 1'b0;
            end
            else if (valid_out_wr == 1'b1) begin
                key_out <= key_out_wr;
                V_out <= V_out_wr;
                valid_out <= 1'b1;
            end
            else begin
                key_out <= key_out_wr;
                V_out   <= V_out_wr;
                valid_out <= valid_out;  
            end
        end
       // if (personalization_string == 384'bx)
        //    ctr_condition <= 1'b0;
        //else 
        //    ctr_condition <= 1'b1;
    end
    
    
 
    
endmodule
