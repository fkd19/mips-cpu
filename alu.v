`timescale 1ns / 1ps
`include <head.h>

module ALU(input [`shamt] IR_E,
			  input [`F] A, B,
			  input [3:0] ALU_OP,
			  output[`F] C);
	 
	 wire[31:0] c0, c1;
	 wire[63:0] sra_srav_temp, sra_ans, srav_ans;  //sra_srav_temp:临时存储B的值，高32位为符号扩展, 后两个为sra，srav的移位结果。
	 
	 assign c0=A+B;	
	 assign c1=A-B; 
	 assign sra_srav_temp[63:32]={32{B[31]}};
	 assign sra_srav_temp[31:0]=B;
	 assign sra_ans=sra_srav_temp >> IR_E[`shamt];
	 assign srav_ans=sra_srav_temp >> A[4:0];
	 
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
                 (ALU_OP == 13)?(sra_ans[`F]):	//sra
                 (ALU_OP == 14)?(srav_ans[`F]):c0;		//加
				 
endmodule
