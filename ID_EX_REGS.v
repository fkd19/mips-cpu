`timescale 1ns / 1ps
`include <head.h>

module ID_EX_REGS(input clk, reset, ID_EX_en, ID_EX_clr, int_clr,
                  input [`EXC]  Exc_in,
                  output [`EXC] Exc_out,
                  input [`F]  IR_E_in,
                  output [`F] IR_E_out,
                  input [`F]  PC8_E_in,
                  output [`F] PC8_E_out,
                  input [`F]  RS_E_in,
                  output [`F] RS_E_out,
                  input [`F]  RT_E_in,
                  output [`F] RT_E_out,
                  input [`F]  EXT_E_in,
                  output [`F] EXT_E_out,
                  input PRE_INST_STALL_AND_JUMP_E_in,
                  output PRE_INST_STALL_AND_JUMP_E_out
                  );
   
   reg [`F] 				  IR_E, PC8_E, RS_E, RT_E, EXT_E;
   reg [`EXC] 				  EXC_E;
   reg PRE_INST_STALL_AND_JUMP_E;
   
   always @(posedge clk)begin
	  if (reset | int_clr | ID_EX_clr)begin
		 IR_E <= 0;
		 PC8_E <= 0;
		 RS_E <= 0;
		 RT_E <= 0;
		 EXT_E <= 0;
		 EXC_E <= 0;  
		 PRE_INST_STALL_AND_JUMP_E <= 0;
	  end
	  else if (ID_EX_en) begin
		 IR_E <= IR_E_in;
		 PC8_E <= PC8_E_in;
		 RS_E <= RS_E_in;
		 RT_E <= RT_E_in;
		 EXT_E <= EXT_E_in;
		 EXC_E <= Exc_in;  
		 PRE_INST_STALL_AND_JUMP_E <= PRE_INST_STALL_AND_JUMP_E_in;
	  end
   end
   
   assign IR_E_out=IR_E;
   assign PC8_E_out=PC8_E;
   assign RS_E_out=RS_E;
   assign RT_E_out=RT_E;
   assign EXT_E_out=EXT_E;
   assign Exc_out=EXC_E;
   assign PRE_INST_STALL_AND_JUMP_E_out=PRE_INST_STALL_AND_JUMP_E;
endmodule
