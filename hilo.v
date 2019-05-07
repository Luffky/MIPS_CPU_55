`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:11:17 05/08/2016 
// Design Name: 
// Module Name:    hilo 
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
module hilo(
    input clk,
    input rst,
    input we,
    input [31:0] hi_i,
    input [31:0] lo_i,
    output reg [31:0] hi_o,
    output reg [31:0] lo_o
    );
	always@(posedge clk) begin
	if(rst == 1) begin 
	    hi_o <= 8'h00000000;
		 lo_o <= 8'h00000000;
	    end
   else if(we == 1) begin
	    hi_o <= hi_i;
		 lo_o <= lo_i;
		 end
	end
	


endmodule
