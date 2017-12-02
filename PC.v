`timescale 1ns / 1ps
`include <head.h>

module PC(input clk, reset,back_pc, PC_en, int_PC_sel, ERET_PC_sel,JUMP_sel, 
          input [`F]  PC4, b_j_jr_tgt, EPC ,PC_IFMID_out,
		  output [`F] PC);
   
   reg [`F] 		  pc;
   
   always @(posedge clk)begin
	  if (reset)	pc <= 32'hbfc0_0000;
	  else if (int_PC_sel)     pc <= 32'hbfc00380;
	  else if (ERET_PC_sel)    pc <= EPC;
	  else if (back_pc)    pc <=(PC_IFMID_out >= 32'h8000_0000)?PC_IFMID_out:pc;
	  else if (JUMP_sel)         pc <= b_j_jr_tgt;
	  else if(PC_en)   pc <= PC4;  
	 
   end
   
   assign PC=pc;
endmodule

module ADDER(input [`F] a,
			 output [`F] b);
   
   assign b=a+4;
endmodule

