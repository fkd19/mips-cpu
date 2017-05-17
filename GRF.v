`timescale 1ns / 1ps
`define F 31:0

module GRF(input clk, reset,
			  input [4:0] Rreg1, Rreg2, Wreg,
			  input [`F] Wdata,
			  input GRF_WE,
			  output [`F] Rdata1, Rdata2);

	reg[`F] _reg[`F];
	reg[`F] Rdata1;
	reg[`F] Rdata2;
	integer i;
	
	initial begin
		for (i=0; i<32; i=i+1)begin
			_reg[i]=0;
		end
	end
	
	always @(posedge clk) begin
		if(reset)begin
			for (i=0; i<32; i=i+1)begin
				_reg[i]=0;
			end
		end
		else if (GRF_WE)begin
			_reg[Wreg] <= Wdata;
			$display("$%d <= %h",Wreg,Wdata);
		end
	end

	always @(*)begin
		if (Rreg1 == 0)						Rdata1 <= 0;
		else if (GRF_WE && (Wreg == Rreg1))	Rdata1 <= Wdata;
		else 										Rdata1 <= _reg[Rreg1];
	end
	
	always @(*)begin
		if (Rreg2 == 0)						Rdata2 <= 0;
		else if (GRF_WE && (Wreg == Rreg2))	Rdata2 <= Wdata;
		else 										Rdata2 <= _reg[Rreg2];
	end
endmodule
