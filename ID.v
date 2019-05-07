`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:39:49 04/26/2016 
// Design Name: 
// Module Name:    ID 
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
module ID(
input rst,
input [31:0] pc_i, //指令地址
input [31:0] inst_i,       //译码阶段指令
input [31:0] reg1_data_i,  //regfile输入的第一个寄存器端口输入
input [31:0] reg2_data_i,  //第二个

input ex_wreg_i,           //执行EX阶段的运算结果
input [31:0] ex_wdata_i,
input [4:0] ex_wd_i,

input mem_wreg_i,          //访存MEM阶段的运算结果
input [31:0] mem_wdata_i,
input [4:0] mem_wd_i,

input is_in_delayslot_i,

output [31:0] excepttype_o,
output [31:0] current_inst_address_o,



output reg next_inst_in_delayslot_o,

output [31:0] inst_o,

output reg branch_flag_o,
output reg[31:0] branch_target_address_o,
output reg[31:0] link_addr_o,
output reg is_in_delayslot_o,

output reg reg1_read_o,    //reg第一个读寄存器端口的读使能信号
output reg reg2_read_o,    //第二个
output reg[4:0] reg1_addr_o, //regfile第一个读寄存器端口的读地址信号
output reg[4:0] reg2_addr_o, //第二个

output reg[7:0] aluop_o, //译码阶段进行运算的子类型
output reg[2:0] alusel_o,//译码阶段进行运算的类型
output reg[31:0] reg1_o, //送入EX运算的源操作数1
output reg[31:0] reg2_o, //源操作数2
output reg[4:0] wd_o,    //指令写入的目的寄存器地址
output reg wreg_o,        //指令是否要写入目的寄存器
output  stall_id
);
wire [5:0] op = inst_i[31:26];
wire [4:0] op2 = inst_i[10:6];
wire [5:0] op3 = inst_i[5:0];
wire [4:0] op4 = inst_i[20:16];

wire[31:0] pc_plus_8;
wire[31:0] pc_plus_4;

wire[31:0] imm_sll2_signedext;
reg excepttype_syscall;
reg excepttype_eret;
assign excepttype_o = {19'b0, excepttype_eret, 3'b0, 
     excepttype_syscall, 8'b0};
assign current_inst_address_o = pc_i;


assign pc_plus_8 = pc_i + 8;
assign pc_plus_4 = pc_i ;

assign imm_sll2_signedext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00};



reg[31:0] imm; //保存立即数


assign inst_o = inst_i;
assign stall_id = 0;
always@(*) begin
if(rst)begin 
    aluop_o <=8'b00000000;
	 alusel_o <=3'b000;
	 wd_o <= 5'b00000;
	 wreg_o <= 0;
	 
	 reg1_read_o <= 0;
	 reg2_read_o <= 0;
	 reg1_addr_o <= 5'b00000;
	 reg2_addr_o <= 5'b00000;
	 imm <= 32'h0;
	 link_addr_o <= 32'h00000000;
	 branch_target_address_o <= 32'h00000000;
	 branch_flag_o <=  0;
	 next_inst_in_delayslot_o <= 0;
	 
    end
else begin
    aluop_o <=8'b00000000;
	 alusel_o <=3'b000;
	 wd_o <= inst_i[15:11];
	 wreg_o <= 0;
	 reg1_read_o <= 0;
	 reg2_read_o <= 0;
	 reg1_addr_o <= inst_i[25:21]; //默认REG1
	 reg2_addr_o <= inst_i[20:16]; //默认REG2
	 imm <= 32'h00000000;
	 link_addr_o <= 32'h00000000;
	 branch_target_address_o <= 32'h00000000;
	 branch_flag_o <=  0;
	 next_inst_in_delayslot_o <= 0;
	 excepttype_syscall <= 1'b0;
	 excepttype_eret <= 1'b0;
	 
	if(is_in_delayslot_i != 1)begin
	 case (op)
	     6'b000000:   begin
		      case (op2)
				    5'b00000:    begin
					     case (op3) 
						      6'b100101:begin  //or
								     wreg_o <= 1;
									  aluop_o <= 8'b00100101;
									  alusel_o <= 3'b001;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end
								6'b100100:begin  //and
								     wreg_o <= 1;
									  aluop_o <= 8'b00100100;
									  alusel_o <= 3'b001;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end
								6'b100110:begin  //xor
								     wreg_o <= 1;
									  aluop_o <= 8'b00100111;
									  alusel_o <= 3'b001;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end
								6'b100111:begin  //nor
								     wreg_o <= 1;
									  aluop_o <= 8'b00100110;
									  alusel_o <= 3'b001;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end
								6'b000100:begin  //sllv
								     wreg_o <= 1;
									  aluop_o <= 8'b00100000;
									  alusel_o <= 3'b000;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end 
								6'b000110:begin  //srlv
								     wreg_o <= 1;
									  aluop_o <= 8'b00100001;
									  alusel_o <= 3'b000;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end											  
		                  6'b000111:begin  //srav
								     wreg_o <= 1;
									  aluop_o <= 8'b00100010;
									  alusel_o <= 3'b000;
									  reg1_read_o <= 1'b1;
									  reg2_read_o <= 1'b1;
									  
									        end 
								6'b101010:begin //slt
								    wreg_o <= 1;
									 aluop_o <= 8'b00101000;
									 alusel_o <= 3'b010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b101011:begin //sltu
								    wreg_o <= 1;
									 aluop_o <= 8'b00101001;
									 alusel_o <= 3'b010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b100000:begin //add
								    wreg_o <= 1;
									 aluop_o <= 8'b00101010;
									 alusel_o <= 3'b010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b100001:begin //addu
								    wreg_o <= 1;
									 aluop_o <= 8'b00101011;
									 alusel_o <= 3'b010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b100010:begin //sub
								    wreg_o <= 1;
									 aluop_o <= 8'b00101100;
									 alusel_o <= 3'b010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b100011:begin //subu
								    wreg_o <= 1;
									 aluop_o <= 8'b00101101;
									 alusel_o <= 3'b010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b011000:begin //mult
								    wreg_o <= 1;
									 aluop_o <= 8'b00110000;
									 alusel_o <= 3'b110;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
								end 
								6'b011001:begin //multu
								    wreg_o <= 1;
									 aluop_o <= 8'b00110001;
									 alusel_o <= 3'b110;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
								end 
								6'b001000:begin //jr
								    wreg_o <= 0;
									 aluop_o <= 8'b10000000;
									 alusel_o <= 3'b011;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b0;
									 link_addr_o <= 32'h00000000;
									 branch_target_address_o <= reg1_o;
									 branch_flag_o <= 1;
									 next_inst_in_delayslot_o <= 1;
									 
								    end
							   6'b001001:begin //jalr
								    wreg_o <= 1;
									 aluop_o <= 8'b10000111;
									 alusel_o <= 3'b011;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b0;
									 wd_o <= inst_i[15:11];
									 link_addr_o <= pc_plus_8;
									 branch_target_address_o <= reg1_o;
									 branch_flag_o <= 1;
									 next_inst_in_delayslot_o <= 1;
									 
									 end
								6'b011010: begin //div
								    wreg_o <= 0;
									 aluop_o <= 8'b00110010;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
								6'b011011: begin //divu
								    wreg_o <= 0;
									 aluop_o <= 8'b00110011;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b1;
									 
									 end
							   6'b010000: begin //mfhi
								    wreg_o <= 1;
									 aluop_o <= 8'b00110100;
									 alusel_o <= 3'b101;
									 reg1_read_o <= 1'b0;
									 reg2_read_o <= 1'b0;
									 
			                   end
								6'b010001: begin //mthi
								    wreg_o <= 0;
									 aluop_o <= 8'b00110101;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b0;
									 
									 end
								6'b010010: begin //mflo
								    wreg_o <= 1;
									 aluop_o <= 8'b00110110;
									 alusel_o <= 3'b101;
									 reg1_read_o <= 1'b0;
									 reg2_read_o <= 1'b0;
									 
			                   end
								6'b010011: begin //mtlo
								    wreg_o <= 0;
									 aluop_o <= 8'b00110111;
									 reg1_read_o <= 1'b1;
									 reg2_read_o <= 1'b0;
									 
									 end
								6'b001100: begin //syscall
								    wreg_o <= 1'b0;
									 aluop_o <= 8'b11110000;
									 alusel_o <= 3'b000;
									 reg1_read_o <= 1'b0;
									 reg2_read_o <= 1'b0;
									 excepttype_syscall <= 1'b1;
									 end
								default: begin
								         end
						  endcase
				  end
				  default: begin
				           end
				endcase
		  end//6'b000000end 
	     6'b001101: //ori
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00100101;
		  alusel_o <= 3'b001;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {16'h0,inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001100: //andi
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00100100;
		  alusel_o <= 3'b001;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {16'h0,inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001110: //xori
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00100111;
		  alusel_o <= 3'b001;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {16'h0,inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001111:   //lui
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00100101;
		  alusel_o <= 3'b001;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {inst_i[15:0],16'h0};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001010: //slti
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00101000;
		  alusel_o <= 3'b010;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {{16{inst_i[15]}},inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001011: //sltiu
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00101001;
		  alusel_o <= 3'b010;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {{16{inst_i[15]}},inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001000: //addi
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00101110;
		  alusel_o <= 3'b010;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {{16{inst_i[15]}},inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b001001: //addiu
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b00101111;
		  alusel_o <= 3'b010;
        reg1_read_o <= 1;
	     reg2_read_o <= 0;
		  imm <= {{16{inst_i[15]}},inst_i[15:0]};
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b000010: //j
		  begin
		  wreg_o <= 0;
		  aluop_o <= 8'b10000001;
		  alusel_o <= 3'b011;
		  reg1_read_o <= 1'b0;
		  reg2_read_o <= 1'b0;
		  link_addr_o <= 32'h00000000;
		  branch_flag_o <= 1;
		  next_inst_in_delayslot_o <= 1;
		  
        branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
        end
        6'b000011: //jal
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b10000010;
		  alusel_o <= 3'b011;
		  wd_o <= 5'b11111;
		  reg1_read_o <= 1'b0;
		  reg2_read_o <= 1'b0;
		  link_addr_o <= pc_plus_8;
		  branch_flag_o <= 1;
		  next_inst_in_delayslot_o <= 1;
		  
        branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
        end			  
		  6'b000100: //beq
		  begin
		  wreg_o <= 0;
		  aluop_o <= 8'b10000011;
		  alusel_o <= 3'b011;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b1;
	     
		  if(reg1_o == reg2_o)begin
		  branch_flag_o <= 1;
		  next_inst_in_delayslot_o <= 1;
		  branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
             end
        end	
        6'b000101: //bne
		  begin
		  wreg_o <= 0;
		  aluop_o <= 8'b10000100;
		  alusel_o <= 3'b011;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b1;
	     
		  if(reg1_o != reg2_o)begin
		  branch_flag_o <= 1;
		  next_inst_in_delayslot_o <= 1;
		  branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
             end
        end	
		  6'b000111: //bgtz
		  begin 
		  wreg_o <= 0;
		  aluop_o <= 8'b10001000;
		  alusel_o <= 3'b011;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  
		  if((reg1_o[31] == 1'b0) && (reg1_o != 32'h00000000))begin 
		      branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
				branch_flag_o <= 1;
				next_inst_in_delayslot_o <= 1;
				end
		  end
		  6'b000110: //blez
		  begin
		  wreg_o <= 0;
		  aluop_o <= 8'b10001001;
		  alusel_o <= 3'b011;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  
		  if((reg1_o[31] == 1'b0) && (reg1_o == 32'h00000000))begin 
		      branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
				branch_flag_o <= 1;
				next_inst_in_delayslot_o <= 1;
				end
		  end
		  6'b010000: //mfc0 mtc0
		  begin
		      if(inst_i[25:21] == 5'b00000) begin
				    aluop_o <= 8'b11000000;
					 alusel_o <= 3'b101;
					 wd_o <= inst_i[20:16];
					 wreg_o <= 1'b1;
					 reg1_read_o <= 1'b0;
					 reg2_read_o <= 1'b0;
					 end
				else if(inst_i[25:21] == 5'b00100) begin
				    aluop_o <= 8'b11000001;
					 alusel_o <= 3'b000;
					 wreg_o <= 1'b0;
					 reg1_read_o <= 1'b1;
					 reg1_addr_o <= inst_i[20:16];
					 reg2_read_o <= 1'b0;
					 end
				else if(inst_i[25:21] == 5'b10000) begin
				    wreg_o <= 1'b0;
					 aluop_o <= 11110001;
					 alusel_o <= 3'b000;
					 reg1_read_o <= 1'b0;
					 reg2_read_o <= 1'b0;
					 excepttype_eret <= 1'b1;
					 end
		  end
		  6'b000001: //regimm
		  begin
		      case (op4)
				    5'b00001: begin //bgez
					 wreg_o <= 0;
		          aluop_o <= 8'b10001010;
		          alusel_o <= 3'b011;
		          reg1_read_o <= 1'b1;
		          reg2_read_o <= 1'b0;
		          
		          if(reg1_o[31] == 1'b0) begin 
		              branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
				        branch_flag_o <= 1;
				        next_inst_in_delayslot_o <= 1;
				        end
		         end
					5'b00000: begin //bltz
					 wreg_o <= 0;
		          aluop_o <= 8'b10001011;
		          alusel_o <= 3'b011;
		          reg1_read_o <= 1'b1;
		          reg2_read_o <= 1'b0;
		          
		          if(reg1_o[31] == 1'b1) begin 
		              branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
				        branch_flag_o <= 1;
				        next_inst_in_delayslot_o <= 1;
				        end
		         end
		      endcase
        end				
        6'b100011: //lw 
		  begin 
		  wreg_o <= 1;
		  aluop_o <= 8'b10000101;
		  alusel_o <= 3'b100;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  wd_o <= inst_i[20:16];
		  
        end
		  6'b101011://sw
		  begin 
		  wreg_o <= 0;
		  aluop_o <= 8'b10000110;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b1;
		  
		  alusel_o <= 3'b100;
		  end
		  
		  6'b100000://lb
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b01000000;
		  alusel_o <= 3'b100;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  wd_o <= inst_i[20:16];
		  
		  end
		  
		  6'b100100://lbu
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b01000001;
		  alusel_o <= 3'b100;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b100001://lh
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b01000010;
		  alusel_o <= 3'b100;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b100101://lhu
		  begin
		  wreg_o <= 1;
		  aluop_o <= 8'b01000011;
		  alusel_o <= 3'b100;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b0;
		  wd_o <= inst_i[20:16];
		  
		  end
		  6'b101000://sb
		  begin
		  wreg_o <= 0;
		  aluop_o <= 8'b01000100;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b1;
		  
		  alusel_o <= 3'b100;
		  end
		  6'b101001://sh
		  begin
		  wreg_o <= 0;
		  aluop_o <= 8'b01000101;
		  reg1_read_o <= 1'b1;
		  reg2_read_o <= 1'b1;
		  
		  alusel_o <= 3'b100;
		  end
		  default: begin
		           end
	 endcase//endcase op
	 if(inst_i[31:21] == 11'b00000000000) begin
	     if(op3 == 6'b000000) begin //sll
		      wreg_o <= 1;
		      aluop_o <= 8'b00100000;
		      alusel_o <= 3'b000;
            reg1_read_o <= 0;
	         reg2_read_o <= 1;
		      imm[4:0] <= inst_i[10:6];
		      wd_o <= inst_i[15:11];
		      
				                 end   
		  else if(op3 == 6'b000010) begin //srl
		      wreg_o <= 1;
		      aluop_o <= 8'b00100001;
		      alusel_o <= 3'b000;
            reg1_read_o <= 0;
	         reg2_read_o <= 1;
		      imm[4:0] <= inst_i[10:6];
		      wd_o <= inst_i[15:11];
		      
				                 end
			else if(op3 == 6'b000011) begin //sra
		      wreg_o <= 1;
		      aluop_o <= 8'b00100010;
		      alusel_o <= 3'b000;
            reg1_read_o <= 0;
	         reg2_read_o <= 1;
		      imm[4:0] <= inst_i[10:6];
		      wd_o <= inst_i[15:11];
		      
				                 end
      end//if inst[31:21]
end
else begin
     wreg_o <= 1;
	  aluop_o <= 8'b01000000;
	  alusel_o <= 3'b000;
     reg1_read_o <= 0;
	  reg2_read_o <= 0;
	  imm[4:0] <= 5'b00000;
	  wd_o <= 5'b00000;
	  
	 
	  end
	  
end//if rst
end//always


always@(*) begin
if(rst)begin
    reg1_o <= 32'h00000000;
	 end
else if((reg1_read_o == 1'b1)&&(ex_wreg_i == 1'b1)
        && (ex_wd_i == reg1_addr_o) && reg1_addr_o != 0) begin
		reg1_o <= ex_wdata_i;
		                               end
												 
else if((reg1_read_o == 1'b1)&&(mem_wreg_i == 1'b1)
        && (mem_wd_i == reg1_addr_o) && reg1_addr_o != 0) begin
		  reg1_o <= mem_wdata_i;
		                                end
												  
else if(reg1_read_o == 1'b1)begin
    reg1_o <= reg1_data_i;
	 end
else if(reg1_read_o == 1'b0)begin
    reg1_o <= imm;
	 end

else 
    reg1_o <= 32'h00000000;
end//always

always@(*) begin  
if(rst)begin
    reg2_o <= 32'h00000000;
	 end
else if((reg2_read_o == 1'b1)&&(ex_wreg_i == 1'b1)
        && (ex_wd_i == reg2_addr_o) && reg2_addr_o != 0) begin
		reg2_o <= ex_wdata_i;
		                               end
												 
else if((reg2_read_o == 1'b1)&&(mem_wreg_i == 1'b1)
        && (mem_wd_i == reg2_addr_o) && reg2_addr_o != 0) begin
		  reg2_o <= mem_wdata_i;
		                                end
												  
else if(reg2_read_o == 1'b1)begin
    reg2_o <= reg2_data_i;
	 end
else if(reg2_read_o == 1'b0)begin
    reg2_o <= imm;
	 end
else 
    reg2_o <= 32'h00000000;
end//always

always@(*) begin
   if(rst)begin
	     is_in_delayslot_o <= 0;
	end 
	else begin
	    is_in_delayslot_o <= is_in_delayslot_i;
	end
	
	

end

endmodule
