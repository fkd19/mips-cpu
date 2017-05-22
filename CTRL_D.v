`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_D(input [`op] IR_OP,
			input [`rt] IR_RT,
			input [`func] IR_FUNC,
			input AB_equal,
			input [2:0] A0_CMP,
			output EXT_sel,
			output[1:0] b_j_jr_sel,
			output PC_sel, ERET_PC_sel);

	 wire lb,lbu,lh,lhu,lw,sb,sh,sw,addi,addiu,slti,sltiu,beq,bne,blez,bgtz,bltz,bgez,j,jal,jalr,jr,eret;
	
D_DEC DEC_CTRL_D(IR_OP,IR_RT,IR_FUNC,lb,lbu,lh,lhu,lw,sb,sh,sw,addi,addiu,slti,sltiu,beq,bne,blez,bgtz,bltz,bgez,j,jal,jalr,jr,eret);
	
	assign EXT_sel=lw|sw|slti|sltiu|lb|lbu|lh|lhu|sb|sh|addi|addiu;		//1：符号扩展	0：无符号扩展
	assign b_j_jr_sel=(jr|jalr)?2'd2:	
					  (j|jal)?2'd1:2'd0;
	assign PC_sel=(beq&AB_equal)|j|jal|jr|jalr|(bgez&(A0_CMP[2]|A0_CMP[1]))|(bgtz&A0_CMP[2])
					 |(blez&(A0_CMP[0]|A0_CMP[1]))|(bltz&A0_CMP[0])|(bne&~AB_equal);
	assign ERET_PC_sel=eret;	//中断处理完毕，选择epc的值作为下一个pc值
endmodule
