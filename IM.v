`timescale 1ns / 1ps

module IM(
    input [31:0] addr,
    output [31:0] instr
    );

	reg[31:0] im[1023:0];
	initial begin
		$readmemh("code.txt", im);
	end
	assign instr=im[addr[11:2]];
endmodule
