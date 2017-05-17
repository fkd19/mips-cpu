`timescale 1ns / 1ps
`define F 31:0

module CMP(input [`F] A,B,
			  output[2:0] cmpout);
	 
	 assign cmpout[2]=({B[31],A[30:0]} > {A[31],B[30:0]})?1:0;
	 assign cmpout[1]=({B[31],A[30:0]} == {A[31],B[30:0]})?1:0;
	 assign cmpout[0]=({B[31],A[30:0]} < {A[31],B[30:0]})?1:0;
endmodule
