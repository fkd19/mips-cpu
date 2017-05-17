`timescale 1ns / 1ps
`define F 31:0
`define ExcCode 6:2
module mips(input clk,
				input reset);
	 
	 wire[`F] bridge_cpu_Rdata,cpu_bridge_Wdata,cpu_bridge_addr,timer0_bridge_Rdata,timer1_bridge_Rdata,bridge_dev_Wdata;
	 wire[1:0] bridge_dev_addr;
	 wire[7:2] bridge_cpu_HWint;
	 wire cpu_bridge_WE,IRQ0,IRQ1, timer0_WE, timer1_WE;
	 wire[3:0] cpu_bridge_BE;
CPU _CPU(clk, reset, bridge_cpu_Rdata, bridge_cpu_HWint, cpu_bridge_addr, cpu_bridge_Wdata, cpu_bridge_WE);

bridge _bridge(cpu_bridge_addr, cpu_bridge_Wdata, cpu_bridge_WE, 
					bridge_cpu_HWint, bridge_cpu_Rdata,
					timer0_bridge_Rdata, timer1_bridge_Rdata, IRQ0, IRQ1,
					bridge_dev_Wdata, bridge_dev_addr, timer0_WE, timer1_WE);

timer time0(clk, reset, bridge_dev_addr, timer0_WE, bridge_dev_Wdata, timer0_bridge_Rdata, IRQ0);
timer time1(clk, reset, bridge_dev_addr, timer1_WE, bridge_dev_Wdata, timer1_bridge_Rdata, IRQ1);
endmodule
	
