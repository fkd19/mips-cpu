`timescale 1ns / 1ps
`define F 31:0

module CP0(input clk,reset,
			  input[4:0] CP0_RWreg,
			  input[`F] CP0_Wdata,PC,
			  input[6:2] EXC_code_in,
			  input[7:2] HWint,
			  input CP0_WE,EXL_clr,
			  output int_clr,
			  output[`F] EPC,CP0_Dataout);

	reg[`F] EPC,PRID;
	reg[15:10] im;
	reg exl, ie; 
	reg [7:2] hw_pend;
	reg [6:2] EXC_code;
	
 	initial begin
		im <= 6'b111111;
		exl <= 0;
		ie <= 1;
		hw_pend <= 0;
		EXC_code <= 0;
		EPC <= 0;
		PRID <= 32'hDC512320;
	end
	
	always @(posedge clk)begin
		if (reset)begin
			im <= 6'b111111;
			exl <= 0;
			ie <= 1;
			hw_pend <= 0;
			EXC_code <= 0;
			EPC <= 0;
		end
		else if (int_req)begin
			hw_pend <= HWint & im;
			EXC_code <= 0;
			EPC <= PC;
			exl <= 1;
		end
		else if (|EXC_code)begin
			hw_pend <= 0;
			EXC_code <= EXC_code_in;
			EPC <= PC;
			exl <= 1;
		end
		else if(CP0_WE)begin
				case(CP0_RWreg)
					5'd12:	{im,exl,ie} <= {CP0_Wdata[15:10],CP0_Wdata[1],CP0_Wdata[0]};
					5'd14:	EPC <= CP0_Wdata;	
					default:	PRID <= 32'hDC512320;
				endcase
			end
		else if (EXL_clr)		exl <= 1'b0;	
	end

	assign int_req=|(HWint&im)&ie&~exl;
	assign CP0_Dataout=(CP0_RWreg == 12)?{16'b0, im, 8'b0, exl, ie}:
							 (CP0_RWreg == 13)?{16'b0, hw_pend, 3'b0, EXC_code, 2'b0}:
							 (CP0_RWreg == 14)?EPC:
							 (CP0_RWreg == 15)?PRID:0;
	assign int_clr=(int_req || EXC_code)?1:0;
endmodule
