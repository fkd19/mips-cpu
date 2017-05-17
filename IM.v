`timescale 1ns / 1ps
`define F 31:0

module IM(input [`F] IM_addr,
			 output [`F] IR);

	reg[`F] im[1023:0];
	initial begin
		$readmemh("code.txt", im);
	end
	assign IR=im[IM_addr[11:2]];
endmodule
