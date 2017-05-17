`timescale 1ns / 1ps
`define F 31:0

module GRF(input clk, reset,
			  input [4:0] Rreg1, Rreg2, Wreg,
			  input [`F] Wdata,
			  input GRF_WE,
			  output [`F] Rdata1, Rdata2);

	reg[`F] _reg[`F];
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
	
	assign Rdata1=(Rreg1 == 0)?0:
					  (GRF_WE && (Wreg == Rreg1))?Wdata:_reg[Rreg1];
	assign Rdata2=(Rreg2 == 0)?0:
					  (GRF_WE && (Wreg == Rreg2))?Wdata:_reg[Rreg2];
endmodule
