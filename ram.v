`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:00 05/01/2016 
// Design Name: 
// Module Name:    ram 
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
module ram(
    input clk,
    input ce,
    input we,
    input [31:0] addr,
    input [3:0] sel,
    input [31:0] data_i,
    output reg[31:0] data_o
    );
reg[7:0] data_mem0[0:1000];
reg[7:0] data_mem1[0:1000];
reg[7:0] data_mem2[0:1000];
reg[7:0] data_mem3[0:1000];
reg n;
reg m;
initial n <= 1;
initial m <= 0;
always@(posedge clk)begin
    if(ce == 0)begin
	     
		  end
	 else if(we == 1)begin
	     if(sel[3] == 1'b1)begin
		      data_mem3[addr[18:2]] <= data_i[31:24];
			end
		  if(sel[2] == 1'b1)begin
		      data_mem2[addr[18:2]] <= data_i[23:16];
			end
			if(sel[1] == 1'b1)begin
		      data_mem1[addr[18:2]] <= data_i[15:8];
			end
			if(sel[0] == 1'b1)begin
		      data_mem0[addr[18:2]] <= data_i[7:0];
			end
		end
end
always@(*)begin
    if(ce == 0)begin
	     data_o <= 32'h00000000;
		  end
	else if(we == 0)begin
	    data_o <= {data_mem3[addr[18:2]],
		           data_mem2[addr[18:2]],
					  data_mem1[addr[18:2]],
					  data_mem0[addr[18:2]]};
       end
	else begin
	    data_o <= 32'h00000000;
		 end
end


endmodule
