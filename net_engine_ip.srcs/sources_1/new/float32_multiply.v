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


module float32_multiply(
        input             in_clk,
        input      [31:0] in_A,
        input      [31:0] in_B,
        input             in_valid,
        output    [31:0] out_result
    );
    
    // Splitting float parts
    // | Sign Bit (1) | exponent Bits (8) | Mactissa bits (23)
    wire sign_bit_A       = in_A[31];
    wire sign_bit_B       = in_B[31];
    
    wire [7:0] exponent_A = in_A[30:23];
    wire [7:0] exponent_B = in_B[30:23];
    
    wire [22:0] mantissa_A = in_A[22:0];
    wire [22:0] mantissa_B = in_B[22:0];
 
     // Sign of the result
    wire sign_bit = sign_bit_A ^ sign_bit_B;

    // Add the exponents
    wire [8:0] exponent_bits_temp = exponent_A + exponent_B - 127;

    // Multiply the mantissas
    wire [47:0] mantissa_bits_temp = {1'b1, mantissa_A} * {1'b1, mantissa_B};

    // Normalize the result
    reg [7:0]  exponent_bits;
    reg [22:0] mantissa_bits;
    reg [31:0] out_result_temp;
    
    always @(posedge in_clk) begin
        if (mantissa_bits_temp[47]) begin
            exponent_bits = exponent_bits_temp + 1;
            mantissa_bits = mantissa_bits_temp[46:24];
        end else begin
            exponent_bits = exponent_bits_temp;
            mantissa_bits = mantissa_bits_temp[45:23];
        end
    end

    // Handle special cases (infinity, NaN, zero)
    always @(posedge in_clk) begin
        if  (in_valid) begin
            if (exponent_A == 8'hFF || exponent_B == 8'hFF) begin
                out_result_temp = {sign_bit, 8'hFF, 23'h0}; // Infinity
            end else if (exponent_A == 0 || exponent_B == 0) begin
                out_result_temp = {sign_bit, 8'h00, 23'h0}; // Zero
            end else begin
                out_result_temp = {sign_bit, exponent_bits, mantissa_bits};
            end
        end
        else begin
            out_result_temp = {sign_bit, 8'h00, 23'h0}; // Zero
        end
    end
    
    assign out_result = out_result_temp;
    
endmodule
