`timescale 1ns / 1ps

module BE_EXT(
    input [1:0] ADDR,
	 input [2:0] BE_CTRL,
    output [3:0] BE
    );
//sw:0		sh:1		sb:2
assign BE=((BE_CTRL == 2) && (ADDR == 0))?4'b0001:
			 ((BE_CTRL == 2) && (ADDR == 1))?4'b0010:
			 ((BE_CTRL == 2) && (ADDR == 2))?4'b0100:
			 ((BE_CTRL == 2) && (ADDR == 3))?4'b1000:
			 ((BE_CTRL == 1) && (ADDR[1] == 0))?4'b0011:
			 ((BE_CTRL == 1) && (ADDR[1] == 1))?4'b1100:
			 ((BE_CTRL == 3) && (ADDR == 0))?4'b0001:
			 ((BE_CTRL == 3) && (ADDR == 1))?4'b0011:
			 ((BE_CTRL == 3) && (ADDR == 2))?4'b0111:
			 ((BE_CTRL == 3) && (ADDR == 3))?4'b1111:
			 ((BE_CTRL == 4) && (ADDR == 0))?4'b1111:
			 ((BE_CTRL == 4) && (ADDR == 1))?4'b1110:
			 ((BE_CTRL == 4) && (ADDR == 2))?4'b1100:
			 ((BE_CTRL == 4) && (ADDR == 3))?4'b1000:4'b1111;
endmodule
