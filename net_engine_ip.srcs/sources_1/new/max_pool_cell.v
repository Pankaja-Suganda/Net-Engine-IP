`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2024 09:51:46 PM
// Design Name: 
// Module Name: max_pool_cell
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


module maxpooling_cell #(
    DATA_WIDTH   = 32
)(
    input wire C_IN_CLK,
    input wire C_IN_RST,
    input wire C_IN_DATA_VALID,
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

// Internal signals for max pooling operation
reg [DATA_WIDTH-1:0] max_1_2;
reg [DATA_WIDTH-1:0] max_3_4;
reg [DATA_WIDTH-1:0] max_5_6;
reg [DATA_WIDTH-1:0] max_7_8;
reg [DATA_WIDTH-1:0] max_1_2_3_4;
reg [DATA_WIDTH-1:0] max_5_6_7_8;
reg [DATA_WIDTH-1:0] max_pool;
reg                  output_valid;
reg [DATA_WIDTH-1:0] output_data;
reg [DATA_WIDTH-1:0] o_data_reg_temp;
reg [DATA_WIDTH-1:0] d_in_data_9_temp;

reg first_stage_valid;
reg second_stage_valid;
// first stage
always @(posedge C_IN_CLK or posedge C_IN_RST) begin
    if (C_IN_RST) begin
        max_1_2 <= 0;
        max_3_4 <= 0;
        max_5_6 <= 0;
        max_7_8 <= 0;
        first_stage_valid <= 'b0;
    end else if (C_IN_DATA_VALID) begin
        max_1_2 <= (D_IN_DATA_1 > D_IN_DATA_2) ? D_IN_DATA_1 : D_IN_DATA_2;
        max_3_4 <= (D_IN_DATA_3 > D_IN_DATA_4) ? D_IN_DATA_3 : D_IN_DATA_4;
        max_5_6 <= (D_IN_DATA_5 > D_IN_DATA_6) ? D_IN_DATA_5 : D_IN_DATA_6;
        max_7_8 <= (D_IN_DATA_7 > D_IN_DATA_8) ? D_IN_DATA_7 : D_IN_DATA_8;
        d_in_data_9_temp <= D_IN_DATA_9;
        first_stage_valid <= 'b1;
    end
    else if (second_stage_valid) begin
        first_stage_valid <= 'b0;
    end
end

// second stage
always @(posedge C_IN_CLK or posedge C_IN_RST) begin
    if (C_IN_RST) begin
        max_1_2_3_4 <= 0;
        max_5_6_7_8 <= 0;
        second_stage_valid <= 'b0;
    end else if (first_stage_valid) begin
        max_1_2_3_4 <= (max_1_2 > max_3_4) ? max_1_2 : max_3_4;
        max_5_6_7_8 <= (max_5_6 > max_7_8) ? max_5_6 : max_7_8;
        second_stage_valid <= 'b1;
    end
    else if (output_valid) begin
        second_stage_valid <= 'b0;
    end
end

// third stage
always @(posedge C_IN_CLK or posedge C_IN_RST) begin
    if (C_IN_RST) begin
        max_pool <= 0;
    end else if (second_stage_valid) begin
        // Calculate the maximum of max_1_2_3_4 and max_5_6_7_8 first
        if (max_1_2_3_4 > max_5_6_7_8) begin
            max_pool <= max_1_2_3_4;
        end else begin
            max_pool <= max_5_6_7_8;
        end

        // Then calculate the maximum of max_pool and D_IN_DATA_9
        if (max_pool > d_in_data_9_temp) begin
            output_data <= max_pool;
        end else begin
            output_data <= d_in_data_9_temp;
        end

        output_valid <= 1'b1;
    end else begin
        output_data  <= 0;
        output_valid <= 1'b0;
    end
end

// bit reversing
integer i;
always @(*) begin
    for (i = 0; i < 4; i = i + 1) begin 
        o_data_reg_temp[i*8 + 7] = output_data[i*8 + 0];
        o_data_reg_temp[i*8 + 6] = output_data[i*8 + 1];
        o_data_reg_temp[i*8 + 5] = output_data[i*8 + 2];
        o_data_reg_temp[i*8 + 4] = output_data[i*8 + 3];
        o_data_reg_temp[i*8 + 3] = output_data[i*8 + 4];
        o_data_reg_temp[i*8 + 2] = output_data[i*8 + 5];
        o_data_reg_temp[i*8 + 1] = output_data[i*8 + 6];
        o_data_reg_temp[i*8 + 0] = output_data[i*8 + 7];
    end
end
assign C_OUT_DATA       = { o_data_reg_temp[7:0], 
                            o_data_reg_temp[15:8], 
                            o_data_reg_temp[23:16], 
                            o_data_reg_temp[31:24]};
assign C_OUT_DATA_VALID = output_valid;

endmodule