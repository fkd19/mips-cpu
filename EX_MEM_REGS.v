`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module EX_MEM_REGS(input clk, reset, EX_MEM_clr, int_clr,
						 input [`F] IR_M_in,
						 output [`F] IR_M_out,
						 input [`F] PC8_M_in,
						 output [`F] PC8_M_out,
						 input [`F] ALUOUT_M_in,
						 output [`F] ALUOUT_M_out,
						 input [`F] RT_M_in,
						 output [`F] RT_M_out,
						 input [`F] XALUOUT_M_in,
						 output [`F] XALUOUT_M_out,
						 input [`ExcCode] EXC_M_in,
						 output [`ExcCode] EXC_M_out);

	 reg[`F] IR_M, PC8_M, ALUOUT_M, RT_M, XALUOUT_M, EXC_M;
	 
	 initial begin
			IR_M <= 0;
			PC8_M <= 0;
			ALUOUT_M <= 0;
			RT_M <= 0;
			XALUOUT_M <= 0;
			EXC_M <= 0;
		end
	 
	 always @(posedge clk)begin
		if (reset)begin
			IR_M <= 0;
			PC8_M <= 0;
			ALUOUT_M <= 0;
			RT_M <= 0;
			XALUOUT_M <= 0;
			EXC_M <= 0;
		end
		else if (EX_MEM_clr|int_clr)begin
			IR_M <= 0;
			PC8_M <= PC8_M;
			ALUOUT_M <= 0;
			RT_M <= 0;
			XALUOUT_M <= 0;
			EXC_M <= 0;
		end
		else begin
			IR_M <= IR_M_in;
			PC8_M <= PC8_M_in;
			ALUOUT_M <= ALUOUT_M_in;
			RT_M <= RT_M_in;
			XALUOUT_M <= XALUOUT_M_in;
			EXC_M <= EXC_M_in;
		end
	 end
	 
	 assign IR_M_out=IR_M;
	 assign PC8_M_out=PC8_M;
	 assign ALUOUT_M_out=ALUOUT_M;
	 assign RT_M_out=RT_M;
	 assign XALUOUT_M_out=XALUOUT_M;
	 assign EXC_M_out=EXC_M;
endmodule
