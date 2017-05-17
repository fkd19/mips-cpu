`timescale 1ns / 1ps
`define F 31:0

module IM(input [`F] IM_addr,
			 output [`F] IR);

	reg[`F] im[2047:0];
	wire[`F] real_IM_addr;
	initial begin
		$readmemh("code.txt", im);
	end
	assign real_IM_addr=IM_addr-32'h0000_3000;
	assign IR=im[real_IM_addr[12:2]];
endmodule
