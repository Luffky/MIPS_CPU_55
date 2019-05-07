`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:47 05/18/2016 
// Design Name: 
// Module Name:    clk 
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
module clk(
    input clk_in,
	 input rst, 
    output reg clk_out
    );
reg[7:0] cnt;
initial clk_out = 0;
initial cnt = 0;
always@(posedge clk_in)
begin
    
	     if(cnt == 2)
		      begin
				    clk_out <= ~clk_out;
					 cnt <= 0;
				end
		  else 
		      cnt <= cnt + 1;
	
end

endmodule
