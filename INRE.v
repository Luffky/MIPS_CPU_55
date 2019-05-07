`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:16 04/26/2016 
// Design Name: 
// Module Name:    INRE 
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
module IFID(

input clk,
input rst,
input [5:0] stall,
input [31:0] if_pc,
input [31:0] if_inst,

input flush,

output reg [31:0] id_pc,
output reg [31:0] id_inst
);
always @(posedge clk)begin
if(rst)begin 
    id_pc <= 32'h00000000;
	 id_inst <= 32'h00000000;
	 end
else if(flush == 1'b1) begin
    id_pc <= 32'h00000000;
	 id_inst <= 32'h00000000;
	 end
else if(stall[1] == 1 && stall[2] == 0)begin
    id_pc <= 32'h00000000;
	 id_inst <= 32'h00000000;
	 end
else if(stall[1] == 0)begin
    id_pc <= if_pc;
	 id_inst <= if_inst;
    end
end



endmodule
