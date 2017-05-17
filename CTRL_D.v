`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_D(input [`F] IR,
				  input [2:0] AB_CMP,A0_CMP,
				  output EXT_sel,
				  output[1:0] b_j_jr_sel,
				  output PC_sel);

	 wire addu,subu;
	 wire ori,lui,lw,sw;
	 wire j,jr,jal,jalr;
	 wire beq,bgez,bgtz,blez,bltz,bne;
	 wire slt,slti,sltiu,sltu;
	 wire sll,sllv,sra,srav,srl,srlv;
	
DECODER DEC_CTRL_D(IR,addu,subu,ori,lui,lw,sw,j,jr,jal,jalr,
	beq,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu,sll,sllv,sra,srav,srl,srlv);
	
	assign EXT_sel=lw|sw|slti|sltiu;
	assign b_j_jr_sel=(jr|jalr)?2:
							(j|jal)?1:0;
	assign PC_sel=(beq&AB_CMP[1])|j|jal|jr|jalr|(bgez&(A0_CMP[2]|A0_CMP[1]))|(bgtz&A0_CMP[2])
					 |(blez&(A0_CMP[0]|A0_CMP[1]))|(bltz&A0_CMP[0])|(bne&~AB_CMP[1]);

endmodule
