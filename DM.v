`timescale 1ns / 1ps

module DM(
    input [31:0] memaddr,
    input [31:0] memdata,
    output [31:0] memout,
    input memread,
    input memwrite,
    input reset,
	 input clk
    );

	reg[31:0] mem[1023:0];
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
		else if (memwrite)begin	
			mem[memaddr[11:2]] <= memdata;
			$display("*%h <= %h",memaddr,memdata);
		end
	end
	
	assign memout=(memread)?mem[memaddr[11:2]]:0;
endmodule
