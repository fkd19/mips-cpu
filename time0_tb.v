`timescale 1ns / 1ps

module time0_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [3:2] addr;
	reg WE;
	reg [31:0] DATA_in;

	// Outputs
	wire [31:0] DATA_out;
	wire IRQ;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.clk(clk), 
		.reset(reset), 
		.addr(addr), 
		.WE(WE), 
		.DATA_in(DATA_in), 
		.DATA_out(DATA_out), 
		.IRQ(IRQ)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		addr = 0;
		WE = 0;
		DATA_in = 32'h10;

		#10;
		WE=1;
		addr=1;
		#10;
		addr=0;
		DATA_in=32'b1001;
		#10;
		WE=0;
		#400;
		WE=1;
		addr=0;
		DATA_in=32'b0000;
		#20;
		WE=0;
		
		#100;
		WE=1;
		addr=0;
		DATA_in=32'b1011;
		#20;
		WE=0;

	end
      always #5 clk=~clk;

      
endmodule

