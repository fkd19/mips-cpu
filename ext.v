`timescale 1ns / 1ps
`define F 31:0

module EXT(input [15:0] imm16,
			  input extop,
			  output [`F] extout);

	wire[`F] signext;
	wire[`F] zeroext;
	wire[15:0] top16;
	
	assign top16={16{imm16[15]}};
	assign signext={top16, imm16};
	assign zeroext={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,imm16};
	
	assign extout=(!extop)?zeroext:signext;
endmodule
