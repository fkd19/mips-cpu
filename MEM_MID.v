`timescale 1ns / 1ps
`include <head.h>

module MEM_MID(
    input clk, reset, int_clr, MEM_MMID_en, MEM_MMID_clr,  
    input[`F] IR_MMID_in,
    output[`F] IR_MMID_out,
    input[`F] PC8_MMID_in,
    output[`F] PC8_MMID_out,
    input[`F] ALUOUT_MMID_in,
    output[`F] ALUOUT_MMID_out,
    input[`F] RT_MMID_in,
    output[`F] RT_MMID_out,
    input[`F] XALUOUT_MMID_in,
    output[`F] XALUOUT_MMID_out,
    input[`EXC] EXC_MMID_in,
    output[`EXC] EXC_MMID_out,
    input PRE_INST_STALL_AND_JUMP_MMID_in,
    output PRE_INST_STALL_AND_JUMP_MMID_out,
    input  CAL_R_MMID_in, CAL_I_MMID_in, LOAD_MMID_in, STORE_MMID_in, JAL_MMID_in, JALR_MMID_in, MF_MMID_in, MTC0_MMID_in, MFC0_MMID_in,
    output CAL_R_MMID_out, CAL_I_MMID_out, LOAD_MMID_out, STORE_MMID_out, JAL_MMID_out, JALR_MMID_out, MF_MMID_out, MTC0_MMID_out, MFC0_MMID_out
    );
    
    reg[`F] IR_MMID, PC8_MMID, ALUOUT_MMID, RT_MMID, XALUOUT_MMID;
    reg[`EXC] EXC_MMID;
    reg PRE_INST_STALL_AND_JUMP_MMID;
    reg CAL_R_MMID, CAL_I_MMID, LOAD_MMID, STORE_MMID, JAL_MMID, JALR_MMID, MF_MMID, MTC0_MMID, MFC0_MMID;
    
    always @(posedge clk)begin
        if (reset | int_clr | MEM_MMID_clr)begin
            IR_MMID <= 0;
            PC8_MMID <= 0;
            ALUOUT_MMID <= 0;
            XALUOUT_MMID <= 0;
            EXC_MMID <= 0;
            RT_MMID <= 0;
            PRE_INST_STALL_AND_JUMP_MMID <= 0;
            
            CAL_R_MMID <= 0;
             CAL_I_MMID  <= 0;
             LOAD_MMID <= 0;
             STORE_MMID  <= 0;
             JAL_MMID <= 0;
             JALR_MMID <= 0;
             MF_MMID <= 0;
             MFC0_MMID <= 0;
             MTC0_MMID <= 0;
        end
        else if (MEM_MMID_en) begin
             IR_MMID <= IR_MMID_in;
             PC8_MMID <= PC8_MMID_in;
             ALUOUT_MMID <= ALUOUT_MMID_in;
             XALUOUT_MMID <= XALUOUT_MMID_in;
             EXC_MMID <= EXC_MMID_in;
             RT_MMID <= RT_MMID_in;
             PRE_INST_STALL_AND_JUMP_MMID <= PRE_INST_STALL_AND_JUMP_MMID_in;
             
             CAL_R_MMID <= CAL_R_MMID_in;
               CAL_I_MMID  <= CAL_I_MMID_in;
               LOAD_MMID <= LOAD_MMID_in;
               STORE_MMID  <= STORE_MMID_in;
               JAL_MMID <= JAL_MMID_in;
               JALR_MMID <= JALR_MMID_in;
               MF_MMID <= MF_MMID_in;
               MFC0_MMID <= MFC0_MMID_in;
               MTC0_MMID <= MTC0_MMID_in;
        end
    end
    
    assign IR_MMID_out=IR_MMID;
    assign PC8_MMID_out=PC8_MMID;
    assign ALUOUT_MMID_out=ALUOUT_MMID;
    assign XALUOUT_MMID_out=XALUOUT_MMID;
    assign EXC_MMID_out=EXC_MMID;
    assign RT_MMID_out=RT_MMID;
    assign PRE_INST_STALL_AND_JUMP_MMID_out = PRE_INST_STALL_AND_JUMP_MMID;
    
    assign CAL_R_MMID_out = CAL_R_MMID;
   assign CAL_I_MMID_out = CAL_I_MMID;
   assign LOAD_MMID_out  = LOAD_MMID;
   assign STORE_MMID_out = STORE_MMID;
   assign JAL_MMID_out   = JAL_MMID;
   assign JALR_MMID_out  = JALR_MMID;
   assign MF_MMID_out    = MF_MMID;
   assign MFC0_MMID_out  = MFC0_MMID;
   assign MTC0_MMID_out  = MTC0_MMID;
    
endmodule
