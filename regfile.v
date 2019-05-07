`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:58 03/28/2016 
// Design Name: 
// Module Name:    regfile 
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
module regfiles( 
input clk, //寄存器组时钟信号，下降沿写入数据（注意：pc 为上升沿， 此为下降沿
input rst, //reset 信号，reset 有效时全部寄存器置零
input we, //写有效信号，we 有效时寄存器才能被写
input[4:0]raddr1, //所需读取的寄存器的地
input[4:0]raddr2, //所需读取的寄存器的地址

input[4:0]waddr, //写寄存器的地址
input[31:0]wdata, //写寄存器数据
output[31:0]rdata1, //raddr1 所对应寄存器的数据，只要有 raddr1 的输入即输出 相应数据
output[31:0]rdata2 //raddr2 所对应寄存器的数据，只要有 raddr2 的输入即输出 相应数据

);

wire [31:0] out;
wire [31:0] d0;
wire [31:0] d1;
wire [31:0] d2;
wire [31:0] d3;
wire [31:0] d4;
wire [31:0] d5;
wire [31:0] d6;
wire [31:0] d7;
wire [31:0] d8;
wire [31:0] d9;
wire [31:0] d10;
wire [31:0] d11;
wire [31:0] d12;
wire [31:0] d13;
wire [31:0] d14;
wire [31:0] d15;
wire [31:0] d16;
wire [31:0] d17;
wire [31:0] d18;
wire [31:0] d19;
wire [31:0] d20;
wire [31:0] d21;
wire [31:0] d22;
wire [31:0] d23;
wire [31:0] d24;
wire [31:0] d25;
wire [31:0] d26;
wire [31:0] d27;
wire [31:0] d28;
wire [31:0] d29;
wire [31:0] d30;
wire [31:0] d31;
pcreg rr0(clk, rst, out[0], wdata, d0);
pcreg rr1(clk, rst, out[1], wdata, d1);
pcreg rr2(clk, rst, out[2], wdata, d2);
pcreg rr3(clk, rst, out[3], wdata, d3);
pcreg rr4(clk, rst, out[4], wdata, d4);
pcreg rr5(clk, rst, out[5], wdata, d5);
pcreg rr6(clk, rst, out[6], wdata, d6);
pcreg rr7(clk, rst, out[7], wdata, d7);
pcreg rr8(clk, rst, out[8], wdata, d8);
pcreg rr9(clk, rst, out[9], wdata, d9);
pcreg rr10(clk, rst, out[10], wdata, d10);
pcreg rr11(clk, rst, out[11], wdata, d11);
pcreg rr12(clk, rst, out[12], wdata, d12);
pcreg rr13(clk, rst, out[13], wdata, d13);
pcreg rr14(clk, rst, out[14], wdata, d14);
pcreg rr15(clk, rst, out[15], wdata, d15);
pcreg rr16(clk, rst, out[16], wdata, d16);
pcreg rr17(clk, rst, out[17], wdata, d17);
pcreg rr18(clk, rst, out[18], wdata, d18);
pcreg rr19(clk, rst, out[19], wdata, d19);
pcreg rr20(clk, rst, out[20], wdata, d20);
pcreg rr21(clk, rst, out[21], wdata, d21);
pcreg rr22(clk, rst, out[22], wdata, d22);
pcreg rr23(clk, rst, out[23], wdata, d23);
pcreg rr24(clk, rst, out[24], wdata, d24);
pcreg rr25(clk, rst, out[25], wdata, d25);
pcreg rr26(clk, rst, out[26], wdata, d26);
pcreg rr27(clk, rst, out[27], wdata, d27);
pcreg rr28(clk, rst, out[28], wdata, d28);
pcreg rr29(clk, rst, out[29], wdata, d29);
pcreg rr30(clk, rst, out[30], wdata, d30);
pcreg rr31(clk, rst, out[31], wdata, d31);
mux1 m1(d0, d1, d2, d3, d4, d5, d6, d7
, d8, d9, d10, d11, d12, d13, d14, d15
, d16, d17, d18, d19, d20, d21, d22, d23
, d24, d25, d26, d27, d28, d29, d30, d31, raddr1, rdata1);

mux1 m2(d0, d1, d2, d3, d4, d5, d6, d7
, d8, d9, d10, d11, d12, d13, d14, d15
, d16, d17, d18, d19, d20, d21, d22, d23
, d24, d25, d26, d27, d28, d29, d30, d31, raddr2, rdata2);


decoder d(waddr, we, out);


endmodule
