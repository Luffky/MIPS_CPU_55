`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:53 04/27/2016 
// Design Name: 
// Module Name:    SOPC 
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
module SOPC(
    input clk ,
    input rst 
    );
wire[31:0] inst_addr;
wire[31:0] inst_i;
wire rom_ce;
wire [31:0]ram_addr_o;
wire [31:0]ram_data_o;
wire [3:0] ram_sel_o;
wire ram_ce_o;
wire ram_we_o;
wire [31:0] data_o;
wire [31:0]hi_i;
wire [31:0]lo_i;
wire [31:0]hi_o;
wire [31:0]lo_o;
wire we;
wire clk1;
wire [31:0] ram_1;
//clk clk0(clk, rst, clk1);
CPU cpu0(clk, rst, inst_i, data_o, ram_addr_o, ram_data_o, ram_we_o, ram_sel_o,
        ram_ce_o, inst_addr, rom_ce);
ROM rom0(rom_ce, inst_addr, inst_i);
ram ram0(clk, ram_ce_o, ram_we_o, ram_addr_o, ram_sel_o, ram_data_o, data_o);



endmodule
