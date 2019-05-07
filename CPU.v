`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:12:20 04/20/2016 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
input clk,
input rst,
input [31:0] rom_data_i,
input [31:0] ram_data_i,


output [31:0] ram_addr_o,
output [31:0] ram_data_o,
output ram_we_o,
output [3:0] ram_sel_o,
output ram_ce_o,

output [31:0] rom_addr_o,
output rom_ce_o

);
//除法变量
wire signed_div;
wire [31:0] div_opdata1;
wire [31:0] div_opdata2;
wire div_start;
wire [63:0] div_result;
wire div_finish;
//ctrl变量
wire stall_id;
wire stall_ex;
wire [5:0]stall;

//转移指令变量
wire id_pc_flag;
wire[31:0] id_pc_address;

wire id_ex_delayslot_i;
wire id_ex_delayslot_o;
wire[31:0] id_ex_link;
wire id_ex_next;

wire[31:0] ex_link_address;
wire ex_is_in_delayslot;

//和HILO寄存器有关的变量

wire [31:0] hi_ex_mem;
wire [31:0] lo_ex_mem;
wire  wb_whilo_ex_mem;

wire [31:0] hi_mem;
wire [31:0] lo_mem;
wire  wb_whilo_mem;

wire [31:0] hi_mem_wb;
wire [31:0] lo_mem_wb;
wire  wb_whilo_mem_wb;

wire [31:0] hi_hilo;
wire [31:0] lo_hilo;
wire wb_whilo_hilo;

wire [31:0] hi_ex;
wire [31:0] lo_ex;

//连接IF/ID模块与译码阶段ID模块的变量
wire[31:0] pc;
wire[31:0] id_pc_i;
wire[31:0] id_inst_i;

//连接译码阶段ID模块输出与ID/EX模块的输入的变量
wire [7:0] id_aluop_o;
wire [2:0] id_alusel_o;
wire [31:0] id_reg1_o;
wire [31:0] id_reg2_o;
wire id_wreg_o;
wire [4:0] id_wd_o;
wire [31:0] id_inst_o;

//连接ID/EX模块输出与执行阶段EX模块的输入的变量

wire [7:0] ex_aluop_i;
wire [2:0] ex_alusel_i;
wire [31:0] ex_reg1_i;
wire [31:0] ex_reg2_i;
wire ex_wreg_i;
wire [4:0] ex_wd_i;
wire [31:0] ex_inst_o;

//连接执行阶段EX
wire ex_wreg_o;
wire [4:0] ex_wd_o;
wire [31:0] ex_wdata_o;

//连接EX/MEM
wire mem_wreg_i;
wire [4:0] mem_wd_i;
wire [31:0] mem_wdata_i;
wire [31:0] ex_inst_i;
wire [7:0] meme_aluop_i;
wire [31:0] meme_mem_addr_i;
wire [31:0] meme_reg2_i;

//连接MEM
wire mem_wreg_o;
wire [4:0] mem_wd_o;
wire [31:0] mem_wdata_o;
wire [7:0] mem_aluop_i;
wire [31:0] mem_addr_i;
wire [31:0] mem_reg2_i;
wire [31:0] mem_data_i;
wire [31:0] mem_addr_p;
wire mem_we_o;
wire [3:0] mem_sel_o;
wire [31:0] mem_data_o;
wire mem_ce_o;

//连接MEM/WB
wire wb_wreg_i;
wire [4:0] wb_wd_i;
wire [31:0] wb_wdata_i;

//连接译码阶段ID与REGFILE
wire [31:0] reg1_data;
wire [31:0] reg2_data;
wire [4:0] reg1_addr;
wire [4:0] reg2_addr;
wire reg1_read;
wire reg2_read;
//CP0
wire [4:0] cp0_read_addr_o;
wire [4:0] cp0_addr_ex;
wire [31:0] cp0_data_ex;
wire cp0_we_ex;

wire [4:0] cp0_addr_exmem;
wire [31:0] cp0_data_exmem;
wire cp0_we_exmem;

wire [4:0] cp0_addr_mem;
wire [31:0] cp0_data_mem;
wire cp0_we_mem;

wire [4:0] cp0_addr_memwb;
wire [31:0] cp0_data_memwb;
wire cp0_we_memwb;

wire [31:0] cp0_data_o;

wire flush;
wire [31:0] new_pc;
wire [31:0] excepttype_o;
wire [31:0] current_inst_address_o;
wire [31:0] ex_current_inst_address;
wire [31:0] ex_excepttype;
wire [31:0] mem_excepttype;
wire [31:0] mem_current_inst_address;
wire mem_is_in_delayslot;
wire [31:0] memm_excepttype;
wire [31:0] memm_current_inst_address;
wire memm_is_in_delayslot;
wire [31:0] cp0_status;
wire [31:0] cp0_cause;
wire [31:0] cp0_epc;
wire [31:0] cp0_excepttype;
wire [31:0] ctrl_epc;
wire cp0_is_in_delayslot;
wire [31:0] cp0_current_inst_address;


//PC
PC pc0(pc,rom_addr_o,flush,new_pc,clk,rst, stall, id_pc_flag,id_pc_address,rom_ce_o);

//IF/ID
IFID if_id0(clk, rst, stall, pc, rom_data_i,flush, id_pc_i, id_inst_i);

//ID
ID id0(rst, id_pc_i,id_inst_i, reg1_data, reg2_data,
       ex_wreg_o, ex_wdata_o, ex_wd_o,
		 mem_wreg_o, mem_wdata_o, mem_wd_o,
		 id_ex_delayslot_i, excepttype_o, current_inst_address_o,
		 id_ex_next, id_inst_o, 
		 id_pc_flag, id_pc_address, id_ex_link, id_ex_delayslot_o, 
       reg1_read, reg2_read, reg1_addr, reg2_addr,
		 id_aluop_o, id_alusel_o, id_reg1_o, id_reg2_o, id_wd_o, id_wreg_o,stall_id);

//regfile
regfiles regfile0(clk, rst, wb_wreg_i, wb_wd_i, wb_wdata_i, reg1_read,
                  reg1_addr, reg1_data, reg2_read, reg2_addr, reg2_data);
						
//IDEX
IDEX id_ex0(rst, clk, stall, id_aluop_o, id_alusel_o, id_reg1_o, id_reg2_o,
            id_wd_o, id_wreg_o, id_ex_link, id_ex_delayslot_o, id_ex_next,
            id_inst_o, flush, current_inst_address_o, excepttype_o, ex_current_inst_address, ex_excepttype,	
				ex_inst_o, ex_link_address, ex_is_in_delayslot, id_ex_delayslot_i,
				ex_aluop_i, ex_alusel_i, ex_reg1_i,
				ex_reg2_i, ex_wd_i, ex_wreg_i);

//EX
EX ex0(rst, ex_aluop_i, ex_alusel_i, ex_reg1_i, ex_reg2_i, ex_wd_i,
       ex_wreg_i, 
		 hi_ex, lo_ex, hi_hilo, lo_hilo, wb_whilo_hilo, hi_mem_wb, lo_mem_wb, wb_whilo_mem_wb,
		 div_result, div_finish,
		 cp0_we_exmem, cp0_addr_mem, cp0_data_exmem,
		 cp0_we_memwb, cp0_addr_memwb, cp0_data_memwb, cp0_data_o,
		 cp0_read_addr_o, cp0_we_ex, cp0_addr_ex, cp0_data_ex,
		 ex_excepttype,ex_current_inst_address, 
       mem_excepttype, mem_is_in_delayslot, mem_current_inst_address,		 
		 hi_ex_mem, lo_ex_mem, wb_whilo_ex_mem, 
		 ex_link_address, ex_is_in_delayslot, ex_inst_o,
		 meme_aluop_i, meme_mem_addr_i, meme_reg2_i, 
		 ex_wd_o, ex_wreg_o, ex_wdata_o, div_opdata1, div_opdata2, div_start, 
		 signed_div, stall_ex);

//EXMEM
EXMEM ex_mem0(clk, rst, stall, ex_wd_o, ex_wreg_o, ex_wdata_o, 
              hi_ex_mem, lo_ex_mem, wb_whilo_ex_mem, 
              meme_aluop_i, meme_mem_addr_i, meme_reg2_i, 
				  cp0_we_ex, cp0_addr_ex, cp0_data_ex,
				  flush, mem_excepttype, mem_is_in_delayslot, mem_current_inst_address,
				  memm_excepttype, memm_is_in_delayslot, memm_current_inst_address,
				  cp0_we_exmem, cp0_addr_exmem, cp0_data_exmem,
				  mem_aluop_i,mem_addr_i, mem_reg2_i,
				  hi_mem, lo_mem, wb_whilo_mem, 
              mem_wd_i, mem_wreg_i, mem_wdata_i);
				  
//MEM
MEM mem0(rst, mem_wd_i, mem_wreg_i, mem_wdata_i, hi_mem, lo_mem, wb_whilo_mem, 
         mem_aluop_i,mem_addr_i, 
         mem_reg2_i, ram_data_i, 
			cp0_we_exmem, cp0_addr_exmem, cp0_data_exmem,
			cp0_we_mem, cp0_addr_mem, cp0_data_mem,
			memm_excepttype, memm_is_in_delayslot, memm_current_inst_address,
			cp0_status, cp0_cause, cp0_epc, 
			cp0_we_memwb, cp0_addr_memwb, cp0_data_memwb,
			cp0_excepttype, ctrl_epc, cp0_is_in_delayslot, cp0_current_inst_address,
			ram_addr_o, ram_we_o, ram_sel_o, ram_data_o,
			ram_ce_o, mem_wd_o, mem_wreg_o, mem_wdata_o, hi_mem_wb, lo_mem_wb, wb_whilo_mem_wb);

//hilo
hilo hilo0(clk, rst, wb_whilo_hilo, hi_hilo, lo_hilo, hi_ex, lo_ex);


//MEMWB
MEMWB mem_wb0(clk, rst, stall, mem_wd_o, mem_wreg_o, mem_wdata_o, hi_mem_wb, lo_mem_wb, wb_whilo_mem_wb,
              cp0_we_mem, cp0_addr_mem, cp0_data_mem, flush,
				  cp0_we_memwb, cp0_addr_memwb, cp0_data_memwb,
              wb_wd_i, wb_wreg_i, wb_wdata_i, hi_hilo, lo_hilo, wb_whilo_hilo);
//cp0
CP0 cp0(rst, clk, cp0_read_addr_o, cp0_we_memwb, cp0_addr_memwb, cp0_data_memwb,
        cp0_excepttype, cp0_current_inst_address, cp0_is_in_delayslot, 
		  cp0_data_o, cp0_status, cp0_cause, cp0_epc);
//ctrl
ctrl ctrl0(rst, stall_id, stall_ex, cp0_excepttype,
           ctrl_epc, new_pc, flush, stall);
//div
div div0(rst, clk, signed_div, div_opdata1, div_opdata2, div_start, 1'b0, div_result, div_finish);
endmodule
