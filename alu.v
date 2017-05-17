`timescale 1ns / 1ps
`define F 31:0
`define shamt 10:6

module ALU(input [`F] IR_E,
			  input [`F] A, B,
			  input [4:0] ALU_OP,
			  output[`F] C,
			  output[2:0] A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP,
			  output[32:31] add_ovfl_sign,sub_ovfl_sign);
	 
	 wire[32:0] c0, c1;
	 
	 assign c0={A[31],A}+{B[31],B};	
	 assign c1={A[31],A}-{B[31],B};	
	 assign add_ovfl_sign=c0[32:31];
	 assign sub_ovfl_sign=c1[32:31];
CMP _AB(A, B, A_B_SIGN_CMP);
CMP _A0(A, 0, A_0_SIGN_CMP);
	 assign A_B_UNSIGN_CMP[2]=(A > B)?1:0;
	 assign A_B_UNSIGN_CMP[1]=(A == B)?1:0;
	 assign A_B_UNSIGN_CMP[0]=(A < B)?1:0;
	 
	 assign C=(ALU_OP == 1)?c1[`F]:			//减
				 (ALU_OP == 2)?(A&B):		//与
				 (ALU_OP == 3)?(A|B):		//或
				 (ALU_OP == 4)?(A^B):		//异或
				 (ALU_OP == 5)?~(A|B):		//或非
				 (ALU_OP == 6)?1:				//置1
				 (ALU_OP == 7)?0:				//置0
				 (ALU_OP == 8)?(B << 16):	//加载高位
				 (ALU_OP == 9)?(B << IR_E[`shamt]):			//sll
				 (ALU_OP == 10)?(B >> IR_E[`shamt]):		//srl
				 (ALU_OP == 11)?(B << A[4:0]):				//sllv
				 (ALU_OP == 12)?(B >> A[4:0]):				//srlv
				 (ALU_OP == 13)?($unsigned($signed(B) >>> IR_E[`shamt])):	//sra
				 (ALU_OP == 14)?($unsigned($signed(B) >>> A[4:0])):			//srav
				 (ALU_OP == 15)?A:c0[`F];		//movz&movn				//加
				 
endmodule
