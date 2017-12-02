`timescale 1ns / 1ps
`include <head.h>

module CTRL_M_2_HALF(input clk, reset, 
              input [`F]   IR, 
              output 	   CP0_WE, EXL_clr, CP0_sel, SL, is_lw);

   reg 			   epc_sign;
   wire 		   lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
			   _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
			   j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal;
   
   DECODER DEC_TRANSLATE(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
                         _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
                         j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal);

   assign CP0_WE=mtc0;
   assign EXL_clr=eret;
   assign CP0_sel=mfc0;
   assign SL = sb|sh|sw|lw|lb|lbu|lh|lhu;
   assign is_lw = lw;
   
endmodule
