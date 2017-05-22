`timescale 1ns / 1ps
`define F 31:0
`define WORD_ADDR 11:2
`define B3 31:24
`define B2 23:16
`define B1 15:8
`define B0 7:0
`define H1 31:16
`define H0 15:0

module DM(input clk, reset,
	  		input [`WORD_ADDR] DM_addr, 
	  		input [`F] DM_data_in, 
	  		output[`F] DM_data_out,
	  		input DM_WE,
	  		input[3:0] BYTE_WE);

	reg[`F] mem[2047:0];
	integer i;
	
	initial begin
		for (i=0; i<2048; i=i+1)begin
			mem[i] <= 0;
		end
	end
	
	always @(posedge clk)begin
		if (reset)begin
			for (i=0; i<2048; i=i+1)	mem[i] <= 0;
		end
		else if (DM_WE)begin
			case(BYTE_WE)
				4'b0001:		mem[DM_addr[`WORD_ADDR]][`B0] <= DM_data_in[`B0];
				4'b0010:		mem[DM_addr[`WORD_ADDR]][`B1] <= DM_data_in[`B0];
				4'b0100:		mem[DM_addr[`WORD_ADDR]][`B2] <= DM_data_in[`B0];
				4'b1000:		mem[DM_addr[`WORD_ADDR]][`B3] <= DM_data_in[`B0];
				4'b0011:		mem[DM_addr[`WORD_ADDR]][`H0] <= DM_data_in[`H0];
				4'b1100:		mem[DM_addr[`WORD_ADDR]][`H1] <= DM_data_in[`H0];
				default:		mem[DM_addr[`WORD_ADDR]] <= DM_data_in;
			endcase
		end
	end
	
	assign DM_data_out=mem[DM_addr[`WORD_ADDR]];
endmodule
