`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_M(input [`F] IR,
				  output DM_WE,
				  output[2:0] BE_CTRL,
				  output LR);
	 
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
	
DECODER DEC_CTRL_M(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,madd,maddu,msub,msubu,swl,swr,movn,movz);

	assign DM_WE=sw|sb|sh|swl|swr;
	assign BE_CTRL=sb?2:
						sh?1:
						swl?3:
						swr?4:0;//sw=0
	assign LR=swl|swr;
endmodule
