`timescale 1ns / 1ps
`include <head.h>

module IF_MID(
    input clk,
    input reset,
    input int_clr, IF_MID_en, IF_MID_clr, ERET_PC_sel, JUMP_sel, delay_groove_IFMID_in,
    output delay_groove_IFMID_out,
    input [`F] PC_IFMID_in,
    output [`F] PC_IFMID_out,
    input [`EXC] EXC_IFMID_in,
    output [`EXC] EXC_IFMID_out,
    input [`F] b_j_jr_tgt,
    output [`F] NPC_IFMID_out,
    input [`F] NPC_D,
    output[1:0] KEEP);
    
    reg[`F] PC_IFMID;
    reg[`EXC] EXC_IFMID;
    reg delay_groove_IFMID;
    reg [1:0] keep;   //keep用于标记指令是否要保留
    reg[`F] NPC_IFMID;
    
    always @(posedge clk)begin
        if (reset | IF_MID_clr)begin
            PC_IFMID <= 0;
            EXC_IFMID <= 0;
            delay_groove_IFMID <= 0;
            NPC_IFMID <= 0;
            keep <= 2'd0;
        end
        else if (IF_MID_en)begin
            PC_IFMID <= PC_IFMID_in;
            EXC_IFMID <= EXC_IFMID_in;
            delay_groove_IFMID <= delay_groove_IFMID_in;
            if (delay_groove_IFMID_in)begin
                if (JUMP_sel)       NPC_IFMID <= b_j_jr_tgt;
                else                NPC_IFMID <= PC_IFMID_in+32'h4;
            end
            else                    NPC_IFMID <= PC_IFMID_in+32'h4;
            if (NPC_D == 32'h0 || NPC_D == PC_IFMID_in)   keep <= 2'b11;
            else                        keep <= 2'b01;
        end
        else begin
            if (delay_groove_IFMID_in)begin
                    delay_groove_IFMID <= 1'b1;
                    if (JUMP_sel)       NPC_IFMID <= b_j_jr_tgt;
            end
            if (keep == 2'b01)begin
                if (NPC_D == PC_IFMID)  keep <= 2'b11;
                else keep <= 2'b00;
            end
            
        end
        
        
    end
    
    assign PC_IFMID_out = PC_IFMID;
    assign EXC_IFMID_out = EXC_IFMID;
    assign delay_groove_IFMID_out = delay_groove_IFMID;
    assign NPC_IFMID_out=NPC_IFMID;
    assign KEEP=keep;
endmodule
