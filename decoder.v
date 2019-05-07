`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:55 05/05/2032 
// Design Name: 
// Module Name:    decoder 
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
module decoder(
input[4:0]data_in,
input ena,
output[31:0]data_out
);
reg[31:0]data_temp;
assign data_out=data_temp;
always@(*) begin
if(ena==1)
case(data_in)
5'b000:
data_temp=32'b11111111111111111111111111111111;
5'b001:
data_temp=32'b11111111111111111111111111111101;
5'b010:
data_temp=32'b11111111111111111111111111111011;
5'b011:
data_temp=32'b11111111111111111111111111110111;
5'b100:
data_temp=32'b11111111111111111111111111101111;
5'b101:
data_temp=32'b11111111111111111111111111011111;
5'b110:
data_temp=32'b11111111111111111111111110111111;
5'b111:
data_temp=32'b11111111111111111111111101111111;
5'b1000:
data_temp=32'b11111111111111111111111011111111;
5'b1001:
data_temp=32'b11111111111111111111110111111111;
5'b1010:
data_temp=32'b11111111111111111111101111111111;
5'b1011:
data_temp=32'b11111111111111111111011111111111;
5'b1100:
data_temp=32'b11111111111111111110111111111111;
5'b1101:
data_temp=32'b11111111111111111101111111111111;
5'b1110:
data_temp=32'b11111111111111111011111111111111;
5'b1111:
data_temp=32'b11111111111111110111111111111111;
5'b10000:
data_temp=32'b11111111111111101111111111111111;
5'b10001:
data_temp=32'b11111111111111011111111111111111;
5'b10010:
data_temp=32'b11111111111110111111111111111111;
5'b10011:
data_temp=32'b11111111111101111111111111111111;
5'b10100:
data_temp=32'b11111111111011111111111111111111;
5'b10101:
data_temp=32'b11111111110111111111111111111111;
5'b10110:
data_temp=32'b11111111101111111111111111111111;
5'b10111:
data_temp=32'b11111111011111111111111111111111;
5'b11000:
data_temp=32'b11111110111111111111111111111111;
5'b11001:
data_temp=32'b11111101111111111111111111111111;
5'b11010:
data_temp=32'b11111011111111111111111111111111;
5'b11011:
data_temp=32'b11110111111111111111111111111111;
5'b11100:
data_temp=32'b11101111111111111111111111111111;
5'b11101:
data_temp=32'b11011111111111111111111111111111;
5'b11110:
data_temp=32'b10111111111111111111111111111111;
5'b11111:
data_temp=32'b01111111111111111111111111111111;
endcase
else
data_temp=32'b11111111111111111111111111111111;
end
endmodule
