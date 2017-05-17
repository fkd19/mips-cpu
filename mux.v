`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module mux_Wreg(input [4:0] rt, rd, 
					 input [1:0] Wreg_sel, 
					 output[4:0] Wreg);
	
	assign Wreg=(Wreg_sel == 1)?rd:
					(Wreg_sel == 2)?5'd31:rt;
endmodule

module mux_ALU_B(input [`F] RT_E, EXT_E, 
					  input ALU_B_sel, 
					  output[`F] AluB);
					  
	assign AluB=(ALU_B_sel == 1)?EXT_E:RT_E;
endmodule

module mux_Wdata(input [`F] ALUOUT, XEXTOUT, PC8,
					  input [1:0] Wdata_sel,
					  output[`F] Wdata);
					  
	assign Wdata=(Wdata_sel == 1)?XEXTOUT:
					 (Wdata_sel == 2)?PC8:ALUOUT;
endmodule

module mux_PC(input [`F] PC4, b_j_jr_tgt, EPC,
				  input ERET_PC_sel, int_PC_sel, PC_sel,
				  output[`F] npc);
				  
	 assign npc=(ERET_PC_sel == 1)?EPC:
					(int_PC_sel == 1)?32'h0000_4180:
					(PC_sel == 1)?b_j_jr_tgt:PC4;
endmodule

module mux_b_j_jr(input [`F] b_tgt, j_tgt, jr_tgt,
						input [1:0] b_j_jr_sel,
						output[`F] NPC);
						
	assign NPC=(b_j_jr_sel == 2)?jr_tgt:
				  (b_j_jr_sel == 1)?j_tgt:b_tgt;
endmodule

module mux_DMOUT(input[`F] CP0_data_out, DMOUT, bridge_Rdata, ALUOUT_M,  
					  input CP0_sel,
					  output[`F] DMOUT_W);
	assign DMOUT_W=CP0_sel?CP0_data_out:
						(ALUOUT_M < 32'h0000_3000)?DMOUT:bridge_Rdata;
endmodule 

