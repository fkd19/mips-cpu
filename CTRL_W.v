`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_W(input [31:21] IR, 
				  input [5:0] IR_FUNC,
				  output [1:0] Wreg_sel, Wdata_sel,
				  output GRF_WE,
				  output[2:0] XEXT_OP);

	 wire lb,lbu,lh,lhu,lw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
						_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,jal,jalr,mfc0;
	
W_DEC DEC_CTRL_W(IR[31:21],IR_FUNC,lb,lbu,lh,lhu,lw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
						_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,jal,jalr,mfc0);
	
	assign Wreg_sel=(jal)?2'd2:
					(add|addu|sub|subu|slt|sltu|jalr|sll|srl|sra|sllv|srlv|srav|_and|_or|_xor|_nor)?2'd1:2'd0;
	assign Wdata_sel=(jal|jalr)?2'd2:
					 (lb|lbu|lh|lhu|lw|mfc0)?2'd1:2'd0;
	assign GRF_WE=add|addu|sub|subu|ori|lui|lw|jal|slt|slti|sltiu|sltu|jalr|lb|lbu|lh|lhu|sll|srl|sra|sllv|srlv|srav
				 |_and|_or|_xor|_nor|addi|addiu|andi|ori|xori|lui|mfc0;
	assign XEXT_OP=(lh) ?3'd4:
					(lhu)?3'd3:
					(lb) ?3'd2:
					(lbu)?3'd1:3'd0;
endmodule
