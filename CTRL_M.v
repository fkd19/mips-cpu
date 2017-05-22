`timescale 1ns / 1ps
`define F 31:0
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0

module CTRL_M(input clk, reset,
				  input [31:16] IR,
				  input [`func] IR_FUNC,
				  input [`F] DM_addr, PC8_M,
				  output cpu_WE,
				  output[2:0] BE_CTRL,
				  output CP0_WE,EXL_clr,CP0_sel,
				  output[`F] PC_save);
	 
	 wire sb,sh,sw,beq,bne,blez,bgtz,bltz,bgez,j,jal,jalr,jr,mfc0,mtc0,eret;
	 reg epc_sign;
	 
M_DEC DEC_CTRL_M(IR[31:16],IR_FUNC,sb,sh,sw,beq,bne,blez,bgtz,bltz,bgez,j,jal,jalr,jr,mfc0,mtc0,eret);

	assign BE_CTRL=((DM_addr < 32'h0000_2000) && sb)?3'd3:
						((DM_addr < 32'h0000_2000) && sh)?3'd2:
						((DM_addr < 32'h0000_2000) && sw)?3'd1:3'd0;
	assign CP0_WE=mtc0;
	assign EXL_clr=eret;
	assign cpu_WE=sw && (DM_addr >= 32'h0000_7f00);
	assign CP0_sel=mfc0;
	//特意延迟了一个周期，不是规范的写法，有待改正。
	always @(posedge clk)begin
		if(reset)	epc_sign <= 0;
		else if (beq|bne|bgez|bgtz|blez|bltz|j|jal|jalr|jr)		epc_sign <= 1;
		else 	epc_sign <= 0;
	end
	
	assign PC_save=(epc_sign)?(PC8_M-32'h0000_000c):(PC8_M-32'd0000_0008);
endmodule
