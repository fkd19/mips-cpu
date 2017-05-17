`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module mux_Wreg(input [4:0] rt, rd, 
					 input [1:0] Wreg_sel, 
					 output[4:0] Wreg);
	
	assign Wreg=(Wreg_sel == 1)?rd:
					(Wreg_sel == 2)?31:rt;
endmodule

module mux_ALU_B(input [`F] RT_E, EXT_E, 
					  input ALU_B_sel, 
					  output[`F] AluB);
					  
	assign AluB=(ALU_B_sel == 1)?EXT_E:RT_E;
endmodule

module mux_Wdata(input [`F] ALUOUT, XEXTOUT, PC8,XALUOUT,
					  input [1:0] Wdata_sel,
					  output[`F] Wdata);
					  
	assign Wdata=(Wdata_sel == 1)?XEXTOUT:
					 (Wdata_sel == 2)?PC8:
					 (Wdata_sel == 3)?XALUOUT:ALUOUT;
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

module muxEXC_op(input[`ExcCode]EXC_pre, 
				  input EXC_sel, 
				  output[`ExcCode] EXC_res);
				  
	assign EXC_res=(EXC_sel)?5'd10:EXC_pre;
endmodule

module muxEXC_ovfl(input[`ExcCode]EXC_pre, 
				  input EXC_sel, 
				  output[`ExcCode] EXC_res);
				  
	assign EXC_res=(EXC_sel)?5'd12:EXC_pre;
endmodule

module mux_DMOUT(input[`F] CP0_data_out, DMOUT, bridge_Rdata, ALUOUT_M,  
					  input CP0_sel,
					  output DMOUT_W);
	assign DMOUT_W=CP0_sel?CP0_data_out:
						(ALUOUT_M < 32'h0000_3000)?DMOUT:bridge_Rdata;
endmodule 

