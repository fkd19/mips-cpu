`timescale 1ns / 1ps
`define F 31:0

module mux_Wreg(input [4:0] rt, rd, 
					 input [1:0] Wreg_sel, 
					 output[4:0] Wreg);
	
	assign Wreg=(Wreg_sel == 0)?rt:
					(Wreg_sel == 1)?rd:
					(Wreg_sel == 2)?31:0;
endmodule

module mux_ALU_B(input [`F] RT_E, EXT_E, 
					  input ALU_B_sel, 
					  output[`F] AluB);
					  
	assign AluB=(ALU_B_sel == 0)?RT_E:
					(ALU_B_sel == 1)?EXT_E:0;
endmodule

module mux_Wdata(input [`F] ALUOUT, XEXTOUT, PC8,XALUOUT,
					  input [1:0] Wdata_sel,//´ýÔö¼Ó
					  output[`F] Wdata);
					  
	assign Wdata=(Wdata_sel == 0)?ALUOUT:
					 (Wdata_sel == 1)?XEXTOUT:
					 (Wdata_sel == 2)?PC8:
					 (Wdata_sel == 3)?XALUOUT:0;
endmodule

module mux_PC(input [`F] PC4, b_j_jr_tgt,
				  input PC_sel,
				  output[`F] npc);
				  
	 assign npc=(PC_sel == 0)?PC4:
					(PC_sel == 1)?b_j_jr_tgt:0;
endmodule

module mux_b_j_jr(input [`F] b_tgt, j_tgt, jr_tgt,
						input [1:0] b_j_jr_sel,
						output[`F] NPC);
						
	assign NPC=(b_j_jr_sel == 2)?jr_tgt:
				  (b_j_jr_sel == 1)?j_tgt:b_tgt;
endmodule

