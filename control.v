`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:59 06/08/2016 
// Design Name: 
// Module Name:    control 
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
module control(
    input man,
	 input [14:0] switch, 
    output reg[31:0] spo
    );
always@(*)begin
    if(man == 0)
	     spo <= 32'h00000000;
	 else begin
	     case(switch[14:12])
		      3'b000: begin //addi
				    spo[31:26] <= 6'b001000; 
					 spo[25:21] <= switch[11:8];
					 spo[20:16] <= 5'b01111;
					 spo[15:0] <= switch[7:0];
					 end
				3'b001: begin //¼õ·¨
				    spo[31:26] <= 6'b000000;
					 spo[25:21] <= switch[11:8];
					 spo[20:16] <= switch[7:4];
					 spo[15:0] <= 16'b0111100000100010;
				    end
				3'b010: begin //Âß¼­×óÒÆ
				    spo[31:26] <= 6'b000000;
					 spo[25:21] <= 5'b00000;
					 spo[20:16] <= switch[11:8];
		          spo[15:11] <= 5'b01111;
					 spo[10:6] <= switch[7:3];
					 spo[5:0] <= 6'b000000;
				    end
				3'b011: begin //ANDI
				    spo[31:26] <= 6'b001100;
					 spo[25:21] <= switch[11:8];
					 spo[20:16] <= 5'b01111;
					 spo[15:0] <= switch[7:0];
				    end
				3'b100: begin //ORI
				    spo[31:26] <= 6'b001001;
					 spo[25:21] <= switch[11:8];
					 spo[20:16] <= 5'b01111;
					 spo[15:0] <= switch[7:0];
				    end
				3'b101: begin //NOR
				    spo[31:26] <= 6'b000000;
					 spo[25:21] <= switch[11:8];
					 spo[20:16] <= switch[7:4];
					 spo[15:0] <= 16'b0111100000100111;
				    end
				3'b110: begin //XORI
				    spo[31:26] <= 6'b001110;
					 spo[25:21] <= switch[11:8];
					 spo[20:16] <= 5'b01111;
					 spo[15:0] <= switch[7:0];
				    end
				3'b111: begin //LUI
				   spo[31:26] <= 6'b001111;
					 spo[25:21] <= 5'b00000;
					 spo[20:16] <= 5'b01111;
					 spo[15:0] <= switch[7:0];
				    end
				default : begin
				    end
			endcase
		end
	     
end



endmodule
