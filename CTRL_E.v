`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_E(input [`F] IR,
				  input [2:0] A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP,
				  output ALU_B_sel,
				  output [3:0] ALU_OP);

	 wire addu,subu;
	 wire ori,lui,lw,sw;
	 wire j,jr,jal,jalr;
	 wire beq,bgez,bgtz,blez,bltz,bne;
	 wire slt,slti,sltiu,sltu;
	 wire sll,sllv,sra,srav,srl,srlv;
	
DECODER DEC_CTRL_E(IR,addu,subu,ori,lui,lw,sw,j,jr,jal,jalr,
	beq,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu,sll,sllv,sra,srav,srl,srlv);
	
	assign ALU_B_sel=ori|lui|lw|sw|slti|sltiu;
	assign ALU_OP=(((slt|slti)&~A_B_SIGN_CMP[0])|((sltu|sltiu)&~A_B_UNSIGN_CMP[0]))?6:
					  (((slt|slti)& A_B_SIGN_CMP[0])|((sltu|sltiu)& A_B_UNSIGN_CMP[0]))?5:
					  (lui)?4:
					  (ori)?3:
					  (0)?2:
					  (subu)?1:0;
endmodule
