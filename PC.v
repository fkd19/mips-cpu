`timescale 1ns / 1ps
`define F 31:0
module PC(input clk, reset, PC_en, int_PC_sel, ERET_PC_sel,
          input [`F] NPC,
			 output [`F] pc);
			 
	reg[`F] pc;
	initial begin
		pc = 32'h0000_3000;
	end
	always @(posedge clk)begin
		if (reset)	pc <= 32'h0000_3000;
		else if(PC_en || int_PC_sel || ERET_PC_sel)		pc <= NPC;
	end
endmodule
