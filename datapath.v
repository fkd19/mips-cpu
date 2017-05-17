`timescale 1ns / 1ps

module datapath(
	 input clk,
    input reset,
	 input[1:0] RegDst,
	input AluSrc,
	input[1:0] MemToReg,
	input[1:0] PCsrc,
	input ExtOp,
	input we,
	input[2:0] AluOp,
	input memread,
	input memwrite,
	output[31:0] instr,
	output[8:0] zero,
	input slt_real
    );

	//指令分割
	wire[6:0] opcode;
	wire[25:0] imm26;
	wire[4:0] rs;
	wire[4:0] rt;
	wire[15:0] imm16;
	wire[4:0] rd;
	wire[4:0] shamt;
	wire[5:0] func;
	//变量声明
	//IF
	wire[31:0] cpc, npc, cpc_4, signext_imm16_00, Naddout, jtgt;
	//ID
	wire[4:0] Wreg;
	wire[31:0] Wdata, Rdata1, Rdata2, ext, AluB;
	//EX
	wire[31:0] aluout, s_value;	//slt系列指令32位结果	
	//WM
	wire[31:0] dmout;
	//IF
	PC _pc(npc, cpc, clk, reset);
	//PC自增
	assign cpc_4=cpc+4;
	assign signext_imm16_00[31:2]=ext[29:0];
	assign signext_imm16_00[1:0]=2'b00;
	assign Naddout=cpc_4+signext_imm16_00;
	assign jtgt[31:28]=cpc[31:28];
	assign jtgt[27:2]=imm26[25:0];
	assign jtgt[1:0]=2'b00;
	mux5 _mux5(cpc_4, Naddout, jtgt, Rdata1, PCsrc, npc);
	IM _IM(cpc, instr);
	//ID&controller
	assign opcode=instr[31:26];
	assign imm26=instr[25:0];
	assign rs=instr[25:21];
	assign rt=instr[20:16];
	assign imm16=instr[15:0];
	assign rd=instr[15:11];
	assign shamt=instr[10:6];
	assign func=instr[5:0];
	mux1 _mux1(rt, rd, RegDst, Wreg);
	mux3 _mux3(aluout, dmout, cpc_4, s_value, MemToReg, Wdata);
	GRF _GRF(clk, reset, rs, rt, Wreg, Wdata, we, Rdata1, Rdata2);
	EXT _EXT(imm16, ExtOp, ext);
	cmp32 _cmp_AB(Rdata1, AluB, zero[5:3]);
	cmp32 _cmp_A0(Rdata1, 0, zero[2:0]);
	assign s_value=(slt_real)?32'h1:32'h0;
	//EX
	mux2 _mux2(Rdata2, ext, AluSrc, AluB);
	alu _alu(Rdata1, AluB, AluOp, aluout, zero[8:6]);
	//WM
	DM _DM(aluout, Rdata2, dmout, memread, memwrite, reset, clk);

endmodule
