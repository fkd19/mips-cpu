`timescale 1ns / 1ps
`define F 31:0
`define func 5:0

module D_TRANSLATE(input [31:16] IR, input [`func] IR_FUNC,
					  output B,CAL_R,CAL_I,LOAD,STORE,JR,JALR);

	 wire lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 jalr,jr,mfc0;
	
HAZ_D_DEC DEC_D_TRANSLATE(IR[31:16],IR_FUNC,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 jalr,jr,mfc0);
	
	assign B=beq|bne;
	assign CAL_R=add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor;
	assign CAL_I=addi|addiu|andi|ori|xori|lui|slti|sltiu; 
	assign LOAD=lw|lb|lbu|lh|lhu|mfc0;
	assign STORE=sw|sb|sh;
	assign JR=jr|bgez|bgtz|blez|bltz;
	assign JALR=jalr;
endmodule

module E_TRANSLATE(input [31:21] IR, input[`func] IR_FUNC,
					  output CAL_R,CAL_I,LOAD,STORE,MTC0);

	 wire lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltumfc0,mtc0;
	
HAZ_E_DEC DEC_E_TRANSLATE(IR[31:21],IR_FUNC,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,mfc0,mtc0);
	
	assign CAL_R=add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor;
	assign CAL_I=addi|addiu|andi|ori|xori|lui|slti|sltiu; 
	assign LOAD=lw|lb|lbu|lh|lhu|mfc0;
	assign STORE=sw|sb|sh;
	assign MTC0=mtc0;
endmodule

module M_TRANSLATE(input [31:21] IR, input[`func] IR_FUNC,
					  output CAL_R,CAL_I,LOAD,STORE,JAL,JALR,MTC0);

	 wire lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							 jal,jalr,mfc0,mtc0;
	
HAZ_M_DEC DEC_M_TRANSLATE(IR[31:21],IR_FUNC,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							 jal,jalr,mfc0,mtc0);
	
	assign CAL_R=add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor;
	assign CAL_I=addi|addiu|andi|ori|xori|lui|slti|sltiu; 
	assign LOAD=lw|lb|lbu|lh|lhu|mfc0;
	assign STORE=sw|sb|sh;
	assign JAL=jal;
	assign JALR=jalr;
	assign MTC0=mtc0;
endmodule

module W_TRANSLATE(input [31:21] IR, input[`func] IR_FUNC,
					  output CAL_R,CAL_I,LOAD,JAL,JALR);

	 wire lb,lbu,lh,lhu,lw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							 jal,jalr,mfc0;
	
HAZ_W_DEC DEC_W_TRANSLATE(IR[31:21],IR_FUNC,lb,lbu,lh,lhu,lw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							 jal,jalr,mfc0);
	
	assign CAL_R=add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor;
	assign CAL_I=addi|addiu|andi|ori|xori|lui|slti|sltiu; 
	assign LOAD=lw|lb|lbu|lh|lhu|mfc0;
	assign JAL=jal;
	assign JALR=jalr;
endmodule
