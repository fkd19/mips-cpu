`timescale 1ns / 1ps
`include <head.h>

module IF_1_HALF(
    input clk,reset, back_pc, PC_en, JUMP_sel,  int_PC_sel, ERET_PC_sel,
    input [`F] 	b_j_jr_tgt, EPC, PC_IFMID_out, PC4_D, 
    output [`F] 	inst_sram_addr,
    output [`F] 	PC,
    output [`EXC]   EXC_D,
    output 	pc_valid);
    
      wire [`F] 		       NPC,pc_paddr,PC4;
      wire                pc_useg,pc_kseg0,pc_kseg1,pc_kseg2,pc_kseg3;
      
      
      assign pc_useg    = PC[31]==1'b0;
      assign pc_kseg0   = PC[31:29]==3'b100;
      assign pc_kseg1   = PC[31:29]==3'b101;
      assign pc_kseg2   = PC[31:29]==3'b110;
      assign pc_kseg3   = PC[31:29]==3'b111;
   
      assign pc_paddr[28: 0] = PC[28: 0];
      assign pc_paddr[31:29] = pc_useg  ? {!PC[30] ? 2'b01 : 2'b10, PC[29]} :
                   (pc_kseg0 || pc_kseg1) ? 3'b000 :  PC[31:29];
    

PC _PC(clk, reset, back_pc, PC_en, int_PC_sel, ERET_PC_sel,JUMP_sel,
        PC4, b_j_jr_tgt, EPC,  PC_IFMID_out, PC);
ADDER _PCplus4(PC, PC4);

       assign inst_sram_addr = pc_paddr;
       assign pc_valid = ~EXC_D;
       assign EXC_D = (PC[1] | PC[0])?5'd4:5'd0;          //这里的0并不是代表中断的0
    
endmodule
