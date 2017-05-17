`timescale 1ns / 1ps
`define F 31:0
`define rt 20:16
`define rd 15:11
`define WORD_ADDR 12:2
`define func 5:0

module MEM(input clk1, clk2, reset,
			  input [`F] IR_M, PC8_M, ALUOUT_M, RT_M,
           output[`F] IR_W, PC8_W, ALUOUT_W, DMOUT_W,
			  input [1:0] Forward_RT_M,
			  input [`F] mux_Wdata_out, PC8_W_out,
			  input [7:2] HWint,
			  output int_clr,
			  output[`F] EPC, cpu_Wdata,
			  input [`F] bridge_Rdata,
			  output cpu_WE);
	
	wire DM_WE,CP0_WE,EXL_clr;
	wire[2:0] BE_CTRL;
	wire[3:0] BYTE_WE;
	wire[`F] MF_RT_M_out,PC,CP0_data_out,DMOUT,PC_save;
	
MUX_FORWARD_M MF_RT_M(RT_M, mux_Wdata_out, PC8_W_out, Forward_RT_M, MF_RT_M_out);
BE_EXT _BE_EXT(ALUOUT_M[1:0], BE_CTRL, BYTE_WE);
BRAM_2K_4B DM(clk2, reset, BYTE_WE, ALUOUT_M[`WORD_ADDR], MF_RT_M_out, DMOUT);
CTRL_M _CTRL_M(clk1, reset, IR_M[31:16], IR_M[`func], ALUOUT_M, PC8_M, 
					cpu_WE, BE_CTRL, CP0_WE, EXL_clr, CP0_sel, PC_save);
CP0 _CP0(clk1, reset, IR_M[`rd], MF_RT_M_out, PC_save, HWint, CP0_WE, EXL_clr, int_clr, EPC, CP0_data_out);
mux_DMOUT _muxDMOUT(CP0_data_out, DMOUT, bridge_Rdata, ALUOUT_M, CP0_sel, DMOUT_W);
	assign ALUOUT_W=ALUOUT_M;
	assign IR_W=IR_M;
	assign PC8_W=PC8_M;
	assign cpu_Wdata=MF_RT_M_out;
endmodule
