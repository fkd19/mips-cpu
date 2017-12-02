`timescale 1ns / 1ps
`include <head.h>

module MUX_FORWARD_D(input [`F] PRE, ALUOUT_M, PC8_M, XALUOUT_M, ALUOUT_MMID, PC8_MMID, XALUOUT_MMID,
							input [2:0] Forward_sel,
							output [`F] sel_result);

	assign sel_result=(Forward_sel == 3'd1)?ALUOUT_M:
				      (Forward_sel == 3'd2)?PC8_M:
                      (Forward_sel == 3'd3)?XALUOUT_M:
                      (Forward_sel == 3'd4)?ALUOUT_MMID:
                      (Forward_sel == 3'd5)?PC8_MMID:
                      (Forward_sel == 3'd6)?XALUOUT_MMID:PRE;
endmodule

module MUX_FORWARD_E(input [`F] PRE, ALUOUT_M, mux_Wdata, PC8_M, PC8_W, XALUOUT_M, XALUOUT_W, ALUOUT_MMID, PC8_MMID, XALUOUT_MMID,
							input [3:0] Forward_sel,
							output [`F] sel_result);

	 assign sel_result=  (Forward_sel == 4'd1)?ALUOUT_M:
                         (Forward_sel == 4'd2)?mux_Wdata:
                         (Forward_sel == 4'd3)?PC8_M:
                         (Forward_sel == 4'd4)?PC8_W:
                         (Forward_sel == 4'd5)?XALUOUT_M:
                         (Forward_sel == 4'd6)?XALUOUT_W:
                         (Forward_sel == 4'd7)?ALUOUT_MMID:
                         (Forward_sel == 4'd8)?PC8_MMID:
                         (Forward_sel == 4'd9)?XALUOUT_MMID:PRE;
endmodule

module MUX_FORWARD_M_2_HALF(input [`F] PRE, mux_Wdata, PC8_W, XALUOUT_W,
							input [1:0]  Forward_sel,
							output [`F] sel_result);

	 assign sel_result=(Forward_sel == 2'd1)?mux_Wdata:
                         (Forward_sel == 2'd2)?PC8_W:
                         (Forward_sel == 2'd3)?XALUOUT_W:PRE;
endmodule
 