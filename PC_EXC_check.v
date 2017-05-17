`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module PC_EXC_check(input[`F] pc,
						  output[`ExcCode] Exc_check_res);
	
	assign Exc_check_res=((pc[1:0] == 0) || (pc >= 32'h0000_5000))?5'd0:5'd12;	
	
endmodule
