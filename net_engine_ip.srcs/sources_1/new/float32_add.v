`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024 12:34:29 AM
// Design Name: 
// Module Name: float32_multiply
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


module float32_add(
        input      [31:0] in_A,
        input      [31:0] in_B,
        output reg [31:0] out_result
    );
    
    // Splitting float parts
    // | Sign Bit (1) | exponent Bits (8) | Mactissa bits (23)
    wire sign_bit_A       = in_A[31];
    wire sign_bit_B       = in_B[31];
    
    wire [7:0] exponent_A = in_A[30:23];
    wire [7:0] exponent_B = in_B[30:23];
    
    wire [22:0] mantissa_A = in_A[22:0];
    wire [22:0] mantissa_B = in_B[22:0];
 
     // Aligning exponents
    wire exp_diff = exponent_A > exponent_B? exponent_A - exponent_B: exponent_B - exponent_A;
    wire [23:0] aligned_mant_A = exponent_A > exponent_B ? mantissa_A : mantissa_A >> exp_diff;
    wire [23:0] aligned_mant_B = exponent_B > exponent_A ? mantissa_B : mantissa_B >> exp_diff;
    wire [7:0]  exp_result     = exponent_A > exponent_B ? exponent_A : exponent_B;

    // Add mantissas
    wire [24:0] mantissa_sum = (sign_bit_A == sign_bit_B) ? 
                               (aligned_mant_A + aligned_mant_B) : 
                               (aligned_mant_A - aligned_mant_B);
    reg [7:0]  exponent_bits;
    reg [22:0] mantissa_bits;
    
    // Normalize the result
    always @(*) begin
        if (mantissa_sum[24]) begin
            exponent_bits = exp_result + 1;
            mantissa_bits = mantissa_sum[24:1];
        end else begin
            exponent_bits = exp_result;
            mantissa_bits = mantissa_sum[23:0];
        end
    end


    // Handle special cases (zero, infinity, NaN)
    always @(*) begin
        if (in_A == 32'b0) begin
            out_result = in_B;
        end else if (in_B == 32'b0) begin
            out_result = in_A;
        end else if (exponent_A == 8'b11111111 || exponent_B == 8'b11111111) begin
            if (mantissa_A != 0 || mantissa_B != 0) begin
                out_result = 32'h7FC00000; // NaN
            end else begin
                out_result = {sign_bit_A, 8'b11111111, 23'b0}; // Infinity
            end
        end else begin
            out_result = {sign_bit_A, exponent_bits, mantissa_bits[22:0]};
        end
    end
    
endmodule
