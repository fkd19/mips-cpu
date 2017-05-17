`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_W(input [`F] IR,
				  output [1:0] Wreg_sel, Wdata_sel,
				  output GRF_WE,
				  output[2:0] XEXT_OP);

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
	 wire mfc0,mtc0,eret;
	
DECODER DEC_CTRL_W(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,madd,maddu,msub,msubu,swl,swr,movn,movz,mfc0,mtc0,eret);
	
	assign Wreg_sel=(jal)?2:
						 (add|addu|sub|subu|slt|sltu|jalr|sll|srl|sra|sllv|srlv|srav|_and|_or|_xor|_nor|mfhi|mflo|movn|movz)?1:0;
	assign Wdata_sel=(mfhi|mflo)?3:
						  (jal|jalr)?2:
						  (lb|lbu|lh|lhu|lw|mfc0)?1:0;
	assign GRF_WE=add|addu|sub|subu|ori|lui|lw|jal|slt|slti|sltiu|sltu|jalr|lb|lbu|lh|lhu|sll|srl|sra|sllv|srlv|srav
					 |_and|_or|_xor|_nor|addi|addiu|andi|ori|xori|lui|mfhi|mflo|movn|movz|mfc0;
	assign XEXT_OP=(lh) ?4:
						(lhu)?3:
						(lb) ?2:
						(lbu)?1:0;
endmodule
