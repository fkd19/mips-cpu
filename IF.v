`timescale 1ns / 1ps
`define F 31:0

module IF(input clk,reset,PC_en,PC_sel, input [`F] b_j_jr_tgt, output[`F] IR_D,PC4_D);
	 
	 wire[`F] NPC;
	 wire[`F] pc;
	 mux_PC _mux_PC(PC4_D, b_j_jr_tgt, PC_sel, NPC);
	 PC _PC(clk, reset, PC_en, NPC, pc);
	 ADDER _PCplus4(pc, PC4_D);
	 IM _IM(pc, IR_D);
endmodule
