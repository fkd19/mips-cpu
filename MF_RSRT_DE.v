`timescale 1ns / 1ps
`define F 31:0

//所有的转发mux，最后一位字母表示是哪一级的mux
module MUX_FORWARD_D(input [`F] PRE, ALUOUT_M, PC8_M,
							input [1:0] Forward_sel,
							output [`F] sel_result);

	assign sel_result=(Forward_sel == 1)?ALUOUT_M:
							(Forward_sel == 2)?PC8_M:PRE;
endmodule

module MUX_FORWARD_E(input [`F] PRE, ALUOUT_M, mux_Wdata, PC8_M, PC8_W,
							input [2:0] Forward_sel,
							output [`F] sel_result);

	 assign sel_result=(Forward_sel == 1)?ALUOUT_M:
							 (Forward_sel == 2)?mux_Wdata:
							 (Forward_sel == 3)?PC8_M:
							 (Forward_sel == 4)?PC8_W:PRE;
endmodule

module MUX_FORWARD_M(input [`F] PRE, mux_Wdata, PC8_W,
							input [1:0]  Forward_sel,
							output [`F] sel_result);

	 assign sel_result=(Forward_sel == 1)?mux_Wdata:
			  				 (Forward_sel == 2)?PC8_W:PRE;
endmodule
 
