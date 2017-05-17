`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module CPU(input clk,
				input reset,
				input[`F] bridge_Rdata,
				input[7:2] HWint,
				output[`F] ALUOUT_M_out, cpu_Wdata,
				output cpu_WE);

wire PC_en, PC_sel, IF_ID_en, IF_ID_clr, ID_EX_clr, BUSY, EX_MEM_clr,int_clr,int_PC_sel,ERET_PC_sel;
wire [`F] b_j_jr_tgt,EPC;
wire [`F] IR_D_in, IR_D_out, PC4_D_in, PC4_D_out;
wire [`F] IR_E_in, IR_E_out, RS_E_in, RS_E_out, RT_E_in, RT_E_out, EXT_E_in, EXT_E_out, PC8_E_in, PC8_E_out;
wire [`F] IR_M_in, IR_M_out, PC8_M_in, PC8_M_out, ALUOUT_M_in, ALUOUT_M_out, RT_M_in, RT_M_out, XALUOUT_M_in, XALUOUT_M_out;
wire [`F] IR_W_in, IR_W_out, PC8_W_in, PC8_W_out, ALUOUT_W_in, ALUOUT_W_out, DMOUT_W_in, DMOUT_W_out, XALUOUT_W_in, XALUOUT_W_out;
wire [2:0] Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E;
wire [1:0] Forward_RT_M;
wire [`F] mux_Wdata_out;
wire [`ExcCode] EXC_D_in, EXC_D_out, EXC_E_in, EXC_E_out, EXC_M_in, EXC_M_out;
	
IF _IF(clk, reset, PC_en, PC_sel, int_clr, ERET_PC_sel, b_j_jr_tgt, EPC, IR_D_in, PC4_D_in, EXC_D_in);//int_clr控制PC跳转到中断程序入口

IF_ID_REGS _IF_ID_REGS(clk, reset, IF_ID_en, IF_ID_clr, int_clr, IR_D_in, IR_D_out, PC4_D_in, PC4_D_out, EXC_D_in, EXC_D_out);

IDandWB _IDandWB(clk, reset, IR_D_out, PC4_D_out, EXC_D_out, 
					  IR_E_in, RS_E_in, RT_E_in, EXT_E_in, PC8_E_in, b_j_jr_tgt, EXC_E_in, PC_sel, ERET_PC_sel,
					  IR_W_out, PC8_W_out, ALUOUT_W_out, DMOUT_W_out, XALUOUT_W_out, 
					  mux_Wdata_out, Forward_RS_D, Forward_RT_D, ALUOUT_M_out, PC8_M_out, XALUOUT_M_out);
					  
ID_EX_REGS _ID_EX_REGS(clk, reset, ID_EX_clr, int_clr, IR_E_in, IR_E_out, PC8_E_in, PC8_E_out, 
							  RS_E_in, RS_E_out, RT_E_in, RT_E_out, EXT_E_in, EXT_E_out, EXC_E_in, EXC_E_out);
					  
EX _EX(clk, reset, IR_E_out, RS_E_out, RT_E_out, EXT_E_out, PC8_E_out, EXC_E_out,
						 IR_M_in, PC8_M_in, ALUOUT_M_in, RT_M_in, XALUOUT_M_in, EXC_M_in, 
			Forward_RS_E, Forward_RT_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, XALUOUT_W_out, 
			BUSY, EX_MEM_clr, int_clr);

EX_MEM_REGS _EX_MEM_REGS(clk, reset, EX_MEM_clr, int_clr, IR_M_in, IR_M_out, PC8_M_in, PC8_M_out, 
								ALUOUT_M_in, ALUOUT_M_out, RT_M_in,RT_M_out, XALUOUT_M_in, XALUOUT_M_out, EXC_M_in, EXC_M_out);

MEM _MEM(clk, reset, IR_M_out, PC8_M_out, ALUOUT_M_out, RT_M_out, XALUOUT_M_out, EXC_M_out,
				IR_W_in, PC8_W_in, ALUOUT_W_in, DMOUT_W_in, XALUOUT_W_in, 
				Forward_RT_M, mux_Wdata_out, PC8_W_out, XALUOUT_W_out,
				HWint, int_clr, int_PC_sel, EPC, cpu_Wdata, bridge_Rdata, cpu_WE);

MEM_WB_REGS _MEM_WB_REGS(clk, reset, int_clr, IR_W_in, IR_W_out, PC8_W_in, PC8_W_out, ALUOUT_W_in, ALUOUT_W_out, 
									DMOUT_W_in, DMOUT_W_out, XALUOUT_W_in, XALUOUT_W_out);

Hazard_unit _Hazard_unit(IR_D_out, IR_E_out, IR_M_out, IR_W_out, BUSY,
								 Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E, Forward_RT_M, 
								 PC_en, IF_ID_en, IF_ID_clr, ID_EX_clr);

endmodule
