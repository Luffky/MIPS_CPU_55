`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:57:29 04/28/2016 
// Design Name: 
// Module Name:    regfiles 
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
    input clk,
    input rst,
    input we,
    input [4:0] waddr,
    input [31:0] wdata,
    input re1,
    input [4:0] raddr1,
    output reg[31:0] rdata1,
    input re2,
    input [4:0] raddr2,
    output reg[31:0] rdata2

    );
	 
reg[31:0] regs[0:31];
 
initial regs[0] <= 0;
initial  regs[1] <= 0;
initial  regs[2] <= 0;
initial  regs[3] <= 0;
initial  regs[4] <= 0;
initial  regs[5] <= 0;
initial  regs[6] <= 0;
initial  regs[7] <= 0;
initial  regs[8] <= 0;
initial  regs[9] <= 0;
initial  regs[10] <= 0;
initial  regs[11] <= 0;
initial  regs[12] <= 0;
initial  regs[13] <= 0;
initial  regs[14] <= 0;
initial  regs[15] <= 0;
initial  regs[16] <= 0;
initial  regs[17] <= 0;
initial  regs[18] <= 0;
initial  regs[19] <= 0;
initial  regs[20] <= 0;
initial  regs[21] <= 0;
initial  regs[22] <= 0;
initial  regs[23] <= 0;
initial  regs[24] <= 0;
initial  regs[25] <= 0;
initial  regs[26] <= 0;
initial  regs[27] <= 0;
initial  regs[28] <= 0;
initial  regs[29] <= 0;
initial  regs[30] <= 0;
initial  regs[31] <= 0;



always@(posedge clk) begin
    if(rst == 0)begin
	     if((we == 1) && waddr != 5'h0) begin
		      regs[waddr] <= wdata;
		  end
		  
	 end
end
	
always@(*) begin
    if(rst == 1) begin
	     rdata1 <= 32'h00000000;
		
	 end 
	 else if(raddr1 == 5'h0) begin
	     rdata1 <= 32'h00000000;
	 end
	 else if((raddr1 == waddr) && (we == 1) && (re1 == 1))begin
	     rdata1 <= wdata;
    end
    else if(re1 == 1) begin
        rdata1 <= regs[raddr1];
    end 
    else begin
        rdata1 <= 32'h00000000;
    end
end

always@(*) begin
    if(rst == 1) begin
	     rdata2 <= 32'h00000000;
	 end 
	 else if(raddr2 == 5'h0) begin
	     rdata2 <= 32'h00000000;
	 end
	 else if((raddr2 == waddr) && (we == 1) && (re2 == 1))begin
	     rdata2 <= wdata;
    end
    else if(re2 == 1) begin
        rdata2 <= regs[raddr2];
    end 
    else begin
        rdata2 <= 32'h00000000;
    end
end 



endmodule
