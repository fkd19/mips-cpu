`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module DECODER(input [31:0] IR,
					output lb,lbu,lh,lhu,lw,sb,sh,sw,
					output add,addu,sub,subu,
					output mult,multu,div,divu,
					output sll,srl,sra,sllv,srlv,srav,
					output _and,_or,_xor,_nor,
					output addi,addiu,andi,ori,xori,lui,
					output slt,slti,sltiu,sltu,
					output beq,bne,blez,bgtz,bltz,bgez,
					output j,jal,jalr,jr,
					output mfhi,mflo,mthi,mtlo,
					output madd,maddu,msub,msubu,
					output swl,swr,movn,movz);

	
	assign lb =(IR[`op] == 6'b100000)?1:0;
	assign lbu=(IR[`op] == 6'b100100)?1:0;
	assign lh =(IR[`op] == 6'b100001)?1:0;
	assign lhu=(IR[`op] == 6'b100101)?1:0;
	assign lw =(IR[`op] == 6'b100011)?1:0;
	assign sb =(IR[`op] == 6'b101000)?1:0;
	assign sh =(IR[`op] == 6'b101001)?1:0;
	assign sw =(IR[`op] == 6'b101011)?1:0;
	
	assign add =({IR[`op],IR[`func]} == 12'b000000_100000)?1:0;
	assign addu=({IR[`op],IR[`func]} == 12'b000000_100001)?1:0;
	assign sub =({IR[`op],IR[`func]} == 12'b000000_100010)?1:0;
	assign subu=({IR[`op],IR[`func]} == 12'b000000_100011)?1:0;

	assign mult =({IR[`op],IR[`func]} == 12'b000000_011000)?1:0;
	assign multu=({IR[`op],IR[`func]} == 12'b000000_011001)?1:0;
	assign div  =({IR[`op],IR[`func]} == 12'b000000_011010)?1:0;
	assign divu =({IR[`op],IR[`func]} == 12'b000000_011011)?1:0;
	
	assign sll =({IR[`op],IR[`func]} == 12'b000000_000000)?1:0;
	assign srl =({IR[`op],IR[`func]} == 12'b000000_000010)?1:0;
	assign sra =({IR[`op],IR[`func]} == 12'b000000_000011)?1:0;
	assign sllv=({IR[`op],IR[`func]} == 12'b000000_000100)?1:0;
	assign srlv=({IR[`op],IR[`func]} == 12'b000000_000110)?1:0;
	assign srav=({IR[`op],IR[`func]} == 12'b000000_000111)?1:0;
	
	assign _and=({IR[`op],IR[`func]} == 12'b000000_100100)?1:0;
	assign _or =({IR[`op],IR[`func]} == 12'b000000_100101)?1:0;
	assign _xor=({IR[`op],IR[`func]} == 12'b000000_100110)?1:0;
	assign _nor=({IR[`op],IR[`func]} == 12'b000000_100111)?1:0;
	
	assign addi =(IR[`op] == 6'b001000)?1:0;
	assign addiu=(IR[`op] == 6'b001001)?1:0;
	assign andi =(IR[`op] == 6'b001100)?1:0;
	assign ori  =(IR[`op] == 6'b001101)?1:0;
	assign xori =(IR[`op] == 6'b001110)?1:0;
	assign lui  =(IR[`op] == 6'b001111)?1:0;
	
	assign slt  =({IR[`op],IR[`func]} == 12'b000000_101010)?1:0;
	assign slti =(IR[`op] == 6'b001010)?1:0;
	assign sltiu=(IR[`op] == 6'b001011)?1:0;
	assign sltu =({IR[`op],IR[`func]} == 12'b000000_101011)?1:0;
	
	assign beq =(IR[`op] == 6'b000100)?1:0;
	assign bne =(IR[`op] == 6'b000101)?1:0;
	assign blez=(IR[`op] == 6'b000110)?1:0;
	assign bgtz=(IR[`op] == 6'b000111)?1:0;
	assign bltz=({IR[`op], IR[`rt]} == 11'b000001_00000)?1:0;
	assign bgez=({IR[`op], IR[`rt]} == 11'b000001_00001)?1:0;
	
	assign j=(IR[`op] == 6'b000010)?1:0;
	assign jal=(IR[`op] == 6'b000011)?1:0;
	assign jr=({IR[`op],IR[`func]} == 12'b000000_001000)?1:0;
	assign jalr=({IR[`op],IR[`func]} == 12'b000000_001001)?1:0;
	
	assign mfhi=({IR[`op],IR[`func]} == 12'b000000_010000)?1:0;
	assign mflo=({IR[`op],IR[`func]} == 12'b000000_010010)?1:0;
	assign mthi=({IR[`op],IR[`func]} == 12'b000000_010001)?1:0;
	assign mtlo=({IR[`op],IR[`func]} == 12'b000000_010011)?1:0;
	
	assign madd =({IR[`op],IR[`func]} == 12'b011100_000000)?1:0;
	assign maddu=({IR[`op],IR[`func]} == 12'b011100_000001)?1:0;
	assign msub =({IR[`op],IR[`func]} == 12'b011100_000100)?1:0;
	assign msubu=({IR[`op],IR[`func]} == 12'b011100_000101)?1:0;
	
	assign swl=(IR[`op] == 6'b101010)?1:0;
	assign swr=(IR[`op] == 6'b101110)?1:0;
	assign movn=({IR[`op],IR[`func]} == 12'b000000_001011)?1:0;
	assign movz=({IR[`op],IR[`func]} == 12'b000000_001010)?1:0;
endmodule
