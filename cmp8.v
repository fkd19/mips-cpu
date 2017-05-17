`timescale 1ns / 1ps

module cmp8(
    input [7:0] d1,
    input [7:0] d2,
    output greater,
	 output equal
    );
	 
	 wire[1:0] greater8;
	 wire[1:0] equal8;
	 cmp4 cmp7_4(d1[7:4], d2[7:4], greater8[1], equal8[1]);
	 cmp4 cmp3_0(d1[3:0], d2[3:0], greater8[0], equal8[0]);
	 
	 assign greater=greater8[1]|(equal8[1]&greater8[0]);
	 assign equal=&equal8;
endmodule
