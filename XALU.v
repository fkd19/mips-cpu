`timescale 1ns / 1ps
`include <head.h>

module XALU(input clk,reset,HI_WE,LO_WE,XALUOUT_sel,
				input[3:0] XALU_OP,
				input[`F] A,B,XALU_Wdata,
				output[`F] XALUOUT,
				output BUSY, div0);
				
    reg  [`F] HI,LO, abs_A, abs_B, rem, quot;
    wire [`F] temp_div_high, temp_rem_high, temp_div_low, temp_rem_low;
    wire [`F] temp_div_31, temp_rem_31, temp_div_30, temp_rem_30,rem_ans, quot_ans, abs_A_wire, abs_B_wire, A_sign_wire, B_sign_wire;
    wire [63:0] temp_mult_ans, mult_ans;
    reg  [5:0] count;     //乘法：40      除法：30到0，外加35表示运算完成，共33个周期
    reg busy, A_sign, B_sign;
    wire mult_a_sign, mult_b_sign;
    reg[63:0] mult_temp[31:0];
    integer i,j;
    
    always @(posedge clk)begin
        if (reset)begin
            abs_A <= 32'd0;
            abs_B <= 32'd1;
            rem <= 32'd0;
            quot <= 32'd0;
            count <= 32'd0;
            A_sign <= 1'd0;
            B_sign <= 1'd0;
            busy <= 1'b0;
            HI <= 32'd0;
            LO <= 32'd0;
            for (i=0; i<32; i=i+1)begin
                mult_temp[i] <= 64'b0;
            end 
        end
        else if ((XALU_OP[1]|XALU_OP[2]) && ~busy) begin
        
            abs_A <= abs_A_wire;
            abs_B <= abs_B_wire;
            rem <= 32'd0;
            quot <= 32'd0;
            HI <= 32'd0;
            LO <= 32'd0;
            count <= XALU_OP[1]?6'd40:
                     XALU_OP[2]?6'd29:0;
            busy <= 1'b1;
            A_sign <= (XALU_OP[0] == 1'b1)?1'b0:A[31];
            B_sign <= (XALU_OP[0] == 1'b1)?1'b0:B[31];
        end
        
        
        if (BUSY) begin
            if (XALU_OP[1] && ~busy)begin
                mult_temp[0] <= abs_B_wire[0]?abs_A_wire:64'b0;
                mult_temp[1] <= abs_B_wire[1]?(abs_A_wire << 1):64'b0;
                mult_temp[2] <= abs_B_wire[2]?(abs_A_wire << 2):64'b0;
                mult_temp[3] <= abs_B_wire[3]?(abs_A_wire << 3):64'b0;
                mult_temp[4] <= abs_B_wire[4]?(abs_A_wire << 4):64'b0;
                mult_temp[5] <= abs_B_wire[5]?(abs_A_wire << 5):64'b0;
                mult_temp[6] <= abs_B_wire[6]?(abs_A_wire << 6):64'b0;
                mult_temp[7] <= abs_B_wire[7]?(abs_A_wire << 7):64'b0;
                mult_temp[8] <= abs_B_wire[8]?(abs_A_wire << 8):64'b0;
                mult_temp[9] <= abs_B_wire[9]?(abs_A_wire << 9):64'b0;
                mult_temp[10] <= abs_B_wire[10]?(abs_A_wire << 10):64'b0;
                mult_temp[11] <= abs_B_wire[11]?(abs_A_wire << 11):64'b0;
                mult_temp[12] <= abs_B_wire[12]?(abs_A_wire << 12):64'b0;
                mult_temp[13] <= abs_B_wire[13]?(abs_A_wire << 13):64'b0;
                mult_temp[14] <= abs_B_wire[14]?(abs_A_wire << 14):64'b0;
                mult_temp[15] <= abs_B_wire[15]?(abs_A_wire << 15):64'b0;
                mult_temp[16] <= abs_B_wire[16]?(abs_A_wire << 16):64'b0;
                mult_temp[17] <= abs_B_wire[17]?(abs_A_wire << 17):64'b0;
                mult_temp[18] <= abs_B_wire[18]?(abs_A_wire << 18):64'b0;
                mult_temp[19] <= abs_B_wire[19]?(abs_A_wire << 19):64'b0;
                mult_temp[20] <= abs_B_wire[20]?(abs_A_wire << 20):64'b0;
                mult_temp[21] <= abs_B_wire[21]?(abs_A_wire << 21):64'b0;
                mult_temp[22] <= abs_B_wire[22]?(abs_A_wire << 22):64'b0;
                mult_temp[23] <= abs_B_wire[23]?(abs_A_wire << 23):64'b0;
                mult_temp[24] <= abs_B_wire[24]?(abs_A_wire << 24):64'b0;
                mult_temp[25] <= abs_B_wire[25]?(abs_A_wire << 25):64'b0;
                mult_temp[26] <= abs_B_wire[26]?(abs_A_wire << 26):64'b0;
                mult_temp[27] <= abs_B_wire[27]?(abs_A_wire << 27):64'b0;
                mult_temp[28] <= abs_B_wire[28]?(abs_A_wire << 28):64'b0;
                mult_temp[29] <= abs_B_wire[29]?(abs_A_wire << 29):64'b0;
                mult_temp[30] <= abs_B_wire[30]?(abs_A_wire << 30):64'b0;
                mult_temp[31] <= abs_B_wire[31]?(abs_A_wire << 31):64'b0;
            end
            else if (count == 6'd40)begin
                HI[`F] <= mult_ans[63:32];
                LO[`F] <= mult_ans[`F];
                count <= 6'd0;
                busy <= 1'b0;
                rem <= 0;
                quot <= 0;
                abs_A <= 0;
                abs_B <= 0;
                A_sign <= 0;
                B_sign <= 0;
            end
            else if (XALU_OP[2] && ~busy)begin
                quot[31] <= (temp_div_31 >= abs_B_wire);
                quot[30] <= (temp_div_30 >= abs_B_wire);
                rem <= temp_rem_30;
            end
            else if (count !=  6'd35)begin
                quot[count] <= (temp_div_high >= abs_B);
                quot[count-1] <= (temp_div_low >= abs_B);
                rem <= temp_rem_low;
                count <= (count == 6'd1)?6'd35: (count-2);
            end
            else begin
                busy <= 1'b0;
                count <= 6'd0;
                HI <= rem_ans;
                LO <= quot_ans;
                rem <= 0;
                quot <= 0;
                abs_A <= 0;
                abs_B <= 0;
                A_sign <= 0;
                B_sign <= 0;
            end
        end
        else if (HI_WE)     begin   HI <= XALU_Wdata;   end
        else if (LO_WE)     begin   LO <= XALU_Wdata;   end
    end 
        
    assign abs_A_wire=XALU_OP[0]?A[`F]:
                      A[31]?(~A[`F]+1'b1):A[`F];
    assign abs_B_wire=XALU_OP[0]?B[`F]:
                      B[31]?(~B[`F]+1'b1):B[`F];
    assign temp_div_high={rem[30:0], abs_A[count]};
    assign temp_rem_high=(temp_div_high >= abs_B)?(temp_div_high - abs_B):temp_div_high;
    assign temp_div_low={temp_rem_high[30:0], abs_A[count-1]};
    assign temp_rem_low=(temp_div_low >= abs_B)?(temp_div_low - abs_B):temp_div_low;
    
    assign temp_div_31={rem[30:0], abs_A_wire[31]};
    assign temp_rem_31=(temp_div_31 >= abs_B_wire)?(temp_div_31-abs_B_wire):temp_div_31;
    assign temp_div_30={temp_rem_31[30:0], abs_A_wire[30]};
    assign temp_rem_30=(temp_div_30 >= abs_B_wire)?(temp_div_30-abs_B_wire):temp_div_30;
    
    assign rem_ans=A_sign?(~rem+32'b1):rem;
    assign quot_ans=(A_sign ^ B_sign)?(~quot[`F]+32'b1):quot[`F];
    assign BUSY=|XALU_OP | busy;
    assign temp_mult_ans=mult_temp[0]+mult_temp[1]+mult_temp[2]+mult_temp[3]+mult_temp[4]+mult_temp[5]+mult_temp[6]+mult_temp[7]
                    +mult_temp[8]+mult_temp[9]+mult_temp[10]+mult_temp[11]+mult_temp[12]+mult_temp[13]+mult_temp[14]+mult_temp[15]
                    +mult_temp[16]+mult_temp[17]+mult_temp[18]+mult_temp[19]+mult_temp[20]+mult_temp[21]+mult_temp[22]+mult_temp[23]
                    +mult_temp[24]+mult_temp[25]+mult_temp[26]+mult_temp[27]+mult_temp[28]+mult_temp[29]+mult_temp[30]+mult_temp[31];
                    
    assign mult_ans=(A_sign ^ B_sign)?(~temp_mult_ans[63:0]+64'd1):temp_mult_ans[63:0];
    assign XALUOUT=(XALUOUT_sel == 0)?HI:LO;
    assign div0=(XALU_OP[2] == 1'b1) && ~busy && (B == 32'd0);
endmodule
