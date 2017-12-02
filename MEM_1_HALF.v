`timescale 1ns / 1ps
`include <head.h>

module MEM_1_HALF(
    input clk,  reset,
    input [`F] 	 IR_M, PC8_M, ALUOUT_M, RT_M, XALUOUT_M,
    input [`EXC]  EXC_M,
    output [`F] 	 IR_MMID, PC8_MMID, ALUOUT_MMID, RT_MMID, XALUOUT_MMID,
    output [`EXC]  EXC_MMID,
    output [`F] 	data_sram_addr,
    output          data_sram_addr_illegal,       
    output [3:0]    byte_en
    );
        wire [3:0] 		   ben;   
        
      wire 			Illegal_r,Illegal_w;
      wire [`F]             mem_vaddr,mem_paddr;
      wire             d_useg,d_kseg0,d_kseg1,d_kseg2,d_kseg3;
      
      assign mem_vaddr = ALUOUT_M;
   
      assign d_useg    = ~mem_vaddr[31];
      assign d_kseg0   = mem_vaddr[31:29]==3'b100;
      assign d_kseg1   = mem_vaddr[31:29]==3'b101;
      assign d_kseg2   = mem_vaddr[31:29]==3'b110;
      assign d_kseg3   = mem_vaddr[31:29]==3'b111;
   
      assign mem_paddr[28: 0] = mem_vaddr[28: 0];
      assign mem_paddr[31:29] =  d_useg  ? {!mem_vaddr[30] ? 2'b01 : 2'b10 , mem_vaddr[29]} :
                     (d_kseg0 || d_kseg1) ? 3'b000 : mem_vaddr[31:29]; //kseg2 or kseg3
    


    assign data_sram_addr=mem_paddr;
    /*
    assign data_sram_wdata=(byte_en == 4'b0001 || byte_en == 4'b0010 || byte_en == 4'b0100 || byte_en == 4'b1000)?{MF_RT_M_out[7:0],MF_RT_M_out[7:0],MF_RT_M_out[7:0],MF_RT_M_out[7:0]}:
                           (byte_en == 4'b0011 || byte_en == 4'b1100)?{MF_RT_M_out[15:0],MF_RT_M_out[15:0]}:MF_RT_M_out;
   */
   assign IR_MMID=IR_M;
   assign PC8_MMID=PC8_M;
   assign ALUOUT_MMID=ALUOUT_M;
   assign XALUOUT_MMID=XALUOUT_M;
   assign RT_MMID=RT_M;
   assign EXC_MMID=(EXC_M != 0)?EXC_M:
                  Illegal_w?5'd5:
                  Illegal_r?5'd4:5'd0;

//CTRL_M
assign ben=((IR_M[`op] == 6'b101000) | ({IR_M[31:29], IR_M[27:26]} == 6'b100_00))?((ALUOUT_M[1:0] == 2'd0)?4'b0001:              //sb, lb, lbu
                                                                                   (ALUOUT_M[1:0] == 2'd1)?4'b0010:
                                                                                   (ALUOUT_M[1:0] == 2'd2)?4'b0100:
                                                                                   (ALUOUT_M[1:0] == 2'd3)?4'b1000:4'b0000):
           ((IR_M[`op] == 6'b101001) | ({IR_M[31:29], IR_M[27:26]} == 6'b100_01))?((ALUOUT_M[1] == 2'd0)?4'b0011:                //sh, lh, lhu
                                                                                   (ALUOUT_M[1] == 2'd1)?4'b1100:4'b0000):
           ({IR_M[31:30], IR_M[28:26]} == 6'b10_011) | (IR_M[31:27] == 5'b11110)?4'b1111:4'b0000;                                //sw, lw, lwg, swg
                                             
  
   assign byte_en = (((IR_M[`op] == 6'b101001)&ALUOUT_M[0])        //sh 
                   | ((IR_M[`op] == 6'b101011)&(ALUOUT_M[1] | ALUOUT_M[0]))     //sw 
                   | (({IR_M[31:29], IR_M[27:26]} == 6'b100_01)&ALUOUT_M[0])     //lh|lhu
                   | ((IR_M[`op] == 6'b100011)&(ALUOUT_M[1] | ALUOUT_M[0])))?4'b0000:   //lw    //表示地址是否违法，违法则byte_en置0
                    ((IR_M[31:27] == 5'b10100)    //sb|sh
                   | ({IR_M[31:30], IR_M[28:26]} == 6'b10_011)              //sw|lw
                   | (IR_M[31:27] == 5'b11110)                  //lwg|swg
                   | ({IR_M[31:29],IR_M[27]} == 4'b100_0))?ben:4'b0000;            //lb|lbu|lh|lhu
                   
   assign Illegal_w = ((IR_M[`op] == 6'b101001)&ALUOUT_M[0]) | ((IR_M[`op] == 6'b101011)&(ALUOUT_M[1] | ALUOUT_M[0]));        //未判断溢出
   assign Illegal_r = (({IR_M[31:29], IR_M[27:26]} == 6'b100_01)&ALUOUT_M[0]) | ((IR_M[`op] == 6'b100011)&(ALUOUT_M[1] | ALUOUT_M[0]));
   assign data_sram_addr_illegal= ((IR_M[`op] == 6'b101001)&ALUOUT_M[0]) | ((IR_M[`op] == 6'b101011)&(ALUOUT_M[1] | ALUOUT_M[0])) 
                                | (({IR_M[31:29], IR_M[27:26]} == 6'b100_01)&ALUOUT_M[0]) | ((IR_M[`op] == 6'b100011)&(ALUOUT_M[1] | ALUOUT_M[0]));      
endmodule
