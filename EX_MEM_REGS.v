`timescale 1ns / 1ps
`include <head.h>

module EX_MEM_REGS(input clk, reset, int_clr, EX_MEM_en,
                   input [`EXC]  Exc_in,
                   input [`F] 	 IR_M_in,
                   output [`F] 	 IR_M_out,
                   input [`F] 	 PC8_M_in,
                   output [`F] 	 PC8_M_out,
                   input [`F] 	 ALUOUT_M_in,
                   output [`F] 	 ALUOUT_M_out,
                   input [`F] 	 RT_M_in,
                   output [`F] 	 RT_M_out,
                   input [`F] 	 XALUOUT_M_in,
                   output [`F] 	 XALUOUT_M_out,
                   output [`EXC] Exc_out,
                   input PRE_INST_STALL_AND_JUMP_M_in,
                   output PRE_INST_STALL_AND_JUMP_M_out,
                   input  CAL_R_M_in, CAL_I_M_in, LOAD_M_in, STORE_M_in, JAL_M_in, JALR_M_in, MF_M_in, MFC0_M_in, MTC0_M_in,
                   output CAL_R_M_out, CAL_I_M_out, LOAD_M_out, STORE_M_out, JAL_M_out, JALR_M_out, MF_M_out, MFC0_M_out, MTC0_M_out
                   );

   reg [`F] 			 IR_M, PC8_M, ALUOUT_M, RT_M, XALUOUT_M;
   reg [`EXC] 			 EXC_M;
   reg PRE_INST_STALL_AND_JUMP_M;
   reg CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JALR_M, MF_M, MFC0_M, MTC0_M;
   
   always @(posedge clk)begin
      if (reset|int_clr)begin
         IR_M <= 32'h0;
         PC8_M <= 0;
         ALUOUT_M <= 0;
         RT_M <= 0;
         XALUOUT_M <= 0;
         EXC_M <= 0;
         PRE_INST_STALL_AND_JUMP_M <= 0;
         
         CAL_R_M <= 0;
         CAL_I_M  <= 0;
         LOAD_M <= 0;
         STORE_M  <= 0;
         JAL_M <= 0;
         JALR_M <= 0;
         MF_M <= 0;
         MFC0_M <= 0;
         MTC0_M <= 0;
      end 
      else if (EX_MEM_en) begin
         IR_M <= IR_M_in;
         PC8_M <= PC8_M_in;
         ALUOUT_M <= ALUOUT_M_in;
         RT_M <= RT_M_in;
         XALUOUT_M <= XALUOUT_M_in;
         EXC_M <= Exc_in;
         PRE_INST_STALL_AND_JUMP_M <= PRE_INST_STALL_AND_JUMP_M_in;
         
         CAL_R_M <= CAL_R_M_in;
          CAL_I_M  <= CAL_I_M_in;
          LOAD_M <= LOAD_M_in;
          STORE_M  <= STORE_M_in;
          JAL_M <= JAL_M_in;
          JALR_M <= JALR_M_in;
          MF_M <= MF_M_in;
          MFC0_M <= MFC0_M_in;
          MTC0_M <= MTC0_M_in;
     end
   end
   
   assign IR_M_out=IR_M;
   assign PC8_M_out=PC8_M;
   assign ALUOUT_M_out=ALUOUT_M;
   assign RT_M_out=RT_M;
   assign XALUOUT_M_out=XALUOUT_M;
   assign Exc_out = EXC_M;
   assign PRE_INST_STALL_AND_JUMP_M_out=PRE_INST_STALL_AND_JUMP_M;
   assign CAL_R_M_out = CAL_R_M;
   assign CAL_I_M_out = CAL_I_M;
   assign LOAD_M_out  = LOAD_M;
   assign STORE_M_out = STORE_M;
   assign JAL_M_out   = JAL_M;
   assign JALR_M_out  = JALR_M;
   assign MF_M_out    = MF_M;
   assign MFC0_M_out  = MFC0_M;
   assign MTC0_M_out  = MTC0_M;
endmodule
