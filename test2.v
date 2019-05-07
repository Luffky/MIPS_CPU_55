`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:37:13 04/27/2016
// Design Name:   SOPC
// Module Name:   F:/ISE/CPU/test2.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SOPC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test2;

	// Inputs
	reg clk;
	reg rst;

   initial begin
		// Initialize Inputs
		clk = 0;
		
		forever #5 clk = ~clk;
	end
	initial begin
	rst = 1;
	#1000 rst= 0;
	
	
	
	
	
	end
	
	// Instantiate the Unit Under Test (UUT)
	SOPC uut (
		.clk(clk), 
		.rst(rst)
	);
	

	
	
	

	
      
endmodule

