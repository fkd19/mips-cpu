`timescale 1ns / 1ps
`define F 31:0
`define WORD_ADDR 12:2
`define B3 31:24
`define B2 23:16
`define B1 15:8
`define B0 7:0
`define H1 31:16
`define H0 15:0
`define Q1 31:8
`define Q0 23:0

module DM(input clk, reset,
			 input [`F] DM_addr, DM_data_in, DM_data_out,
			 input DM_WE,LR,
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
			if (LR)begin
				case (BYTE_WE)
					4'b0001:		begin mem[DM_addr[`WORD_ADDR]][`B0] <= DM_data_in[`B3];	
											$display("*%h <= %h",DM_addr,DM_data_in[`B3]);	end
					4'b0011:		begin mem[DM_addr[`WORD_ADDR]][`H0] <= DM_data_in[`H1];	
											$display("*%h <= %h",DM_addr,DM_data_in[`H1]);	end
					4'b0111:		begin mem[DM_addr[`WORD_ADDR]][`Q0] <= DM_data_in[`Q1];	
											$display("*%h <= %h",DM_addr,DM_data_in[`Q1]);	end
					4'b1111:		begin mem[DM_addr[`WORD_ADDR]] <= DM_data_in;	
											$display("*%h <= %h",DM_addr,DM_data_in);	end
					4'b1000:		begin mem[DM_addr[`WORD_ADDR]][`B3] <= DM_data_in[`B0];	
											$display("*%h <= %h",DM_addr,DM_data_in[`B0]);	end
					4'b1100:		begin mem[DM_addr[`WORD_ADDR]][`H1] <= DM_data_in[`H0];	
											$display("*%h <= %h",DM_addr,DM_data_in[`H0]);	end
					4'b1110:		begin mem[DM_addr[`WORD_ADDR]][`Q1] <= DM_data_in[`Q0];	
											$display("*%h <= %h",DM_addr,DM_data_in[`Q0]);	end
				endcase
			end
			else if ((BYTE_WE == 4'b1100) || (BYTE_WE == 4'b0011))begin
				mem[DM_addr[`WORD_ADDR]][`H1] <= (BYTE_WE[3:2] == 2'b11)?DM_data_in[`H0]:mem[DM_addr[`WORD_ADDR]][`H1];
				mem[DM_addr[`WORD_ADDR]][`H0] <= (BYTE_WE[1:0] == 2'b11)?DM_data_in[`H0]:mem[DM_addr[`WORD_ADDR]][`H0];
				$display("*%h <= %h",DM_addr,DM_data_in[`H0]);end
			else if ((BYTE_WE == 4'b1000) || (BYTE_WE == 4'b0100) || (BYTE_WE == 4'b0010) || (BYTE_WE == 4'b0001))begin
				mem[DM_addr[`WORD_ADDR]][`B3] <= (BYTE_WE[3])?DM_data_in[`B0]:mem[DM_addr[`WORD_ADDR]][`B3];
				mem[DM_addr[`WORD_ADDR]][`B2] <= (BYTE_WE[2])?DM_data_in[`B0]:mem[DM_addr[`WORD_ADDR]][`B2];
				mem[DM_addr[`WORD_ADDR]][`B1] <= (BYTE_WE[1])?DM_data_in[`B0]:mem[DM_addr[`WORD_ADDR]][`B1];
				mem[DM_addr[`WORD_ADDR]][`B0] <= (BYTE_WE[0])?DM_data_in[`B0]:mem[DM_addr[`WORD_ADDR]][`B0];
				$display("*%h <= %h",DM_addr,DM_data_in[`B0]);end
			else begin
				mem[DM_addr[`WORD_ADDR]] <= DM_data_in;
				$display("*%h <= %h",DM_addr,DM_data_in);end
		end
	end
	
	assign DM_data_out=mem[DM_addr[`WORD_ADDR]];
endmodule
