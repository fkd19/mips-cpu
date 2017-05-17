`timescale 1ns / 1ps
`define F 31:0

module XEXT(input [1:0] ADDR,
				input [`F] DMOUT,
				input [2:0] XEXT_OP,
				output [`F] XEXTOUT);

		wire[`F] b;
		wire[`F] h;
		
		assign b[31:24]=(ADDR == 3)?DMOUT[31:24]:
							 (ADDR == 2)?DMOUT[23:16]:
							 (ADDR == 1)?DMOUT[15:8]:
							 (ADDR == 0)?DMOUT[7:0]:0;
		assign h[31:16]=(ADDR[1] == 1)?DMOUT[31:16]:
							 (ADDR[1] == 0)?DMOUT[15:0]:0;
					
		assign XEXTOUT=(XEXT_OP == 4)?$unsigned($signed(h) >>> 16):
							(XEXT_OP == 3)?(h >>  16):
							(XEXT_OP == 2)?$unsigned($signed(b) >>> 24):
							(XEXT_OP == 1)?(b >>  24):DMOUT;
endmodule
