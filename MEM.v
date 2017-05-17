`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
`define rt 20:16
`define rd 15:11

module MEM(input clk, reset,
			  input [`F] IR_M, PC8_M, ALUOUT_M, RT_M, XALUOUT_M, 
			  input[`ExcCode] EXC_M,
           output[`F] IR_W, PC8_W, ALUOUT_W, DMOUT_W, XALUOUT_W,
			  input [1:0] Forward_RT_M,
			  input [`F] mux_Wdata_out, PC8_W_out, XALUOUT_W_out,
			  input [7:2] HWint,
			  output int_clr,
			  output[`F] EPC, cpu_Wdata,
			  input [`F] bridge_Rdata,
			  output cpu_WE);
	
	wire DM_WE,LR,data_addr_exc,CP0_WE,EXL_clr;
	wire[2:0] BE_CTRL;
	wire[3:0] BYTE_WE;
	wire[`F] MF_RT_M_out,PC,CP0_data_out,DMOUT,PC_save;
	wire[`ExcCode] EXC_CP0;
	
MUX_FORWARD_M MF_RT_M(RT_M, mux_Wdata_out, PC8_W_out, XALUOUT_W_out, Forward_RT_M, MF_RT_M_out);
BE_EXT _BE_EXT(ALUOUT_M[1:0], BE_CTRL, BYTE_WE);
DM _DM(clk, reset, ALUOUT_M, MF_RT_M_out, DMOUT, DM_WE, LR, BYTE_WE);
CTRL_M _CTRL_M(clk, IR_M, ALUOUT_M, PC8_M, DM_WE, cpu_WE, BE_CTRL, LR, data_addr_exc, CP0_WE, EXL_clr, CP0_sel, PC_save);
muxEXC_ovfl _EXC_M(EXC_M, data_addr_exc, EXC_CP0);
CP0 _CP0(clk, reset, IR_M[`rd], MF_RT_M_out, PC_save, EXC_CP0, HWint, CP0_WE, EXL_clr, //将EXC_CP0替换成0，就不支持异常
			int_clr, EPC, CP0_data_out);
mux_DMOUT _muxDMOUT(CP0_data_out, DMOUT, bridge_Rdata, ALUOUT_M, CP0_sel, DMOUT_W);
	assign ALUOUT_W=ALUOUT_M;
	assign IR_W=IR_M;
	assign PC8_W=PC8_M;
	assign XALUOUT_W=XALUOUT_M;
	assign cpu_Wdata=MF_RT_M_out;
	
endmodule
