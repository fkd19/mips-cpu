`timescale 1ns / 1ps
`include <head.h>

module MMID_WB_REGS(input clk, reset, int_clr, MMID_WB_en, MMID_WB_clr,
				   input [`F]  IR_W_in,
				   output [`F] IR_W_out,
				   input [`F]  PC8_W_in,
				   output [`F] PC8_W_out,
				   input [`F]  ALUOUT_W_in,
				   output [`F] ALUOUT_W_out,
				   input [`F]  DMOUT_W_in,
				   output [`F] DMOUT_W_out,
                   input [`F]  XALUOUT_W_in,
                   output [`F] XALUOUT_W_out,
                   input  CAL_R_W_in, CAL_I_W_in, LOAD_W_in, STORE_W_in, JAL_W_in, JALR_W_in, MF_W_in, MFC0_W_in,
                   output CAL_R_W_out, CAL_I_W_out, LOAD_W_out, STORE_W_out, JAL_W_out, JALR_W_out, MF_W_out, MFC0_W_out);

   reg [`F] 	IR_W, PC8_W, ALUOUT_W, DMOUT_W, XALUOUT_W;
   reg          CAL_R_W, CAL_I_W, LOAD_W, STORE_W, JAL_W, JALR_W, MF_W, MFC0_W;

   always @(posedge clk)begin
	  if (reset | int_clr | MMID_WB_clr)begin
		 IR_W <= 0;
		 PC8_W <= 0;
		 ALUOUT_W <= 0;
		 DMOUT_W <= 0;
		 XALUOUT_W <= 0;
		 
		 CAL_R_W <= 0;
		 CAL_I_W <= 0; 
		 LOAD_W <= 0; 
		 STORE_W <= 0; 
		 JAL_W <= 0; 
		 JALR_W <= 0; 
		 MF_W <= 0; 
		 MFC0_W <= 0;
	  end
	  else if (MMID_WB_en) begin
		 IR_W <= IR_W_in;
		 PC8_W <= PC8_W_in;
		 ALUOUT_W <= ALUOUT_W_in;
		 DMOUT_W <= DMOUT_W_in;
		 XALUOUT_W <= XALUOUT_W_in;
		 
		 CAL_R_W <= CAL_R_W_in;
         CAL_I_W <= CAL_I_W_in; 
         LOAD_W <= LOAD_W_in; 
         STORE_W <= STORE_W_in; 
         JAL_W <= JAL_W_in; 
         JALR_W <= JALR_W_in; 
         MF_W <= MF_W_in; 
         MFC0_W <= MFC0_W_in;
	  end
   end
   
   assign IR_W_out=IR_W;
   assign PC8_W_out=PC8_W;
   assign ALUOUT_W_out=ALUOUT_W;
   assign DMOUT_W_out=DMOUT_W;
   assign XALUOUT_W_out=XALUOUT_W;
   
   assign CAL_R_W_out = CAL_R_W;
   assign CAL_I_W_out = CAL_I_W; 
   assign LOAD_W_out = LOAD_W; 
   assign STORE_W_out = STORE_W; 
   assign JAL_W_out = JAL_W; 
   assign JALR_W_out = JALR_W; 
   assign MF_W_out = MF_W; 
   assign MFC0_W_out = MFC0_W;
endmodule
