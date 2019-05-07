`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:37:38 04/26/2016 
// Design Name: 
// Module Name:    PC 
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



module PC(
output reg [31:0]pc_addr,
output reg [31:0]addr,
/////
input flush,
input [31:0] new_pc,
/////
input clk,
input rst,
input [5:0] stall,
input branch_flag_i,
input [31:0] branch_target_address_i,

output reg ce
);
always@(posedge clk )begin
if(rst) begin
	 ce <= 0;
	     end
else begin
    ce <= 1;
	  end
end 

always@(posedge clk)begin
if(rst)begin
     pc_addr <= 32'b00000000000000000000000000000000;
	  addr <= 32'b00000000000000000000000000000000;
	        end
else if(flush == 1'b1) begin
    pc_addr <= new_pc;
	 addr <= new_pc;
	 end
else if(stall[0] == 0 && branch_flag_i == 1) begin
    pc_addr <= branch_target_address_i;
	 addr <= branch_target_address_i;
	        end
			  
else if(stall[0] == 0)begin
    pc_addr <= pc_addr + 4;
	 addr <= addr+4;
	        end
	 
end 


endmodule
