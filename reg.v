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
// ע���� ena �ź���Чʱ��rst Ҳ�������üĴ���
input ena, // 
input[31:0]data_in, // 31 λ���룬�������ݽ�������Ĵ����ڲ�
output reg[31:0]data_out // 31 λ���������ʱʼ����� PC �Ĵ����ڲ��洢��ֵ
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
