module EXT(
    input [15:0] imm16,
    input extop,
    output [31:0] extout
    );

	wire[31:0] signext;
	wire[31:0] zeroext;
	
	assign signext[31:16]={16{imm16[15]}};
	assign signext[15:0]=imm16;
	assign zeroext[31:16]=16'h0000;
	assign zeroext[15:0]=imm16;
	
	assign extout=(!extop)?zeroext:signext;
endmodule
