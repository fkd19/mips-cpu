`timescale 1ns / 1ps
`define F 31:0
`define s0 0
`define s1 1
`define s2 2
`define s3 3
`define s4 4
`define s5 5
`define s6 6
`define s7 7
`define s8 8
`define s9 9
`define s10 10

module XALU(input clk,reset,HI_WE,LO_WE,XALUOUT_sel,
				input[3:0] XALU_OP,
				input[`F] A,B,XALU_Wdata,
				output[`F] XALUOUT,
				output BUSY);

		reg[`F] HI,LO;
		reg[3:0] state,tag;
		wire signed [63:0] sign_mul_res;
		wire unsigned [63:0] unsign_mul_res;
		wire signed [`F] sign_div_hi,sign_div_lo;
		wire unsigned [`F] unsign_div_hi,unsign_div_lo;
		
		assign sign_mul_res  =(BUSY && ~(|XALU_OP))?sign_mul_res  :($signed(A) * $signed(B));
		assign unsign_mul_res=(BUSY && ~(|XALU_OP))?unsign_mul_res:(A * B);
		assign sign_div_hi   =(BUSY && ~(|XALU_OP))?sign_div_hi   :($signed(A) % $signed(B));
		assign unsign_div_hi =(BUSY && ~(|XALU_OP))?unsign_div_hi :(A % B);
		assign sign_div_lo   =(BUSY && ~(|XALU_OP))?sign_div_lo   :($signed(A) / $signed(B));
		assign unsign_div_lo =(BUSY && ~(|XALU_OP))?unsign_div_lo :(A / B);
		
		initial begin
			tag <= 0;
			state <= `s0;
			HI <= 0;
			LO <= 0;
		end
		
		always @(posedge clk)begin
			if (reset)begin
				HI <= 0;
				LO <= 0;
				tag <= 0;
				state <= `s0;
			end
			else begin
				case(state)
					`s0:	begin 
							state <=((XALU_OP == 1)|(XALU_OP == 2)|(XALU_OP == 5)
									  |(XALU_OP == 6)|(XALU_OP == 7)|(XALU_OP == 8))?`s6:
									  ((XALU_OP == 3)|(XALU_OP == 4))?`s1:`s0;
							tag <=XALU_OP;
						end
					`s1:	state <= `s2;
					`s2:	state <= `s3;
					`s3:	state <= `s4;
					`s4:	state <= `s5;
					`s5:	state <= `s6;
					`s6:	state <= `s7;
					`s7:	state <= `s8;
					`s8:	state <= `s9;
					`s9:	begin state <= `s0;	
								tag <= 0;
								{HI,LO} <=(tag == 1)?sign_mul_res:
											 (tag == 2)?unsign_mul_res:
											 (tag == 3)?{sign_div_hi,sign_div_lo}:
											 (tag == 4)?{unsign_div_hi,unsign_div_lo}:
											 (tag == 5)?({HI,LO}+sign_mul_res):
											 (tag == 6)?({HI,LO}+unsign_mul_res):
											 (tag == 7)?({HI,LO}-sign_mul_res):
											 (tag == 8)?({HI,LO}-unsign_mul_res):{HI,LO};	end
					default: begin state <= `s0;	tag <= 0;	end
				endcase
				if (state != `s9)begin
					HI <=(HI_WE)?XALU_Wdata:HI;
					LO <=(LO_WE)?XALU_Wdata:LO;
				end
			end
		end
		
		assign BUSY=((state != `s0) || XALU_OP)?1:0;
		assign XALUOUT=(XALUOUT_sel == 0)?HI:LO;
endmodule
