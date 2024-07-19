`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2024
// Design Name: 
// Module Name: float32_add
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit floating point addition module based on IEEE 754 standard
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module float32_add(
        input             in_clk,
        input      [31:0] in_A,
        input      [31:0] in_B,
        input             in_valid,
        output reg [31:0] out_result
    );
    
    // Splitting float parts
    wire sign_bit_A       = in_A[31];
    wire sign_bit_B       = in_B[31];
    
    wire [7:0] exponent_A = in_A[30:23];
    wire [7:0] exponent_B = in_B[30:23];
    
    wire [22:0] mantissa_A = in_A[22:0];
    wire [22:0] mantissa_B = in_B[22:0];
    
    reg [7:0] exp_diff;
    reg [7:0] exp_result;
    reg [24:0] aligned_mant_A;
    reg [24:0] aligned_mant_B;
    reg [24:0] mantissa_sum;
    reg mantissa_sign;
    reg [7:0] exponent_bits;
    reg [22:0] mantissa_bits;
    
    // Normalize the result
    always @(posedge in_clk) begin
        if (in_valid) begin
            if (in_A == 32'b0) begin
                out_result <= in_B;
            end else if (in_B == 32'b0) begin
                out_result <= in_A;
            end else if (exponent_A == 8'b11111111 || exponent_B == 8'b11111111) begin
                if (mantissa_A != 0 || mantissa_B != 0) begin
                    out_result <= 32'h7FC00000; // NaN
                end else begin
                    out_result <= {sign_bit_A, 8'b11111111, 23'b0}; // Infinity
                end
            end else begin
                // Align exponents
                exp_diff = (exponent_A > exponent_B) ? (exponent_A - exponent_B) : (exponent_B - exponent_A);
                aligned_mant_A = (exponent_A > exponent_B) ? {1'b1, mantissa_A} : {1'b1, mantissa_A} >> exp_diff;
                aligned_mant_B = (exponent_B > exponent_A) ? {1'b1, mantissa_B} : {1'b1, mantissa_B} >> exp_diff;
                exp_result = (exponent_A > exponent_B) ? exponent_A : exponent_B;
                
                // Add or subtract mantissas based on the signs
                mantissa_sum = (sign_bit_A == sign_bit_B) ? (aligned_mant_A + aligned_mant_B) : 
                               ((aligned_mant_A >= aligned_mant_B) ? (aligned_mant_A - aligned_mant_B) : (aligned_mant_B - aligned_mant_A));
                mantissa_sign = (sign_bit_A == sign_bit_B) ? sign_bit_A : (aligned_mant_A >= aligned_mant_B ? sign_bit_A : sign_bit_B);
                
                // Normalize the result
                if (mantissa_sum[24]) begin
                    exponent_bits = exp_result + 1;
                    mantissa_bits = mantissa_sum[23:1];
                end else begin
                    exponent_bits = exp_result;
                    mantissa_bits = mantissa_sum[22:0];
                end
                
                // Handle underflow (result exponent too small)
                if (exponent_bits < 8'b00000001) begin
                    exponent_bits = 8'b00000000;
                    mantissa_bits = mantissa_sum[22:0];
                end
                
                // Construct the output result
                out_result <= {mantissa_sign, exponent_bits, mantissa_bits};
            end
        end
    end
endmodule
