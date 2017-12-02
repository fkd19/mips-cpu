`timescale 1ns / 1ps
`include <head.h>

module CTRL_W(input [`F] IR,
              output [1:0] Wreg_sel, Wdata_sel,
              output GRF_WE,
              output[2:0] XEXT_OP);

	wire lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
                          _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
                          j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal;
                  
  DECODER DEC_TRANSLATE(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
                            _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
                            j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal);
	
	assign Wreg_sel=(jal|bgezal|bltzal)?2'd2:
				    (add|addu|sub|subu|slt|sltu|jalr|sll|srl|sra|sllv|srlv|srav|_and|_or|_xor|_nor|mfhi|mflo)?2'd1:2'd0;
	assign Wdata_sel=(mfhi|mflo)?2'd3:
	                 (jal|jalr|bgezal|bltzal)?2'd2:
					 (lb|lbu|lh|lhu|lw|mfc0)?2'd1:2'd0;
	assign GRF_WE=add|addu|sub|subu|ori|lui|lw|jal|slt|slti|sltiu|sltu|jalr|lb|lbu|lh|lhu|sll|srl|sra|sllv|srlv|srav
					 |_and|_or|_xor|_nor|addi|addiu|andi|ori|xori|lui|mfc0|mfhi|mflo|bgezal|bltzal;
	assign XEXT_OP=(lh) ?3'd4:
						(lhu)?3'd3:
						(lb) ?3'd2:
						(lbu)?3'd1:3'd0;
endmodule
