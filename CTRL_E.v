`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_E(input [`op] IR_OP,
			input [`func] IR_FUNC,
			input A_B_SIGN_less, A_B_UNSIGN_less,
			output ALU_B_sel,
			output [3:0] ALU_OP);

	 wire lb,lbu,lh,lhu,lw,sb,sh,sw,sub,subu,sll,srl,sra,sllv,srlv,srav,
					  _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu;
	
E_DEC DEC_CTRL_E(IR_OP,IR_FUNC,lb,lbu,lh,lhu,lw,sb,sh,sw,sub,subu,sll,srl,sra,sllv,srlv,srav,
					  _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu);
	
	assign ALU_B_sel=ori|lui|lw|sw|slti|sltiu|lb|lbu|lh|lhu|sb|sh|addi|addiu|andi|ori|xori|lui;
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
endmodule
