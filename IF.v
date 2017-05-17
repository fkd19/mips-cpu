`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module IF(input clk,reset,PC_en,PC_sel,int_PC_sel, ERET_PC_sel,
			 input [`F] b_j_jr_tgt, EPC,
			 output[`F] IR_D,PC4_D,
			 output[`ExcCode] EXC_D);
	 
	 wire[`F] NPC, pc;
	 mux_PC _mux_PC(PC4_D, b_j_jr_tgt, EPC, ERET_PC_sel, int_PC_sel, PC_sel, NPC);
	 PC _PC(clk, reset, PC_en, int_PC_sel, ERET_PC_sel, NPC, pc);
	 ADDER _PCplus4(pc, PC4_D);
	 IM _IM(pc, IR_D);
	 PC_EXC_check _PC_EXC_check(pc, EXC_D);
endmodule
