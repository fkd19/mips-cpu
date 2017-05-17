`timescale 1ns / 1ps
`define F 31:0
`define IDLE 0
`define LOAD 1
`define CNTING 2
`define INT 3 
`define enable 0
`define mode 2:1
`define im 3

module timer(
    input clk,
    input reset,
    input [3:2] addr,
    input WE,
    input [`F] DATA_in,
    output [`F] DATA_out,
    output IRQ);

	reg[`F] ctrl, preset, count, state;
	
	initial begin
		ctrl <= 0;
		preset <= 0;
		count <= 0;
		state <= `LOAD;
	end
	
	always @(posedge clk)begin
		if (reset)begin
			ctrl <= 0;
			preset <= 0;
			count <= 0;
			state <= `LOAD;
		end
		else begin
			if (WE && (addr == 2'd1))	preset <= DATA_in; 
			if (WE && (addr == 2'd0))begin
				ctrl[3:0] <= DATA_in[3:0];
				state <= `LOAD;
			end 
			else begin 
				case(state)	
				`LOAD:		begin	if (ctrl[`enable] == 1)begin	
										state <= `CNTING;	
										count <= preset;	
										end	
								end
							
				`CNTING:		begin if (ctrl[`enable] == 1)	begin 
										count <= count-1;
										if ((count == 1) && (ctrl[`mode] == 0))	begin state <= `INT; 	ctrl[`enable] <= 0;	end
										if ((count == 1) && (ctrl[`mode] == 1))	begin state <= `INT; 	end
									end
								end
								
				`INT:			begin 			
									if (ctrl[`mode] == 1)		begin state <= `CNTING;	count <= preset;			end
								end
				default:		state <= `LOAD;
				endcase
		end
		
		end
	end
	assign IRQ=((ctrl[`im] == 1) && (state == `INT))?1:0;
	assign DATA_out=(addr == 0)?ctrl:
						 (addr == 1)?preset:
						 (addr == 2)?count:32'hbbbb_bbbb;
endmodule
