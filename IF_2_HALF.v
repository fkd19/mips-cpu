`timescale 1ns / 1ps
`include <head.h>

module IF_2_HALF(
    input inst_sram_rrdy, int_eret_refuse,
    input [1:0] KEEP,
    input[`F] PC_IFMID, inst_data,
    output[`F] PC4_D, IR_D,
    input[`EXC] EXC_IFMID,
    output[`EXC] EXC_D,
    input [`F] NPC_IFMID,
    output [`F] NPC_D,
    input [`F]  NPC_D_out
    );
    
    ADDER _PC_mid_plus4(PC_IFMID, PC4_D);
    assign IR_D = (PC_IFMID < 32'h8000_0000 || ~inst_sram_rrdy || int_eret_refuse || ~(|KEEP) || (NPC_D_out != 32'h0 && NPC_D_out != PC_IFMID && KEEP == 2'd1))?32'h0:inst_data;
    assign EXC_D=EXC_IFMID;
    assign NPC_D= (PC_IFMID < 32'h8000_0000 || ~inst_sram_rrdy || int_eret_refuse || ~(|KEEP) || (NPC_D_out != 32'h0 && NPC_D_out != PC_IFMID && KEEP == 2'd1))?32'h0:NPC_IFMID;
endmodule
