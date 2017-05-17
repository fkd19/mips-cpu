`timescale 1ns / 1ps
`define F 31:0
module TRANSLATE(input [`F] IR,
					  output B,CAL_R,CAL_I,LOAD,STORE,JAL,JR,JALR,MF,MDFT,MTC0,ERET);

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
	
DECODER DEC_TRANSLATE(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,madd,maddu,msub,msubu,swl,swr,movn,movz,mfc0,mtc0,eret);
	
	assign B=beq|bne;
	assign CAL_R=add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor
					|mult|multu|div|divu|mthi|mtlo|madd|maddu|msub|msubu|movn|movz;
	assign CAL_I=addi|addiu|andi|ori|xori|lui|slti|sltiu; 
	assign LOAD=lw|lb|lbu|lh|lhu|mfc0;
	assign STORE=sw|sb|sh|swl|swr;
	assign JAL=jal;
	assign JR=jr|bgez|bgtz|blez|bltz;
	assign JALR=jalr;
	assign MF=mfhi|mflo;
	assign MDFT=mult|multu|div|divu|mfhi|mflo|mthi|mtlo|madd|maddu|msub|msubu;
	assign MTC0=mtc0;
	assign ERET=eret;
endmodule
