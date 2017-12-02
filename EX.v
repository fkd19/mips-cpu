`timescale 1ns / 1ps
`include <head.h>

module EX(input clk, reset, 
          input [`F] 	IR_E, RS_E, RT_E, EXT_E, PC8_E,
          input [`EXC] 	Exc_in,
          output [`EXC] Exc_out,
          output [`F] 	IR_M, PC8_M, ALUOUT_M, RT_M,XALUOUT_M,
          input [3:0] 	Forward_RS_E, Forward_RT_E,
          input [`F] 	ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, XALUOUT_W_out, ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out,
          output 	BUSY,
          output CAL_R_M, CAL_I_M, LOAD_M, STORE_M, JAL_M, JALR_M, MF_M, MFC0_M, MTC0_M
	  );
   
   
   wire [3:0] 		ALU_OP, XALU_OP;
   wire 		ALU_B_sel, A_B_SIGN_less, A_B_UNSIGN_less, HI_WE, LO_WE, HI_LO_sel, add_addi, sub, div0;
   wire [`F] 		ALU_B, MF_RS_E_out, MF_RT_E_out;	 
   
   wire [32:0] 		temp_add,temp_sub;
   
   MUX_FORWARD_E MF_RS_E(RS_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, 
			 XALUOUT_W_out, ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out, Forward_RS_E, MF_RS_E_out);
   
   MUX_FORWARD_E MF_RT_E(RT_E, ALUOUT_M_out, mux_Wdata_out, PC8_M_out, PC8_W_out, XALUOUT_M_out, 
			 XALUOUT_W_out, ALUOUT_MMID_out, PC8_MMID_out,XALUOUT_MMID_out, Forward_RT_E, MF_RT_E_out);
   
   mux_ALU_B _mux_ALU_B(MF_RT_E_out, EXT_E, ALU_B_sel, ALU_B);
   
   ALU _ALU(IR_E[`shamt], MF_RS_E_out, ALU_B, ALU_OP, ALUOUT_M);
   XALU _XALU(clk, reset, HI_WE, LO_WE, HI_LO_sel, XALU_OP,  MF_RS_E_out, ALU_B, MF_RS_E_out, XALUOUT_M, BUSY, div0);
   
   assign A_B_SIGN_less=({ALU_B[31],MF_RS_E_out[30:0]} < {MF_RS_E_out[31],ALU_B[30:0]})?1'b1:1'b0;
   assign A_B_UNSIGN_less=(MF_RS_E_out < ALU_B)?1'b1:1'b0;
   
   CTRL_E _CTRL_E(IR_E, A_B_SIGN_less, A_B_UNSIGN_less, ALU_B_sel, ALU_OP, XALU_OP,  HI_WE, LO_WE, HI_LO_sel, add_addi, sub);
   
   assign PC8_M=PC8_E;
   assign RT_M=MF_RT_E_out;
   assign IR_M=IR_E;
   
   assign temp_add = {MF_RS_E_out[31],MF_RS_E_out} + {ALU_B[31],ALU_B};
   assign temp_sub = {MF_RS_E_out[31],MF_RS_E_out} - {ALU_B[31],ALU_B};      
   assign Exc_out = (Exc_in!=0)?Exc_in:
                    (((temp_add[32]^temp_add[31]) & add_addi) || ((temp_sub[32]^temp_sub[31]) & sub))?12:
                    div0?0:0;         //暂时还没查到除零异常的exception code， 先写作0，暂不识别。

//translate_M
//add|addu|sub|subu|slt|sltu|sll|sllv|sra|srav|srl|srlv|_and|_or|_xor|_nor|mult|multu|div|divu|mthi|mtlo;
assign CAL_R_M=({IR_M[`op],IR_M[`sa],IR_M[5:3]} == 14'b000000_00000_100)             //add|addu|sub|subu|_and|_or|_xor|_nor
         | ({IR_M[`op],IR_M[`sa],IR_M[5:1]} == 16'b000000_00000_10101)            //slt|sltu
         | ({IR_M[`op],IR_M[`rs],IR_M[`func]} == 17'b000000_00000_000000)         //sll
         | ({IR_M[`op],IR_M[`rs],IR_M[5:1]} == 16'b000000_00000_00001)         //srl|sra
         | ({IR_M[`op],IR_M[`sa],IR_M[`func]} == 17'b000000_00000_000100)         //sllv
         | ({IR_M[`op],IR_M[`sa],IR_M[5:1]} == 16'b000000_00000_00011)         //srlv|srav
         | ({IR_M[`op],IR_M[`rd],IR_M[`sa],IR_M[5:2]} == 20'b000000_0000000000_0110)    //mult|multu|div|divu
         | ({IR_M[`op],IR_M[`rt],IR_M[`rd],IR_M[`sa],IR_M[5:2], IR_M[0]} == 26'b000000_000000000000000_0100_1);       //mthi|mtlo
//addi|addiu|andi|ori|xori|lui|slti|sltiu; 
assign CAL_I_M=({IR_M[31:29],IR_M[27]} == 4'b0010)                 //addi|addiu|andi|ori
         | (IR_M[`op] == 6'b001110)                       //xori
         | ({IR_M[`op],IR_M[`rs]} == 11'b001111_00000)      //lui
         | (IR_M[31:27] == 5'b00101);                       //slti|sltiu
//lw|lb|lbu|lh|lhu|mfc0;
assign LOAD_M=({IR_M[31:29],IR_M[27]} == 4'b1000)        //lb|lbu|lh|lhu
        | (IR_M[`op] == 6'b100011)              //lw
        | (IR_M[`op] == 6'b111100)  //lwg
        | ({IR_M[`op], IR_M[`rs],IR_M[`mft]} == 19'b010000_00000_00000000);    //mfc0
assign MFC0_M=({IR_M[`op], IR_M[`rs],IR_M[`mft]} == 19'b010000_00000_00000000);   //mfc0
//sw|sb|sh;
assign STORE_M=(IR_M[31:27] == 5'b10100)    //sb|sh
         | (IR_M[`op] == 6'b111101)//swg
         | (IR_M[`op] == 6'b101011);  //sw
//jal | bgezal | bltzal;
assign JAL_M=(IR_M[`op] == 6'b000011)     //jal
       | ({IR_M[`op],IR_M[20:17]} == 10'b000001_1000);   //bgezal|bltzal
//jalr;
assign JALR_M=({IR_M[`op],IR_M[`rt],IR_M[`sa],IR_M[`func]} == 22'b000000_00000_00000_001001);   //jalr
//mfhi|mflo
assign MF_M=({IR_M[`op],IR_M[`rs],IR_M[`rt],IR_M[`sa],IR_M[5:2],IR_M[0]} == 26'b000000_0000000000_00000_0100_0);     //mfhi|mflo
assign MTC0_M=({IR_M[`op], IR_M[`rs],IR_M[`mft]} == 19'b010000_00100_00000000);

endmodule
