`timescale 1ns / 1ps
`define F 31:0

module DM(input clk, reset,
			 input [`F] DM_addr, DM_data_in, DM_data_out,
			 input DM_WE);

	reg[`F] mem[1023:0];
	integer i;
	
	initial begin
		for (i=0; i<1024; i=i+1)begin
			mem[i] <= 0;
		end
	end
	
	always @(posedge clk)begin
		if (reset)begin
			for (i=0; i<1024; i=i+1)	mem[i] <= 0;
		end
		else if (DM_WE)begin	
			mem[DM_addr[11:2]] <= DM_data_in;
			$display("*%h <= %h",DM_addr,DM_data_in);
		end
	end
	
	assign DM_data_out=mem[DM_addr[11:2]];
endmodule
