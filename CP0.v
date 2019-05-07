`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:51 07/18/2016 
// Design Name: 
// Module Name:    CP0 
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
module CP0(
    input rst,
    input clk,
    input [4:0] raddr_i,
    input we_i,
    input [4:0] waddr_i,
    input [31:0] data_i,
	 input [31:0] excepttype_i,
    input [31:0] current_inst_addr_i,
    input is_in_delayslot_i,
	 
    output reg[31:0] data_o,
    output reg[31:0] status_o,
    output reg[31:0] cause_o,
    output reg[31:0] epc_o

    );
reg[31:0] config_o;
reg[31:0] count_o;
reg[31:0] compare_o;
reg timer_int_o;
wire [5:0] int_i;
assign int_i = 6'b000000;
always@(posedge clk) begin
    if(rst == 1)begin 
	     count_o <= 32'h00000000;
		  compare_o <= 32'h00000000;
		  status_o <= 32'b00010000000000000000000000000000;
		  cause_o <= 32'h00000000;
		  epc_o <= 32'h00000000;
		  config_o <= 32'b00000000000000001000000000000000;
		  timer_int_o <= 1'b0;
		  end 
	 else begin
	 count_o <= count_o + 1;
	 cause_o[15:10] <= int_i;
	 if(compare_o != 32'h00000000 && count_o == compare_o)begin
	     timer_int_o <= 1'b1;
	 end
	 if(we_i == 1)begin
	     case(waddr_i)
		      5'b01001: begin
				    count_o <= data_i;
				end
				5'b01011: begin
				    compare_o <= data_i;
				end
				5'b01100: begin
				    status_o <= data_i;
				end
				5'b01110: begin
				    epc_o <= data_i;
				end
				5'b01101: begin
				    cause_o[9:8] <= data_i[9:8];
					 cause_o[23] <= data_i[23];
					 cause_o[22] <= data_i[22];
				end
		 endcase
	 end
	 case (excepttype_i)
				32'h00000001:		begin
					if(is_in_delayslot_i == 1'b1 ) begin
						epc_o <= current_inst_addr_i - 4 ;
						cause_o[31] <= 1'b1;
					end else begin
					  epc_o <= current_inst_addr_i;
					  cause_o[31] <= 1'b0;
					end
					status_o[1] <= 1'b1;
					cause_o[6:2] <= 5'b00000;
					
				end
				32'h00000008:		begin
					if(status_o[1] == 1'b0) begin
						if(is_in_delayslot_i == 1'b1 ) begin
							epc_o <= current_inst_addr_i - 4 ;
							cause_o[31] <= 1'b1;
						end else begin
					  	epc_o <= current_inst_addr_i;
					  	cause_o[31] <= 1'b0;
						end
					end
					status_o[1] <= 1'b1;
					cause_o[6:2] <= 5'b01000;			
				end
				32'h0000000a:		begin
					if(status_o[1] == 1'b0) begin
						if(is_in_delayslot_i == 1'b1 ) begin
							epc_o <= current_inst_addr_i - 4 ;
							cause_o[31] <= 1'b1;
						end else begin
					  	epc_o <= current_inst_addr_i;
					  	cause_o[31] <= 1'b0;
						end
					end
					status_o[1] <= 1'b1;
					cause_o[6:2] <= 5'b01010;					
				end
				32'h0000000d:		begin
					if(status_o[1] == 1'b0) begin
						if(is_in_delayslot_i == 1'b1 ) begin
							epc_o <= current_inst_addr_i - 4 ;
							cause_o[31] <= 1'b1;
						end else begin
					  	epc_o <= current_inst_addr_i;
					  	cause_o[31] <= 1'b0;
						end
					end
					status_o[1] <= 1'b1;
					cause_o[6:2] <= 5'b01101;					
				end
				32'h0000000c:		begin
					if(status_o[1] == 1'b0) begin
						if(is_in_delayslot_i == 1'b1 ) begin
							epc_o <= current_inst_addr_i - 4 ;
							cause_o[31] <= 1'b1;
						end else begin
					  	epc_o <= current_inst_addr_i;
					  	cause_o[31] <= 1'b0;
						end
					end
					status_o[1] <= 1'b1;
					cause_o[6:2] <= 5'b01100;					
				end				
				32'h0000000e:   begin
					status_o[1] <= 1'b0;
				end
				default:  begin
				end
			endcase			

	 end
end //always

always@(*)begin
    if(rst == 1) begin
	     data_o <= 32'h00000000;
	 end
	 else begin
	 case (raddr_i)
	     5'b01001: begin
	         data_o <= count_o;
	         end
		  5'b01011: begin
		      data_o <= compare_o;
				end
		  5'b01100: begin
		      data_o <= status_o;
				end
		  5'b01101: begin
		      data_o <= cause_o;
				end
		  5'b01110: begin 
		      data_o <= epc_o;
				end
		  5'b10000: begin 
		      data_o <= config_o;
		      end
		  default : begin
		      end
		  endcase
	 end
end
endmodule
		      
			



