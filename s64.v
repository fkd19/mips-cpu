`timescale 1ns / 1ps
`define F 31:0
`define DIP 7:0
`define USER 7:0

module s64_drive(input[`F] addr,
					  input[`DIP] S0, S1, S2, S3, S4, S5, S6, S7,
					  output[`F] dataout);
	/*
	reg[`DIP] S7, S6, S5, S4, S3, S2, S1, S0;
	
	always @(posedge clk)begin
		if (reset)	{S7, S6, S5, S4, S3, S2, S1, S0} <= 0;
		else {S7, S6, S5, S4, S3, S2, S1, S0} <= {S0_in, S1_in, S2_in, S3_in, S4_in, S5_in, S6_in, S7_in};
	end
	*/
	assign dataout=(addr == 32'h0000_7f2c)?{S3, S2, S1, S0}:
						(addr == 32'h0000_7f30)?{S7, S6, S5, S4}:0;
endmodule

module LED_drive(input clk, reset,
					  input[`F] data_in,
					  input LED_WE,
					  output[`F] dataout, LED_light);

	reg[`F] LED;
	/*
	initial begin
		LED <= 0;
	end
	*/
	always @(posedge clk)begin
		if (reset)				LED <= 0;
		else if (LED_WE)		LED <= data_in;
	end
	
	assign dataout=LED;
	assign LED_light=~LED;
endmodule

module user_drive(input[`F] addr,
						input[`USER] user_key,//_in,
						output[`F] dataout);
	/*
	reg[`USER] user_key;
	
	always @(posedge clk)begin
		if (reset)	user_key <= 0;
		else 			user_key <= user_key_in;
	end
	*/
	assign dataout=(addr == 32'h0000_7f40)?{24'b0, user_key}:32'b0;
endmodule
