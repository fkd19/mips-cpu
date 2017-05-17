`timescale 1ns / 1ps
`define F 31:0

module MEM(input clk, reset,
			  input [`F] IR_M, PC8_M, ALUOUT_M, RT_M,
           output[`F] IR_W, PC8_W, ALUOUT_W, DMOUT_W,
			  input [1:0] Forward_RT_M,
			  input [`F] mux_Wdata_out, PC8_W_out);
	
	wire DM_WE;
	wire[`F] MF_RT_M_out;
	
MUX_FORWARD_M MF_RT_M(RT_M, mux_Wdata_out, PC8_W_out, Forward_RT_M, MF_RT_M_out);
DM _DM(clk, reset, ALUOUT_M, MF_RT_M_out, DMOUT_W, DM_WE);
CTRL_M _CTRL_M(IR_M, DM_WE);

	assign ALUOUT_W=ALUOUT_M;
	assign IR_W=IR_M;
	assign PC8_W=PC8_M;
endmodule
