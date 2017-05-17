`timescale 1ns / 1ps
`define F 31:0
module TRANSLATE(input [`F] IR,
					  output B,CAL_R,CAL_I,LOAD,STORE,JAL,JR,JALR);

	 wire addu,subu;
	 wire ori,lui,lw,sw;
	 wire j,jr,jal,jalr;
	 wire beq,bgez,bgtz,blez,bltz,bne;
	 wire slt,slti,sltiu,sltu;
	 wire sll,sllv,sra,srav,srl,srlv;
	
DECODER DEC_TRANSLATE(IR,addu,subu,ori,lui,lw,sw,j,jr,jal,jalr,
	beq,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu,sll,sllv,sra,srav,srl,srlv);
	
	assign B=beq|bgez|bgtz|blez|bltz|bne;
	assign CAL_R=addu|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv;
	assign CAL_I=ori|lui|slti|sltiu; 
	assign LOAD=lw;
	assign STORE=sw;
	assign JAL=jal;
	assign JR=jr;
	assign JALR=jalr;
endmodule
