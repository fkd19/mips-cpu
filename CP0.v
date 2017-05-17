`timescale 1ns / 1ps
`define F 31:0

module CP0(input clk,reset,
			  input[4:0] CP0_RWreg,
			  input[`F] CP0_Wdata,PC,
			  input[7:2] HWint,
			  input CP0_WE,EXL_clr,
			  output int_clr,
			  output[`F] EPC,CP0_Dataout);

	reg[`F] epc;
	reg[15:10] im;
	reg exl, ie; 
	reg [7:2] hw_pend;
	
 	initial begin
		im <= 6'b111111;
		exl <= 0;
		ie <= 1;
		hw_pend <= 0;
		epc <= 0;
	end
	
	always @(posedge clk)begin
		if (reset)begin
			im <= 6'b111111;
			exl <= 0;
			ie <= 1;
			hw_pend <= 0;
			epc <= 0;
		end
		else if (int_req)begin
			hw_pend <= HWint & im;
			epc <= PC;
			exl <= 1;
		end
		else if (CP0_WE && (CP0_RWreg == 5'd12))	{im,exl,ie} <= {CP0_Wdata[15:10],CP0_Wdata[1],CP0_Wdata[0]};
		else if (CP0_WE && (CP0_RWreg == 5'd14))	epc <= CP0_Wdata;	
		else if (EXL_clr)		exl <= 1'b0;	
	end

	assign EPC=epc;
	assign int_req=|(HWint&im)&ie&~exl;
	assign CP0_Dataout=(CP0_RWreg == 12)?{16'b0, im, 8'b0, exl, ie}:
							 (CP0_RWreg == 13)?{16'b0, hw_pend, 10'b0}:
							 (CP0_RWreg == 14)?EPC:
							 (CP0_RWreg == 15)?32'hDC512320:0;
	assign int_clr=int_req?1'b1:1'b0;
endmodule
