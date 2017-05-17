`timescale 1ns / 1ps

module cmp32(
    input [31:0] A,
    input [31:0] B,
    output[2:0] cmpout
    );
	 
	 wire[7:0] greater32;
	 wire[7:0] equal32;
	 
	 one_bit_cmp cmp31(B[31], A[31], greater32[7], equal32[7]);
	 one_bit_cmp cmp30(A[30], B[30], greater32[6], equal32[6]);
	 one_bit_cmp cmp29(A[29], B[29], greater32[5], equal32[5]);
	 one_bit_cmp cmp28(A[28], B[28], greater32[4], equal32[4]);
	 cmp4 cmp27_24(A[27:24], B[27:24], greater32[3], equal32[3]);
	 cmp8 cmp23_16(A[23:16], B[23:16], greater32[2], equal32[2]);
	 cmp8 cmp15_8(A[15:8], B[15:8], greater32[1], equal32[1]);
	 cmp8 cmp7_0(A[7:0], B[7:0], greater32[0], equal32[0]);

	assign cmpout[2]=greater32[7]|(equal32[7]&greater32[6])|((&equal32[7:6])&greater32[5])
				     |((&equal32[7:5])&greater32[4])|((&equal32[7:4])&greater32[3])
				     |((&equal32[7:3])&greater32[2])|((&equal32[7:2])&greater32[1])
				     |((&equal32[7:1])&greater32[0]);
	assign cmpout[1]=(A == B)?1:0;
	assign cmpout[0]=~cmpout[2]&~cmpout[1];

endmodule
