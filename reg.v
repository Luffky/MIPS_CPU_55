`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:27:13 04/05/2016 
// Design Name: 
// Module Name:    reg 
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
module pcreg(
input clk, 
input rst, 
// 注：当 ena 信号无效时，rst 也可以重置寄存器
input ena, // 
input[31:0]data_in, // 31 位输入，输入数据将被存入寄存器内部
output reg[31:0]data_out // 31 位输出，工作时始终输出 PC 寄存器内部存储的值
);
initial data_out = 0;
always @ (*)
begin 
if(rst==1)
	 data_out = 0;
else 
	 if(ena==0)
		  data_out = data_in;
	 else
	     data_out = data_out;
end
endmodule 
