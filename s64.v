`timescale 1ns / 1ps
`define F 31:0
`define DIP 7:0
`define USER 7:0

//64位开关
module s64_drive(input[`F] addr,
					  input[`DIP] S0, S1, S2, S3, S4, S5, S6, S7,
					  output[`F] dataout);
	
	assign dataout=(addr == 32'h0000_7f2c)?{S3, S2, S1, S0}:
						(addr == 32'h0000_7f30)?{S7, S6, S5, S4}:0;
endmodule

//LED驱动
module LED_drive(input clk, reset,
					  input[`F] data_in,
					  input LED_WE,
					  output[`F] dataout, LED_light);

	reg[`F] LED;
	
	always @(posedge clk)begin
		if (reset)				LED <= 0;
		else if (LED_WE)		LED <= data_in;
	end
	
	assign dataout=LED;
	assign LED_light=~LED;
endmodule

//8位用户按钮
module user_drive(input[`F] addr,
						input[`USER] user_key,//_in,
						output[`F] dataout);
	
	assign dataout=(addr == 32'h0000_7f40)?{24'b0, user_key}:32'b0;
endmodule
