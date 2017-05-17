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
	assign zeroext={16'b0,imm16};
	
	assign extout=(!extop)?zeroext:signext;
endmodule

module CMP(input [`F] A,B,
			  output[2:0] cmpout);
	 
	 assign cmpout[2]=({B[31],A[30:0]} > {A[31],B[30:0]})?1'b1:1'b0;
	 assign cmpout[1]=({B[31],A[30:0]} == {A[31],B[30:0]})?1'b1:1'b0;
	 assign cmpout[0]=({B[31],A[30:0]} < {A[31],B[30:0]})?1'b1:1'b0;
endmodule

module XEXT(input [1:0] ADDR,
				input [`F] DMOUT,
				input [2:0] XEXT_OP,
				output [`F] XEXTOUT);

		wire[`F] b;
		wire[`F] h;
		
		assign b[31:24]=(ADDR == 3)?DMOUT[31:24]:
							 (ADDR == 2)?DMOUT[23:16]:
							 (ADDR == 1)?DMOUT[15:8]:
							 (ADDR == 0)?DMOUT[7:0]:8'b0;
		assign h[31:16]=(ADDR[1] == 1)?DMOUT[31:16]:
							 (ADDR[1] == 0)?DMOUT[15:0]:16'b0;
					
		assign XEXTOUT=(XEXT_OP == 4)?$unsigned($signed(h) >>> 16):
							(XEXT_OP == 3)?(h >>  16):
							(XEXT_OP == 2)?$unsigned($signed(b) >>> 24):
							(XEXT_OP == 1)?(b >>  24):DMOUT;
endmodule

module BE_EXT(
    input [1:0] ADDR,
	 input [2:0] BE_CTRL,
    output [3:0] BE
    );
//sw:1		sh:2		sb:3
assign BE=((BE_CTRL == 3) && (ADDR == 0))?4'b0001:
			 ((BE_CTRL == 3) && (ADDR == 1))?4'b0010:
			 ((BE_CTRL == 3) && (ADDR == 2))?4'b0100:
			 ((BE_CTRL == 3) && (ADDR == 3))?4'b1000:
			 ((BE_CTRL == 2) && (ADDR[1] == 0))?4'b0011:
			 ((BE_CTRL == 2) && (ADDR[1] == 1))?4'b1100:
			  (BE_CTRL == 1)?4'b1111:4'b0000;
endmodule
