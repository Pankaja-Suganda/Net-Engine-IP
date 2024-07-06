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

// first stage
always @(posedge C_IN_CLK or posedge C_IN_RST) begin
    if (C_IN_RST) begin
        max_1_2 <= 0;
        max_3_4 <= 0;
        max_5_6 <= 0;
        max_7_8 <= 0;
    end else if (C_IN_DATA_VALID) begin
        max_1_2 <= (D_IN_DATA_1 > D_IN_DATA_2) ? D_IN_DATA_1 : D_IN_DATA_2;
        max_3_4 <= (D_IN_DATA_3 > D_IN_DATA_4) ? D_IN_DATA_3 : D_IN_DATA_4;
        max_5_6 <= (D_IN_DATA_5 > D_IN_DATA_6) ? D_IN_DATA_5 : D_IN_DATA_6;
        max_7_8 <= (D_IN_DATA_7 > D_IN_DATA_8) ? D_IN_DATA_7 : D_IN_DATA_8;
    end
end

// second stage
always @(posedge C_IN_CLK or posedge C_IN_RST) begin
    if (C_IN_RST) begin
        max_1_2_3_4 <= 0;
        max_5_6_7_8 <= 0;
    end else if (C_IN_DATA_VALID) begin
        max_1_2_3_4 <= (max_1_2 > max_3_4) ? max_1_2 : max_3_4;
        max_5_6_7_8 <= (max_5_6 > max_7_8) ? max_5_6 : max_7_8;
    end
end

// third stage
always @(posedge C_IN_CLK or posedge C_IN_RST) begin
    if (C_IN_RST) begin
        max_pool <= 0;
    end else if (C_IN_DATA_VALID) begin
        max_pool <= (max_1_2_3_4 > max_5_6_7_8) ? max_1_2_3_4 : max_5_6_7_8;
        max_pool <= (max_pool > D_IN_DATA_9) ? max_pool : D_IN_DATA_9;
        
        output_data <= max_pool;
        output_valid <= 1'b1;
    end else begin
        output_data  <= 0;
        output_valid <= 1'b0;
    end
end

assign C_OUT_DATA       = output_data;
assign C_OUT_DATA_VALID = output_data;

endmodule
