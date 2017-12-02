`timescale 1ns / 1ps
`define F 31:0
`define EXC 6:2
`define IM 15:10
`define IP 9:8
`define EXL 1
`define IE 0
`define BD 31
`define HW_PEND 15:10
`define SW_PEND 9:8

module CP0(input clk,reset,SL,epc_sel,
	   input [4:0] 	CP0_RWreg,
	   input [`F] 	CP0_Wdata,PC,Bad_PC8,Bad_addr,
	   input [7:2] 	HWint,
	   input 	CP0_WE,EXL_clr,
	   output 	int_clr,
	   output [`F] 	EPC,CP0_Dataout,
           input [`EXC] Exc_in);

   reg 			add_en;   
   reg [`F] 		bad_Vaddr, sr, cause, epc,cr_count; //8,12,13,14ºÅ¼Ä´æÆ÷
   wire 		int_req;
   wire [`F] 		bad_PC;
   wire 		exception;      

   always @(posedge clk)begin
      if (reset)begin
             sr[1:0] <= 2'b01;          //12
             cause <= 0;                   //13
             epc <= 0;
             cr_count <= 0;
      end
      else if (int_req)begin
             cause[`HW_PEND] <= HWint & sr[`IM];
             epc <= PC;
             sr[`EXL] <= 1;
             cause[`EXC] <= 0;
      end
      else if(exception)begin
             sr[`EXL] <= 1;
             //epc <= (Exc_in == 5'd8 || Exc_in == 5'd9)?PC+4:PC;
             epc <= PC;
	         if(Exc_in==4 && ~SL)begin
                    bad_Vaddr <= bad_PC;
	         end
	         else if((Exc_in==4 && SL) || Exc_in==5)begin
                    bad_Vaddr <= Bad_addr;
	         end
             cause[`EXC] <= Exc_in;
             cause[`BD] <= epc_sel;
      end
      else if (CP0_WE && (CP0_RWreg == 5'd12))	sr[15:0] <= {CP0_Wdata[15:8],6'b0,CP0_Wdata[1:0]};
      else if (CP0_WE && (CP0_RWreg == 5'd13))	cause[9:8] <= CP0_Wdata[9:8];
      else if (CP0_WE && (CP0_RWreg == 5'd14))	epc <= CP0_Wdata;
      else if (CP0_WE && (CP0_RWreg == 5'd9))   cr_count <= CP0_Wdata;      
      else if (EXL_clr)		 sr[`EXL] <= 1'b0;	
      
      if(reset)begin
       	    add_en <= 0;
       	    cr_count <= 0;
      end
      else begin
            if (add_en)     cr_count <= cr_count + 1;
            add_en <= ~add_en;
      end
   end

   assign EPC=epc;
   assign bad_PC=Bad_PC8-32'd8;
   assign int_req=|((HWint & sr[`IM]) | (|(cause[`SW_PEND] & sr[`IP]))) & sr[`IE] & ~sr[`EXL];
   assign exception = ~int_req & ~sr[`EXL] & (Exc_in!=0);
   assign CP0_Dataout=(CP0_RWreg == 12)?sr:
		      (CP0_RWreg == 13)?cause:
		      (CP0_RWreg == 14)?epc:
		      (CP0_RWreg == 8)?bad_Vaddr:
		      (CP0_RWreg == 9)?cr_count : 0;
   
   assign int_clr = (int_req | exception) ? 1'b1 : 1'b0;
endmodule
