`timescale 1ns / 1ps
`define F 31:0

module EX(input clk, reset,
			 input [`F] IR_E, RS_E, RT_E, EXT_E, PC8_E,
			 output[`F] IR_M, PC8_M, ALUOUT_M, RT_M,XALUOUT_M,
			 input[2:0] Forward_RS_E, Forward_RT_E,
			 input [`F] ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, XALUOUT_W_out,
			 output BUSY, EX_MEM_clr);

	 wire[4:0] ALU_OP;
	 wire[3:0] XALU_OP;
	 wire ALU_B_sel,HI_WE,LO_WE,XALUOUT_sel;
	 wire[`F] ALU_B,MF_RS_E_out, MF_RT_E_out;
	 wire[2:0] A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP;	 
	 
MUX_FORWARD_E MF_RS_E(RS_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, XALUOUT_W_out, Forward_RS_E, MF_RS_E_out);
MUX_FORWARD_E MF_RT_E(RT_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, XALUOUT_W_out, Forward_RT_E, MF_RT_E_out);
mux_ALU_B _mux_ALU_B(MF_RT_E_out, EXT_E, ALU_B_sel, ALU_B);
ALU _ALU(IR_E, MF_RS_E_out, ALU_B, ALU_OP, ALUOUT_M, A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP);
XALU _XALU(clk, reset, HI_WE, LO_WE, XALUOUT_sel, XALU_OP, MF_RS_E_out, ALU_B, MF_RS_E_out, XALUOUT_M, BUSY);
CTRL_E _CTRL_E(IR_E, MF_RT_E_out, A_B_SIGN_CMP, A_0_SIGN_CMP, A_B_UNSIGN_CMP,
						ALU_B_sel, HI_WE, LO_WE, XALUOUT_sel, ALU_OP, XALU_OP, EX_MEM_clr);

	 assign PC8_M=PC8_E;
	 assign RT_M=MF_RT_E_out;
	 assign IR_M=IR_E;
endmodule
