`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_W(input [`F] IR,
				  output [1:0] Wreg_sel, Wdata_sel,
				  output GRF_WE);

	 wire addu,subu;
	 wire ori,lui,lw,sw;
	 wire j,jr,jal,jalr;
	 wire beq,bgez,bgtz,blez,bltz,bne;
	 wire slt,slti,sltiu,sltu;
	 wire sll,sllv,sra,srav,srl,srlv;
	
DECODER DEC_CTRL_D(IR,addu,subu,ori,lui,lw,sw,j,jr,jal,jalr,
	beq,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu,sll,sllv,sra,srav,srl,srlv);
	
	assign Wreg_sel=(jal)?2:
						 (addu|subu|slt|sltu|jalr)?1:0;
	assign Wdata_sel=(jal|jalr)?2:
						  (lw)?1:0;
	assign GRF_WE=addu|subu|ori|lui|lw|jal|slt|slti|sltiu|sltu|jalr;
endmodule
