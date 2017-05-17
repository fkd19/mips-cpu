`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

 module Hazard_unit(
    input [`F] IR_D, IR_E, IR_M, IR_W,
	 input BUSY,
	 output[2:0] Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E,
	 output[1:0] Forward_RT_M,
    output PC_en, IF_ID_en, ID_EX_clr
    );
	 
	 wire stall_b_cal_r, stall_b_cal_i, stall_b_load;
	 wire stall_jr_cal_r, stall_jr_cal_i, stall_jr_load;
	 wire stall_cal_r_load, stall_cal_i_load, stall_load_load, stall_store_load;
	 wire stall_b, stall_load, stall_jr, stall_MDFT;
	 
							  wire B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JAL_D, JR_D, JALR_D, MF_D, MDFT_D;
							  wire B_E, CAL_R_E, CAL_I_E, LOAD_E, STORE_E, JAL_E, JR_E, JALR_E, MF_E, MDFT_E;
							  wire B_M, CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JR_M, JALR_M, MF_M, MDFT_M;
							  wire B_W, CAL_R_W, CAL_I_W, LOAD_W, STORE_W, JAL_W, JR_W, JALR_W, MF_W, MDFT_W;
TRANSLATE D_translate(IR_D, B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JAL_D, JR_D, JALR_D, MF_D, MDFT_D);
TRANSLATE E_translate(IR_E, B_E, CAL_R_E, CAL_I_E, LOAD_E, STORE_E, JAL_E, JR_E, JALR_E, MF_E, MDFT_E);
TRANSLATE M_translate(IR_M, B_M, CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JR_M, JALR_M, MF_M, MDFT_M);
TRANSLATE W_translate(IR_W, B_W, CAL_R_W, CAL_I_W, LOAD_W, STORE_W, JAL_W, JR_W, JALR_W, MF_W, MDFT_W);
//ÔÝÍ£	
assign stall_b=(B_D && (CAL_R_E|MF_E)   && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0)) 
				|| (B_D && (CAL_R_E|MF_E)   && (IR_D[`rt] == IR_E[`rd]) && (IR_D[`rt] != 0))
				|| (B_D && (CAL_I_E|LOAD_E) && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0)) 
				|| (B_D && (CAL_I_E|LOAD_E) && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0))
				|| (B_D &&  LOAD_M  		    && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0))
				|| (B_D &&  LOAD_M  		    && (IR_D[`rt] == IR_M[`rt]) && (IR_D[`rt] != 0));
						
assign stall_load=((CAL_R_D|CAL_I_D|LOAD_D|STORE_D) && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
													 || (CAL_R_D && LOAD_E && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0));

assign stall_jr_jalr=((JR_D|JALR_D) && (CAL_R_E|MF_E)   && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0))
						|| ((JR_D|JALR_D) && (CAL_I_E|LOAD_E) && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
						|| ((JR_D|JALR_D) && LOAD_M           && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0));

assign stall_MDFT=BUSY && MDFT_D;
assign stall=stall_b || stall_load || stall_jr_jalr || stall_MDFT;

assign PC_en=~stall;
assign IF_ID_en=~stall;
assign ID_EX_clr=stall;
	 
//×ª·¢
assign Forward_RS_D=(CAL_R_M && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?1: 
						  (CAL_I_M && (B_D|JR_D|JALR_D) && (IR_M[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?1:
						  (JAL_M   && (B_D|JR_D|JALR_D) && (5'd31 == IR_D[`rs]))?2:
						  (JALR_M  && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?2:
						  (MF_M    && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3:0; 
						  
						  
assign Forward_RT_D=(CAL_R_M && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?1:
						  (CAL_I_M && B_D && (IR_M[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?1:
						  (JAL_M   && B_D && (5'd31 == IR_D[`rt]))?2:
						  (JALR_M  && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?2:
						  (MF_M    && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3:0;
						  
assign Forward_RS_E=(CAL_R_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?1: 
						  (CAL_I_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?1:
						  (JAL_M   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?3:
						  (JALR_M  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?3:
						  (MF_M    && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?5: 
						  (CAL_R_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?2:
						  (CAL_I_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?2:
						  (LOAD_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?2:
						  (JAL_W   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?4:
						  (JALR_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4:
						  (MF_W    && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?6:0;

assign Forward_RT_E=(CAL_R_M &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?1: 
						  (CAL_I_M &&  CAL_R_E && (IR_M[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?1:
						  (JAL_M   &&  CAL_R_E && (5'd31 == IR_E[`rt]))?3:
						  (JALR_M  &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?3:
						  (MF_M    &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?5: 
						  (CAL_R_W && (CAL_R_E|STORE_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?2:
						  (CAL_I_W && (CAL_R_E|STORE_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?2:
						  (LOAD_W  && (CAL_R_E|STORE_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?2:
						  (JAL_W   && (CAL_R_E|STORE_E) && (5'd31 == IR_E[`rt]))?4:
						  (JALR_W  && (CAL_R_E|STORE_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4:
						  (MF_W    && (CAL_R_E|STORE_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?6:0;
						  
assign Forward_RT_M=(CAL_R_W && STORE_M && (IR_W[`rd] == IR_M[`rt]) && (IR_M[`rt] != 0))?1:
						  (CAL_I_W && STORE_M && (IR_W[`rt] == IR_M[`rt]) && (IR_M[`rt] != 0))?1:
						  (LOAD_W  && STORE_M && (IR_W[`rt] == IR_M[`rt]) && (IR_M[`rt] != 0))?1:
						  (JAL_W   && STORE_M && (5'd31 == IR_M[`rt]))?2:
						  (JALR_W  && STORE_M && (IR_W[`rd] == IR_M[`rt]) && (IR_M[`rt] != 0))?2:
						  (MF_W    && STORE_M && (IR_W[`rd] == IR_M[`rt]) && (IR_M[`rt] != 0))?3:0;
endmodule
