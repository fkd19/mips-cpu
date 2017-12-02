`timescale 1ns / 1ps
`include <head.h>

module IF_ID_REGS(input clk, reset, IF_ID_en,  IF_ID_clr, int_clr, ERET_PC_sel,
                  input [`EXC] 	Exc_in,
                  output [`EXC] Exc_out,
				  input [`F] 	IR_D_in,
				  output [`F] 	IR_D_out,
				  input [`F] 	PC4_D_in,
				  output [`F] 	PC4_D_out,
				  input JUMP_sel, delay_groove_IF_ID, delay_groove_D_in, 
				  output delay_groove_D_out, 
				  input [`F] b_j_jr_tgt, NPC_D_in, EPC, 
				  output [`F] NPC_D_out
				  );
   
   reg [`F] 					IR_D,PC4_D;
   reg [`EXC] 					EXC_D;
   reg delay_groove_D;
   reg [`F] NPC_D;
   
   always @(posedge clk)begin
	  if (reset | int_clr | IF_ID_clr)begin
		 IR_D <= 0;
		 PC4_D <= 0;
		 EXC_D <= 0;
		 delay_groove_D <= 0;
		 NPC_D <= 0;
		 
	  end
	  else if (IF_ID_en)begin
          IR_D <= IR_D_in;
          PC4_D <= PC4_D_in;
          EXC_D <= Exc_in;
          delay_groove_D <= delay_groove_IF_ID | delay_groove_D_in;
          if (delay_groove_IF_ID)begin
                if (JUMP_sel)   NPC_D <= b_j_jr_tgt;
                else            NPC_D <= NPC_D_in;
          end
          else                  NPC_D <= NPC_D_in;
          
	  end
   end
   
   assign Exc_out = EXC_D; 
   assign IR_D_out=IR_D;
   assign PC4_D_out=PC4_D;
   assign delay_groove_D_out = delay_groove_D;
   assign NPC_D_out=NPC_D;
endmodule

