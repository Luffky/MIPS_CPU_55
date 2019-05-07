`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:34:42 04/26/2016 
// Design Name: 
// Module Name:    IDEX 
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
module IDEX(
input rst,
input clk,
input [5:0] stall,
input [7:0] id_aluop,
input [2:0] id_alusel,
input [31:0] id_reg1,
input [31:0] id_reg2,
input [4:0] id_wd,
input id_wreg,

input [31:0] id_link_address,
input id_is_in_delayslot,
input next_inst_in_delayslot_i,

input [31:0] id_inst,

//////////////
input flush,
input [31:0] id_current_inst_address,
input [31:0] id_excepttype,
output reg [31:0] ex_current_inst_address,
output reg [31:0] ex_excepttype,
//////////////

output reg[31:0] ex_inst,

output reg[31:0] ex_link_address,
output reg ex_is_in_delayslot,
output reg is_in_delayslot_o, 

output reg[7:0] ex_aluop,
output reg[2:0] ex_alusel,
output reg[31:0] ex_reg1,
output reg[31:0] ex_reg2,
output reg [4:0] ex_wd,
output reg ex_wreg
);
always@(posedge clk) begin
if(rst) begin
    ex_aluop <= 8'b00000000;
	 ex_alusel <= 3'b000;
	 ex_reg1 <= 32'h00000000;
	 ex_reg2 <= 32'h00000000;
	 ex_wd <=5'b00000;
	 ex_wreg <= 0;
	 ex_link_address <= 8'h00000000;
	 ex_is_in_delayslot <= 0;
	 is_in_delayslot_o <= 0;
	 ex_excepttype <= 32'h00000000;
	 ex_current_inst_address <= 32'h00000000;
	 end
else if (flush == 1'b1) begin 
    ex_aluop <= 8'b00000000;
	 ex_alusel <= 3'b000;
	 ex_reg1 <= 8'h00000000;
	 ex_reg2 <= 8'h00000000;
	 ex_wd <= 5'b00000;
	 ex_wreg <= 1'b0;
	 ex_excepttype <= 32'h00000000;
	 ex_current_inst_address <= 32'h00000000;
	 ex_link_address <= 8'h00000000;
	 ex_is_in_delayslot <= 1'b0;
	 is_in_delayslot_o <= 1'b0;
	 ex_inst <= 32'h00000000;
	 end
else if (stall[2] == 1 && stall[3] == 0) begin
    ex_aluop <= 8'b00000000;
	 ex_alusel <= 3'b000;
	 ex_reg1 <= 8'h00000000;
	 ex_reg2 <= 8'h00000000;
	 ex_wd <= 5'b00000;
	 ex_wreg <= 1'b0;
	 ex_link_address <= 8'h00000000;
	 ex_is_in_delayslot <= 1'b0;
	 is_in_delayslot_o <= 1'b0;
	 ex_inst <= id_inst;
	 ex_excepttype <= 32'h00000000;
	 ex_current_inst_address <= 32'h00000000;
	 end
else if(stall[2] == 0) begin 
    ex_aluop <= id_aluop;
	 ex_alusel <= id_alusel;
	 ex_reg1 <= id_reg1;
	 ex_reg2 <= id_reg2;
	 ex_wd <=id_wd;
	 ex_wreg <= id_wreg;
	 ex_link_address <= id_link_address;
	 ex_is_in_delayslot <= id_is_in_delayslot;
	 is_in_delayslot_o <= next_inst_in_delayslot_i;
	 ex_inst <= id_inst;
	 ex_excepttype <= id_excepttype;
	 ex_current_inst_address <= id_current_inst_address;
    end 
end


endmodule
