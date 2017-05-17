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

	 wire lb,lbu,lh,lhu,lw,sb,sh,sw;
	 wire add,addu,sub,subu;
	 wire mult,multu,div,divu;
	 wire sll,srl,sra,sllv,srlv,srav;
	 wire _and,_or,_xor,_nor;
	 wire addi,addiu,andi,ori,xori,lui;
	 wire slt,slti,sltiu,sltu;
	 wire beq,bne,blez,bgtz,bltz,bgez;
	 wire j,jal,jalr,jr;
	 wire mfhi,mflo,mthi,mtlo;
	 wire madd,maddu,msub,msubu;
	 wire swl,swr,movn,movz;
	
DECODER DEC_CTRL_D(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,madd,maddu,msub,msubu,swl,swr,movn,movz);
	
	assign EXT_sel=lw|sw|slti|sltiu|lb|lbu|lh|lhu|sb|sh|addi|addiu|swl|swr;
	assign b_j_jr_sel=(jr|jalr)?2:
							(j|jal)?1:0;
	assign PC_sel=(beq&AB_CMP[1])|j|jal|jr|jalr|(bgez&(A0_CMP[2]|A0_CMP[1]))|(bgtz&A0_CMP[2])
					 |(blez&(A0_CMP[0]|A0_CMP[1]))|(bltz&A0_CMP[0])|(bne&~AB_CMP[1]);

endmodule
