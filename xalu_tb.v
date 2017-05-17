`timescale 1ns / 1ps

module xalu_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0]XALU_OP;
	reg HI_WE;
	reg LO_WE;
	reg XALUOUT_sel;
	reg [31:0] A;
	reg [31:0] B;
	reg [31:0] XALU_Wdata;

	// Outputs
	wire [31:0] XALUOUT;
	wire BUSY;

	// Instantiate the Unit Under Test (UUT)
	XALU uut (
		.clk(clk), 
		.reset(reset), 
		.XALU_OP(XALU_OP), 
		.HI_WE(HI_WE), 
		.LO_WE(LO_WE), 
		.XALUOUT_sel(XALUOUT_sel), 
		.A(A), 
		.B(B), 
		.XALU_Wdata(XALU_Wdata), 
		.XALUOUT(XALUOUT), 
		.BUSY(BUSY)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		XALU_OP = 0;
		HI_WE = 0;
		LO_WE = 0;
		XALUOUT_sel = 0;
		A = 0;
		B = 0;
		XALU_Wdata = 0;

		#20;
		XALU_OP=1;
		A=32'h0000_1234;
		B=32'HCABB_FCA8;
		#60;
		XALU_OP=2;
		B=32'h0000_1234;
		A=32'HCABB_FCA8;
		#60;
		XALU_OP=4;
		B=32'h0000_1234;
		A=32'HCABB_FCA8;
		#110;
		XALU_OP=8;
		#110;
		reset=1;
		#10;
		reset=0;
		#10;
		HI_WE=1;
		XALU_Wdata = 32'H1234;
		#20;
		HI_WE=0;
		LO_WE=1;
		XALU_Wdata = 32'H5678;
		#30;
		XALUOUT_sel = 1;
	end
      always #5 clk=~clk;
endmodule

