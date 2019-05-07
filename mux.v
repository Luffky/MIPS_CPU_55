`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:25:57 05/05/2016 
// Design Name: 
// Module Name:    mux 
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
module mux1(   
input [31:0] a , 
input [31:0] b ,
input [31:0] c ,
input [31:0] d ,
input [31:0] e , 
input [31:0] f ,
input [31:0] g , 
input [31:0] h ,
input [31:0] i , 
input [31:0] j ,
input [31:0] k , 
input [31:0] l ,
input [31:0] m , 
input [31:0] n ,
input [31:0] o ,
input [31:0] p ,
input [31:0] q , 
input [31:0] r ,
input [31:0] s ,
input [31:0] t ,
input [31:0] u , 
input [31:0] v ,
input [31:0] w , 
input [31:0] x ,
input [31:0] y , 
input [31:0] z ,
input [31:0] z1 , 
input [31:0] z2 ,
input [31:0] z3 , 
input [31:0] z4 ,
input [31:0] z5 ,
input [31:0] z6 ,
input [4:0] se , 
input re1, 
output reg [31:0]  oue
);

always@(*) begin
case(se)
5'b0:
oue = a;
5'b1:
oue = b;
5'b10:
oue = c;
5'b11:
oue = d;
5'b100:
oue = e;
5'b101:
oue = f;
5'b110:
oue = g;
5'b111:
oue = h;
5'b1000:
oue = i;
5'b1001:
oue = j;
5'b1010:
oue = k;
5'b1011:
oue = l;
5'b1100:
oue = m;
5'b1101:
oue = n;
5'b1110:
oue = o;
5'b1111:
oue = p;
5'b10000:
oue = q;
5'b10001:
oue = r;
5'b10010:
oue = s;
5'b10011:
oue = t;
5'b10100:
oue = u;
5'b10101:
oue = v;
5'b10110:
oue = w;
5'b10111:
oue = x;
5'b11000:
oue = y;
5'b11001:
oue = z;
5'b11010:
oue = z1;
5'b11011:
oue = z2;
5'b11100:
oue = z3;
5'b11101:
oue = z4;
5'b11110:
oue = z5;
5'b11111:
oue = z6;
endcase
end
endmodule 
