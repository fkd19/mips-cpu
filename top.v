`timescale 1ns / 1ps
`include <head.h>

module CPU(
	   int_n_i,
	   aclk,
	   areset_n
	   ,inst_sram_cen
	   ,inst_sram_wr
	   ,inst_sram_addr
	   ,inst_sram_wdata
	   ,inst_sram_ack
	   ,inst_sram_rrdy
	   ,inst_sram_rdata

	   ,data_sram_cen
	   ,data_sram_wr
	   ,data_sram_addr
	   ,data_sram_wdata
	   ,data_sram_ack
	   ,data_sram_rrdy
	   ,data_sram_rdata
	   ,is_lw);

   output          is_lw;
   input   [ 5:0]  int_n_i;
   input           aclk;
   input           areset_n;
   
   output [ 3:0]   inst_sram_cen;
   output [31:0]   inst_sram_wdata;
   output          inst_sram_wr;
   output [31:0]   inst_sram_addr;
   
   input [31:0]    inst_sram_rdata;
   input           inst_sram_ack;              //指令地址是不是ok
   input           inst_sram_rrdy;             //指令是不是准备好了

  
   output [ 3:0]   data_sram_cen;
   output [31:0]   data_sram_wdata;
   output          data_sram_wr;
   output [31:0]   data_sram_addr;                //访存地址
   
   input [31:0]    data_sram_rdata;           //读的数据
   input           data_sram_ack;             //地址是不是ok
   input           data_sram_rrdy;            //数据是不是准备好了

   wire 	   pc_valid;
   wire [3:0] 	   mem_byte_en;
   wire 	   BUSY;
   wire [31:0] 	   data_ifc_wdata;
   
   wire 	       reset = ~areset_n;   
   wire 	       clk = aclk;
   wire [5:0] 	   HWint = ~int_n_i;   
   wire [`F] 	   b_j_jr_tgt,EPC;
   wire [`F]      PC_IFMID_in, PC_IFMID_out, NPC_IFMID_out;
   wire [`F] 	   IR_D_in, IR_D_out, PC4_D_in, PC4_D_out, NPC_D_in, NPC_D_out;
   wire 	       MF_RT_M_out, data_sram_addr_illegal,MMID_WB_en, int_eret_refuse, JUMP_sel,delay_groove_IFMID, delay_groove_IF_ID, pre_PC_sel, back_pc, PC_en, PC_sel, int_clr,IF_MID_en,IF_MID_clr, ERET_PC_sel, REAL_IF_ID_clr, IF_ID_en, IF_ID_clr, ID_EX_en, ID_EX_clr, EX_MEM_en, MEM_MMID_en, MEM_MMID_clr, MMID_WB_clr;   
   wire [1:0]      KEEP;
   wire [`F] 	   IR_E_in, IR_E_out, RS_E_in, RS_E_out, RT_E_in, RT_E_out, EXT_E_in, EXT_E_out, PC8_E_in, PC8_E_out;
   wire [`F] 	   IR_M_in, IR_M_out, PC8_M_in, PC8_M_out, ALUOUT_M_in, ALUOUT_M_out, RT_M_in, RT_M_out, XALUOUT_M_in, XALUOUT_M_out;
   wire [`F] 	   IR_MMID_in, IR_MMID_out, PC8_MMID_in, PC8_MMID_out, ALUOUT_MMID_in, ALUOUT_MMID_out, RT_MMID_in, RT_MMID_out, XALUOUT_MMID_in, XALUOUT_MMID_out;
   wire [`F] 	   IR_W_in, IR_W_out, PC8_W_in, PC8_W_out, ALUOUT_W_in, ALUOUT_W_out, DMOUT_W_in, DMOUT_W_out, XALUOUT_W_in, XALUOUT_W_out;
   wire 		   CAL_R_M_in, CAL_I_M_in, LOAD_M_in, STORE_M_in, JAL_M_in, JALR_M_in, MF_M_in, MFC0_M_in, MTC0_M_in;
   wire 		   CAL_R_M_out, CAL_I_M_out, LOAD_M_out, STORE_M_out, JAL_M_out, JALR_M_out, MF_M_out, MFC0_M_out, MTC0_M_out;
   wire            CAL_R_MMID_in, CAL_I_MMID_in, LOAD_MMID_in, STORE_MMID_in, JAL_MMID_in, JALR_MMID_in, MF_MMID_in, MTC0_MMID_in, MFC0_MMID_in;
   wire            CAL_R_MMID_out, CAL_I_MMID_out, LOAD_MMID_out, STORE_MMID_out, JAL_MMID_out, JALR_MMID_out, MF_MMID_out, MTC0_MMID_out, MFC0_MMID_out;
   wire            CAL_R_W_in, CAL_I_W_in, LOAD_W_in, STORE_W_in, JAL_W_in, JALR_W_in, MF_W_in, MFC0_W_in;
   wire            CAL_R_W_out, CAL_I_W_out, LOAD_W_out, STORE_W_out, JAL_W_out, JALR_W_out, MF_W_out, MFC0_W_out;
   
   wire [3:0] 	   Forward_RS_E, Forward_RT_E;
   wire [2:0] 	   Forward_RS_D, Forward_RT_D;
   wire [1:0]     Forward_RT_M_2_HALF;
   wire [`F] 	   mux_Wdata_out;
   /**********流水级之间的异常处理编码变量定义*************/
   wire [`EXC] 	   EXC_IFMID_in, EXC_IFMID_out, EXC_D_in, EXC_D_out,  EXC_E_in, EXC_E_out, EXC_M_in, EXC_M_out, EXC_MMID_in, EXC_MMID_out;
   wire DELAY_GRROVE_IFMID_out, DELAY_GRROVE_D_out, DELAY_GRROVE_E_out, DELAY_GRROVE_M_out, DELAY_GRROVE_MMID_out;
   
    assign inst_sram_wr = 0;
    assign inst_sram_cen = pc_valid ? 4'b1111 : 4'b0;   
    assign data_sram_cen = mem_byte_en;
    assign data_sram_wdata = RT_M_out;
    assign inst_sram_wdata = 32'h0;

IF_1_HALF _IF_1_HALF(clk, reset, back_pc, PC_en, JUMP_sel,  int_clr, ERET_PC_sel, b_j_jr_tgt, EPC, PC_IFMID_out, PC4_D_out, inst_sram_addr, PC_IFMID_in, EXC_IFMID_in, pc_valid);

IF_MID _IF_MID(clk, reset, int_clr, IF_MID_en, IF_MID_clr, ERET_PC_sel, JUMP_sel, delay_groove_IFMID, DELAY_GRROVE_IFMID_out, 
                PC_IFMID_in, PC_IFMID_out, EXC_IFMID_in, EXC_IFMID_out, b_j_jr_tgt, NPC_IFMID_out, NPC_D_out, KEEP);

IF_2_HALF _IF_2_HALF(inst_sram_rrdy, int_eret_refuse, KEEP, PC_IFMID_out, inst_sram_rdata, PC4_D_in,  IR_D_in, 
                        EXC_IFMID_out, EXC_D_in, NPC_IFMID_out, NPC_D_in, NPC_D_out);

IF_ID_REGS _IF_ID_REGS(clk, reset, IF_ID_en, IF_ID_clr, int_clr, ERET_PC_sel, EXC_D_in, EXC_D_out,IR_D_in, IR_D_out, 
                        PC4_D_in, PC4_D_out, JUMP_sel, delay_groove_IF_ID,  DELAY_GRROVE_IFMID_out, DELAY_GRROVE_D_out,
                        b_j_jr_tgt, NPC_D_in, EPC, NPC_D_out);

IDandWB _IDandWB(clk, reset, EXC_D_out, EXC_E_in, IR_D_out, PC4_D_out, IR_E_in, RS_E_in, RT_E_in, EXT_E_in, PC8_E_in,
        b_j_jr_tgt, PC_sel, IR_W_out, PC8_W_out, ALUOUT_W_out, DMOUT_W_out, XALUOUT_W_out,
        mux_Wdata_out, Forward_RS_D, Forward_RT_D, ALUOUT_M_out, PC8_M_out, XALUOUT_M_out,ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out);

ID_EX_REGS _ID_EX_REGS(clk, reset, ID_EX_en, ID_EX_clr, int_clr, EXC_E_in,EXC_E_out, IR_E_in, IR_E_out,
          PC8_E_in, PC8_E_out, RS_E_in, RS_E_out, RT_E_in, RT_E_out, EXT_E_in, EXT_E_out, DELAY_GRROVE_D_out, DELAY_GRROVE_E_out);


EX _EX(clk, reset, IR_E_out, RS_E_out, RT_E_out, EXT_E_out, PC8_E_out, EXC_E_out, EXC_M_in, IR_M_in, PC8_M_in,
      ALUOUT_M_in, RT_M_in, XALUOUT_M_in, Forward_RS_E, Forward_RT_E, ALUOUT_M_out, mux_Wdata_out,
      PC8_M_out, PC8_W_out, XALUOUT_M_out, XALUOUT_W_out,ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out, BUSY,
      CAL_R_M_in, CAL_I_M_in, LOAD_M_in, STORE_M_in, JAL_M_in, JALR_M_in, MF_M_in, MFC0_M_in, MTC0_M_in);


EX_MEM_REGS _EX_MEM_REGS(clk, reset, int_clr, EX_MEM_en, EXC_M_in, IR_M_in, IR_M_out, PC8_M_in, 
                        PC8_M_out, ALUOUT_M_in, ALUOUT_M_out, RT_M_in, RT_M_out, XALUOUT_M_in, XALUOUT_M_out,
                        EXC_M_out, DELAY_GRROVE_E_out, DELAY_GRROVE_M_out,
                        CAL_R_M_in, CAL_I_M_in, LOAD_M_in, STORE_M_in, JAL_M_in, JALR_M_in, MF_M_in, MFC0_M_in, MTC0_M_in,
                        CAL_R_M_out, CAL_I_M_out, LOAD_M_out, STORE_M_out, JAL_M_out, JALR_M_out, MF_M_out, MFC0_M_out, MTC0_M_out);

MEM_1_HALF _MEM_1_HALF(clk, reset, IR_M_out, PC8_M_out, ALUOUT_M_out, RT_M_out, XALUOUT_M_out, EXC_M_out,
                       IR_MMID_in, PC8_MMID_in, ALUOUT_MMID_in, RT_MMID_in, XALUOUT_MMID_in, EXC_MMID_in,
                       data_sram_addr, data_sram_addr_illegal, mem_byte_en);

MEM_MID _MEM_MID(clk, reset, int_clr, MEM_MMID_en, MEM_MMID_clr, IR_MMID_in, IR_MMID_out, PC8_MMID_in, PC8_MMID_out,
           ALUOUT_MMID_in, ALUOUT_MMID_out,RT_MMID_in, RT_MMID_out, XALUOUT_MMID_in, XALUOUT_MMID_out, EXC_MMID_in, EXC_MMID_out,
           DELAY_GRROVE_M_out, DELAY_GRROVE_MMID_out,
           CAL_R_M_out, CAL_I_M_out, LOAD_M_out, STORE_M_out, JAL_M_out, JALR_M_out, MF_M_out, MTC0_M_out, MFC0_M_out, 
           CAL_R_MMID_out, CAL_I_MMID_out, LOAD_MMID_out, STORE_MMID_out, JAL_MMID_out, JALR_MMID_out, MF_MMID_out, MTC0_MMID_out, MFC0_MMID_out);

MEM_2_HALF _MEM_2_HALF(clk, reset,DELAY_GRROVE_MMID_out, EXC_MMID_out, IR_MMID_out,  PC8_MMID_out, ALUOUT_MMID_out, RT_MMID_out, XALUOUT_MMID_out,
                       IR_W_in, PC8_W_in, ALUOUT_W_in, DMOUT_W_in, XALUOUT_W_in, Forward_RT_M_2_HALF, mux_Wdata_out, PC8_W_out, 
                       XALUOUT_W_out, HWint, int_clr, EPC, data_sram_rdata,is_lw);

MMID_WB_REGS _MMID_WB_REGS(clk, reset, int_clr, MMID_WB_en, MMID_WB_clr, IR_W_in, IR_W_out, PC8_W_in, PC8_W_out, 
                        ALUOUT_W_in, ALUOUT_W_out, DMOUT_W_in, DMOUT_W_out, XALUOUT_W_in, XALUOUT_W_out,
                        CAL_R_MMID_out, CAL_I_MMID_out, LOAD_MMID_out, STORE_MMID_out, JAL_MMID_out, JALR_MMID_out, MF_MMID_out, MFC0_MMID_out,
                        CAL_R_W_out, CAL_I_W_out, LOAD_W_out, STORE_W_out, JAL_W_out, JALR_W_out, MF_W_out, MFC0_W_out);


Hazard_unit _Hazard_unit(clk, reset, int_clr, data_sram_addr_illegal, IR_D_out, IR_E_out, IR_M_out, IR_MMID_out, IR_W_out, PC_IFMID_out, PC_IFMID_in, PC4_D_out, EPC, NPC_D_out, 
                        inst_sram_ack, inst_sram_rrdy, data_sram_ack, data_sram_rrdy, PC_sel, BUSY,
                        inst_sram_cen, data_sram_cen, KEEP,
                        Forward_RS_D, Forward_RT_D, Forward_RS_E, Forward_RT_E, Forward_RT_M_2_HALF, 
                        int_eret_refuse, JUMP_sel, ERET_PC_sel, delay_groove_IFMID, delay_groove_IF_ID, back_pc, PC_en, IF_MID_en, IF_MID_clr,IF_ID_en, IF_ID_clr, ID_EX_en, ID_EX_clr, EX_MEM_en, MEM_MMID_en, MEM_MMID_clr, MMID_WB_en, MMID_WB_clr,
                        data_sram_wr,
                        CAL_R_M_out, CAL_I_M_out, LOAD_M_out, STORE_M_out, JAL_M_out, JALR_M_out, MF_M_out, MFC0_M_out, MTC0_M_out,
                        CAL_R_MMID_out, CAL_I_MMID_out, LOAD_MMID_out, STORE_MMID_out, JAL_MMID_out, JALR_MMID_out, MF_MMID_out, MTC0_MMID_out, MFC0_MMID_out,
                        CAL_R_W_out, CAL_I_W_out, LOAD_W_out, STORE_W_out, JAL_W_out, JALR_W_out, MF_W_out, MFC0_W_out);

endmodule
