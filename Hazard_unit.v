`timescale 1ns / 1ps
`include <head.h>

module Hazard_unit(input clk, reset, int_clr, data_sram_addr_illegal,
				   input [`F] 	IR_D, IR_E, IR_M, IR_MMID, IR_W,PC_IFMID_out, PC, PC4_D, EPC, NPC_D_out,
				   input 		IF_GET_ADDR_OK, IF_GET_DATA_OK, MEM_GET_ADDR_OK, MEM_GET_DATA_OK,PC_sel,BUSY,
				   input [3:0] if_ben, mem_ben, 
				   input [1:0] KEEP,
				   output [2:0] Forward_RS_D, Forward_RT_D, 
				   output [3:0] Forward_RS_E, Forward_RT_E,
				   output [1:0] Forward_RT_M_2_HALF,
				   output int_eret_refuse, JUMP_sel, ERET_PC_sel, delay_groove_IFMID, delay_groove_IF_ID, back_pc,
				   output PC_en, IF_MID_en, IF_MID_clr, IF_ID_en, IF_ID_clr, ID_EX_en, ID_EX_clr, EX_MEM_en, MEM_MMID_en, MEM_MMID_clr, MMID_WB_en, MMID_WB_clr,
				   output data_sram_wr,
				   input CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JALR_M, MF_M, MFC0_M, MTC0_M,
				   input CAL_R_MMID, CAL_I_MMID, LOAD_MMID, STORE_MMID, JAL_MMID, JALR_MMID, MF_MMID, MTC0_MMID, MFC0_MMID,
				   input CAL_R_W, CAL_I_W, LOAD_W, STORE_W, JAL_W, JALR_W, MF_W, MFC0_W);
   
   
   wire 						stall, stall_b, stall_load, stall_jr_jalr, stall_MDFT, stall_ERET;
   wire 						B_D, CAL_R_D, CAL_I_D, LOAD_D, STORE_D, JR_D, JALR_D, MDFT_D,ERET_D, JUMP_D;
   wire 						CAL_R_E, CAL_I_E, LOAD_E, STORE_E, JAL_E, JALR_E, MTC0_E, MF_E;
   
   //暂停	
   assign stall_b=(B_D && (CAL_R_E|MF_E)   && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0)) 
	           || (B_D && (CAL_R_E|MF_E)   && (IR_D[`rt] == IR_E[`rd]) && (IR_D[`rt] != 0))
	           || (B_D && (CAL_I_E|LOAD_E) && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0)) 
		       || (B_D && (CAL_I_E|LOAD_E) && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0))
		       || (B_D &&  LOAD_M  		&& (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0))
			   || (B_D &&  LOAD_M  		&& (IR_D[`rt] == IR_M[`rt]) && (IR_D[`rt] != 0))
			   || (B_D &&  LOAD_MMID  	&& (IR_D[`rs] == IR_MMID[`rt]) && (IR_D[`rs] != 0))
               || (B_D &&  LOAD_MMID    && (IR_D[`rt] == IR_MMID[`rt]) && (IR_D[`rt] != 0));
   
   assign stall_load=((CAL_R_D|CAL_I_D|LOAD_D|STORE_D) && LOAD_E && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
	               || ((CAL_R_D|STORE_D) && LOAD_E && (IR_D[`rt] == IR_E[`rt]) && (IR_D[`rt] != 0))
	               || ((CAL_R_D|CAL_I_D|LOAD_D|STORE_D) && LOAD_M && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0))
                   || ((CAL_R_D|STORE_D) && LOAD_M && (IR_D[`rt] == IR_M[`rt]) && (IR_D[`rt] != 0));

   assign stall_jr_jalr=((JR_D|JALR_D) && (CAL_R_E|MF_E)   && (IR_D[`rs] == IR_E[`rd]) && (IR_D[`rs] != 0))
                     || ((JR_D|JALR_D) && (CAL_I_E|LOAD_E) && (IR_D[`rs] == IR_E[`rt]) && (IR_D[`rs] != 0))
                     || ((JR_D|JALR_D) && LOAD_M           && (IR_D[`rs] == IR_M[`rt]) && (IR_D[`rs] != 0))
                     || ((JR_D|JALR_D) && LOAD_MMID        && (IR_D[`rs] == IR_MMID[`rt]) && (IR_D[`rs] != 0));

   assign stall_MDFT=BUSY && MDFT_D;

   assign stall_ERET=(ERET_D && MTC0_E && (IR_E[`rd] == 5'd14))
                  || (ERET_D && MTC0_M && (IR_M[`rd] == 5'd14))
                  || (ERET_D && MTC0_MMID && (IR_MMID[`rd] == 5'd14));

   assign stall=stall_b | stall_load | stall_jr_jalr | stall_MDFT | stall_ERET;
    
      assign ERET_PC_sel=ERET_D && ~stall_ERET;
      assign JUMP_sel=IF_ID_en && PC_sel && (PC != PC4_D || (PC_en && PC == PC4_D));
      assign int_eret_refuse=(ERET_PC_sel || int_clr || PC == 32'hbfc0_0380) || (PC == EPC) && PC_IFMID_out >= 32'h8000_0000 &&  IF_GET_DATA_OK;
      assign back_pc=(PC_IFMID_out >= 32'h8000_0000) && IF_GET_DATA_OK && ~IF_ID_en
                  && ((NPC_D_out != 32'h0 && NPC_D_out == PC_IFMID_out && KEEP == 2'd1) || KEEP == 2'b11);    //因阻塞导致的PC回退，与IF_MID清空同时发生
      
      //是否为延迟槽指令（前面的跳转指令有可能不跳转）
      assign delay_groove_IFMID=(JUMP_D && PC4_D == PC && PC_en)
                             || (JUMP_D && IF_ID_en && PC4_D == PC_IFMID_out && PC_IFMID_out >= 32'h8000_0000 && ~IF_GET_DATA_OK);      
      assign delay_groove_IF_ID=(JUMP_D && IF_ID_en && PC4_D == PC_IFMID_out && PC_IFMID_out >= 32'h8000_0000 &&  IF_GET_DATA_OK); 
      
      assign PC_en=~IF_MID_en?1'b0:
                   ((|if_ben) && IF_GET_ADDR_OK)?1'b1:1'b0;
      
      assign IF_MID_en=~IF_ID_en?1'b0:
                       ((PC_IFMID_out >= 32'h8000_0000 && IF_GET_DATA_OK) || PC_IFMID_out == 32'h0 || (|PC_IFMID_out[1:0]))?1'b1:1'b0;
                        
      assign IF_MID_clr=((PC_IFMID_out >= 32'h8000_0000) && IF_GET_DATA_OK && ~IF_ID_en)
                     || (IF_MID_en && ~PC_en);
      
      assign IF_ID_en=(stall|~ID_EX_en)?1'b0:1'b1; 
      assign IF_ID_clr=IF_ID_en && ~IF_MID_en;
      
      assign ID_EX_en=~EX_MEM_en?1'b0:1'b1;
      assign ID_EX_clr=ID_EX_en & ~IF_ID_en;
      
      assign EX_MEM_en=~MEM_MMID_en?1'b0:
      ((LOAD_M & ~MFC0_M) | STORE_M)?((~data_sram_addr_illegal)?((|mem_ben) && MEM_GET_ADDR_OK):
                                                                1'b1):1'b1;
      
      assign MEM_MMID_en=((LOAD_MMID & ~MFC0_MMID) | STORE_MMID)?MEM_GET_DATA_OK:1'b1;
      assign MEM_MMID_clr=MEM_MMID_en & ~EX_MEM_en;
      assign MMID_WB_en=(~MEM_MMID_en && (Forward_RS_E == 3'd2 || Forward_RS_E == 3'd4 || Forward_RS_E == 3'd6
                                       || Forward_RT_E == 3'd2 || Forward_RT_E == 3'd4 || Forward_RT_E == 3'd6))?1'b0:1'b1;
      assign MMID_WB_clr=~MEM_MMID_en && ~(Forward_RS_E == 3'd2 || Forward_RS_E == 3'd4 || Forward_RS_E == 3'd6
                                        || Forward_RT_E == 3'd2 || Forward_RT_E == 3'd4 || Forward_RT_E == 3'd6);
   //传给sram的控制信号
   assign data_sram_wr=STORE_M;          
   
   //转发
   assign Forward_RS_D=(CAL_R_M && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd1: 
					   (CAL_I_M && (B_D|JR_D|JALR_D) && (IR_M[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd1:
					   (JAL_M   && (B_D|JR_D|JALR_D) && (5'd31 == IR_D[`rs]))?3'd2:
					   (JALR_M  && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd2:
					   (MF_M    && (B_D|JR_D|JALR_D) && (IR_M[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd3:
					   (CAL_R_MMID && (B_D|JR_D|JALR_D) && (IR_MMID[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd4: 
                       (CAL_I_MMID && (B_D|JR_D|JALR_D) && (IR_MMID[`rt] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd4:
                       (JAL_MMID   && (B_D|JR_D|JALR_D) && (5'd31 == IR_D[`rs]))?3'd5:
                       (JALR_MMID  && (B_D|JR_D|JALR_D) && (IR_MMID[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd5:
                       (MF_MMID    && (B_D|JR_D|JALR_D) && (IR_MMID[`rd] == IR_D[`rs]) && (IR_D[`rs] != 0))?3'd6:3'd0; 
   
   
   assign Forward_RT_D=(CAL_R_M && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd1:
                       (CAL_I_M && B_D && (IR_M[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd1:
                       (JAL_M   && B_D && (5'd31 == IR_D[`rt]))?3'd2:
                       (JALR_M  && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd2:
                       (MF_M    && B_D && (IR_M[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd3:
                       (CAL_R_MMID && B_D && (IR_MMID[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd4:
                       (CAL_I_MMID && B_D && (IR_MMID[`rt] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd4:
                       (JAL_MMID   && B_D && (5'd31 == IR_D[`rt]))?3'd5:
                       (JALR_MMID  && B_D && (IR_MMID[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd5:
                       (MF_MMID    && B_D && (IR_MMID[`rd] == IR_D[`rt]) && (IR_D[`rt] != 0))?3'd6:3'd0;
   
   assign Forward_RS_E=(CAL_R_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd1: 
                       (CAL_I_M && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd1:
                       (JAL_M   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?4'd3:
                       (JALR_M  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd3:
                       (MF_M    && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_M[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd5: 
                       (CAL_R_MMID && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_MMID[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd7: 
                       (CAL_I_MMID && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_MMID[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd7:
                       (JAL_MMID   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?4'd8:
                       (JALR_MMID  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_MMID[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd8:
                       (MF_MMID    && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_MMID[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd9:
                       (CAL_R_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd2:
                       (CAL_I_W && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd2:
                       (LOAD_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rt] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd2:
                       (JAL_W   && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (5'd31 == IR_E[`rs]))?4'd4:
                       (JALR_W  && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd4:
                       (MF_W    && (CAL_R_E|CAL_I_E|LOAD_E|STORE_E) && (IR_W[`rd] == IR_E[`rs]) && (IR_E[`rs] != 0))?4'd6:4'd0;

   assign Forward_RT_E=(CAL_R_M &&  (CAL_R_E|STORE_E) && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd1: 
                       (CAL_I_M &&  (CAL_R_E|STORE_E) && (IR_M[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd1:
                       (JAL_M   &&  (CAL_R_E|STORE_E) && (5'd31 == IR_E[`rt]))?4'd3:
                       (JALR_M  &&  (CAL_R_E|STORE_E) && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd3:
                       (MF_M    &&  (CAL_R_E|STORE_E) && (IR_M[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd5:
                       (CAL_R_MMID &&  (CAL_R_E|STORE_E) && (IR_MMID[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd7: 
                       (CAL_I_MMID &&  (CAL_R_E|STORE_E) && (IR_MMID[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd7:
                       (JAL_MMID   &&  (CAL_R_E|STORE_E) && (5'd31 == IR_E[`rt]))?4'd8:
                       (JALR_MMID  &&  (CAL_R_E|STORE_E) && (IR_MMID[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd8:
                       (MF_MMID    &&  (CAL_R_E|STORE_E) && (IR_MMID[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd9: 
                       (CAL_R_W && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd2:
                       (CAL_I_W && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd2:
                       (LOAD_W  && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rt] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd2:
                       (JAL_W   && (CAL_R_E|STORE_E|MTC0_E) && (5'd31 == IR_E[`rt]))?4'd4:
                       (JALR_W  && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd4:
                       (MF_W    && (CAL_R_E|STORE_E|MTC0_E) && (IR_W[`rd] == IR_E[`rt]) && (IR_E[`rt] != 0))?4'd6:4'd0;
                         
   assign Forward_RT_M_2_HALF=(CAL_R_W && MTC0_MMID && (IR_W[`rd] == IR_MMID[`rt]) && (IR_MMID[`rt] != 0))?2'd1:
                              (CAL_I_W && MTC0_MMID && (IR_W[`rt] == IR_MMID[`rt]) && (IR_MMID[`rt] != 0))?2'd1:
                              (LOAD_W  && MTC0_MMID && (IR_W[`rt] == IR_MMID[`rt]) && (IR_MMID[`rt] != 0))?2'd1:
                              (JAL_W   && MTC0_MMID && (5'd31 == IR_MMID[`rt]))?2'd2:
                              (JALR_W  && MTC0_MMID && (IR_W[`rd] == IR_MMID[`rt]) && (IR_MMID[`rt] != 0))?2'd2:
                              (MF_W    && MTC0_MMID && (IR_W[`rd] == IR_MMID[`rt]) && (IR_MMID[`rt] != 0))?2'd3:2'd0;                              

//translate_D
assign B_D=(IR_D[31:27] == 5'b00010);                       //beq|bne
//add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor|mult|multu|div|divu|mthi|mtlo;
assign CAL_R_D=({IR_D[`op],IR_D[`sa],IR_D[5:3]} == 14'b000000_00000_100)             //add|addu|sub|subu|_and|_or|_xor|_nor
         | ({IR_D[`op],IR_D[`sa],IR_D[5:1]} == 16'b000000_00000_10101)            //slt|sltu
         | ({IR_D[`op],IR_D[`rs],IR_D[`func]} == 17'b000000_00000_000000)         //sll
         | ({IR_D[`op],IR_D[`rs],IR_D[5:1]} == 16'b000000_00000_00001)         //srl|sra
         | ({IR_D[`op],IR_D[`sa],IR_D[`func]} == 17'b000000_00000_000100)         //sllv
         | ({IR_D[`op],IR_D[`sa],IR_D[5:1]} == 16'b000000_00000_00011)         //srlv|srav
         | ({IR_D[`op],IR_D[`rd],IR_D[`sa],IR_D[5:2]} == 20'b000000_0000000000_0110)    //mult|multu|div|divu
         | ({IR_D[`op],IR_D[`rt],IR_D[`rd],IR_D[`sa],IR_D[5:2], IR_D[0]} == 26'b000000_000000000000000_0100_1);       //mthi|mtlo
//addi|addiu|andi|ori|xori|lui|slti|sltiu; 
assign CAL_I_D=({IR_D[31:29],IR_D[27]} == 4'b001_0)                 //addi|addiu|andi|ori
         | (IR_D[`op] == 6'b001110)                       //xori
         | ({IR_D[`op],IR_D[`rs]} == 11'b001111_00000)      //lui
         | (IR_D[31:27] == 5'b00101);                       //slti|sltiu
//lw|lb|lbu|lh|lhu|mfc0;
assign LOAD_D=({IR_D[31:29],IR_D[27]} == 4'b100_0)        //lb|lbu|lh|lhu
        | (IR_D[`op] == 6'b100011)              //lw
        | (IR_D[`op] == 6'b111100)//lwg
        | ({IR_D[`op], IR_D[`rs],IR_D[`mft]} == 19'b010000_00000_00000000);    //mfc0

//sw|sb|sh;
assign STORE_D=(IR_D[31:27] == 5'b10100)    //sb|sh
         | (IR_D[`op] == 6'b111101)//swg
         | (IR_D[`op] == 6'b101011);  //sw

//jr|bgez|bgtz|blez|bltz|bgezal|bltzal;
assign JR_D=({IR_D[`op],IR_D[`rt],IR_D[`rd],IR_D[`sa],IR_D[`func]} == 27'b000000_0000000000_00000_001000)     //jr
      | ({IR_D[31:27],IR_D[`rt]} == 10'b00011_00000)        //blez|bgtz
      | ({IR_D[`op], IR_D[19:17]} == 9'b000001_000);       //bgez|bltz|bgezal|bltzal
//jalr;
assign JALR_D=({IR_D[`op],IR_D[`rt],IR_D[`sa],IR_D[`func]} == 22'b000000_00000_00000_001001);   //jalr

//mult|multu|div|divu|mfhi|mflo|mthi|mtlo;
assign MDFT_D=({IR_D[`op],IR_D[`rd],IR_D[`sa],IR_D[5:2]} == 20'b000000_0000000000_0110)    //mult|multu|div|divu
        | ({IR_D[`op],IR_D[`rs],IR_D[`rt],IR_D[`sa],IR_D[5:2]} == 25'b000000_0000000000_00000_0100);     //mfhi|mflo|mthi|mtlo
        
assign ERET_D=(IR_D[`F] == 32'h4200_0018);
//j|jal|jr|jalr|beq|bne|bgez|bltz|blez|bgtz|bgezal|bltzal;
assign JUMP_D=(IR_D[31:27] == 5'b00001)   //j|jal
        | ({IR_D[`op],IR_D[`rt],IR_D[`rd],IR_D[`sa],IR_D[`func]} == 27'b000000_0000000000_00000_001000)     //jr
        | ({IR_D[`op],IR_D[`rt],IR_D[`sa],IR_D[`func]} == 22'b000000_00000_00000_001001)   //jalr
        | (IR_D[31:27] == 5'b00010)                       //beq|bne
        | ({IR_D[31:27],IR_D[`rt]} == 10'b00011_00000)        //blez|bgtz
        | ({IR_D[`op], IR_D[19:17]} == 9'b000001_000);       //bgez|bltz|bgezal|bltzal 
        
//translate_E
//add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor|mult|multu|div|divu|mthi|mtlo;
assign CAL_R_E=({IR_E[`op],IR_E[`sa],IR_E[5:3]} == 14'b000000_00000_100)             //add|addu|sub|subu|_and|_or|_xor|_nor
         | ({IR_E[`op],IR_E[`sa],IR_E[5:1]} == 16'b000000_00000_10101)            //slt|sltu
         | ({IR_E[`op],IR_E[`rs],IR_E[`func]} == 17'b000000_00000_000000)         //sll
         | ({IR_E[`op],IR_E[`rs],IR_E[5:1]} == 16'b000000_00000_00001)         //srl|sra
         | ({IR_E[`op],IR_E[`sa],IR_E[`func]} == 17'b000000_00000_000100)         //sllv
         | ({IR_E[`op],IR_E[`sa],IR_E[5:1]} == 16'b000000_00000_00011)         //srlv|srav
         | ({IR_E[`op],IR_E[`rd],IR_E[`sa],IR_E[5:2]} == 20'b000000_0000000000_0110)    //mult|multu|div|divu
         | ({IR_E[`op],IR_E[`rt],IR_E[`rd],IR_E[`sa],IR_E[5:2], IR_E[0]} == 26'b000000_000000000000000_0100_1);       //mthi|mtlo
//addi|addiu|andi|ori|xori|lui|slti|sltiu; 
assign CAL_I_E=({IR_E[31:29],IR_E[27]} == 4'b0010)                 //addi|addiu|andi|ori
         | (IR_E[`op] == 6'b001110)                       //xori
         | ({IR_E[`op],IR_E[`rs]} == 11'b001111_00000)      //lui
         | (IR_E[31:27] == 5'b00101);                       //slti|sltiu
//lw|lb|lbu|lh|lhu|mfc0;
assign LOAD_E=({IR_E[31:29],IR_E[27]} == 4'b1000)        //lb|lbu|lh|lhu
        | (IR_E[`op] == 6'b100011)              //lw
        | (IR_E[`op] == 6'b111100)//lwg
        | ({IR_E[`op], IR_E[`rs],IR_E[`mft]} == 19'b010000_00000_00000000);    //mfc0
//sw|sb|sh;
assign STORE_E=(IR_E[31:27] == 5'b10100)    //sb|sh
         | (IR_E[`op] == 6'b111101)//swg
         | (IR_E[`op] == 6'b101011);  //sw
//jal | bgezal | bltzal;
assign JAL_E=(IR_E[`op] == 6'b000011)     //jal
       | ({IR_E[`op],IR_E[20:17]} == 10'b000001_1000);   //bgezal|bltzal
//jalr;
assign JALR_E=({IR_E[`op],IR_E[`rt],IR_E[`sa],IR_E[`func]} == 22'b000000_00000_00000_001001);   //jalr
//mfhi|mflo
assign MF_E=({IR_E[`op],IR_E[`rs],IR_E[`rt],IR_E[`sa],IR_E[5:2],IR_E[0]} == 26'b000000_0000000000_00000_0100_0);     //mfhi|mflo
assign MTC0_E=({IR_E[`op], IR_E[`rs],IR_E[`mft]} == 19'b010000_00100_00000000);

endmodule
