`timescale 1ns / 1ps

module controller(
    input [31:26] opcode,
    input [5:0] func,
	 input[8:0] zero,
    output[1:0] RegDst,
	 output AluSrc,
    output[1:0] PCsrc,
    output[1:0] MemToReg,
    output ExtOp,
	 output we,
	 output[2:0] AluOp,
	 output memread,
	 output memwrite,
	 input[4:0] rt,
	 output slts_real
    );

	wire addu,subu,ori,lui,lw,sw,beq,jr,jal,bgez,bgtz,blez,bltz,bne,slt,slti,sltiu,sltu;
	
	assign addu=({opcode,func} == 12'b000000_100001)?1:0;
	assign subu=({opcode,func} == 12'b000000_100011)?1:0;
	assign ori=(opcode == 6'b001101)?1:0;
	assign lui=(opcode == 6'b001111)?1:0;
	assign lw=(opcode == 6'b100011)?1:0;
	assign sw=(opcode == 6'b101011)?1:0;
	assign beq=(opcode == 6'b000100)?1:0;
	assign jr=({opcode,func} == 12'b000000_001000)?1:0;
	assign jal=(opcode == 6'b000011)?1:0;
	assign bgez=({opcode, rt} == 11'b000001_00001)?1:0;
	assign bgtz=(opcode == 6'b000111)?1:0;
	assign blez=(opcode == 6'b000110)?1:0;
	assign bltz=({opcode, rt} == 11'b000001_00000)?1:0;
	assign bne=(opcode == 6'b000101)?1:0;
	assign slt=({opcode,func} == 12'b000000_101010)?1:0;
	assign slti=(opcode == 6'b001010)?1:0;
	assign sltiu=(opcode == 6'b001011)?1:0;
	assign sltu=({opcode,func} == 12'b000000_101011)?1:0;
	
	
	assign PCsrc[1]=jal|jr;
	assign PCsrc[0]=(beq&zero[4])|jr|(bgez&(zero[2]|zero[1]))
			 |(bgtz&zero[2])|(blez&(zero[1]|zero[0]))|(bltz&zero[0])|(bne&~zero[4]);
	assign RegDst[1]=jal;
	assign RegDst[0]=addu|subu|slt|sltu;
	assign MemToReg[1]=jal|slt|slti|sltiu|sltu;
	assign MemToReg[0]=lw|slt|slti|sltiu|sltu;
	assign AluSrc=ori|lui|lw|sw|slti|sltiu;
	assign ExtOp=lw|sw|beq|bgez|bgtz|blez|bltz|bne|slti|sltiu;
	assign we=addu|subu|ori|lui|lw|jal|slt|slti|sltiu|sltu;
	assign memread=lw;
	assign memwrite=sw;
	assign AluOp[2]=lui;
	assign AluOp[1]=ori;
	assign AluOp[0]=subu|ori;
	assign slts_real=(slt&zero[3])|(slti&zero[3])|(sltiu&zero[6])|(sltu&zero[6]);
endmodule
