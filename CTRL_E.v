`timescale 1ns / 1ps
`include <head.h>

module CTRL_E(input [`F] IR,
              input 	   A_B_SIGN_less, A_B_UNSIGN_less,
              output 	   ALU_B_sel,
              output [3:0] ALU_OP, XALU_OP, 
              output 	   HI_WE, LO_WE, HI_LO_sel, add_addi, _sub);

   wire 		   lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
                           _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
                           j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal;
   
   DECODER DEC_TRANSLATE(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
                         _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
                         j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal);
   
   assign ALU_B_sel=ori|lui|lw|sw|slti|sltiu|lb|lbu|lh|lhu|sb|sh|addi|addiu|andi|ori|xori|lui| (IR[31:27] == 5'b11110);   //lwg| swg   
   assign ALU_OP=(sub|subu)?4'd1:
		 (_and|andi)?4'd2:
		 (_or|ori)?4'd3:
		 (_xor|xori)?4'd4:
		 _nor?4'd5:
		 (((slt|slti)& A_B_SIGN_less)|((sltu|sltiu)& A_B_UNSIGN_less))?4'd6:
		 (((slt|slti)&~A_B_SIGN_less)|((sltu|sltiu)&~A_B_UNSIGN_less))?4'd7:
		 lui?4'd8:
		 sll?4'd9:
		 srl?4'd10:
		 sllv?4'd11:
		 srlv?4'd12:
		 sra?4'd13:
		 srav?4'd14:4'd0;
   
   assign XALU_OP=mult?4'd2:
                  multu?4'd3:
                  div?4'd4:
                  divu?4'd5:4'd0;
   
   assign HI_WE=mthi;
   assign LO_WE=mtlo;
   assign HI_LO_sel=(mflo)?4'd1:4'd0;
   assign add_addi=add|addi;
   assign _sub=sub;
   
endmodule
