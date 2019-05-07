`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:31:27 04/27/2016
// Design Name:   CLK
// Module Name:   F:/ISE/CPU/test.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CLK
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire clk1;
	wire clk2;
	wire clk4;
	wire fetch;
	wire alu_clk;

	// Instantiate the Unit Under Test (UUT)
	CLK uut (
		.clk(clk), 
		.reset(reset), 
		.clk1(clk1), 
		.clk2(clk2), 
		.clk4(clk4), 
		.fetch(fetch), 
		.alu_clk(alu_clk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

