`timescale 1ns / 1ps
`define F 31:0

module mips(
    input clk,
    input reset
    );
	 wire PC_en, PC_sel, IF_ID_en, ID_EX_clr;
    wire [`F] b_j_jr_tgt;
    wire [`F] IR_D_in, IR_D_out, PC4_D_in, PC4_D_out;
	 wire [`F] IR_E_in, IR_E_out, RS_E_in, RS_E_out, RT_E_in, RT_E_out, EXT_E_in, EXT_E_out, PC8_E_in, PC8_E_out;
	 wire [`F] IR_M_in, IR_M_out, PC8_M_in, PC8_M_out, ALUOUT_M_in, ALUOUT_M_out, RT_M_in, RT_M_out;
	 wire [`F] IR_W_in, IR_W_out, PC8_W_in, PC8_W_out, ALUOUT_W_in, ALUOUT_W_out, DMOUT_W_in, DMOUT_W_out;
	 wire [2:0] Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E;
	 wire [1:0] Forward_RT_M;
	 wire [`F] mux_Wdata_out;
	
IF _IF(clk, reset, PC_en, PC_sel, b_j_jr_tgt, IR_D_in, PC4_D_in);

IF_ID_REGS _IF_ID_REGS(clk, reset, IF_ID_en, IR_D_in, IR_D_out, PC4_D_in, PC4_D_out);

IDandWB _IDandWB(clk, reset, IR_D_out, PC4_D_out, IR_E_in, RS_E_in, RT_E_in, EXT_E_in, PC8_E_in, b_j_jr_tgt, PC_sel, 
					  IR_W_out, PC8_W_out, ALUOUT_W_out, DMOUT_W_out, 
					  mux_Wdata_out, Forward_RS_D, Forward_RT_D, ALUOUT_M_out, PC8_M_out);
					  
ID_EX_REGS _ID_EX_REGS(clk, reset, ID_EX_clr, IR_E_in, IR_E_out, PC8_E_in, PC8_E_out, 
							  RS_E_in, RS_E_out, RT_E_in, RT_E_out, EXT_E_in, EXT_E_out);
					  
EX _EX(IR_E_out, RS_E_out, RT_E_out, EXT_E_out, PC8_E_out, IR_M_in, PC8_M_in, ALUOUT_M_in, RT_M_in, 
		 Forward_RS_E, Forward_RT_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out);

EX_MEM_REGS _EX_MEM_REGS(clk, reset, IR_M_in, IR_M_out, PC8_M_in, PC8_M_out, ALUOUT_M_in, ALUOUT_M_out, RT_M_in, RT_M_out);

MEM _MEM(clk, reset, IR_M_out, PC8_M_out, ALUOUT_M_out, RT_M_out, IR_W_in, PC8_W_in, ALUOUT_W_in, DMOUT_W_in, 
			Forward_RT_M, mux_Wdata_out, PC8_W_out);

MEM_WB_REGS _MEM_WB_REGS(clk, reset, IR_W_in, IR_W_out, PC8_W_in, PC8_W_out, ALUOUT_W_in, ALUOUT_W_out, DMOUT_W_in, DMOUT_W_out);

Hazard_unit _Hazard_unit(IR_D_out, IR_E_out, IR_M_out, IR_W_out, 
								 Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E, Forward_RT_M, PC_en, IF_ID_en, ID_EX_clr);
endmodule
