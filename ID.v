`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define I16 15:0
`define I26 25:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module IDandWB(input clk, reset,
					input [`F] IR_D, PC4_D,
					output [`F] IR_E, RS_E, RT_E, EXT_E, PC8_E, b_j_jr_tgt,
					output PC_sel, ERET_PC_sel,
					input[31:11] IR_W, 
					input[`func] IR_W_FUNC, 
					input[`F] PC8_W, ALUOUT_W, DMOUT_W,
					output [`F] Wdata,
					input[1:0] Forward_RS_D, Forward_RT_D,
					input[`F] ALUOUT_M_out, PC8_M_out);
	//ID阶段变量声明
	wire[`F] Rdata1,Rdata2,EXTOUT;
	wire[2:0] A0_CMPOUT;
	wire[1:0] b_j_jr_sel;
	wire EXT_sel, AB_equal;
	wire[`F] MF_RS_D_out;
	wire[`F] MF_RT_D_out;
	//WB阶段变量声明
	wire[1:0] Wreg_sel, Wdata_sel;
	wire[4:0] Wreg;
	wire[2:0] XEXT_OP;
	wire[`F] XEXTOUT;
	wire GRF_WE;
	//ID阶段执行
//转发
MUX_FORWARD_D MF_RS_D(Rdata1, ALUOUT_M_out, PC8_M_out, Forward_RS_D, MF_RS_D_out);//这里的PC8_W不用加后缀_out
MUX_FORWARD_D MF_RT_D(Rdata2, ALUOUT_M_out, PC8_M_out, Forward_RT_D, MF_RT_D_out);//传进来的就是PC8_W

GRF _GRF(clk, reset, IR_D[`rs], IR_D[`rt], Wreg, Wdata, GRF_WE, Rdata1, Rdata2);
//扩展器
EXT _EXT(IR_D[`I16], EXT_sel, EXTOUT);
assign AB_equal=(MF_RS_D_out == MF_RT_D_out)?1'b1:1'b0;
CMP _CMP_A0(MF_RS_D_out, 0, A0_CMPOUT);
//D级反馈的next pc
NPC _NPC(PC4_D, IR_D[`I26], MF_RS_D_out, b_j_jr_sel, b_j_jr_tgt);
CTRL_D _CTRL_D(IR_D[`op], IR_D[`rt], IR_D[`func], AB_equal, A0_CMPOUT, EXT_sel, b_j_jr_sel, PC_sel, ERET_PC_sel);
ADDER _PC4plus4(PC4_D, PC8_E);
	assign IR_E=IR_D;
	assign EXT_E=EXTOUT;
	assign RS_E=Rdata1;
	assign RT_E=Rdata2;
//WB阶段执行
//扩展，主要用于lb, lh, lbu, lhu
XEXT _XEXT(ALUOUT_W[1:0], DMOUT_W, XEXT_OP, XEXTOUT);
//写寄存器选择
mux_Wreg _mux_Wreg(IR_W[`rt], IR_W[`rd], Wreg_sel, Wreg);
//写入数据选择
mux_Wdata _mux_Wdata(ALUOUT_W, XEXTOUT, PC8_W, Wdata_sel, Wdata);
CTRL_W _CTRL_W(IR_W[31:21], IR_W_FUNC, Wreg_sel, Wdata_sel, GRF_WE, XEXT_OP);
endmodule
