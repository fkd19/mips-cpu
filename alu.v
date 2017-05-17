`timescale 1ns / 1ps
`define F 31:0

module ALU(input [`F] IR_E,
			  input [`F] A, B,
			  input [3:0] ALU_OP,
			  output[`F] C,
			  output[2:0] A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP);
	 
	 wire addOver;
	 wire subOver;
	 wire[`F] c1, c2, c3, c4, c5;
	 
	 assign {addOver,c1}={A[31],A}+{B[31],B};
	 assign {subOver,c2}={A[31],A}-{B[31],B};
	 assign c3=A&B;
	 assign c4=A|B;
	 assign c5=B << 16;
CMP _AB(A, B, A_B_SIGN_CMP);
CMP _A0(A, 0, A_0_SIGN_CMP);
	 assign A_B_UNSIGN_CMP[2]=(A > B)?1:0;
	 assign A_B_UNSIGN_CMP[1]=(A == B)?1:0;
	 assign A_B_UNSIGN_CMP[0]=(A < B)?1:0;
	 
	 assign C=(ALU_OP == 0)?c1:
				 (ALU_OP == 1)?c2:
				 (ALU_OP == 2)?c3:
				 (ALU_OP == 3)?c4:
				 (ALU_OP == 4)?c5:
				 (ALU_OP == 5)?1:
				 (ALU_OP == 6)?0:0;
endmodule
