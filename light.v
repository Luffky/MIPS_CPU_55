`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:07 05/25/2016 
// Design Name: 
// Module Name:    light 
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
module light(
    input [31:0] x,
    input clk,
	 input rst,
    output reg [6:0] a_to_g,
	 output reg[7:0] an

    );
wire [2:0] s;
reg [3:0] digit;
reg [31:0] clkdiv;
wire [7:0] aen;

assign s = clkdiv[19:17]; 
assign aen = 8'b11111111;



always@(*)begin
case(s)
    3'b000: digit = x[3:0];
	 3'b001: digit = x[7:4];
	 3'b010: digit = x[11:8];
	 3'b011: digit = x[15:12];
	 3'b100: digit = x[19:16];
	 3'b101: digit = x[23:20];
	 3'b110: digit = x[27:24];
	 3'b111: digit = x[31:28];
endcase
end

always@(*)begin
case(digit)
   0: a_to_g = 7'b0000001;     
   1: a_to_g = 7'b1001111;    
   2: a_to_g = 7'b0010010;     
   3: a_to_g = 7'b0000110;     
   4: a_to_g = 7'b1001100;    
   5: a_to_g = 7'b0100100;     
   6: a_to_g = 7'b0100000;     
   7: a_to_g = 7'b0001111;    
   8: a_to_g = 7'b0000000;     
   9: a_to_g = 7'b0000100;     
 'hA: a_to_g = 7'b0001000; 
 'hB: a_to_g = 7'b1100000;    
 'hC: a_to_g = 7'b0110001;     
 'hD: a_to_g = 7'b1000010;     
 'hE: a_to_g = 7'b0110000;     
 'hF: a_to_g = 7'b0111000;     
default: a_to_g = 7'b0000001;  // 0 
  endcase

end

always@(*)begin
an = 8'b11111111;
    if(aen[s] == 1)
	     an[s] = 0;
end


 
always@(posedge clk)begin
    if(rst == 1)
	     clkdiv <= 0;
	 else
	     clkdiv <= clkdiv + 1;
	 
end

  

endmodule
