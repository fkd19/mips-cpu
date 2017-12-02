`timescale 1ns / 1ps
`include <head.h>


module MEM_2_HALF(
       input clk,  reset, delay_groove,
       input [`EXC]  EXC_MMID,
       input [`F] 	 IR_MMID, PC8_MMID, ALUOUT_MMID, RT_MMID, XALUOUT_MMID,
       output [`F] 	 IR_W, PC8_W, ALUOUT_W, DMOUT_W, XALUOUT_W,
       input [1:0] 	 Forward_RT_M,
       input [`F] 	 mux_Wdata_out, PC8_W_out, XALUOUT_W_out,
       input [7:2] 	 HWint,
       output 	 int_clr,
       output [`F] 	 EPC,
       input [`F] 	 DMOUT,       //rdata
       output is_lw
       );
    
    wire               SL,CP0_WE,EXL_clr, CP0_sel;
    wire [`F]          CP0_data_out,PC_save,MF_RT_M_out;
    
MUX_FORWARD_M_2_HALF MF_RT_M_2_HALF(RT_MMID, mux_Wdata_out, PC8_W_out, XALUOUT_W_out, Forward_RT_M, MF_RT_M_out);
CTRL_M_2_HALF _CTRL_M_2_HALF(clk, reset, IR_MMID, CP0_WE, EXL_clr, CP0_sel, SL,is_lw);
CP0 _CP0(clk, reset, SL, delay_groove, IR_MMID[`rd], MF_RT_M_out, PC_save, PC8_MMID, ALUOUT_MMID,
         HWint, CP0_WE, EXL_clr, int_clr, EPC, CP0_data_out, EXC_MMID);
mux_DMOUT _muxDMOUT(CP0_data_out, DMOUT, CP0_sel, DMOUT_W);
    
    assign PC_save=delay_groove?(PC8_MMID-32'h0000_000c):(PC8_MMID-32'd0000_0008);
    assign IR_W=IR_MMID;
   assign PC8_W=PC8_MMID;
   assign ALUOUT_W=ALUOUT_MMID;
   assign XALUOUT_W=XALUOUT_MMID;

endmodule
