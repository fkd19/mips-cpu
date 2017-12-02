`timescale 1ns / 1ps
`include <head.h>

module CTRL_D(input [`F] IR_D,
                output         Illegal);

       wire lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
            _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
            j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret,bgezal, bltzal,Break, syscall,lwg,gpu,swg;
	
DECODER DEC_TRANSLATE(IR_D,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
                          _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
                          j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,mfc0,mtc0,eret, Break, syscall, bgezal, bltzal);
	assign lwg = (IR_D[`op] == 6'b111100);
	assign gpu = (IR_D[`op] == 6'b111111);
	assign swg = (IR_D[`op] == 6'b111101);
	assign Illegal = ~(lb|lbu|lh|lhu|lw|sb|sh|sw|addi|addiu|slti|sltiu|beq|bne|blez|bgtz|bltz|bgez|j|jal|jalr|jr|eret|bgezal|bltzal|
                  _and|andi|add|addu|sub|subu|slt|sltu|div|divu|mult|multu|lui|_nor|_or|ori|_xor|xori|sll|sllv|sra|srav|srl|srlv|
                  mfhi|mflo|mthi|mtlo|Break|syscall|mtc0|mfc0|lwg|gpu|swg);
endmodule
