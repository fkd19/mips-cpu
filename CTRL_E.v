`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_E(input [`F] IR,RT_E,
				  input [2:0] A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP,
				  output ALU_B_sel,HI_WE,LO_WE,XALUOUT_sel,
				  output [4:0] ALU_OP,
				  output [3:0] XALU_OP,
				  output EX_MEM_clr);

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
	
DECODER DEC_CTRL_E(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,madd,maddu,msub,msubu,swl,swr,movn,movz);
	
	assign ALU_B_sel=ori|lui|lw|sw|slti|sltiu|lb|lbu|lh|lhu|sb|sh|addi|addiu|andi|ori|xori|lui|swl|swr;
	assign ALU_OP=(sub|subu)?1:
					  (_and|andi)?2:
					  (_or|ori)?3:
					  (_xor|xori)?4:
					  _nor?5:
					  (((slt|slti)& A_B_SIGN_CMP[0])|((sltu|sltiu)& A_B_UNSIGN_CMP[0]))?6:
					  (((slt|slti)&~A_B_SIGN_CMP[0])|((sltu|sltiu)&~A_B_UNSIGN_CMP[0]))?7:
					  lui?8:
					  sll?9:
					  srl?10:
					  sllv?11:
					  srlv?12:
					  sra?13:
					  srav?14:
					  (movz|movn)?15:0;
	assign XALU_OP=mult?1:
						multu?2:
						div?3:
						divu?4:
						madd?5:
						maddu?6:
						msub?7:
						msubu?8:0;
	assign HI_WE=mthi;
	assign LO_WE=mtlo;
	assign XALUOUT_sel=(mflo)?1:0;
	assign EX_MEM_clr=(movz && (|RT_E)) || (movn && ~(|RT_E));
endmodule
