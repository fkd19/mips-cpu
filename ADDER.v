`timescale 1ns / 1ps
`define F 31:0
module ADDER(input [`F] a,
				 output[`F] b);
				 
	assign b=a+4;
	
endmodule
