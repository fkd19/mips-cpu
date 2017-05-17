`timescale 1ns / 1ps

module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output [31:0] C,
	 output [2:0] zero
    );
	reg[31:0] C;
	 wire cout1;
	 wire cout2;
	 wire[31:0] c1;
	 wire[31:0] c2;
	 wire[31:0] c3;
	 wire[31:0] c4;
	 wire[31:0] c5;
	 
	 assign {cout1,c1}=A+B;
	 assign {cout2,c2}=A-B;
	 assign c3=A&B;
	 assign c4=A|B;
	 assign c5[31:16]=B[15:0];
	 assign c5[15:0]=16'h0000;
	 assign zero[2]=(A > B)?1:0;
	 assign zero[1]=(A == B)?1:0;
	 assign zero[0]=(A < B)?1:0;
	 always @(*) begin
	case(ALUOp)
		3'b000:  C=c1;
		3'b001:  C=c2;
		3'b010:  C=c3;
		3'b011:  C=c4;
		3'b100:	C=c5;
	endcase
	end

endmodule
