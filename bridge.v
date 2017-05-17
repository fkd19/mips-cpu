`timescale 1ns / 1ps
`define F 31:0

module bridge(input[`F]  CPU_addr,CPU_Wdata,
				  input CPU_WE,
				  output[7:2] CPU_HWint,
				  output[`F] CPU_Rdata,
				  input[`F] time0_Rdata,time1_Rdata,
				  input IRQ0,IRQ1,
				  output[`F] DEV_Wdata,
				  output[1:0] DEV_addr,
				  output timer0_WE,timer1_WE);
				  
	assign DEV_Wdata=CPU_Wdata;
	assign DEV_addr=CPU_addr[3:2];
	assign CPU_HWint={0,0,0,0,IRQ1,IRQ0};
	assign timer0_WE=((CPU_addr[15:4] == 12'h7f0) && CPU_WE)?1:0;
	assign timer1_WE=((CPU_addr[15:4] == 12'h7f1) && CPU_WE)?1:0;
	assign CPU_Rdata=(CPU_addr[15:4] == 12'h7f0)?time0_Rdata:
						  (CPU_addr[15:4] == 12'h7f1)?time1_Rdata:32'hffff_ffff;
endmodule
