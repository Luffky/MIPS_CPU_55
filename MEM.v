`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:01:28 04/27/2016 
// Design Name: 
// Module Name:    MEM 
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
module MEM(
    input rst,
    input [4:0] wd_i,
    input wreg_i,
    input [31:0] wdata_i,
	 input [31:0] hi_i,
	 input [31:0] lo_i,
	 input whilo_i,
	 
input [7:0]  aluop_i,
input [31:0] mem_addr_i,
input [31:0] reg2_i,

input [31:0] mem_data_i,
/////////////////
input cp0_reg_we_i,
input [4:0] cp0_reg_write_addr_i,
input [31:0] cp0_reg_data_i,

output reg cp0_reg_we_o,
output reg[4:0] cp0_reg_write_addr_o,
output reg[31:0] cp0_reg_data_o,
/////////////
input [31:0] excepttype_i,
input is_in_delayslot_i,
input [31:0] current_inst_address_i,
input [31:0] cp0_status_i,
input [31:0] cp0_cause_i,
input [31:0] cp0_epc_i,
input wb_cp0_reg_we,
input [4:0] wb_cp0_reg_write_addr,
input [31:0] wb_cp0_reg_data,

output reg [31:0] excepttype_o,
output [31:0] cp0_epc_o,
output is_in_delayslot_o,
output [31:0] current_inst_address_o,


output reg[31:0] mem_addr_o,
output mem_we_o,
output reg[3:0] mem_sel_o,
output reg[31:0] mem_data_o,
output reg mem_ce_o,	 
	 
    output reg [4:0] wd_o,
    output reg wreg_o,
    output reg [31:0] wdata_o,
	 output reg [31:0] hi_o,
	 output reg [31:0] lo_o,
	 output reg whilo_o
    );

reg mem_we;




reg[31:0] cp0_status;
reg[31:0] cp0_cause;
reg[31:0] cp0_epc;




assign is_in_delayslot_o = is_in_delayslot_i;
assign current_inst_address_o = current_inst_address_i;	 
	 
always@(*)begin
if(rst) begin
    cp0_status <= 32'h00000000;
	 end
else if((wb_cp0_reg_we == 1'b1 )&& (wb_cp0_reg_write_addr == 5'b01100))begin
    cp0_status <= wb_cp0_reg_data;
	 end 
else begin
    cp0_status <= cp0_status_i;
	 end
end

always@(*)begin
if(rst) begin
    cp0_epc <= 32'h00000000;
	 end
else if((wb_cp0_reg_we == 1'b1 )&& (wb_cp0_reg_write_addr == 5'b01110))begin
    cp0_epc <= wb_cp0_reg_data;
	 end 
else begin
    cp0_epc <= cp0_epc_i;
	 end
end

assign cp0_epc_o = cp0_epc;

always@(*) begin
    if(rst == 1'b1) begin
	     cp0_cause <= 32'h00000000;
		  end
	 else if((wb_cp0_reg_we == 1'b1) && (wb_cp0_reg_write_addr
	         == 5'b01101)) begin
		  cp0_cause[9:8] <= wb_cp0_reg_data[9:8];
		  cp0_cause[22] <= wb_cp0_reg_data[22];
		  cp0_cause[23] <= wb_cp0_reg_data[23];
		  end
	 else begin
	     cp0_cause <= cp0_cause_i;
		  end
end
always@(*) begin
    if(rst) begin 
	    excepttype_o <= 32'h00000000;
		 end
	 else begin 
	    excepttype_o <= 32'h00000000;
		 if(current_inst_address_i != 32'h00000000) begin 
		     if(((cp0_cause[15:8] & (cp0_status[15:8])) !=
			  8'h00) && (cp0_status[1] == 1'b0) && 
			  (cp0_status[0] == 1'b1)) begin
			      excepttype_o <= 32'h00000001;
			      end
			  else if(excepttype_i[8] == 1'b1) begin 
			      excepttype_o <= 32'h00000008;
					end
			  else if(excepttype_i[9] == 1'b1) begin 
			      excepttype_o <= 32'h0000000a;
					end
			  else if(excepttype_i[10] == 1'b1) begin 
			      excepttype_o <= 32'h0000000d;
					end
			  else if(excepttype_i[11] == 1'b1) begin 
			      excepttype_o <= 32'h0000000c;
					end
			  else if(excepttype_i[12] == 1'b1) begin 
			      excepttype_o <= 32'h0000000e;
					end
		 end
	end
end
assign mem_we_o = mem_we & (~(|excepttype_o));

	 
always@(*) begin
if(rst) begin
    wd_o <= 5'b00000;
	 wreg_o <= 0;
	 wdata_o <= 32'h00000000;
	 hi_o <= 32'h00000000;
	 lo_o <= 32'h00000000;
	 whilo_o <= 0;
	 mem_addr_o <= 8'h00000000;
	 mem_we <= 0;
	 mem_sel_o <= 4'b0000;
	 mem_data_o <= 8'h00000000;
	 mem_ce_o <= 0;
	 cp0_reg_we_o <= 1'b0;
	 cp0_reg_write_addr_o <= 5'b00000;
	 cp0_reg_data_o <= 32'h00000000;
	     end
else begin 
    wd_o <= wd_i;
	 wreg_o <= wreg_i;
	 wdata_o <= wdata_i;
	 hi_o <= hi_i;
	 lo_o <= lo_i;
	 whilo_o <= whilo_i;
	 mem_addr_o <= 8'h00000000;
	 mem_we <= 0;
	 mem_sel_o <= 4'b1111;
	 mem_data_o <= 8'h00000000;
	 mem_ce_o <= 0;
	 cp0_reg_we_o <= cp0_reg_we_i;
	 cp0_reg_write_addr_o <= cp0_reg_write_addr_i;
	 cp0_reg_data_o <= cp0_reg_data_i;
	 case(aluop_i)
	 8'b01000000: begin//lb
	     mem_addr_o <= mem_addr_i;
		  mem_we <= 0;
		  mem_ce_o <= 1;
		  case(mem_addr_i[1:0])
		      2'b00:begin
				    wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:24]};
					 mem_sel_o <= 4'b1000;
					 end
				2'b01:begin
				    wdata_o <= {{24{mem_data_i[23]}},mem_data_i[23:16]};
					 mem_sel_o <= 4'b0100;
					 end
				2'b10:begin
				    wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:8]};
					 mem_sel_o <= 4'b0010;
					 end
				2'b11:begin
				    wdata_o <= {{24{mem_data_i[7]}},mem_data_i[7:0]};
					 mem_sel_o <= 4'b0001;
					 end
				default:begin
				    wdata_o <= 8'h00000000;
					 end
			endcase
    end
	 8'b01000001: begin//lbu
	     mem_addr_o <= mem_addr_i;
		  mem_we <= 0;
		  mem_ce_o <= 1;
		  case(mem_addr_i[1:0])
		      2'b00:begin
				    wdata_o <= {{24{1'b0}},mem_data_i[31:24]};
					 mem_sel_o <= 4'b1000;
					 end
				2'b01:begin
				    wdata_o <= {{24{1'b0}},mem_data_i[23:16]};
					 mem_sel_o <= 4'b0100;
					 end
				2'b10:begin
				    wdata_o <= {{24{1'b0}},mem_data_i[15:8]};
					 mem_sel_o <= 4'b0010;
					 end
				2'b11:begin
				    wdata_o <= {{24{1'b0}},mem_data_i[7:0]};
					 mem_sel_o <= 4'b0001;
					 end
				default:begin
				    wdata_o <= 8'h00000000;
					 end
			endcase
    end
	 8'b01000010: begin//lh
	     mem_addr_o <= mem_addr_i;
		  mem_we <= 0;
		  mem_ce_o <= 1;
		  case(mem_addr_i[1:0])
		      2'b00:begin
				    wdata_o <= {{16{mem_data_i[31]}},mem_data_i[31:16]};
					 mem_sel_o <= 4'b1100;
					 end
				
				2'b10:begin
				    wdata_o <= {{16{mem_data_i[15]}},mem_data_i[15:0]};
					 mem_sel_o <= 4'b0011;
					 end
				
				default:begin
				    wdata_o <= 8'h00000000;
					 end
			endcase
    end
	 8'b01000011: begin//lhu
	     mem_addr_o <= mem_addr_i;
		  mem_we <= 0;
		  mem_ce_o <= 1;
		  case(mem_addr_i[1:0])
		      2'b00:begin
				    wdata_o <= {{16{1'b0}},mem_data_i[31:16]};
					 mem_sel_o <= 4'b1100;
					 end
				
				2'b10:begin
				    wdata_o <= {{16{1'b0}},mem_data_i[15:0]};
					 mem_sel_o <= 4'b0011;
					 end
				
				default:begin
				    wdata_o <= 8'h00000000;
					 end
			endcase
    end
	 8'b01000100: begin//sb
	     mem_addr_o <= mem_addr_i;
		  mem_we <= 1;
		  mem_data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
		  mem_ce_o <= 1;
		  case(mem_addr_i[1:0])
		      2'b00:begin
				    mem_sel_o <= 4'b1000;
					 end
				2'b01:begin
				    mem_sel_o <= 4'b0100;
					 end
				2'b10:begin
				    mem_sel_o <= 4'b0010;
					 end
				2'b11:begin
				    mem_sel_o <= 4'b0001;
					 end
				default:begin
				    mem_sel_o <= 4'b0000;
				end
		  endcase
	 end
	 8'b01000101: begin//sh
	     mem_addr_o <= mem_addr_i;
		  mem_we <= 1;
		  mem_data_o <= {reg2_i[15:0],reg2_i[15:0]};
		  mem_ce_o <= 1;
		  case(mem_addr_i[1:0])
		      2'b00:begin
				    mem_sel_o <= 4'b1100;
					 end
			
				2'b10:begin
				    mem_sel_o <= 4'b0011;
					 end
				
				default:begin
				    mem_sel_o <= 4'b0000;
				end
		  endcase
	 end
	 8'b10000101: begin//lw
	 mem_addr_o <= mem_addr_i;
	 mem_we <= 0;
	 wdata_o <= mem_data_i;
	 mem_sel_o <= 4'b1111;
	 mem_ce_o <= 1;
	 end
	 
	 8'b10000110: begin//sw
	 mem_addr_o <= mem_addr_i;
	 mem_we <= 1;
	 mem_data_o <= reg2_i;
	 mem_sel_o <= 4'b1111;
	 mem_ce_o <= 1;
	 end
	 default: begin
	 mem_sel_o <= 4'b0000;
	 end
	 endcase
	 end
end


endmodule
