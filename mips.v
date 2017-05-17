`timescale 1ns / 1ps

module mips(
    input clk,
    input reset
    );
	
	wire[31:0] instr;
	//信号声明
	wire[1:0] RegDst, MemToReg, PCsrc;
	wire AluSrc,ExtOp,we,memread,memwrite,slts_real;
	wire[2:0] AluOp;
	wire[8:0] zero;	//[8:6]:无符号比较	[5:3]:有符号比较	[2:0]:有符号与零比较
	
	
//controller
controller _controller(instr[31:26], instr[5:0], zero, RegDst, AluSrc, PCsrc, MemToReg, ExtOp, we, AluOp, memread, memwrite, instr[20:16], slts_real);
//datapath
datapath _datapath(clk, reset, RegDst, AluSrc, MemToReg, PCsrc, ExtOp, we, AluOp, memread, memwrite, instr, zero, slts_real);
endmodule
