`timescale 1ns / 1ps
`include <head.h>


module IDandWB(input clk, reset,
                input [`EXC]    Exc_in,
                output [`EXC]   Exc_out,
                input [`F] IR_D, PC4_D,
                output [`F] IR_E, RS_E, RT_E, EXT_E, PC8_E, b_j_jr_tgt,
                output PC_sel,
                input[`F] IR_W, 
                input[`F] PC8_W, ALUOUT_W, DMOUT_W, XALUOUT_W, 
                output [`F] Wdata,
                input[2:0] Forward_RS_D, Forward_RT_D,
                input[`F] ALUOUT_M_out, PC8_M_out, XALUOUT_M_out,ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out
                );
	//ID阶段变量声明
	wire[`F] Rdata1,Rdata2,EXTOUT;
	wire[2:0] A0_CMPOUT;
	wire[1:0] b_j_jr_sel;
	wire EXT_sel, AB_equal;
	wire[`F] MF_RS_D_out;
	wire[`F] MF_RT_D_out;
	wire     GPU_run, lwg, swg;
	wire[`F] GPU_wdata, GPU_threshold, GPU_rdata;
	wire 		     nop,Illegal, SYSCALL, BREAK;   
	
	//WB阶段变量声明
	wire[1:0] Wreg_sel, Wdata_sel;
	wire[4:0] Wreg;
	wire[2:0] XEXT_OP;
	wire[`F] XEXTOUT;
	wire GRF_WE;
	//ID阶段执行
MUX_FORWARD_D MF_RS_D(Rdata1, ALUOUT_M_out, PC8_M_out, XALUOUT_M_out, ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out, Forward_RS_D, MF_RS_D_out);
MUX_FORWARD_D MF_RT_D(Rdata2, ALUOUT_M_out, PC8_M_out, XALUOUT_M_out, ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out, Forward_RT_D, MF_RT_D_out);

GRF _GRF(clk, reset, IR_D[`rs], IR_D[`rt], Wreg, Wdata, GRF_WE, Rdata1, Rdata2);

EXT _EXT(IR_D[`I16], EXT_sel, EXTOUT);
     assign AB_equal=(MF_RS_D_out == MF_RT_D_out)?1'b1:1'b0;
     assign A0_CMPOUT[2]=({1'b0,MF_RS_D_out[30:0]} > {MF_RS_D_out[31],31'b0})?1'b1:1'b0;
	 assign A0_CMPOUT[1]=({1'b0,MF_RS_D_out[30:0]} == {MF_RS_D_out[31],31'b0})?1'b1:1'b0;
	 assign A0_CMPOUT[0]=({1'b0,MF_RS_D_out[30:0]} < {MF_RS_D_out[31],31'b0})?1'b1:1'b0;
NPC _NPC(PC4_D, IR_D[`I26], MF_RS_D_out, b_j_jr_sel, b_j_jr_tgt);
CTRL_D _CTRL_D(IR_D, Illegal);
ADDER _PC4plus4(PC4_D, PC8_E);
GPU _GPU(clk, reset, GPU_run, lwg, swg, GPU_wdata, IR_D, GPU_rdata);
	assign IR_E=IR_D;
	assign EXT_E=EXTOUT;
	assign RS_E=Rdata1;
	assign RT_E=swg?GPU_rdata:Rdata2;
	assign SYSCALL={IR_D[`op],IR_D[`func]} == 12'b000000_001100;
	assign BREAK={IR_D[`op],IR_D[`func]} == 12'b000000_001101;
	assign Exc_out = (Exc_in != 0)?Exc_in:
                     Illegal?10:
                     SYSCALL?8:
                     BREAK?9:0;
		
//d级控制器
//lw|sw|slti|sltiu|lb|lbu|lh|lhu|sb|sh|addi|addiu;
assign GPU_run=(IR_D[`op] == 6'b111111);

assign swg=(IR_D[`op] == 6'b111101);
assign EXT_sel=({IR_D[31:29],IR_D[27]} == 4'b100_0)        //lb|lbu|lh|lhu
             | ({IR_D[31:30],IR_D[28:26]} == 5'b10_011)              //lw|sw
             | (IR_D[31:27] == 5'b10100)    //sb|sh
             | (IR_D[31:28] == 4'b0010)     //slti|sltiu|addi|addiu
             | (IR_D[`op] == 6'b111100);    //lwg                       
assign b_j_jr_sel=(({IR_D[`op],IR_D[`rt],IR_D[`rd],IR_D[`sa],IR_D[`func]} == 27'b000000_0000000000_00000_001000)     //jr
                |  ({IR_D[`op],IR_D[`rt],IR_D[`sa],IR_D[`func]} == 22'b000000_00000_00000_001001))?2'd2:           //jalr
                  (IR_D[31:27] == 5'b00001)?2'd1:2'd0;       //j|jal
assign PC_sel=((IR_D[`op] == 6'b000100)
                &(MF_RS_D_out == MF_RT_D_out))            //beq
             |(IR_D[31:27] == 5'b00001)                      //j|jal
             |({IR_D[`op],IR_D[`rt],IR_D[`rd],IR_D[`sa],IR_D[`func]} == 27'b000000_0000000000_00000_001000)          //jr
             |({IR_D[`op],IR_D[`rt],IR_D[`sa],IR_D[`func]} == 22'b000000_00000_00000_001001)                       //jalr
             |(({IR_D[`op],IR_D[19:16]} == 10'b000001_0001)
                &(({1'b0,MF_RS_D_out[30:0]} > {MF_RS_D_out[31],31'b0})|({1'b0,MF_RS_D_out[30:0]} == {MF_RS_D_out[31],31'b0})))//bgez|bgezal A0_CMPOUT[2]|A0_CMPOUT[1]
             |(({IR_D[`op],IR_D[`rt]} == 11'b000111_00000)
                &({1'b0,MF_RS_D_out[30:0]} > {MF_RS_D_out[31],31'b0}))      //bgtz A0_CMPOUT[2]
             |(({IR_D[`op],IR_D[`rt]} == 11'b000110_00000)
                &(({1'b0,MF_RS_D_out[30:0]} < {MF_RS_D_out[31],31'b0})|({1'b0,MF_RS_D_out[30:0]} == {MF_RS_D_out[31],31'b0})))       //blez  A0_CMPOUT[0]|A0_CMPOUT[1]|
             |(({IR_D[`op],IR_D[19:16]} == 10'b000001_0000)
                &({1'b0,MF_RS_D_out[30:0]} < {MF_RS_D_out[31],31'b0}))          //bltz|bltzal  A0_CMPOUT[0]
             |((IR_D[`op] == 6'b000101)
                &~(MF_RS_D_out == MF_RT_D_out));                   //bne
//WB阶段执行
XEXT _XEXT(ALUOUT_W[1:0], DMOUT_W, XEXT_OP, XEXTOUT);
mux_Wreg _mux_Wreg(IR_W[`rt], IR_W[`rd], Wreg_sel, Wreg);
mux_Wdata _mux_Wdata(ALUOUT_W, XEXTOUT, PC8_W, XALUOUT_W, Wdata_sel, Wdata);
CTRL_W _CTRL_W(IR_W, Wreg_sel, Wdata_sel, GRF_WE, XEXT_OP);
assign lwg=(IR_W[`op] == 6'b111100);
assign GPU_wdata=DMOUT_W;
endmodule
