`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module Hazard_unit(
    input [`F] IR_D, IR_E, IR_M, IR_W,
	 output[1:0] Forward_RS_D, Forward_RT_D, 
	 output[2:0] Forward_RS_E, Forward_RT_E,
	 output[1:0] Forward_RT_M,
    output PC_en, IF_ID_en, ID_EX_clr
    );
	 
	 wire stall_b, stall_load, stall_jr_jalr;
	 //第一部分代表指令类型，第二部分代表指令所在流水级，例如CAL_R_D表示两个寄存器的计算类指令，在D级
								   wire B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JR_D, JALR_D;
D_TRANSLATE D(IR_D[31:16], IR_D[`func], B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JR_D, JALR_D);
								   wire CAL_R_E, CAL_I_E, LOAD_E, STORE_E, MTC0_E;
E_TRANSLATE E(IR_E[31:21], IR_E[`func], CAL_R_E, CAL_I_E, LOAD_E, STORE_E, MTC0_E);
								   wire CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JALR_M, MTC0_M;
M_TRANSLATE M(IR_M[31:21], IR_M[`func], CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JALR_M, MTC0_M);
								   wire CAL_R_W, CAL_I_W, LOAD_W, JAL_W, JALR_W;
W_TRANSLATE W(IR_W[31:21], IR_W[`func], CAL_R_W, CAL_I_W, LOAD_W, JAL_W, JALR_W);
//暂停
assign stall_b=(B_D &&  CAL_R_E  && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0)) 
				|| (B_D &&  CAL_R_E  && (IR_D[`rt] == IR_E[`rd]) && (IR_D[`rt] != 0))
				|| (B_D && (CAL_I_E|LOAD_E) && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0)) 
				|| (B_D && (CAL_I_E|LOAD_E) && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0))
				|| (B_D &&  LOAD_M  	&& (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0))
				|| (B_D &&  LOAD_M  	&& (IR_D[`rt] == IR_M[`rt]) && (IR_D[`rt] != 0));
						
assign stall_load=((CAL_R_D|CAL_I_D|LOAD_D|STORE_D) && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
													 || (CAL_R_D && LOAD_E && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0));

assign stall_jr_jalr=((JR_D|JALR_D) && CAL_R_E   && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0))
						|| ((JR_D|JALR_D) && (CAL_I_E|LOAD_E) && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
						|| ((JR_D|JALR_D) && LOAD_M    && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0));

assign stall=stall_b || stall_load || stall_jr_jalr;

assign PC_en=~stall;
assign IF_ID_en=~stall;
assign ID_EX_clr=stall;
	 
//转发
assign Forward_RS_D=(CAL_R_M && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?2'd1: 
						  (CAL_I_M && (B_D|JR_D|JALR_D) && (IR_M[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?2'd1:
						  (JAL_M   && (B_D|JR_D|JALR_D) && (5'd31 == IR_D[`rs]))?2'd2:
						  (JALR_M  && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?2'd2:2'd0; 
						  
						  
assign Forward_RT_D=(CAL_R_M && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?2'd1:
						  (CAL_I_M && B_D && (IR_M[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?2'd1:
						  (JAL_M   && B_D && (5'd31 == IR_D[`rt]))?2'd2:
						  (JALR_M  && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?2'd2:2'd0;
						  
assign Forward_RS_E=(CAL_R_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd1: 
						  (CAL_I_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd1:
						  (JAL_M   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?3'd3:
						  (JALR_M  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd3: 
						  (CAL_R_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd2:
						  (CAL_I_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd2:
						  (LOAD_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd2:
						  (JAL_W   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?3'd4:
						  (JALR_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?3'd4:3'd0;

assign Forward_RT_E=(CAL_R_M &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd1: 
						  (CAL_I_M &&  CAL_R_E && (IR_M[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd1:
						  (JAL_M   &&  CAL_R_E && (5'd31 == IR_E[`rt]))?3'd3:
						  (JALR_M  &&  CAL_R_E && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd3: 
						  (CAL_R_W && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd2:
						  (CAL_I_W && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd2:
						  (LOAD_W  && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd2:
						  (JAL_W   && (CAL_R_E|STORE_E|MTC0_E) && (5'd31 == IR_E[`rt]))?3'd4:
						  (JALR_W  && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?3'd4:3'd0;
						  
assign Forward_RT_M=(CAL_R_W && (STORE_M|MTC0_M) && (IR_W[`rd] == IR_M[`rt]) && (IR_M[`rt] != 0))?2'd1:
						  (CAL_I_W && (STORE_M|MTC0_M) && (IR_W[`rt] == IR_M[`rt]) && (IR_M[`rt] != 0))?2'd1:
						  (LOAD_W  && (STORE_M|MTC0_M) && (IR_W[`rt] == IR_M[`rt]) && (IR_M[`rt] != 0))?2'd1:
						  (JAL_W   && (STORE_M|MTC0_M) && (5'd31 == IR_M[`rt]))?2'd2:
						  (JALR_W  && (STORE_M|MTC0_M) && (IR_W[`rd] == IR_M[`rt]) && (IR_M[`rt] != 0))?2'd2:2'd0;
endmodule
