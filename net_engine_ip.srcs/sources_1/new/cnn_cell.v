`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2024 05:39:35 PM
// Design Name: 
// Module Name: conv_cell
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

module conv_cell
#(
    parameter DATA_WIDTH  = 32,
    parameter KERNAL_SIZE = 3
)(
    // input ports
    input wire C_IN_CLK,
    input wire C_IN_RST,
    input wire C_IN_DATA_VALID,
    input wire [DATA_WIDTH-1:0] D_IN_BIAS,
    
    // input kernal 
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_1,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_2,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_3,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_4,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_5,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_6,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_7,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_8,
    input wire [DATA_WIDTH-1:0]	D_IN_KERNAL_9,
    
    // input data
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_1,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_2,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_3,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_4,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_5,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_6,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_7,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_8,
    input wire [DATA_WIDTH-1:0]	D_IN_DATA_9,
    // output ports
    output                 C_OUT_DATA_VALID,
    output[DATA_WIDTH-1:0] C_OUT_DATA
);

// internal params
integer sum_i, mul_i;

// internal registers
reg [DATA_WIDTH-1:0] sum_reg;
reg [DATA_WIDTH-1:0] o_data_reg;
reg [DATA_WIDTH-1:0] o_data_reg_temp;
reg [DATA_WIDTH-1:0] multiply_reg [(KERNAL_SIZE * KERNAL_SIZE) - 1:0];

// control registers
reg o_data_valid_reg;
reg sum_data_valid;
reg multiply_data_valid;


// multiply operation
always @(posedge C_IN_CLK) begin
    if(C_IN_DATA_VALID) begin
        multiply_reg[0] <= D_IN_DATA_1 * D_IN_KERNAL_1;
        multiply_reg[1] <= D_IN_DATA_2 * D_IN_KERNAL_2;
        multiply_reg[2] <= D_IN_DATA_3 * D_IN_KERNAL_3;
        multiply_reg[3] <= D_IN_DATA_4 * D_IN_KERNAL_4;
        multiply_reg[4] <= D_IN_DATA_5 * D_IN_KERNAL_5;
        multiply_reg[5] <= D_IN_DATA_6 * D_IN_KERNAL_6;
        multiply_reg[6] <= D_IN_DATA_7 * D_IN_KERNAL_7;
        multiply_reg[7] <= D_IN_DATA_8 * D_IN_KERNAL_8;
        multiply_reg[8] <= D_IN_DATA_9 * D_IN_KERNAL_9;
    end
    
    multiply_data_valid <= C_IN_DATA_VALID;
end

// sum operation
always @(*) begin
    sum_reg = 0;
    for(sum_i = 0; sum_i < (KERNAL_SIZE * KERNAL_SIZE); sum_i = sum_i + 1) begin
        sum_reg = sum_reg + multiply_reg[sum_i];
    end
    
    sum_data_valid <= multiply_data_valid;
end

// adding bias
always @(posedge C_IN_CLK) begin

    if (C_IN_RST) begin
        o_data_valid_reg <= 0;
    end else begin
        if (C_IN_DATA_VALID) begin
            o_data_reg       <= sum_reg * D_IN_BIAS;
            o_data_valid_reg <= sum_data_valid;
        end else begin
            o_data_reg       <= 0;
            o_data_valid_reg <= 0;
        end
    end
end

// bit reversing
integer i;
always @(*) begin
    for (i = 0; i < 4; i = i + 1) begin 
        o_data_reg_temp[i*8 + 7] = o_data_reg[i*8 + 0];
        o_data_reg_temp[i*8 + 6] = o_data_reg[i*8 + 1];
        o_data_reg_temp[i*8 + 5] = o_data_reg[i*8 + 2];
        o_data_reg_temp[i*8 + 4] = o_data_reg[i*8 + 3];
        o_data_reg_temp[i*8 + 3] = o_data_reg[i*8 + 4];
        o_data_reg_temp[i*8 + 2] = o_data_reg[i*8 + 5];
        o_data_reg_temp[i*8 + 1] = o_data_reg[i*8 + 6];
        o_data_reg_temp[i*8 + 0] = o_data_reg[i*8 + 7];
    end
end

// assigning
assign C_OUT_DATA_VALID = o_data_valid_reg;
assign C_OUT_DATA       = { o_data_reg_temp[7:0], 
                            o_data_reg_temp[15:8], 
                            o_data_reg_temp[23:16], 
                            o_data_reg_temp[31:24]};

endmodule
