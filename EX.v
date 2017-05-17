`timescale 1ns / 1ps
`define F 31:0

module EX(input [`F] IR_E, RS_E, RT_E, EXT_E, PC8_E,
			 output[`F] IR_M, PC8_M, ALUOUT_M, RT_M,
			 input[2:0] Forward_RS_E, Forward_RT_E,
			 input [`F] ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out);

	 wire[3:0] ALU_OP;
	 wire ALU_B_sel;
	 wire[`F] ALU_B;
	 wire[2:0] A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP;
	 wire[`F] MF_RS_E_out, MF_RT_E_out;
	 
MUX_FORWARD_E MF_RS_E(RS_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, Forward_RS_E, MF_RS_E_out);
MUX_FORWARD_E MF_RT_E(RT_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, Forward_RT_E, MF_RT_E_out);
mux_ALU_B _mux_ALU_B(MF_RT_E_out, EXT_E, ALU_B_sel, ALU_B);
ALU _ALU(IR_E, MF_RS_E_out, ALU_B, ALU_OP, ALUOUT_M, A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP);
CTRL_E _CTRL_E(IR_E, A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP, ALU_B_sel, ALU_OP);

	 assign PC8_M=PC8_E;
	 assign RT_M=MF_RT_E_out;
	 assign IR_M=IR_E;
endmodule
