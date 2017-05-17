`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_M(input clk,
				  input [`F] IR, DM_addr, PC8_M,
				  output DM_WE, cpu_WE,
				  output[2:0] BE_CTRL,
				  output LR,data_addr_exc,CP0_WE,EXL_clr,CP0_sel,
				  output[`F] PC_save);
	 
	 wire lb,lbu,lh,lhu,lw,sb,sh,sw;
	 wire add,addu,sub,subu;
	 wire mult,multu,div,divu;
	 wire sll,srl,sra,sllv,srlv,srav;
	 wire _and,_or,_xor,_nor;
	 wire addi,addiu,andi,ori,xori,lui;
	 wire slt,slti,sltiu,sltu;
	 wire beq,bne,blez,bgtz,bltz,bgez;
	 wire j,jal,jalr,jr;
	 wire mfhi,mflo,mthi,mtlo;
	 wire madd,maddu,msub,msubu;
	 wire swl,swr,movn,movz;
	 wire mfc0,mtc0,eret;
	 reg epc_sign;
	 
	 initial begin
		epc_sign <= 0;
	 end
	 
DECODER DEC_CTRL_M(IR,lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav,
							 _and,_or,_xor,_nor,addi,addiu,andi,ori,xori,lui,slt,slti,sltiu,sltu,beq,bne,blez,bgtz,bltz,bgez,
							 j,jal,jalr,jr,mfhi,mflo,mthi,mtlo,madd,maddu,msub,msubu,swl,swr,movn,movz,mfc0,mtc0,eret);

	assign DM_WE=(sw|sb|sh|swl|swr) && (DM_addr < 32'h0000_3000);
	assign BE_CTRL=sb?2:
						sh?1:
						swl?3:
						swr?4:0;//sw=0
	assign LR=swl|swr;
	assign data_addr_exc=((sw|lw) && (DM_addr[1:0] != 2'b0)) 
							|| ((sh|lh|lhu) && (DM_addr[0] != 1'b0))
							|| ((sw|lw|sh|lh|lhu|sb|lb) && (((DM_addr > 32'h0000_2fff) && (DM_addr < 32'h0000_7f00)) 
																	|| (DM_addr > 32'h0000_7f1c)));
	assign CP0_WE=mtc0;
	assign EXL_clr=eret;
	assign cpu_WE=sw && ((DM_addr == 32'h0000_7f00) 
							|| (DM_addr == 32'h0000_7f04) 
							|| (DM_addr == 32'h0000_7f10) 
							|| (DM_addr == 32'h0000_7f14));
	assign CP0_sel=mfc0;
	
	always @(posedge clk)begin
		if (beq|bne|bgez|bgtz|blez|bltz|j|jal|jalr|jr)begin	
			epc_sign <= 1;
		end
		else begin
			epc_sign <= 0;
		end
	end
	
	assign PC_save=(epc_sign)?(PC8_M-32'h0000_000c):(PC8_M-32'd0000_0008);
endmodule
