`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:08 04/27/2016 
// Design Name: 
// Module Name:    ROM 
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
module ROM(
    input ce,
    input [31:0] addr,
    output reg [31:0] inst
    );
reg[31:0] inst_mem[0:1000];

initial $readmemh ("_2_sll.hex.txt", inst_mem);

always@(*)begin
if(ce==0)begin
    inst <= 8'h00000000;
	      end
else begin
    inst <= inst_mem[addr[18:2]];
	  end
end


endmodule
