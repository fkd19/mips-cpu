`timescale 1ns / 1ps
`include <head.h>

module EXT(input [15:0] imm16,
			  input extop,
			  output [`F] extout);

	wire[`F] signext;
	wire[`F] zeroext;
	wire[15:0] top16;
	
	assign top16={16{imm16[15]}};
	assign signext={top16, imm16};
	assign zeroext={16'b0,imm16};
	
	assign extout=(!extop)?zeroext:signext;
endmodule

module XEXT(input [1:0] ADDR,
				input [`F] DMOUT,
				input [2:0] XEXT_OP,
				output [`F] XEXTOUT);

		wire[`F] b;
		wire[`F] h;
		wire [31:16] h_head;
		wire [31:8] b_head; 
		
		assign h_head={16{h[31]}};
		assign b_head={24{b[31]}};
		assign b[31:24]=(ADDR == 3)?DMOUT[31:24]:
							 (ADDR == 2)?DMOUT[23:16]:
							 (ADDR == 1)?DMOUT[15:8]:
							 (ADDR == 0)?DMOUT[7:0]:8'b0;
		assign h[31:16]=(ADDR[1] == 1)?DMOUT[31:16]:
							 (ADDR[1] == 0)?DMOUT[15:0]:16'b0;
					
		assign XEXTOUT=(XEXT_OP == 4)?{h_head, h[31:16]}:
							(XEXT_OP == 3)?(h >>  16):
							(XEXT_OP == 2)?{b_head, b[31:24]}:
							(XEXT_OP == 1)?(b >>  24):DMOUT;
endmodule

