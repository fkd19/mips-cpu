`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

 module Hazard_unit(//jalr暂未做处理
    input [`F] IR_D, IR_E, IR_M, IR_W,
	 output[2:0] Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E,
	 output[1:0] Forward_RT_M,
    output PC_en, IF_ID_en, ID_EX_clr
    );
	 
	 wire stall_b_cal_r, stall_b_cal_i, stall_b_load;
	 wire stall_jr_cal_r, stall_jr_cal_i, stall_jr_load;
	 wire stall_cal_r_load, stall_cal_i_load, stall_load_load, stall_store_load;
	 wire stall_b;
	 wire stall_load;
	 wire stall_jr;
	 
	 wire B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JAL_D, JR_D, JALR_D;
	 wire B_E, CAL_R_E, CAL_I_E, LOAD_E, STORE_E, JAL_E, JR_E, JALR_E;
	 wire B_M, CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JR_M, JALR_M;
	 wire B_W, CAL_R_W, CAL_I_W, LOAD_W, STORE_W, JAL_W, JR_W, JALR_W;
TRANSLATE D_translate(IR_D, B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JAL_D, JR_D, JALR_D);
TRANSLATE E_translate(IR_E, B_E, CAL_R_E, CAL_I_E, LOAD_E, STORE_E, JAL_E, JR_E, JALR_E);
TRANSLATE M_translate(IR_M, B_M, CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JR_M, JALR_M);
TRANSLATE W_translate(IR_W, B_W, CAL_R_W, CAL_I_W, LOAD_W, STORE_W, JAL_W, JR_W, JALR_W);
//暂停	
assign stall_b_cal_r=(B_D && CAL_R_E && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0)) 
						|| (B_D && CAL_R_E && (IR_D[`rt] == IR_E[`rd]) && (IR_D[`rt] != 0));
assign stall_b_cal_i=(B_D && CAL_I_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0)) 
						|| (B_D && CAL_I_E && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0));
assign stall_b_load =(B_D && LOAD_E  && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
					   || (B_D && LOAD_E  && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0))
					   || (B_D && LOAD_M  && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0))
 					   || (B_D && LOAD_M  && (IR_D[`rt] == IR_M[`rt]) && (IR_D[`rt] != 0));
						
assign stall_cal_r_load=(CAL_R_D && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
						   || (CAL_R_D && LOAD_E && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0));
assign stall_cal_i_load= CAL_I_D && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0);
assign stall_load_load = LOAD_D  && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0);
assign stall_store_load= STORE_D && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0);

assign stall_jr_cal_r=(JR_D|JALR_D) && CAL_R_E && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0);
assign stall_jr_cal_i=(JR_D|JALR_D) && CAL_I_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0);
assign stall_jr_load=((JR_D|JALR_D) && LOAD_E  && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0)) 
					  	|| ((JR_D|JALR_D) && LOAD_M  && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0));

assign stall_b=stall_b_cal_r || stall_b_cal_i || stall_b_load;
assign stall_load=stall_cal_r_load || stall_cal_i_load || stall_load_load || stall_store_load;
assign stall_jr=stall_jr_cal_r || stall_jr_cal_i || stall_jr_load;
assign stall=stall_b || stall_load || stall_jr;

assign PC_en=~stall;
assign IF_ID_en=~stall;
assign ID_EX_clr=stall;
	 
//转发
assign Forward_RS_D=(CAL_R_M && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?1: 
						  (CAL_I_M && (B_D|JR_D|JALR_D) && (IR_M[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?1:
						  (JAL_M   && (B_D|JR_D|JALR_D) && (5'd31 == IR_D[`rs]))?3:
						  (JALR_M  && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]))?3:
						  (CAL_R_W && (B_D|JR_D|JALR_D) && (IR_W[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?2:
						  (CAL_I_W && (B_D|JR_D|JALR_D) && (IR_W[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?2:
						  (LOAD_W  && (B_D|JR_D|JALR_D) && (IR_W[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?2:
						  (JAL_W   && (B_D|JR_D|JALR_D) && (5'd31 == IR_D[`rs]))?4:
						  (JALR_W  && (B_D|JR_D|JALR_D) && (IR_W[`rd] == IR_D[`rs]))?4:0;
						  
assign Forward_RT_D=(CAL_R_M && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?1:
						  (CAL_I_M && B_D && (IR_M[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?1:
						  (JAL_M   && B_D && (5'd31 == IR_D[`rt]))?3:
						  (JALR_M  && B_D && (IR_M[`rd] == IR_D[`rt]))?3:
						  (CAL_R_W && B_D && (IR_W[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?2:
						  (CAL_I_W && B_D && (IR_W[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?2:
						  (LOAD_W  && B_D && (IR_W[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?2:
						  (JAL_W   && B_D && (5'd31 == IR_D[`rt]))?4:
						  (JALR_W  && B_D && (IR_W[`rd] == IR_D[`rt]))?4:0;
						  
assign Forward_RS_E=(CAL_R_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?1: 
						  (CAL_I_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?1:
						  (JAL_M   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?3:
						  (JALR_M  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]))?3:
						  (CAL_R_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?2:
						  (CAL_I_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?2:
						  (LOAD_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?2:
						  (JAL_W   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?4:
						  (JALR_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]))?4:0;

assign Forward_RT_E=(CAL_R_M &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?1: 
						  (CAL_I_M &&  CAL_R_E && (IR_M[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?1:
						  (JAL_M   &&  CAL_R_E && (5'd31 == IR_E[`rt]))?3:
						  (JALR_M  &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]))?3:
						  (CAL_R_W && (CAL_R_E|STORE_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?2:
						  (CAL_I_W && (CAL_R_E|STORE_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?2:
						  (LOAD_W  && (CAL_R_E|STORE_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?2:
						  (JAL_W   && (CAL_R_E|STORE_E) && (5'd31 == IR_E[`rt]))?4:
						  (JALR_W  && (CAL_R_E|STORE_E) && (IR_W[`rd] == IR_E[`rt]))?4:0;
						  
assign Forward_RT_M=(CAL_R_W && STORE_M && (IR_W[`rd] == IR_M[`rt]) && (IR_M[`rt] != 0))?1:
						  (CAL_I_W && STORE_M && (IR_W[`rt] == IR_M[`rt]) && (IR_M[`rt] != 0))?1:
						  (LOAD_W  && STORE_M && (IR_W[`rt] == IR_M[`rt]) && (IR_M[`rt] != 0))?1:
						  (JAL_W   && STORE_M && (5'd31 == IR_M[`rt]))?2:
						  (JALR_W  && STORE_M && (IR_W[`rd] == IR_M[`rt]))?2:0;
endmodule
