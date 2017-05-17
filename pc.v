`timescale 1ns / 1ps

module PC(
    input [31:0] NPC,
    output [31:0] CPC,
	 input clk,
	 input reset
    );

	reg[31:0] pc;
	initial begin
		pc = 32'h0000_3000;
	end
	always @(posedge clk)begin
		if (reset)	pc <= 32'h0000_3000;
		else			pc <= NPC;
	end
	assign CPC=pc;
endmodule
