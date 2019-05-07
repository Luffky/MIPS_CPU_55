`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:38 04/20/2016 
// Design Name: 
// Module Name:    CLK 
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
module CLK(
input clk,
input reset,
output clk1,
output reg clk2,
output reg clk4,
output reg fetch,
output reg alu_clk
);
reg[7:0] state;
parameter a0 = 8'b00000000,
          a1 = 8'b00000001,
          a2 = 8'b00000010,
          a3 = 8'b00000100,
			 a4 = 8'b00001000,
			 a5 = 8'b00010000,
			 a6 = 8'b00100000,
			 a7 = 8'b01000000,
			 a8 = 8'b10000000;
assign clk1 = ~clk;
always@(negedge clk)begin 
    if(reset)begin
	     clk2 <= 0 ;
	     clk4 <= 1 ;
	     fetch <= 0;
	     alu_clk <= 0;
	     state <= a0;
	 end
	 else begin
	 case(state)
	 a1:begin
	     clk2 <= ~clk2;
		  alu_clk <= ~alu_clkl;
		  state <= a2;
		  end
	 a2:begin
	     clk2 <= ~clk2;
		  clk4 <= ~clk4;
		  alu_clk <= ~alu_clk;
		  state <= a3;
		  end
	 a3:begin 
	     clk2 <= ~clk2;
		  state <= a4;
		  end
	 a4:begin 
	     clk2 <= ~clk2;
		  clk4 <= ~clk4;
		  fetch <= ~fetch;
		  state <= a5;
        end
    a5:begin 
        clk2 <= ~clk2;
        state <= a6;	
        end
    a6:begin
        clk2 <= ~clk2;
        clk4 <= ~clk4;
        state <= a7;
        end
    a7:begin 
        clk2 <= ~clk2;
        state <= a8;
        end
    a8:begin
        clk2 <= ~clk2;
		  clk4 <= ~clk4;
		  state <= a1;
		  end
	 a0: state <= a1;
	 default: state <= idle;
	 endcase 
end 
end
endmodule
 
  		  


