`timescale 1ns / 1ps
`include <head.h>

module mux_Wreg(input [4:0] rt, rd, 
				input [1:0]  Wreg_sel, 
				output [4:0] Wreg);
   
   assign Wreg=(Wreg_sel == 1)?rd:
			   (Wreg_sel == 2)?5'd31:rt;
endmodule

module mux_ALU_B(input [`F] RT_E, EXT_E, 
				 input 		 ALU_B_sel, 
				 output [`F] AluB);
   
   assign AluB=(ALU_B_sel == 1)?EXT_E:RT_E;
endmodule

module mux_Wdata(input [`F] ALUOUT, XEXTOUT, PC8, XALUOUT,
				 input [1:0] Wdata_sel,
				 output [`F] Wdata);
   
   assign Wdata=(Wdata_sel == 1)?XEXTOUT:
				(Wdata_sel == 2)?PC8:
			    (Wdata_sel == 3)? XALUOUT:ALUOUT;
endmodule

module mux_b_j_jr(input [`F] b_tgt, j_tgt, jr_tgt,
				  input [1:0] b_j_jr_sel,
				  output [`F] NPC);
   
   assign NPC=(b_j_jr_sel == 2)?jr_tgt:
			  (b_j_jr_sel == 1)?j_tgt:b_tgt;
endmodule

module mux_DMOUT(input[`F] CP0_data_out, DMOUT, 
				 input 		 CP0_sel,
				 output [`F] DMOUT_W);
   assign DMOUT_W=CP0_sel?CP0_data_out:DMOUT;
endmodule 

