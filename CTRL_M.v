`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_M(input [`F] IR,
				  output DM_WE);
	 
	 wire addu,subu;
	 wire ori,lui,lw,sw;
	 wire j,jr,jal,jalr;
	 wire beq,bgez,bgtz,blez,bltz,bne;
	 wire slt,slti,sltiu,sltu;
	 wire sll,sllv,sra,srav,srl,srlv;
	
DECODER DEC_CTRL_M(IR,addu,subu,ori,lui,lw,sw,j,jr,jal,jalr,
	beq,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu,sll,sllv,sra,srav,srl,srlv);

	assign DM_WE=sw;

endmodule
