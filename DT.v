`timescale 1ns / 1ps
`define F 31:0
`define DT 7:0
`define AA 0
`define BB 1
`define CC 2
`define DD 3
`define PRESET 18'd100000

//八位LED显示十六进制数，分为左右两组，一组四个数。在计数器模式下，每次每组只显示1个数，0.1秒内遍历一次所有的LED管，形成八只LED同时发光的效果
module DT_drive(input clk, reset,
					  input [`F] DT_data_in, addr, 
					  input DT_WE,
					  output[`F] DT_data_out,
					  output [`DT] tube0_print, tube1_print, tube2_print,
					  output [3:0] sel0, sel1,
					  output sel2);

	reg[`F] SIGN, DATA;
	reg[17:0] count;
	reg[1:0] state;
	wire[`DT] N0,N1,N2,N3,N4,N5,N6,N7,SG;
	wire[`DT] N0_0,N1_0,N2_0,N3_0,N4_0,N5_0,N6_0,N7_0;
	wire[`DT] N0_1,N1_1,N2_1,N3_1,N4_1,N5_1,N6_1,N7_1;
	wire[`F] N_DATA;
	
	always @(posedge clk)begin
		if (reset)begin
			count <= `PRESET;
			{SIGN,DATA} <= 0;
		end
		else if (DT_WE)begin
			SIGN <=(addr == 32'h0000_7f38)?DT_data_in:SIGN;
			DATA <=(addr == 32'h0000_7f3c)?DT_data_in:DATA;
		end
		
		//实现扫描
		case(state)
			`AA:		begin if (count ==0)begin state <= `BB; count <= `PRESET; end
						else count <= count - 1; end
			`BB:		begin if (count ==0)begin state <= `CC; count <= `PRESET; end
						else count <= count - 1; end
			`CC:		begin if (count ==0)begin state <= `DD; count <= `PRESET; end
						else count <= count - 1; end
			`DD:		begin if (count ==0)begin state <= `AA; count <= `PRESET; end
						else count <= count - 1; end
			default:	begin state <= `AA; count <= `PRESET; end
		endcase
	end
	
DT_decoder _N0(DATA[3:0]  , N0_0);
DT_decoder _N1(DATA[7:4]  , N1_0);
DT_decoder _N2(DATA[11:8] , N2_0);
DT_decoder _N3(DATA[15:12], N3_0);
DT_decoder _N4(DATA[19:16], N4_0);
DT_decoder _N5(DATA[23:20], N5_0);
DT_decoder _N6(DATA[27:24], N6_0);
DT_decoder _N7(DATA[31:28], N7_0);

	assign N_DATA=(~DATA) + 1;

DT_decoder _N0_(N_DATA[3:0]  , N0_1);
DT_decoder _N1_(N_DATA[7:4]  , N1_1);
DT_decoder _N2_(N_DATA[11:8] , N2_1);
DT_decoder _N3_(N_DATA[15:12], N3_1);
DT_decoder _N4_(N_DATA[19:16], N4_1);
DT_decoder _N5_(N_DATA[23:20], N5_1);
DT_decoder _N6_(N_DATA[27:24], N6_1);
DT_decoder _N7_(N_DATA[31:28], N7_1);
	
	//正负数显示方式不一样，要判断一下
	assign {N0,N1,N2,N3,N4,N5,N6,N7}=(DATA[31] == 0)?{N0_0,N1_0,N2_0,N3_0,N4_0,N5_0,N6_0,N7_0}:
													 {N0_1,N1_1,N2_1,N3_1,N4_1,N5_1,N6_1,N7_1};
	//SG是正负号
	assign SG=reset?8'b1000_0001:
				 DATA[31]?8'b1111_1110:8'b1111_1111;
	assign sel0=(state == `AA)?4'b1000:
				(state == `BB)?4'b0100:
				(state == `CC)?4'b0010:4'b0001;
	assign sel1=sel0;
	assign sel2=1;
	assign DT_data_out=(addr == 32'h0000_7f38)?SIGN:
						(addr == 32'h0000_7f3c)?DATA:0;
	assign {tube0_print, tube1_print} = (state == `AA)?{N3, N7}:
										(state == `BB)?{N2, N6}:
										(state == `CC)?{N1, N5}:
										(state == `DD)?{N0, N4}:16'b1000_0001_1000_0001;
	assign tube2_print = SG;
endmodule

//将4位二进制数转化为晶体管对应管亮灯的信号
module DT_decoder(input[3:0] num, output[`DT] drive_signal);
	assign drive_signal=(num == 4'h1)?8'b1100_1111:
						(num == 4'h2)?8'b1001_0010:
						(num == 4'h3)?8'b1000_0110:
						(num == 4'h4)?8'b1100_1100:
						(num == 4'h5)?8'b1010_0100:
						(num == 4'h6)?8'b1010_0000:
						(num == 4'h7)?8'b1000_1111:
						(num == 4'h8)?8'b1000_0000:
						(num == 4'h9)?8'b1000_0100:
						(num == 4'ha)?8'b1000_1000:
						(num == 4'hb)?8'b1110_0000:
						(num == 4'hc)?8'b1011_0001:
						(num == 4'hd)?8'b1100_0010:
						(num == 4'he)?8'b1011_0000:
						(num == 4'hf)?8'b1011_1000:8'b1000_0001;
endmodule
