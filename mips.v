`timescale 1ns / 1ps
`define F 31:0
`define DT 7:0
`define DIP 7:0
`define USER 7:0

module mips(input clk_in, sys_rstn, uart_rxd, 
				input[`DIP] dip_switch0, dip_switch1, dip_switch2, dip_switch3, dip_switch4, dip_switch5, dip_switch6, dip_switch7,
				output uart_txd,
				input[`USER] user_key,
				output[`F] led_light, 
				output[`DT] digital_tube0, digital_tube1, digital_tube2,
				output[3:0] digital_tube_sel0, digital_tube_sel1,
				output digital_tube_sel2);
	 
	 wire[`F] bridge_cpu_Rdata,cpu_bridge_Wdata,cpu_bridge_addr,bridge_dev_Wdata, bridge_dev_addr, bridge_uart_addr;
	 wire[`F] timer_bridge_Rdata,urat_bridge_Rdata,s64_bridge_Rdata,LED_bridge_Rdata,DT_bridge_Rdata,user_bridge_Rdata;
	 wire[7:2] bridge_cpu_HWint;
	 wire[`USER] real_user_key;
	 wire cpu_bridge_WE,IRQ, timer_WE, LED_WE, DT_WE, clk1, clk2, urat_WE, reset;
	 assign reset=~sys_rstn;

clk _clk(clk_in, clk1, clk2);

CPU _CPU( clk1, clk2, reset, bridge_cpu_Rdata, bridge_cpu_HWint, cpu_bridge_addr, cpu_bridge_Wdata, cpu_bridge_WE);

bridge _bridge(cpu_bridge_addr, cpu_bridge_Wdata, cpu_bridge_WE, 
					bridge_cpu_HWint, bridge_cpu_Rdata,
					timer_bridge_Rdata,urat_bridge_Rdata,s64_bridge_Rdata,LED_bridge_Rdata,DT_bridge_Rdata,user_bridge_Rdata,
					IRQ,urat_int,
					bridge_dev_Wdata, bridge_dev_addr, timer_WE, LED_WE, DT_WE, urat_WE);

timer _timer(clk1, reset, bridge_dev_addr[3:2], timer_WE, bridge_dev_Wdata, timer_bridge_Rdata, IRQ);
	assign bridge_uart_addr=bridge_dev_addr-32'h0000_7f10;
MiniUART _MiniUART(bridge_uart_addr[4:2], bridge_dev_Wdata, urat_bridge_Rdata, urat_WE,  urat_WE,
						 clk1, sys_rstn, uart_rxd, uart_txd, urat_int);

DT_drive DT(clk1, reset, bridge_dev_Wdata, bridge_dev_addr, DT_WE, DT_bridge_Rdata, 
				digital_tube0, digital_tube1, digital_tube2, digital_tube_sel0, digital_tube_sel1, digital_tube_sel2);

s64_drive _s64(bridge_dev_addr, dip_switch0, dip_switch1, dip_switch2, dip_switch3, dip_switch4,
					dip_switch5, dip_switch6, dip_switch7, s64_bridge_Rdata);
					
LED_drive _LED(clk1, reset, bridge_dev_Wdata, LED_WE, LED_bridge_Rdata, led_light);
	assign real_user_key=~user_key;
user_drive _user(bridge_dev_addr, real_user_key, user_bridge_Rdata);
endmodule
	
