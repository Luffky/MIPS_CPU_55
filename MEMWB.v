`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:05:55 04/27/2016 
// Design Name: 
// Module Name:    MEMWB 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MEMWB(
    input clk,
    input rst,
	 input [5:0] stall,
    input [4:0] mem_wd,
    input mem_wreg,
    input [31:0] mem_wdata,
	 input [31:0] mem_hi,
	 input [31:0] mem_lo,
	 input  mem_whilo,
////////////////////
    input mem_cp0_reg_we,
	 input [4:0] mem_cp0_reg_write_addr,
	 input [31:0] mem_cp0_reg_data,
	 
	 input flush,
	 
	 output reg wb_cp0_reg_we,
	 output reg[4:0]wb_cp0_reg_write_addr,
	 output reg [31:0] wb_cp0_reg_data,
/////////////////////
	  
    output reg [4:0] wb_wd,
    output reg wb_wreg,
    output reg [31:0] wb_wdata,
	 output reg [31:0] wb_hi,
	 output reg [31:0] wb_lo,
	 output reg wb_whilo
    );
always@(posedge clk) begin 
if(rst) begin
    wb_wd <= 5'b00000;
	 wb_wreg <= 0;
	 wb_wdata <= 32'h00000000;
	 wb_hi <= 8'h00000000;
	 wb_lo <= 8'h00000000;
	 wb_whilo <= 0;
	 wb_cp0_reg_we <= 1'b0;
	 wb_cp0_reg_write_addr <= 5'b00000;
	 wb_cp0_reg_data <= 32'h00000000;
	    end 
else if(flush == 1'b1) begin
   wb_wd <= 5'b00000;
	 wb_wreg <= 0;
	 wb_wdata <= 32'h00000000;
	 wb_hi <= 8'h00000000;
	 wb_lo <= 8'h00000000;
	 wb_whilo <= 0;
	 wb_cp0_reg_we <= 1'b0;
	 wb_cp0_reg_write_addr <= 5'b00000;
	 wb_cp0_reg_data <= 32'h00000000;
	 end
else if(stall[4] == 1 && stall[5] == 0) begin 
    wb_wd <= 5'b00000;
	 wb_wreg <= 0;
	 wb_wdata <= 8'h00000000;
	 wb_hi <= 8'h00000000;
	 wb_lo <= 8'h00000000;
	 wb_whilo <= 0;
	 wb_cp0_reg_we <= 1'b0;
	 wb_cp0_reg_write_addr <= 5'b00000;
	 wb_cp0_reg_data <= 32'h00000000;
	 end
else if(stall[4] == 0) begin 
    wb_wd <= mem_wd;
	 wb_wreg <= mem_wreg;
	 wb_wdata <= mem_wdata;
	 wb_hi <= mem_hi;
	 wb_lo <= mem_lo;
	 wb_whilo <= mem_whilo;
    wb_cp0_reg_we <= mem_cp0_reg_we;
	 wb_cp0_reg_write_addr <= mem_cp0_reg_write_addr;
	 wb_cp0_reg_data <= mem_cp0_reg_data;
	 end
end

endmodule
