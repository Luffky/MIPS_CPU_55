`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:00 04/26/2016 
// Design Name: 
// Module Name:    EX 
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
module EX(
input rst,
input [7:0] aluop_i,
input [2:0] alusel_i,
input [31:0] reg1_i,
input signed [31:0] reg2_i,
input [4:0] wd_i,
input wreg_i,
//hilo寄存器相关
input [31:0] hi_i,
input [31:0] lo_i,

input [31:0] wb_hi_i,
input [31:0] wb_lo_i,
input wb_whilo_i,

input [31:0] mem_hi_i,
input [31:0] mem_lo_i,
input mem_whilo_i,

input [63:0] div_result_i,
input div_finish_i,

//CP0
input mem_cp0_reg_we,
input [4:0] mem_cp0_reg_write_addr,
input [31:0] mem_cp0_reg_data,

input wb_cp0_reg_we,
input [4:0] wb_cp0_reg_write_addr,
input [31:0] wb_cp0_reg_data,

input [31:0] cp0_reg_data_i,
output reg [4:0] cp0_reg_read_addr_o,

output reg cp0_reg_we_o,
output reg[4:0] cp0_reg_write_addr_o,
output reg[31:0] cp0_reg_data_o,

input [31:0] excepttype_i,
input [31:0] current_inst_address_i,
output [31:0] excepttype_o,
output is_in_delayslot_o,
output [31:0] current_inst_address_o,

/////////////////////////////////////


output reg[31:0] hi_o,
output reg[31:0] lo_o,
output reg whilo_o,
//
input [31:0] link_address_i,
input is_in_delayslot_i,

input [31:0] inst_i,

output [7:0] aluop_o,
output [31:0] mem_addr_o,
output [31:0] reg2_o,

output reg[4:0] wd_o,
output reg wreg_o,
output reg[31:0] wdata_o,


output reg[31:0] div_opdata1_o,
output reg[31:0] div_opdata2_o,
output reg div_start_o,
output reg signed_div_o,
output reg stall_ex

);
reg[31:0] logicout;
reg[31:0] shiftres;
reg[31:0] moveres;
reg[31:0] HI;
reg[31:0] LO;

reg stall_for_div;

wire ov_sum; //溢出
wire reg1_eq_reg2;//第一个操作数=第二个
wire reg1_lt_reg2;//第一个操作数<第二个
reg[31:0] arithmeticres;//保存算数运算结果
wire[31:0] reg2_i_mux; //保存输入的第二个操作数reg2_i的补码

wire[31:0] result_sum; //保存加法结果
wire[31:0] opdata1_mult;
wire[31:0] opdata2_mult;


wire[63:0] hilo_temp;
reg[63:0] mulres;
wire ov_subsum;
reg ovassert;


assign excepttype_o = {excepttype_i[31:12], ovassert, 1'b0,
excepttype_i[9:8],8'h00};

assign is_in_delayslot_o = is_in_delayslot_i;
assign current_inst_address_o = current_inst_address_i;


assign aluop_o = aluop_i;
assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
assign reg2_o = reg2_i;

assign reg2_i_mux = ((aluop_i ==  8'b00101100) || (aluop_i == 8'b00101101)||
                     (aluop_i == 8'b00101000)) ? (~reg2_i)+1 : reg2_i;
//如果减法操作或者有符号比较则转换第二个数为补码
assign result_sum = reg1_i + reg2_i_mux;

assign ov_sum = (((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31])
|| ((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31])));
assign ov_subsum = (((!reg1_i[31] && reg2_i[31]) && result_sum[31])
|| ((reg1_i[31] && !reg2_i[31]) && (!result_sum[31])));


assign reg1_lt_reg2 = ((aluop_i == 8'b00101000))? 
((reg1_i[31] && !reg2_i[31]) || (!reg1_i[31] && !reg2_i[31] && result_sum[31])
||(reg1_i[31] && reg2_i[31] && result_sum[31])) : (reg1_i < reg2_i);//比较


always@(*)begin 
    if(rst) begin
	     {HI,LO} <= {8'h00000000, 8'h00000000};
		  end
	 else if(mem_whilo_i == 1)begin
	     {HI,LO} <= {mem_hi_i, mem_lo_i};
		  end
	 else if(wb_whilo_i == 1)begin
	     {HI,LO} <= {wb_hi_i, wb_lo_i};
		  end
	 else begin 
	     {HI,LO} <= {hi_i, lo_i};
		  end
end

always@(*)begin //移动运算
if(rst)begin
    moveres <= 8'h00000000;
	 end
else begin
    moveres <= 8'h00000000;
	 case(aluop_i)
	     8'b00110100:begin //mfhi
		      moveres <= HI;
				end
        8'b00110110:begin //mflo
		      moveres <= LO;
				end
	     8'b11000000: begin //mfc0
		      cp0_reg_read_addr_o <= inst_i[15:11];
				moveres <= cp0_reg_data_i;
			   if(mem_cp0_reg_we == 1 && mem_cp0_reg_write_addr == inst_i[15:11])begin 
				    moveres <= mem_cp0_reg_data;
				    end
			   else if (wb_cp0_reg_we == 1 && wb_cp0_reg_write_addr == inst_i[15:11]) begin
				    moveres <= wb_cp0_reg_data;
					 end
			end
			default : begin
			end
	endcase
	
end
end
				    

 


always@(*)begin //算术运算
if(rst)begin
    arithmeticres <= 8'h00000000;
    end
else begin
    case(aluop_i)
	     8'b00101000,8'b00101001:begin //比较运算
		      arithmeticres <= reg1_lt_reg2;
			   end
		  8'b00101010,8'b00101011,8'b00101110,8'b00101111:begin//加法运算
		      arithmeticres <= result_sum;
				end
		  8'b00101100,8'b00101101:begin //减法运算	      
				arithmeticres <= result_sum;
				end
		  default: begin
		      arithmeticres <= 8'h00000000;
				end
	 endcase
	 if(((aluop_i == 8'b00101010) || (aluop_i == 8'b00101110)) && (ov_sum == 1'b1)) begin
	     arithmeticres <= 8'h00000000;
	     end
    else if((aluop_i == 8'b00101100) &&(ov_subsum == 1'b1)) begin
	     arithmeticres <= 8'h00000000;
	     end
    end//
end//always
			



	 
always@(*)begin //逻辑运算

if(rst)begin
    logicout <= 8'h00000000;
	 end
else begin 
    case(aluop_i)
	 8'b00100101:begin //或运算
	     logicout <= reg1_i | reg2_i;
		       end
	 8'b00100100:begin //与运算
	     logicout <= reg1_i & reg2_i;
		       end
	 8'b00100110:begin //或非运算
	     logicout <= ~(reg1_i | reg2_i);
		       end
	 8'b00100111:begin //异或运算
	     logicout <= reg1_i ^ reg2_i;
		       end
	 default: begin
	     logicout <= 8'h00000000;
		       end
	 endcase
end//if
end//always



always@(*) begin //移位运算
if(rst) begin
    shiftres <= 8'h00000000;
	     end
else begin
    case(aluop_i)
	 8'b00100000:begin //逻辑左移
	     shiftres <= reg2_i << reg1_i[4:0] ;
		       end
	 8'b00100001:begin //逻辑右移
	     shiftres <= reg2_i >> reg1_i[4:0] ;
		       end
	 8'b00100010:begin //算数右移
	     shiftres <= reg2_i >>> reg1_i[4:0] ;
		 
		  
		  
		       end
	 default: begin
	     shiftres <= 8'h00000000;
		       end
	 endcase
end//if
end//always

always@(*) begin
    stall_ex = stall_for_div;
	 end
	 
always@(*)begin //除法运算
if(rst) begin
    stall_for_div <= 0;
	 div_opdata1_o <= 8'h00000000;
	 div_opdata2_o <= 8'h00000000;
    div_start_o <= 1'b0;
    signed_div_o <= 1'b0;
    end 
else begin
    stall_for_div <= 0;
	 div_opdata1_o <= 8'h00000000;
	 div_opdata2_o <= 8'h00000000;
    div_start_o <= 1'b0;
    signed_div_o <= 1'b0;
    case(aluop_i)
	     8'b00110010: begin
		      if(div_finish_i == 0) begin
				    div_opdata1_o <= reg1_i;
					 div_opdata2_o <= reg2_i;
					 div_start_o <= 1'b1;
					 signed_div_o <= 1'b1;
					 stall_for_div <= 1;
				    end
			   else if(div_finish_i == 1) begin
				    div_opdata1_o <= reg1_i;
					 div_opdata2_o <= reg2_i;
					 div_start_o <= 0;
					 signed_div_o <= 1'b1;
					 stall_for_div <= 0;
				    end
				else begin
				    stall_for_div <= 0;
	             div_opdata1_o <= 8'h00000000;
	             div_opdata2_o <= 8'h00000000;
                div_start_o <= 1'b0;
                signed_div_o <= 1'b0;
				    end
			   end
		  8'b00110011: begin
		      if(div_finish_i == 0) begin
				    div_opdata1_o <= reg1_i;
					 div_opdata2_o <= reg2_i;
					 div_start_o <= 1;
					 signed_div_o <= 1'b0;
					 stall_for_div <= 1;
				    end
			   else if(div_finish_i == 1) begin
				    div_opdata1_o <= reg1_i;
					 div_opdata2_o <= reg2_i;
					 div_start_o <= 0;
					 signed_div_o <= 1'b0;
					 stall_for_div <= 0;
				    end
				else begin
				    stall_for_div <= 0;
	             div_opdata1_o <= 8'h00000000;
	             div_opdata2_o <= 8'h00000000;
                div_start_o <= 1'b0;
                signed_div_o <= 1'b0;
				    end
			   end
		  default: begin
		      end
	endcase 
end 
end
        	 

	 
	 
assign opdata1_mult =((aluop_i == 8'b00110000) && (reg1_i[31] == 1'b1)) ? (~reg1_i + 1) : reg1_i;
assign opdata2_mult =((aluop_i == 8'b00110000) && (reg2_i[31] == 1'b1)) ? (~reg2_i + 1) : reg2_i;

assign hilo_temp = opdata1_mult * opdata2_mult;

always@(*)begin//乘法赋值
    if(rst == 1)begin
	     mulres <= 16'h0000000000000000;
	 end
	 else if(aluop_i == 8'b00110000) begin
	     if(reg1_i[31] ^ reg2_i[31] == 1'b1) begin
		      mulres <= ~hilo_temp + 1;
		  end 
		  else begin
		      mulres <= hilo_temp;
		  end
	 end
	 else begin 
	     mulres <= hilo_temp;
	 end
end

always@(*)begin//输出赋值
wd_o <= wd_i;

if(((aluop_i == 8'b00101010) || (aluop_i == 8'b00101110)) && (ov_sum == 1'b1)) begin
    wreg_o <= 0;
	 ovassert <= 1'b1;

	 end
else if((aluop_i == 8'b00101100) &&(ov_subsum == 1'b1)) begin
    wreg_o <= 0;
	 ovassert <= 1'b1;
	 
	 end
else begin 
    wreg_o <= wreg_i;
	 ovassert <= 1'b0;
    end
    case(alusel_i)
	 3'b001: begin //逻辑运算
	     wdata_o <= logicout;
		   end
	 3'b000: begin //取移位运算
	     wdata_o <= shiftres;
		   end
	 3'b010: begin //算术运算
	     wdata_o <= arithmeticres;
		  end
	 3'b011: begin
	     wdata_o <= link_address_i;
		  end
	 3'b101: begin
	     wdata_o <= moveres;
		  end
	 default:
	     wdata_o <= 32'h00000000;
		  
	
	 endcase 
end

always@(*) begin //hilo
    if(rst)begin
	     whilo_o <= 0;
		  hi_o <= 8'h00000000;
		  lo_o <= 8'h00000000;
		  end
	 else if ((aluop_i == 8'b00110000) || (aluop_i == 8'b00110001)) begin //mul
	     whilo_o <= 1;
	     hi_o <= mulres[63:32];
	     lo_o <= mulres[31:0];
		  end
	 else if(aluop_i == 8'b00110101) begin //mthi
	     whilo_o <= 1;
		  hi_o <= reg1_i;
		  lo_o <= LO;
		  end
	 else if(aluop_i == 8'b00110111) begin //mtlo
	     whilo_o <= 1;
		  hi_o <= HI;
		  lo_o <= reg1_i;
		  end
	 else if((aluop_i == 8'b00110010) || (aluop_i == 8'b00110011)) begin //div
	     whilo_o <= 1;
	     hi_o <= div_result_i[63:32];
	     lo_o <= div_result_i[31:0];
	     end
	 else begin
	     whilo_o <= 0;
		  hi_o <= 8'h00000000;
		  lo_o <= 8'h00000000;
		  end
end

always@(*)begin 
    if(rst==1) begin 
	     cp0_reg_write_addr_o <= 5'b00000;
		  cp0_reg_we_o <= 1'b0;
		  cp0_reg_data_o <= 32'h00000000;
		  end
	 else if(aluop_i == 8'b11000001) begin
	     cp0_reg_write_addr_o <= inst_i[15:11];
		  cp0_reg_we_o <= 1'b1;
		  cp0_reg_data_o <= reg1_i;
		  end
	 else begin
	     cp0_reg_write_addr_o <= 5'b00000;
		  cp0_reg_we_o <= 1'b0;
		  cp0_reg_data_o <= 32'h00000000;
		  end
end
		      




endmodule
