`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module DECODER(input [31:0] IR,
	 output addu,subu,ori,lui,lw,sw,j,jr,jal,jalr,beq,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu,sll,sllv,sra,srav,srl,srlv);

	assign addu=({IR[`op],IR[`func]} == 12'b000000_100001)?1:0;
	assign subu=({IR[`op],IR[`func]} == 12'b000000_100011)?1:0;
	assign ori=(IR[`op] == 6'b001101)?1:0;
	assign lui=(IR[`op] == 6'b001111)?1:0;
	assign lw=(IR[`op] == 6'b100011)?1:0;
	assign sw=(IR[`op] == 6'b101011)?1:0;
	assign beq=(IR[`op] == 6'b000100)?1:0;
	assign jr=({IR[`op],IR[`func]} == 12'b000000_001000)?1:0;
	assign jal=(IR[`op] == 6'b000011)?1:0;
	assign bgez=({IR[`op], IR[`rt]} == 11'b000001_00001)?1:0;
	assign bgtz=(IR[`op] == 6'b000111)?1:0;
	assign blez=(IR[`op] == 6'b000110)?1:0;
	assign bltz=({IR[`op], IR[`rt]} == 11'b000001_00000)?1:0;
	assign bne=(IR[`op] == 6'b000101)?1:0;
	assign slt=({IR[`op],IR[`func]} == 12'b000000_101010)?1:0;
	assign slti=(IR[`op] == 6'b001010)?1:0;
	assign sltiu=(IR[`op] == 6'b001011)?1:0;
	assign sltu=({IR[`op],IR[`func]} == 12'b000000_101011)?1:0;
	assign j=(IR[`op] == 6'b000010)?1:0;
	assign jalr=({IR[`op],IR[`func]} == 12'b000000_001001)?1:0;
	assign sll=({IR[`op],IR[`func]} == 12'b000000_000000)?1:0;
	assign sllv=({IR[`op],IR[`func]} == 12'b000000_000100)?1:0;
	assign sra=({IR[`op],IR[`func]} == 12'b000000_000011)?1:0;
	assign srav=({IR[`op],IR[`func]} == 12'b000000_000111)?1:0;
	assign srl=({IR[`op],IR[`func]} == 12'b000000_000010)?1:0;
	assign srlv=({IR[`op],IR[`func]} == 12'b000000_000110)?1:0;
endmodule
