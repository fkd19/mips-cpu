`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module D_DEC(input [`op] IR, input[`rt] IR1, input[`func] IR2,
		output lb,lbu,lh,lhu,lw,sb,sh,sw,addi,addiu,slti,sltiu,beq,bne,blez,bgtz,bltz,bgez,j,jal,jalr,jr,eret);

	
	assign lb =(IR[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR[`op] == 6'b100011)?1'b1:1'b0;
	assign sb =(IR[`op] == 6'b101000)?1'b1:1'b0;
	assign sh =(IR[`op] == 6'b101001)?1'b1:1'b0;
	assign sw =(IR[`op] == 6'b101011)?1'b1:1'b0;
	
	assign addi =(IR[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR[`op] == 6'b001001)?1'b1:1'b0;
	
	assign slti =(IR[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR[`op] == 6'b001011)?1'b1:1'b0;
	
	assign beq =(IR[`op] == 6'b000100)?1'b1:1'b0;
	assign bne =(IR[`op] == 6'b000101)?1'b1:1'b0;
	assign blez=(IR[`op] == 6'b000110)?1'b1:1'b0;
	assign bgtz=(IR[`op] == 6'b000111)?1'b1:1'b0;
	assign bltz=({IR[`op], IR1[`rt]} == 11'b000001_00000)?1'b1:1'b0;
	assign bgez=({IR[`op], IR1[`rt]} == 11'b000001_00001)?1'b1:1'b0;
	
	assign j=(IR[`op] == 6'b000010)?1'b1:1'b0;
	assign jal=(IR[`op] == 6'b000011)?1'b1:1'b0;
	assign jr=({IR[`op],IR2[`func]} == 12'b000000_001000)?1'b1:1'b0;
	assign jalr=({IR[`op],IR2[`func]} == 12'b000000_001001)?1'b1:1'b0;

	assign eret=({IR[`op],IR2[`func]} == 12'b010000_011000)?1'b1:1'b0;
endmodule

module E_DEC(input [`op] IR, input [`func] IR1,
				output lb,lbu,lh,lhu,lw,sb,sh,sw,sub,subu,sll,srl,sra,sllv,srlv,srav,
						_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu);

	
	assign lb =(IR[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR[`op] == 6'b100011)?1'b1:1'b0;
	assign sb =(IR[`op] == 6'b101000)?1'b1:1'b0;
	assign sh =(IR[`op] == 6'b101001)?1'b1:1'b0;
	assign sw =(IR[`op] == 6'b101011)?1'b1:1'b0;

	assign sub =({IR[`op],IR1[`func]} == 12'b000000_100010)?1'b1:1'b0;
	assign subu=({IR[`op],IR1[`func]} == 12'b000000_100011)?1'b1:1'b0;

	assign sll =({IR[`op],IR1[`func]} == 12'b000000_000000)?1'b1:1'b0;
	assign srl =({IR[`op],IR1[`func]} == 12'b000000_000010)?1'b1:1'b0;
	assign sra =({IR[`op],IR1[`func]} == 12'b000000_000011)?1'b1:1'b0;
	assign sllv=({IR[`op],IR1[`func]} == 12'b000000_000100)?1'b1:1'b0;
	assign srlv=({IR[`op],IR1[`func]} == 12'b000000_000110)?1'b1:1'b0;
	assign srav=({IR[`op],IR1[`func]} == 12'b000000_000111)?1'b1:1'b0;
	
	assign _and=({IR[`op],IR1[`func]} == 12'b000000_100100)?1'b1:1'b0;
	assign _or =({IR[`op],IR1[`func]} == 12'b000000_100101)?1'b1:1'b0;
	assign _xor=({IR[`op],IR1[`func]} == 12'b000000_100110)?1'b1:1'b0;
	assign _nor=({IR[`op],IR1[`func]} == 12'b000000_100111)?1'b1:1'b0;
	
	assign addi =(IR[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR[`op] == 6'b001001)?1'b1:1'b0;
	assign andi =(IR[`op] == 6'b001100)?1'b1:1'b0;
	assign ori  =(IR[`op] == 6'b001101)?1'b1:1'b0;
	assign xori =(IR[`op] == 6'b001110)?1'b1:1'b0;
	assign lui  =(IR[`op] == 6'b001111)?1'b1:1'b0;
	
	assign slt  =({IR[`op],IR1[`func]} == 12'b000000_101010)?1'b1:1'b0;
	assign slti =(IR[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR[`op] == 6'b001011)?1'b1:1'b0;
	assign sltu =({IR[`op],IR1[`func]} == 12'b000000_101011)?1'b1:1'b0;
endmodule

module M_DEC(input [31:16] IR, input[`func] IR1,
				output sb,sh,sw,beq,bne,blez,bgtz,bltz,bgez,j,jal,jalr,jr,mfc0,mtc0,eret);

	assign sb =(IR[`op] == 6'b101000)?1'b1:1'b0;
	assign sh =(IR[`op] == 6'b101001)?1'b1:1'b0;
	assign sw =(IR[`op] == 6'b101011)?1'b1:1'b0;
	
	assign beq =(IR[`op] == 6'b000100)?1'b1:1'b0;
	assign bne =(IR[`op] == 6'b000101)?1'b1:1'b0;
	assign blez=(IR[`op] == 6'b000110)?1'b1:1'b0;
	assign bgtz=(IR[`op] == 6'b000111)?1'b1:1'b0;
	assign bltz=({IR[`op], IR[`rt]} == 11'b000001_00000)?1'b1:1'b0;
	assign bgez=({IR[`op], IR[`rt]} == 11'b000001_00001)?1'b1:1'b0;
	
	assign j=(IR[`op] == 6'b000010)?1'b1:1'b0;
	assign jal=(IR[`op] == 6'b000011)?1'b1:1'b0;
	assign jr=({IR[`op],IR1[`func]} == 12'b000000_001000)?1'b1:1'b0;
	assign jalr=({IR[`op],IR1[`func]} == 12'b000000_001001)?1'b1:1'b0;
	
	assign mfc0=({IR[`op], IR[`rs]} == 11'b010000_00000)?1'b1:1'b0;
	assign mtc0=({IR[`op], IR[`rs]} == 11'b010000_00100)?1'b1:1'b0;
	assign eret=({IR[`op],IR1[`func]} == 12'b010000_011000)?1'b1:1'b0;
endmodule

module W_DEC(input [31:21] IR1, input[5:0] IR2,
				output lb,lbu,lh,lhu,lw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
						_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,jal,jalr,mfc0);

	
	assign lb =(IR1[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR1[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR1[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR1[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR1[`op] == 6'b100011)?1'b1:1'b0;
	
	assign add =({IR1[`op],IR2[`func]} == 12'b000000_100000)?1'b1:1'b0;
	assign addu=({IR1[`op],IR2[`func]} == 12'b000000_100001)?1'b1:1'b0;
	assign sub =({IR1[`op],IR2[`func]} == 12'b000000_100010)?1'b1:1'b0;
	assign subu=({IR1[`op],IR2[`func]} == 12'b000000_100011)?1'b1:1'b0;

	assign sll =({IR1[`op],IR2[`func]} == 12'b000000_000000)?1'b1:1'b0;
	assign srl =({IR1[`op],IR2[`func]} == 12'b000000_000010)?1'b1:1'b0;
	assign sra =({IR1[`op],IR2[`func]} == 12'b000000_000011)?1'b1:1'b0;
	assign sllv=({IR1[`op],IR2[`func]} == 12'b000000_000100)?1'b1:1'b0;
	assign srlv=({IR1[`op],IR2[`func]} == 12'b000000_000110)?1'b1:1'b0;
	assign srav=({IR1[`op],IR2[`func]} == 12'b000000_000111)?1'b1:1'b0;
	
	assign _and=({IR1[`op],IR2[`func]} == 12'b000000_100100)?1'b1:1'b0;
	assign _or =({IR1[`op],IR2[`func]} == 12'b000000_100101)?1'b1:1'b0;
	assign _xor=({IR1[`op],IR2[`func]} == 12'b000000_100110)?1'b1:1'b0;
	assign _nor=({IR1[`op],IR2[`func]} == 12'b000000_100111)?1'b1:1'b0;
	
	assign addi =(IR1[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR1[`op] == 6'b001001)?1'b1:1'b0;
	assign andi =(IR1[`op] == 6'b001100)?1'b1:1'b0;
	assign ori  =(IR1[`op] == 6'b001101)?1'b1:1'b0;
	assign xori =(IR1[`op] == 6'b001110)?1'b1:1'b0;
	assign lui  =(IR1[`op] == 6'b001111)?1'b1:1'b0;
	
	assign slt  =({IR1[`op],IR2[`func]} == 12'b000000_101010)?1'b1:1'b0;
	assign slti =(IR1[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR1[`op] == 6'b001011)?1'b1:1'b0;
	assign sltu =({IR1[`op],IR2[`func]} == 12'b000000_101011)?1'b1:1'b0;
	
	assign jal=(IR1[`op] == 6'b000011)?1'b1:1'b0;
	assign jalr=({IR1[`op],IR2[`func]} == 12'b000000_001001)?1'b1:1'b0;
	
	assign mfc0=({IR1[`op], IR1[`rs]} == 11'b010000_00000)?1'b1:1'b0;
endmodule

module HAZ_D_DEC(input [31:16] IR, 
					input [`func] IR1,
					output lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							jalr,jr,mfc0);

	assign lb =(IR[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR[`op] == 6'b100011)?1'b1:1'b0;
	assign sb =(IR[`op] == 6'b101000)?1'b1:1'b0;
	assign sh =(IR[`op] == 6'b101001)?1'b1:1'b0;
	assign sw =(IR[`op] == 6'b101011)?1'b1:1'b0;
	
	assign add =({IR[`op],IR1[`func]} == 12'b000000_100000)?1'b1:1'b0;
	assign addu=({IR[`op],IR1[`func]} == 12'b000000_100001)?1'b1:1'b0;
	assign sub =({IR[`op],IR1[`func]} == 12'b000000_100010)?1'b1:1'b0;
	assign subu=({IR[`op],IR1[`func]} == 12'b000000_100011)?1'b1:1'b0;

	assign sll =({IR[`op],IR1[`func]} == 12'b000000_000000)?1'b1:1'b0;
	assign srl =({IR[`op],IR1[`func]} == 12'b000000_000010)?1'b1:1'b0;
	assign sra =({IR[`op],IR1[`func]} == 12'b000000_000011)?1'b1:1'b0;
	assign sllv=({IR[`op],IR1[`func]} == 12'b000000_000100)?1'b1:1'b0;
	assign srlv=({IR[`op],IR1[`func]} == 12'b000000_000110)?1'b1:1'b0;
	assign srav=({IR[`op],IR1[`func]} == 12'b000000_000111)?1'b1:1'b0;
	
	assign _and=({IR[`op],IR1[`func]} == 12'b000000_100100)?1'b1:1'b0;
	assign _or =({IR[`op],IR1[`func]} == 12'b000000_100101)?1'b1:1'b0;
	assign _xor=({IR[`op],IR1[`func]} == 12'b000000_100110)?1'b1:1'b0;
	assign _nor=({IR[`op],IR1[`func]} == 12'b000000_100111)?1'b1:1'b0;
	
	assign addi =(IR[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR[`op] == 6'b001001)?1'b1:1'b0;
	assign andi =(IR[`op] == 6'b001100)?1'b1:1'b0;
	assign ori  =(IR[`op] == 6'b001101)?1'b1:1'b0;
	assign xori =(IR[`op] == 6'b001110)?1'b1:1'b0;
	assign lui  =(IR[`op] == 6'b001111)?1'b1:1'b0;
	
	assign slt  =({IR[`op],IR1[`func]} == 12'b000000_101010)?1'b1:1'b0;
	assign slti =(IR[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR[`op] == 6'b001011)?1'b1:1'b0;
	assign sltu =({IR[`op],IR1[`func]} == 12'b000000_101011)?1'b1:1'b0;
	
	assign beq =(IR[`op] == 6'b000100)?1'b1:1'b0;
	assign bne =(IR[`op] == 6'b000101)?1'b1:1'b0;
	assign blez=(IR[`op] == 6'b000110)?1'b1:1'b0;
	assign bgtz=(IR[`op] == 6'b000111)?1'b1:1'b0;
	assign bltz=({IR[`op], IR[`rt]} == 11'b000001_00000)?1'b1:1'b0;
	assign bgez=({IR[`op], IR[`rt]} == 11'b000001_00001)?1'b1:1'b0;

	assign jr=({IR[`op],IR1[`func]} == 12'b000000_001000)?1'b1:1'b0;
	assign jalr=({IR[`op],IR1[`func]} == 12'b000000_001001)?1'b1:1'b0;
	
	assign mfc0=({IR[`op], IR[`rs]} == 11'b010000_00000)?1'b1:1'b0;
endmodule

module HAZ_E_DEC(input [31:21] IR, input [`func] IR1,
					output lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							mfc0,mtc0);

	
	assign lb =(IR[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR[`op] == 6'b100011)?1'b1:1'b0;
	assign sb =(IR[`op] == 6'b101000)?1'b1:1'b0;
	assign sh =(IR[`op] == 6'b101001)?1'b1:1'b0;
	assign sw =(IR[`op] == 6'b101011)?1'b1:1'b0;
	
	assign add =({IR[`op],IR1[`func]} == 12'b000000_100000)?1'b1:1'b0;
	assign addu=({IR[`op],IR1[`func]} == 12'b000000_100001)?1'b1:1'b0;
	assign sub =({IR[`op],IR1[`func]} == 12'b000000_100010)?1'b1:1'b0;
	assign subu=({IR[`op],IR1[`func]} == 12'b000000_100011)?1'b1:1'b0;

	assign sll =({IR[`op],IR1[`func]} == 12'b000000_000000)?1'b1:1'b0;
	assign srl =({IR[`op],IR1[`func]} == 12'b000000_000010)?1'b1:1'b0;
	assign sra =({IR[`op],IR1[`func]} == 12'b000000_000011)?1'b1:1'b0;
	assign sllv=({IR[`op],IR1[`func]} == 12'b000000_000100)?1'b1:1'b0;
	assign srlv=({IR[`op],IR1[`func]} == 12'b000000_000110)?1'b1:1'b0;
	assign srav=({IR[`op],IR1[`func]} == 12'b000000_000111)?1'b1:1'b0;
	
	assign _and=({IR[`op],IR1[`func]} == 12'b000000_100100)?1'b1:1'b0;
	assign _or =({IR[`op],IR1[`func]} == 12'b000000_100101)?1'b1:1'b0;
	assign _xor=({IR[`op],IR1[`func]} == 12'b000000_100110)?1'b1:1'b0;
	assign _nor=({IR[`op],IR1[`func]} == 12'b000000_100111)?1'b1:1'b0;
	
	assign addi =(IR[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR[`op] == 6'b001001)?1'b1:1'b0;
	assign andi =(IR[`op] == 6'b001100)?1'b1:1'b0;
	assign ori  =(IR[`op] == 6'b001101)?1'b1:1'b0;
	assign xori =(IR[`op] == 6'b001110)?1'b1:1'b0;
	assign lui  =(IR[`op] == 6'b001111)?1'b1:1'b0;
	
	assign slt  =({IR[`op],IR1[`func]} == 12'b000000_101010)?1'b1:1'b0;
	assign slti =(IR[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR[`op] == 6'b001011)?1'b1:1'b0;
	assign sltu =({IR[`op],IR1[`func]} == 12'b000000_101011)?1'b1:1'b0;

	assign mfc0=({IR[`op], IR[`rs]} == 11'b010000_00000)?1'b1:1'b0;
	assign mtc0=({IR[`op], IR[`rs]} == 11'b010000_00100)?1'b1:1'b0;
endmodule

module HAZ_M_DEC(input [31:21] IR, input [`func] IR1,
					output lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							_and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							jal,jalr,mfc0,mtc0);

	
	assign lb =(IR[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR[`op] == 6'b100011)?1'b1:1'b0;
	assign sb =(IR[`op] == 6'b101000)?1'b1:1'b0;
	assign sh =(IR[`op] == 6'b101001)?1'b1:1'b0;
	assign sw =(IR[`op] == 6'b101011)?1'b1:1'b0;
	
	assign add =({IR[`op],IR1[`func]} == 12'b000000_100000)?1'b1:1'b0;
	assign addu=({IR[`op],IR1[`func]} == 12'b000000_100001)?1'b1:1'b0;
	assign sub =({IR[`op],IR1[`func]} == 12'b000000_100010)?1'b1:1'b0;
	assign subu=({IR[`op],IR1[`func]} == 12'b000000_100011)?1'b1:1'b0;

	assign sll =({IR[`op],IR1[`func]} == 12'b000000_000000)?1'b1:1'b0;
	assign srl =({IR[`op],IR1[`func]} == 12'b000000_000010)?1'b1:1'b0;
	assign sra =({IR[`op],IR1[`func]} == 12'b000000_000011)?1'b1:1'b0;
	assign sllv=({IR[`op],IR1[`func]} == 12'b000000_000100)?1'b1:1'b0;
	assign srlv=({IR[`op],IR1[`func]} == 12'b000000_000110)?1'b1:1'b0;
	assign srav=({IR[`op],IR1[`func]} == 12'b000000_000111)?1'b1:1'b0;
	
	assign _and=({IR[`op],IR1[`func]} == 12'b000000_100100)?1'b1:1'b0;
	assign _or =({IR[`op],IR1[`func]} == 12'b000000_100101)?1'b1:1'b0;
	assign _xor=({IR[`op],IR1[`func]} == 12'b000000_100110)?1'b1:1'b0;
	assign _nor=({IR[`op],IR1[`func]} == 12'b000000_100111)?1'b1:1'b0;
	
	assign addi =(IR[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR[`op] == 6'b001001)?1'b1:1'b0;
	assign andi =(IR[`op] == 6'b001100)?1'b1:1'b0;
	assign ori  =(IR[`op] == 6'b001101)?1'b1:1'b0;
	assign xori =(IR[`op] == 6'b001110)?1'b1:1'b0;
	assign lui  =(IR[`op] == 6'b001111)?1'b1:1'b0;
	
	assign slt  =({IR[`op],IR1[`func]} == 12'b000000_101010)?1'b1:1'b0;
	assign slti =(IR[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR[`op] == 6'b001011)?1'b1:1'b0;
	assign sltu =({IR[`op],IR1[`func]} == 12'b000000_101011)?1'b1:1'b0;

	assign jal=(IR[`op] == 6'b000011)?1'b1:1'b0;
	assign jalr=({IR[`op],IR1[`func]} == 12'b000000_001001)?1'b1:1'b0;
	
	assign mfc0=({IR[`op], IR[`rs]} == 11'b010000_00000)?1'b1:1'b0;
	assign mtc0=({IR[`op], IR[`rs]} == 11'b010000_00100)?1'b1:1'b0;
endmodule

module HAZ_W_DEC(input [31:21] IR, input [`func] IR1,
					output lb,lbu,lh,lhu,lw,add,addu,sub,subu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,
							 jal,jalr,mfc0);

	
	assign lb =(IR[`op] == 6'b100000)?1'b1:1'b0;
	assign lbu=(IR[`op] == 6'b100100)?1'b1:1'b0;
	assign lh =(IR[`op] == 6'b100001)?1'b1:1'b0;
	assign lhu=(IR[`op] == 6'b100101)?1'b1:1'b0;
	assign lw =(IR[`op] == 6'b100011)?1'b1:1'b0;
	
	assign add =({IR[`op],IR1[`func]} == 12'b000000_100000)?1'b1:1'b0;
	assign addu=({IR[`op],IR1[`func]} == 12'b000000_100001)?1'b1:1'b0;
	assign sub =({IR[`op],IR1[`func]} == 12'b000000_100010)?1'b1:1'b0;
	assign subu=({IR[`op],IR1[`func]} == 12'b000000_100011)?1'b1:1'b0;

	assign sll =({IR[`op],IR1[`func]} == 12'b000000_000000)?1'b1:1'b0;
	assign srl =({IR[`op],IR1[`func]} == 12'b000000_000010)?1'b1:1'b0;
	assign sra =({IR[`op],IR1[`func]} == 12'b000000_000011)?1'b1:1'b0;
	assign sllv=({IR[`op],IR1[`func]} == 12'b000000_000100)?1'b1:1'b0;
	assign srlv=({IR[`op],IR1[`func]} == 12'b000000_000110)?1'b1:1'b0;
	assign srav=({IR[`op],IR1[`func]} == 12'b000000_000111)?1'b1:1'b0;
	
	assign _and=({IR[`op],IR1[`func]} == 12'b000000_100100)?1'b1:1'b0;
	assign _or =({IR[`op],IR1[`func]} == 12'b000000_100101)?1'b1:1'b0;
	assign _xor=({IR[`op],IR1[`func]} == 12'b000000_100110)?1'b1:1'b0;
	assign _nor=({IR[`op],IR1[`func]} == 12'b000000_100111)?1'b1:1'b0;
	
	assign addi =(IR[`op] == 6'b001000)?1'b1:1'b0;
	assign addiu=(IR[`op] == 6'b001001)?1'b1:1'b0;
	assign andi =(IR[`op] == 6'b001100)?1'b1:1'b0;
	assign ori  =(IR[`op] == 6'b001101)?1'b1:1'b0;
	assign xori =(IR[`op] == 6'b001110)?1'b1:1'b0;
	assign lui  =(IR[`op] == 6'b001111)?1'b1:1'b0;
	
	assign slt  =({IR[`op],IR1[`func]} == 12'b000000_101010)?1'b1:1'b0;
	assign slti =(IR[`op] == 6'b001010)?1'b1:1'b0;
	assign sltiu=(IR[`op] == 6'b001011)?1'b1:1'b0;
	assign sltu =({IR[`op],IR1[`func]} == 12'b000000_101011)?1'b1:1'b0;
	
	assign jal=(IR[`op] == 6'b000011)?1'b1:1'b0;
	assign jalr=({IR[`op],IR1[`func]} == 12'b000000_001001)?1'b1:1'b0;
	
	assign mfc0=({IR[`op], IR[`rs]} == 11'b010000_00000)?1'b1:1'b0;
endmodule
