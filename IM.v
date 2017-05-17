`timescale 1ns / 1ps
`define F 31:0

module IM(input [`F] IM_addr,
			 output [`F] IR);

	reg[`F] im[2047:0];
	reg[`F] exception_handle[1024:0];
	wire[`F] real_IM_addr,exception_handle_addr;
	initial begin
		$readmemh("code.txt", im);
		$readmemh("handle.txt", exception_handle);
	end
	assign real_IM_addr=IM_addr-32'h0000_3000;
	assign exception_handle_addr=IM_addr-32'h0000_4180;
	assign IR=(IM_addr >= 32'h0000_4180)?exception_handle[exception_handle_addr[12:2]]:im[real_IM_addr[12:2]];
endmodule
