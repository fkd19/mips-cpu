`timescale 1ns / 1ps
`define F 31:0

module MEM_WB_REGS(input clk, reset, int_clr,
						 input [`F] IR_W_in,
						 output[`F] IR_W_out,
						 input [`F] PC8_W_in,
						 output[`F] PC8_W_out,
						 input [`F] ALUOUT_W_in,
						 output[`F] ALUOUT_W_out,
						 input [`F] DMOUT_W_in,
						 output[`F] DMOUT_W_out);

	 reg[`F] IR_W, PC8_W, ALUOUT_W, DMOUT_W;
	 
	 always @(posedge clk)begin
		if (reset|int_clr)begin
			IR_W <= 0;
			PC8_W <= 0;
			ALUOUT_W <= 0;
			DMOUT_W <= 0;
		end
		else begin
			IR_W <= IR_W_in;
			PC8_W <= PC8_W_in;
			ALUOUT_W <= ALUOUT_W_in;
			DMOUT_W <= DMOUT_W_in;
		end
	 end
	 
	 assign IR_W_out=IR_W;
	 assign PC8_W_out=PC8_W;
	 assign ALUOUT_W_out=ALUOUT_W;
	 assign DMOUT_W_out=DMOUT_W;
endmodule
