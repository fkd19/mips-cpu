`timescale 1ns / 1ps

module mux1(
    input [4:0] rt,
    input [4:0] rd,
    input[1:0] RegDst,
	 output [4:0] Wreg
    );

	reg[4:0] Wreg;
	always @(*)begin
		case(RegDst)
			2'b00:	Wreg=rt;
			2'b01:	Wreg=rd;
			2'b10:	Wreg=31;
		endcase
	end
endmodule

module mux2(input [31:0] Rdata2,
    input [31:0] ext,
    input AluSrc,
	 output [31:0] AluB
	 );
	assign AluB=(!AluSrc)?Rdata2:ext;
endmodule

module mux3(input [31:0] aluout,
    input [31:0] dmout,
	 input[31:0] cpc_4,
	 input[31:0] s_value,
    input[1:0] MemToReg,
	 output [31:0] Wdata
	 );
	
	reg[31:0] Wdata;
	always @(*)begin
		case(MemToReg)
			2'b00:	Wdata=aluout;
			2'b01:	Wdata=dmout;
			2'b10:	Wdata=cpc_4;
			2'b11:	Wdata=s_value;
		endcase
	end
	
endmodule

module mux5(input[31:0] cpc_4,
	 input[31:0] Naddout,
	 input[31:0] jtgt,
	 input[31:0] Rdata1,
	 input[1:0] PCsrc,
	 output[31:0] npc
	 );
	 
	 reg[31:0] npc;
	always @(*) begin
		case(PCsrc)
			2'b00:	npc=cpc_4;
			2'b01:	npc=Naddout;
			2'b10:	npc=jtgt;
			2'b11:	npc=Rdata1;
		endcase
	end
	
endmodule

module mux6(
);

endmodule
