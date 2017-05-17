`timescale 1ns / 1ps

module GRF(
    input clk,
	 input reset,
    input [4:0] Rreg1,
    input [4:0] Rreg2,
    input [4:0] Wreg,
    input [31:0] Wdata,
    input we,
    output [31:0] Rdata1,
    output [31:0] Rdata2
    );

	reg[31:0] _reg[31:0];
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
		else if (we)begin
			_reg[Wreg] <= Wdata;
			$display("$%d <= %h",Wreg,Wdata);
		end
	end
	assign Rdata1=(Rreg1 == 0)?0:_reg[Rreg1];
	assign Rdata2=(Rreg2 == 0)?0:_reg[Rreg2];

endmodule
