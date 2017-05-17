`timescale 1ns / 1ps

module cmp4(
    input [3:0] A,
    input [3:0] B,
    output greater4,
	 output equal4
    );
	 wire[3:0] equal;
    wire[3:0] greater;
		one_bit_cmp cmp3(A[3], B[3], greater[3], equal[3]);
		one_bit_cmp cmp2(A[2], B[2], greater[2], equal[2]);
		one_bit_cmp cmp1(A[1], B[1], greater[1], equal[1]);
		one_bit_cmp cmp0(A[0], B[0], greater[0], equal[0]); 
	 assign greater4=greater[3]|(equal[3]&greater[2])|((&equal[3:2])&greater[1])|((&equal[3:1])&greater[0]); 
	 assign equal4=&equal;
endmodule

module one_bit_cmp(input a1, input b1, output greater1, output equal1);
		assign	greater1=a1 & ~b1;
		assign	equal1=(a1 & b1) | (~a1 & ~b1);
endmodule
