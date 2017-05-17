`timescale 1ns / 1ps
`define F 31:0

module IF_ID_REGS(input clk, reset, IF_ID_en,
						input [`F] IR_D_in,
						output [`F] IR_D_out,
						input [`F] PC4_D_in,
						output [`F] PC4_D_out);

	reg[`F] IR_D;
	reg[`F] PC4_D;
	
	initial begin
		IR_D <= 0;
		PC4_D <= 0;
	end
	
	always @(posedge clk)begin
		if (reset)begin
			IR_D <= 0;
			PC4_D <= 0;
		end
		else if (IF_ID_en)begin
			IR_D <= IR_D_in;
			PC4_D <= PC4_D_in;
		end
	end
	
	assign IR_D_out=IR_D;
	assign PC4_D_out=PC4_D;
endmodule
