`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:31:33 10/22/2016 
// Design Name: 
// Module Name:    fsm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fsm(
    input Clk,
    input Clr,
    input X,
    output Z
    );

	parameter s0=4'b0001,
			  s1=4'b0010,
		      s2=4'b0100,
			  s3=4'b1000;
	reg[3:0] state;
	reg Z;
	
	//initial section
	initial begin
		state <= s0;
		Z <= 0;
	end
	
	//convert section
	always @(posedge Clk or posedge Clr)begin
		if (Clr)
			state <= s0;
		else begin
			case(state)
				s0:if (~X)		state <= s0;//x=0
					else			state <= s1;//x=1
				s1:if (~X)		state <= s2;
					else			state <= s1;
				s2:if (~X)		state <= s0;
					else			state <= s3;
				s3:if (~X)		state <= s2;
					else			state <= s1;
				default:			state <= s0;
			endcase
		end//end of else begin
	end//end of always begin
		
		//display section
		always @(state)begin
			case(state)
				s0:Z <= 1'b0;
				s1:Z <= 1'b0;
				s2:Z <= 1'b0;
				s3:Z <= 1'b1;
				default:Z <= 1'b0;
			endcase
		end//end of always begin
endmodule
