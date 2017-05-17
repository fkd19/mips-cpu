`timescale 1ns / 1ps
`define F 31:0

module NPC(input [`F] PC4_D,
			  input [25:0] imm26,
			  input [`F] jr_tgt,
			  input[1:0] b_j_jr_sel,
			  output [`F] npc);

	wire[`F] b_tgt;
	wire[`F] j_tgt;
	wire[`F] offset;
	
	assign offset[31:18]={14{imm26[15]}};
	assign offset[17:2]=imm26[15:0];
	assign offset[1:0]=0;
	assign b_tgt=offset+PC4_D;
	assign j_tgt[31:28]=PC4_D[31:28];
	assign j_tgt[27:2]=imm26[25:0];
	assign j_tgt[1:0]=0;
	
mux_b_j_jr _mux_b_j_jr(b_tgt, j_tgt, jr_tgt, b_j_jr_sel, npc);
endmodule
