`timescale 1ns / 1ps
`define F 31:0
`define shamt 10:6

module ALU(input [`shamt] IR_E,
			  input [`F] A, B,
			  input [3:0] ALU_OP,
			  output[`F] C);
	 
	 wire[31:0] c0, c1;
	 
	 assign c0=A+B;	
	 assign c1=A-B;
	 assign C=(ALU_OP == 1)?c1:			//减
				 (ALU_OP == 2)?(A&B):		//与
				 (ALU_OP == 3)?(A|B):		//或
				 (ALU_OP == 4)?(A^B):		//异或
				 (ALU_OP == 5)?~(A|B):		//或非
				 (ALU_OP == 6)?32'b1:				//置1
				 (ALU_OP == 7)?32'b0:				//置0
				 (ALU_OP == 8)?(B << 16):	//加载高位
				 (ALU_OP == 9)?(B << IR_E[`shamt]):			//sll
				 (ALU_OP == 10)?(B >> IR_E[`shamt]):		//srl
				 (ALU_OP == 11)?(B << A[4:0]):				//sllv
				 (ALU_OP == 12)?(B >> A[4:0]):				//srlv
				 (ALU_OP == 13)?($unsigned($signed(B) >>> IR_E[`shamt])):	//sra
				 (ALU_OP == 14)?($unsigned($signed(B) >>> A[4:0])):c0;		//加
				 
endmodule
