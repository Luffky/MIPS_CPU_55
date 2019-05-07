`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:53:55 04/26/2016 
// Design Name: 
// Module Name:    EXMEM 
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
module EXMEM(
input clk,
input rst,
input [5:0] stall,
input [4:0] ex_wd,
input   ex_wreg,
input [31:0] ex_wdata,
input [31:0] ex_hi,
input [31:0] ex_lo,
input ex_whilo,

input [7:0] ex_aluop,
input [31:0] ex_mem_addr,
input [31:0] ex_reg2,

/////////////////////
input ex_cp0_reg_we,
input [4:0] ex_cp0_reg_write_addr,
input [31:0] ex_cp0_reg_data,

input flush,
input [31:0] ex_excepttype,
input ex_is_in_delayslot,
input [31:0] ex_current_inst_address,

output reg[31:0] mem_excepttype,
output reg mem_is_in_delayslot,
output reg[31:0] mem_current_inst_address,



output reg mem_cp0_reg_we,
output reg[4:0] mem_cp0_reg_write_addr,
output reg[31:0] mem_cp0_reg_data,
//////////////////////


output reg[7:0] mem_aluop,
output reg[31:0] mem_mem_addr,
output reg[31:0] mem_reg2,
output reg[31:0] mem_hi,
output reg[31:0] mem_lo,
output reg mem_whilo,

output reg[4:0] mem_wd,
output reg mem_wreg,
output reg [31:0] mem_wdata
);



always@(posedge clk) begin
if(rst) begin
    mem_wd <= 5'b00000;
	 mem_wreg <= 0;
	 mem_wdata <= 32'h00000000;
	 mem_aluop <= 8'b00000000;
	 mem_mem_addr <= 8'h00000000;
	 mem_reg2 <= 8'h00000000;
	 mem_hi <= 8'h00000000;
	 mem_lo <= 8'h00000000;
	 mem_whilo <= 0;
	 mem_cp0_reg_we <= 1'b0;
	 mem_cp0_reg_write_addr <= 5'b00000;
	 mem_cp0_reg_data <= 32'h00000000;
	 mem_excepttype <= 32'h00000000;
	 mem_is_in_delayslot <= 1'b0;
	 mem_current_inst_address <= 32'h00000000;
	     end
else if (flush == 1'b1) begin
    mem_wd <= 5'b00000;
	 mem_wreg <= 0;
	 mem_wdata <= 32'h00000000;
	 mem_aluop <= 8'b00000000;
	 mem_mem_addr <= 8'h00000000;
	 mem_reg2 <= 8'h00000000;
	 mem_hi <= 8'h00000000;
	 mem_lo <= 8'h00000000;
	 mem_whilo <= 0;
	 mem_cp0_reg_we <= 1'b0;
	 mem_cp0_reg_write_addr <= 5'b00000;
	 mem_cp0_reg_data <= 32'h00000000;
	 mem_excepttype <= 32'h00000000;
	 mem_is_in_delayslot <= 1'b0;
	 mem_current_inst_address <= 32'h00000000;
	 end
else if (stall[3] == 1 && stall[4] == 0)begin
    mem_wd <= 5'b00000;
	 mem_wreg <= 0;
	 mem_wdata <= 8'h00000000;
	 mem_aluop <= 8'b00000000;
	 mem_mem_addr <= 8'h00000000;
	 mem_reg2 <= 8'h00000000;
	 mem_hi <= 8'h00000000;
	 mem_lo <= 8'h00000000;
	 mem_whilo <= 0;
	 mem_cp0_reg_we <= 1'b0;
	 mem_cp0_reg_write_addr <= 5'b00000;
	 mem_cp0_reg_data <= 32'h00000000;
	 mem_excepttype <= 32'h00000000;
	 mem_is_in_delayslot <= 1'b0;
	 mem_current_inst_address <= 32'h00000000;
	 end
else if(stall[3] == 0) begin 
    mem_wd <= ex_wd;
	 mem_wreg <= ex_wreg;
	 mem_wdata <= ex_wdata;
	 mem_aluop <= ex_aluop;
	 mem_mem_addr <= ex_mem_addr;
	 mem_reg2 <= ex_reg2;
	 mem_hi <= ex_hi;
	 mem_lo <= ex_lo;
	 mem_whilo <= ex_whilo;
	 mem_cp0_reg_we <= ex_cp0_reg_we;
	 mem_cp0_reg_write_addr <= ex_cp0_reg_write_addr;
	 mem_cp0_reg_data <= ex_cp0_reg_data;
	 mem_excepttype <= ex_excepttype;
	 mem_is_in_delayslot <= ex_is_in_delayslot;
	 mem_current_inst_address <= ex_current_inst_address;
	 end
end


endmodule
