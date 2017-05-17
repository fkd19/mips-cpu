`timescale 1ns / 1ps
`define F 31:0
`define H 15:0

module bridge(input[`F]  CPU_addr,CPU_Wdata,
				  input CPU_WE,
				  output[7:2] CPU_HWint,
				  output[`F] CPU_Rdata,
				  input[`F] timer_Rdata, URAT_Rdata, s64_Rdata, LED_Rdata, DT_Rdata, user_Rdata,
				  input IRQ, urat_int,
				  output[`F] DEV_Wdata, DEV_addr,
				  output timer_WE, LED_WE, DT_WE, urat_WE);
				  
	assign DEV_Wdata=CPU_Wdata;
	assign DEV_addr=CPU_addr;
	assign CPU_HWint={4'b0,urat_int,IRQ};
	assign timer_WE=((CPU_addr[15:4] == 12'h7f0) && CPU_WE)?1'b1:1'b0;
	assign DT_WE=(((CPU_addr[`H] == 16'h7f38) || (CPU_addr[`H] == 16'h7f3c)) && CPU_WE)?1'b1:1'b0;
	assign LED_WE=((CPU_addr[`H] == 16'h7f34) && CPU_WE)?1'b1:1'b0;
	assign urat_WE=((CPU_addr[`H] >= 16'h7f10) && (CPU_addr[`H] <= 16'h7f2b) && CPU_WE)?1'b1:1'b0;
	assign CPU_Rdata=((CPU_addr[`H] >= 16'h7f00) && (CPU_addr[`H] <= 16'h7f0b))?timer_Rdata:
						  ((CPU_addr[`H] >= 16'h7f10) && (CPU_addr[`H] <= 16'h7f2b))?URAT_Rdata:
						  ((CPU_addr[`H] == 16'h7f2c) || (CPU_addr[`H] == 16'h7f30))?s64_Rdata:
						  (CPU_addr[`H] == 16'h7f34)?LED_Rdata:
						  ((CPU_addr[`H] == 16'h7f38) || (CPU_addr[`H] == 16'h7f3c))?DT_Rdata:
						  (CPU_addr[`H] == 16'h7f40)?user_Rdata:32'hffff_ffff;
endmodule
