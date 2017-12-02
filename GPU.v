`timescale 1ns / 1ps
`include <head.h>
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/09/06 15:16:58
// Design Name: 
// Module Name: GPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define RN 144
`define RNL 143:0
`define CN 100
`define CNL 99:0

module GPU(
    input clk,
    input reset,
    input run,
    input inwrite,
    input outwrite,
    input [`F] data_in,
    input [`F] threshold,
    output [`F] data_out
    );
    
    reg [`F] di [`RNL], do [`CNL];
    reg [9:0] ctin, ctout;
    wire flag;
    wire [`CNL] regin;
    wire [`F] regout0;
    wire [`F] regout1;
    wire [`F] regout2;
    wire [`F] regout3;
    wire [`F] regout4;
    wire [`F] regout5;
    wire [`F] regout6;
    wire [`F] regout7;
    wire [`F] regout8;
    wire [`F] regout9;
    wire [`F] regout10;
    wire [`F] regout11;
    wire [`F] regout12;
    wire [`F] regout13;
    wire [`F] regout14;
    wire [`F] regout15;
    wire [`F] regout16;
    wire [`F] regout17;
    wire [`F] regout18;
    wire [`F] regout19;
    wire [`F] regout20;
    wire [`F] regout21;
    wire [`F] regout22;
    wire [`F] regout23;
    wire [`F] regout24;
    wire [`F] regout25;
    wire [`F] regout26;
    wire [`F] regout27;
    wire [`F] regout28;
    wire [`F] regout29;
    wire [`F] regout30;
    wire [`F] regout31;
    wire [`F] regout32;
    wire [`F] regout33;
    wire [`F] regout34;
    wire [`F] regout35;
    wire [`F] regout36;
    wire [`F] regout37;
    wire [`F] regout38;
    wire [`F] regout39;
    wire [`F] regout40;
    wire [`F] regout41;
    wire [`F] regout42;
    wire [`F] regout43;
    wire [`F] regout44;
    wire [`F] regout45;
    wire [`F] regout46;
    wire [`F] regout47;
    wire [`F] regout48;
    wire [`F] regout49;
    wire [`F] regout50;
    wire [`F] regout51;
    wire [`F] regout52;
    wire [`F] regout53;
    wire [`F] regout54;
    wire [`F] regout55;
    wire [`F] regout56;
    wire [`F] regout57;
    wire [`F] regout58;
    wire [`F] regout59;
    wire [`F] regout60;
    wire [`F] regout61;
    wire [`F] regout62;
    wire [`F] regout63;
    wire [`F] regout64;
    wire [`F] regout65;
    wire [`F] regout66;
    wire [`F] regout67;
    wire [`F] regout68;
    wire [`F] regout69;
    wire [`F] regout70;
    wire [`F] regout71;
    wire [`F] regout72;
    wire [`F] regout73;
    wire [`F] regout74;
    wire [`F] regout75;
    wire [`F] regout76;
    wire [`F] regout77;
    wire [`F] regout78;
    wire [`F] regout79;
    wire [`F] regout80;
    wire [`F] regout81;
    wire [`F] regout82;
    wire [`F] regout83;
    wire [`F] regout84;
    wire [`F] regout85;
    wire [`F] regout86;
    wire [`F] regout87;
    wire [`F] regout88;
    wire [`F] regout89;
    wire [`F] regout90;
    wire [`F] regout91;
    wire [`F] regout92;
    wire [`F] regout93;
    wire [`F] regout94;
    wire [`F] regout95;
    wire [`F] regout96;
    wire [`F] regout97;
    wire [`F] regout98;
    wire [`F] regout99;
    wire [`F] regout100;
    wire [`F] regout101;
    wire [`F] regout102;
    wire [`F] regout103;
    wire [`F] regout104;
    wire [`F] regout105;
    wire [`F] regout106;
    wire [`F] regout107;
    wire [`F] regout108;
    wire [`F] regout109;
    wire [`F] regout110;
    wire [`F] regout111;
    wire [`F] regout112;
    wire [`F] regout113;
    wire [`F] regout114;
    wire [`F] regout115;
    wire [`F] regout116;
    wire [`F] regout117;
    wire [`F] regout118;
    wire [`F] regout119;
    wire [`F] regout120;
    wire [`F] regout121;
    wire [`F] regout122;
    wire [`F] regout123;
    wire [`F] regout124;
    wire [`F] regout125;
    wire [`F] regout126;
    wire [`F] regout127;
    wire [`F] regout128;
    wire [`F] regout129;
    wire [`F] regout130;
    wire [`F] regout131;
    wire [`F] regout132;
    wire [`F] regout133;
    wire [`F] regout134;
    wire [`F] regout135;
    wire [`F] regout136;
    wire [`F] regout137;
    wire [`F] regout138;
    wire [`F] regout139;
    wire [`F] regout140;
    wire [`F] regout141;
    wire [`F] regout142;
    wire [`F] regout143;
    
    integer i;
    
    initial begin
        for (i=0; i<`RN; i=i+1) begin
            di[i]=0;
        end
        
        for (i=0; i<`CN; i=i+1) begin
            do[i]=0;
        end
        
        ctin = 0;
        ctout = 0;
    end
    
    assign regout0 = di[0];
    assign regout1 = di[1];
    assign regout2 = di[2];                         
    assign regout3 = di[3];
    assign regout4 = di[4];
    assign regout5 = di[5];
    assign regout6 = di[6];
    assign regout7 = di[7];
    assign regout8 = di[8];
    assign regout9 = di[9];
    assign regout10 = di[10];
    assign regout11 = di[11];
    assign regout12 = di[12];                         
    assign regout13 = di[13];
    assign regout14 = di[14];
    assign regout15 = di[15];
    assign regout16 = di[16];
    assign regout17 = di[17];
    assign regout18 = di[18];
    assign regout19 = di[19];
    assign regout20 = di[20];
    assign regout21 = di[21];
    assign regout22 = di[22];                         
    assign regout23 = di[23];
    assign regout24 = di[24];
    assign regout25 = di[25];
    assign regout26 = di[26];
    assign regout27 = di[27];
    assign regout28 = di[28];
    assign regout29 = di[29];
    assign regout30 = di[30];
    assign regout31 = di[31];
    assign regout32 = di[32];                         
    assign regout33 = di[33];
    assign regout34 = di[34];
    assign regout35 = di[35];
    assign regout36 = di[36];
    assign regout37 = di[37];
    assign regout38 = di[38];
    assign regout39 = di[39]; 
    assign regout40 = di[40];
    assign regout41 = di[41];
    assign regout42 = di[42];                         
    assign regout43 = di[43];
    assign regout44 = di[44];
    assign regout45 = di[45];
    assign regout46 = di[46];
    assign regout47 = di[47];
    assign regout48 = di[48];
    assign regout49 = di[49];
    assign regout50 = di[50];
    assign regout51 = di[51];
    assign regout52 = di[52];                         
    assign regout53 = di[53];
    assign regout54 = di[54];
    assign regout55 = di[55];
    assign regout56 = di[56];
    assign regout57 = di[57];
    assign regout58 = di[58];
    assign regout59 = di[59]; 
    assign regout60 = di[60];
    assign regout61 = di[61];
    assign regout62 = di[62];                         
    assign regout63 = di[63];
    assign regout64 = di[64];
    assign regout65 = di[65];
    assign regout66 = di[66];
    assign regout67 = di[67];
    assign regout68 = di[68];
    assign regout69 = di[69];
    assign regout70 = di[70];
    assign regout71 = di[71];
    assign regout72 = di[72];                         
    assign regout73 = di[73];
    assign regout74 = di[74];
    assign regout75 = di[75];
    assign regout76 = di[76];
    assign regout77 = di[77];
    assign regout78 = di[78];
    assign regout79 = di[79];
    assign regout80 = di[80];
    assign regout81 = di[81];
    assign regout82 = di[82];                         
    assign regout83 = di[83];
    assign regout84 = di[84];
    assign regout85 = di[85];
    assign regout86 = di[86];
    assign regout87 = di[87];
    assign regout88 = di[88];
    assign regout89 = di[89];
    assign regout90 = di[90];
    assign regout91 = di[91];
    assign regout92 = di[92];                         
    assign regout93 = di[93];
    assign regout94 = di[94];
    assign regout95 = di[95];
    assign regout96 = di[96];
    assign regout97 = di[97];
    assign regout98 = di[98];
    assign regout99 = di[99]; 
    assign regout100 = di[100];
    assign regout101 = di[101];
    assign regout102 = di[102];                         
    assign regout103 = di[103];
    assign regout104 = di[104];
    assign regout105 = di[105];
    assign regout106 = di[106];
    assign regout107 = di[107];
    assign regout108 = di[108];
    assign regout109 = di[109]; 
    assign regout110 = di[110];
    assign regout111 = di[111];
    assign regout112 = di[112];                         
    assign regout113 = di[113];
    assign regout114 = di[114];
    assign regout115 = di[115];
    assign regout116 = di[116];
    assign regout117 = di[117];
    assign regout118 = di[118];
    assign regout119 = di[119];
    assign regout120 = di[120];
    assign regout121 = di[121];
    assign regout122 = di[122];                         
    assign regout123 = di[123];
    assign regout124 = di[124];
    assign regout125 = di[125];
    assign regout126 = di[126];
    assign regout127 = di[127];
    assign regout128 = di[128];
    assign regout129 = di[129];
    assign regout130 = di[130];
    assign regout131 = di[131];
    assign regout132 = di[132];                         
    assign regout133 = di[133];
    assign regout134 = di[134];
    assign regout135 = di[135];
    assign regout136 = di[136];
    assign regout137 = di[137];
    assign regout138 = di[138];
    assign regout139 = di[139]; 
    assign regout140 = di[140];
    assign regout141 = di[141];
    assign regout142 = di[142];                         
    assign regout143 = di[143];
    
    always @(posedge clk) begin
        if(reset)begin
            for (i=0; i<`RN; i=i+1) begin
                di[i] <= 0;
            end
            
            for (i=0; i<`CN; i=i+1) begin
                do[i] <= 0;
            end
            
            ctin <= 0;
            ctout <= 0;
        end
        else begin
            if (inwrite) begin
                di[ctin] <= data_in;
                ctin <= ctin + 1;
            end
            
            else if (run) begin
                for (i=0; i<`CN; i=i+1) begin
                    do[i] <= regin[i];
                end
                ctin <= 0;
                ctout <= 0;
            end
            
            else if (outwrite) begin
                ctout <= ctout + 1;
            end
        end
    end
    
    sobel sobel0(threshold,regout0[7:0],regout1[7:0],regout2[7:0],regout12[7:0],regout13[7:0],regout14[7:0],regout24[7:0],regout25[7:0],regout26[7:0],regin[0]);
    sobel sobel1(threshold,regout1[7:0],regout2[7:0],regout3[7:0],regout13[7:0],regout14[7:0],regout15[7:0],regout25[7:0],regout26[7:0],regout27[7:0],regin[1]);
    sobel sobel2(threshold,regout2[7:0],regout3[7:0],regout4[7:0],regout14[7:0],regout15[7:0],regout16[7:0],regout26[7:0],regout27[7:0],regout28[7:0],regin[2]);
    sobel sobel3(threshold,regout3[7:0],regout4[7:0],regout5[7:0],regout15[7:0],regout16[7:0],regout17[7:0],regout27[7:0],regout28[7:0],regout29[7:0],regin[3]);
    sobel sobel4(threshold,regout4[7:0],regout5[7:0],regout6[7:0],regout16[7:0],regout17[7:0],regout18[7:0],regout28[7:0],regout29[7:0],regout30[7:0],regin[4]);
    sobel sobel5(threshold,regout5[7:0],regout6[7:0],regout7[7:0],regout17[7:0],regout18[7:0],regout19[7:0],regout29[7:0],regout30[7:0],regout31[7:0],regin[5]);
    sobel sobel6(threshold,regout6[7:0],regout7[7:0],regout8[7:0],regout18[7:0],regout19[7:0],regout20[7:0],regout30[7:0],regout31[7:0],regout32[7:0],regin[6]);
    sobel sobel7(threshold,regout7[7:0],regout8[7:0],regout9[7:0],regout19[7:0],regout20[7:0],regout21[7:0],regout31[7:0],regout32[7:0],regout33[7:0],regin[7]);
    sobel sobel8(threshold,regout8[7:0],regout9[7:0],regout10[7:0],regout20[7:0],regout21[7:0],regout22[7:0],regout32[7:0],regout33[7:0],regout34[7:0],regin[8]);
    sobel sobel9(threshold,regout9[7:0],regout10[7:0],regout11[7:0],regout21[7:0],regout22[7:0],regout23[7:0],regout33[7:0],regout34[7:0],regout35[7:0],regin[9]);
    sobel sobel10(threshold,regout12[7:0],regout13[7:0],regout14[7:0],regout24[7:0],regout25[7:0],regout26[7:0],regout36[7:0],regout37[7:0],regout38[7:0],regin[10]);
    sobel sobel11(threshold,regout13[7:0],regout14[7:0],regout15[7:0],regout25[7:0],regout26[7:0],regout27[7:0],regout37[7:0],regout38[7:0],regout39[7:0],regin[11]);
    sobel sobel12(threshold,regout14[7:0],regout15[7:0],regout16[7:0],regout26[7:0],regout27[7:0],regout28[7:0],regout38[7:0],regout39[7:0],regout40[7:0],regin[12]);
    sobel sobel13(threshold,regout15[7:0],regout16[7:0],regout17[7:0],regout27[7:0],regout28[7:0],regout29[7:0],regout39[7:0],regout40[7:0],regout41[7:0],regin[13]);
    sobel sobel14(threshold,regout16[7:0],regout17[7:0],regout18[7:0],regout28[7:0],regout29[7:0],regout30[7:0],regout40[7:0],regout41[7:0],regout42[7:0],regin[14]);
    sobel sobel15(threshold,regout17[7:0],regout18[7:0],regout19[7:0],regout29[7:0],regout30[7:0],regout31[7:0],regout41[7:0],regout42[7:0],regout43[7:0],regin[15]);
    sobel sobel16(threshold,regout18[7:0],regout19[7:0],regout20[7:0],regout30[7:0],regout31[7:0],regout32[7:0],regout42[7:0],regout43[7:0],regout44[7:0],regin[16]);
    sobel sobel17(threshold,regout19[7:0],regout20[7:0],regout21[7:0],regout31[7:0],regout32[7:0],regout33[7:0],regout43[7:0],regout44[7:0],regout45[7:0],regin[17]);
    sobel sobel18(threshold,regout20[7:0],regout21[7:0],regout22[7:0],regout32[7:0],regout33[7:0],regout34[7:0],regout44[7:0],regout45[7:0],regout46[7:0],regin[18]);
    sobel sobel19(threshold,regout21[7:0],regout22[7:0],regout23[7:0],regout33[7:0],regout34[7:0],regout35[7:0],regout45[7:0],regout46[7:0],regout47[7:0],regin[19]);
    sobel sobel20(threshold,regout24[7:0],regout25[7:0],regout26[7:0],regout36[7:0],regout37[7:0],regout38[7:0],regout48[7:0],regout49[7:0],regout50[7:0],regin[20]);
    sobel sobel21(threshold,regout25[7:0],regout26[7:0],regout27[7:0],regout37[7:0],regout38[7:0],regout39[7:0],regout49[7:0],regout50[7:0],regout51[7:0],regin[21]);
    sobel sobel22(threshold,regout26[7:0],regout27[7:0],regout28[7:0],regout38[7:0],regout39[7:0],regout40[7:0],regout50[7:0],regout51[7:0],regout52[7:0],regin[22]);
    sobel sobel23(threshold,regout27[7:0],regout28[7:0],regout29[7:0],regout39[7:0],regout40[7:0],regout41[7:0],regout51[7:0],regout52[7:0],regout53[7:0],regin[23]);
    sobel sobel24(threshold,regout28[7:0],regout29[7:0],regout30[7:0],regout40[7:0],regout41[7:0],regout42[7:0],regout52[7:0],regout53[7:0],regout54[7:0],regin[24]);
    sobel sobel25(threshold,regout29[7:0],regout30[7:0],regout31[7:0],regout41[7:0],regout42[7:0],regout43[7:0],regout53[7:0],regout54[7:0],regout55[7:0],regin[25]);
    sobel sobel26(threshold,regout30[7:0],regout31[7:0],regout32[7:0],regout42[7:0],regout43[7:0],regout44[7:0],regout54[7:0],regout55[7:0],regout56[7:0],regin[26]);
    sobel sobel27(threshold,regout31[7:0],regout32[7:0],regout33[7:0],regout43[7:0],regout44[7:0],regout45[7:0],regout55[7:0],regout56[7:0],regout57[7:0],regin[27]);
    sobel sobel28(threshold,regout32[7:0],regout33[7:0],regout34[7:0],regout44[7:0],regout45[7:0],regout46[7:0],regout56[7:0],regout57[7:0],regout58[7:0],regin[28]);
    sobel sobel29(threshold,regout33[7:0],regout34[7:0],regout35[7:0],regout45[7:0],regout46[7:0],regout47[7:0],regout57[7:0],regout58[7:0],regout59[7:0],regin[29]);
    sobel sobel30(threshold,regout36[7:0],regout37[7:0],regout38[7:0],regout48[7:0],regout49[7:0],regout50[7:0],regout60[7:0],regout61[7:0],regout62[7:0],regin[30]);
    sobel sobel31(threshold,regout37[7:0],regout38[7:0],regout39[7:0],regout49[7:0],regout50[7:0],regout51[7:0],regout61[7:0],regout62[7:0],regout63[7:0],regin[31]);
    sobel sobel32(threshold,regout38[7:0],regout39[7:0],regout40[7:0],regout50[7:0],regout51[7:0],regout52[7:0],regout62[7:0],regout63[7:0],regout64[7:0],regin[32]);
    sobel sobel33(threshold,regout39[7:0],regout40[7:0],regout41[7:0],regout51[7:0],regout52[7:0],regout53[7:0],regout63[7:0],regout64[7:0],regout65[7:0],regin[33]);
    sobel sobel34(threshold,regout40[7:0],regout41[7:0],regout42[7:0],regout52[7:0],regout53[7:0],regout54[7:0],regout64[7:0],regout65[7:0],regout66[7:0],regin[34]);
    sobel sobel35(threshold,regout41[7:0],regout42[7:0],regout43[7:0],regout53[7:0],regout54[7:0],regout55[7:0],regout65[7:0],regout66[7:0],regout67[7:0],regin[35]);
    sobel sobel36(threshold,regout42[7:0],regout43[7:0],regout44[7:0],regout54[7:0],regout55[7:0],regout56[7:0],regout66[7:0],regout67[7:0],regout68[7:0],regin[36]);
    sobel sobel37(threshold,regout43[7:0],regout44[7:0],regout45[7:0],regout55[7:0],regout56[7:0],regout57[7:0],regout67[7:0],regout68[7:0],regout69[7:0],regin[37]);
    sobel sobel38(threshold,regout44[7:0],regout45[7:0],regout46[7:0],regout56[7:0],regout57[7:0],regout58[7:0],regout68[7:0],regout69[7:0],regout70[7:0],regin[38]);
    sobel sobel39(threshold,regout45[7:0],regout46[7:0],regout47[7:0],regout57[7:0],regout58[7:0],regout59[7:0],regout69[7:0],regout70[7:0],regout71[7:0],regin[39]);
    sobel sobel40(threshold,regout48[7:0],regout49[7:0],regout50[7:0],regout60[7:0],regout61[7:0],regout62[7:0],regout72[7:0],regout73[7:0],regout74[7:0],regin[40]);
    sobel sobel41(threshold,regout49[7:0],regout50[7:0],regout51[7:0],regout61[7:0],regout62[7:0],regout63[7:0],regout73[7:0],regout74[7:0],regout75[7:0],regin[41]);
    sobel sobel42(threshold,regout50[7:0],regout51[7:0],regout52[7:0],regout62[7:0],regout63[7:0],regout64[7:0],regout74[7:0],regout75[7:0],regout76[7:0],regin[42]);
    sobel sobel43(threshold,regout51[7:0],regout52[7:0],regout53[7:0],regout63[7:0],regout64[7:0],regout65[7:0],regout75[7:0],regout76[7:0],regout77[7:0],regin[43]);
    sobel sobel44(threshold,regout52[7:0],regout53[7:0],regout54[7:0],regout64[7:0],regout65[7:0],regout66[7:0],regout76[7:0],regout77[7:0],regout78[7:0],regin[44]);
    sobel sobel45(threshold,regout53[7:0],regout54[7:0],regout55[7:0],regout65[7:0],regout66[7:0],regout67[7:0],regout77[7:0],regout78[7:0],regout79[7:0],regin[45]);
    sobel sobel46(threshold,regout54[7:0],regout55[7:0],regout56[7:0],regout66[7:0],regout67[7:0],regout68[7:0],regout78[7:0],regout79[7:0],regout80[7:0],regin[46]);
    sobel sobel47(threshold,regout55[7:0],regout56[7:0],regout57[7:0],regout67[7:0],regout68[7:0],regout69[7:0],regout79[7:0],regout80[7:0],regout81[7:0],regin[47]);
    sobel sobel48(threshold,regout56[7:0],regout57[7:0],regout58[7:0],regout68[7:0],regout69[7:0],regout70[7:0],regout80[7:0],regout81[7:0],regout82[7:0],regin[48]);
    sobel sobel49(threshold,regout57[7:0],regout58[7:0],regout59[7:0],regout69[7:0],regout70[7:0],regout71[7:0],regout81[7:0],regout82[7:0],regout83[7:0],regin[49]);
    sobel sobel50(threshold,regout60[7:0],regout61[7:0],regout62[7:0],regout72[7:0],regout73[7:0],regout74[7:0],regout84[7:0],regout85[7:0],regout86[7:0],regin[50]);
    sobel sobel51(threshold,regout61[7:0],regout62[7:0],regout63[7:0],regout73[7:0],regout74[7:0],regout75[7:0],regout85[7:0],regout86[7:0],regout87[7:0],regin[51]);
    sobel sobel52(threshold,regout62[7:0],regout63[7:0],regout64[7:0],regout74[7:0],regout75[7:0],regout76[7:0],regout86[7:0],regout87[7:0],regout88[7:0],regin[52]);
    sobel sobel53(threshold,regout63[7:0],regout64[7:0],regout65[7:0],regout75[7:0],regout76[7:0],regout77[7:0],regout87[7:0],regout88[7:0],regout89[7:0],regin[53]);
    sobel sobel54(threshold,regout64[7:0],regout65[7:0],regout66[7:0],regout76[7:0],regout77[7:0],regout78[7:0],regout88[7:0],regout89[7:0],regout90[7:0],regin[54]);
    sobel sobel55(threshold,regout65[7:0],regout66[7:0],regout67[7:0],regout77[7:0],regout78[7:0],regout79[7:0],regout89[7:0],regout90[7:0],regout91[7:0],regin[55]);
    sobel sobel56(threshold,regout66[7:0],regout67[7:0],regout68[7:0],regout78[7:0],regout79[7:0],regout80[7:0],regout90[7:0],regout91[7:0],regout92[7:0],regin[56]);
    sobel sobel57(threshold,regout67[7:0],regout68[7:0],regout69[7:0],regout79[7:0],regout80[7:0],regout81[7:0],regout91[7:0],regout92[7:0],regout93[7:0],regin[57]);
    sobel sobel58(threshold,regout68[7:0],regout69[7:0],regout70[7:0],regout80[7:0],regout81[7:0],regout82[7:0],regout92[7:0],regout93[7:0],regout94[7:0],regin[58]);
    sobel sobel59(threshold,regout69[7:0],regout70[7:0],regout71[7:0],regout81[7:0],regout82[7:0],regout83[7:0],regout93[7:0],regout94[7:0],regout95[7:0],regin[59]);
    sobel sobel60(threshold,regout72[7:0],regout73[7:0],regout74[7:0],regout84[7:0],regout85[7:0],regout86[7:0],regout96[7:0],regout97[7:0],regout98[7:0],regin[60]);
    sobel sobel61(threshold,regout73[7:0],regout74[7:0],regout75[7:0],regout85[7:0],regout86[7:0],regout87[7:0],regout97[7:0],regout98[7:0],regout99[7:0],regin[61]);
    sobel sobel62(threshold,regout74[7:0],regout75[7:0],regout76[7:0],regout86[7:0],regout87[7:0],regout88[7:0],regout98[7:0],regout99[7:0],regout100[7:0],regin[62]);
    sobel sobel63(threshold,regout75[7:0],regout76[7:0],regout77[7:0],regout87[7:0],regout88[7:0],regout89[7:0],regout99[7:0],regout100[7:0],regout101[7:0],regin[63]);
    sobel sobel64(threshold,regout76[7:0],regout77[7:0],regout78[7:0],regout88[7:0],regout89[7:0],regout90[7:0],regout100[7:0],regout101[7:0],regout102[7:0],regin[64]);
    sobel sobel65(threshold,regout77[7:0],regout78[7:0],regout79[7:0],regout89[7:0],regout90[7:0],regout91[7:0],regout101[7:0],regout102[7:0],regout103[7:0],regin[65]);
    sobel sobel66(threshold,regout78[7:0],regout79[7:0],regout80[7:0],regout90[7:0],regout91[7:0],regout92[7:0],regout102[7:0],regout103[7:0],regout104[7:0],regin[66]);
    sobel sobel67(threshold,regout79[7:0],regout80[7:0],regout81[7:0],regout91[7:0],regout92[7:0],regout93[7:0],regout103[7:0],regout104[7:0],regout105[7:0],regin[67]);
    sobel sobel68(threshold,regout80[7:0],regout81[7:0],regout82[7:0],regout92[7:0],regout93[7:0],regout94[7:0],regout104[7:0],regout105[7:0],regout106[7:0],regin[68]);
    sobel sobel69(threshold,regout81[7:0],regout82[7:0],regout83[7:0],regout93[7:0],regout94[7:0],regout95[7:0],regout105[7:0],regout106[7:0],regout107[7:0],regin[69]);
    sobel sobel70(threshold,regout84[7:0],regout85[7:0],regout86[7:0],regout96[7:0],regout97[7:0],regout98[7:0],regout108[7:0],regout109[7:0],regout110[7:0],regin[70]);
    sobel sobel71(threshold,regout85[7:0],regout86[7:0],regout87[7:0],regout97[7:0],regout98[7:0],regout99[7:0],regout109[7:0],regout110[7:0],regout111[7:0],regin[71]);
    sobel sobel72(threshold,regout86[7:0],regout87[7:0],regout88[7:0],regout98[7:0],regout99[7:0],regout100[7:0],regout110[7:0],regout111[7:0],regout112[7:0],regin[72]);
    sobel sobel73(threshold,regout87[7:0],regout88[7:0],regout89[7:0],regout99[7:0],regout100[7:0],regout101[7:0],regout111[7:0],regout112[7:0],regout113[7:0],regin[73]);
    sobel sobel74(threshold,regout88[7:0],regout89[7:0],regout90[7:0],regout100[7:0],regout101[7:0],regout102[7:0],regout112[7:0],regout113[7:0],regout114[7:0],regin[74]);
    sobel sobel75(threshold,regout89[7:0],regout90[7:0],regout91[7:0],regout101[7:0],regout102[7:0],regout103[7:0],regout113[7:0],regout114[7:0],regout115[7:0],regin[75]);
    sobel sobel76(threshold,regout90[7:0],regout91[7:0],regout92[7:0],regout102[7:0],regout103[7:0],regout104[7:0],regout114[7:0],regout115[7:0],regout116[7:0],regin[76]);
    sobel sobel77(threshold,regout91[7:0],regout92[7:0],regout93[7:0],regout103[7:0],regout104[7:0],regout105[7:0],regout115[7:0],regout116[7:0],regout117[7:0],regin[77]);
    sobel sobel78(threshold,regout92[7:0],regout93[7:0],regout94[7:0],regout104[7:0],regout105[7:0],regout106[7:0],regout116[7:0],regout117[7:0],regout118[7:0],regin[78]);
    sobel sobel79(threshold,regout93[7:0],regout94[7:0],regout95[7:0],regout105[7:0],regout106[7:0],regout107[7:0],regout117[7:0],regout118[7:0],regout119[7:0],regin[79]);
    sobel sobel80(threshold,regout96[7:0],regout97[7:0],regout98[7:0],regout108[7:0],regout109[7:0],regout110[7:0],regout120[7:0],regout121[7:0],regout122[7:0],regin[80]);
    sobel sobel81(threshold,regout97[7:0],regout98[7:0],regout99[7:0],regout109[7:0],regout110[7:0],regout111[7:0],regout121[7:0],regout122[7:0],regout123[7:0],regin[81]);
    sobel sobel82(threshold,regout98[7:0],regout99[7:0],regout100[7:0],regout110[7:0],regout111[7:0],regout112[7:0],regout122[7:0],regout123[7:0],regout124[7:0],regin[82]);
    sobel sobel83(threshold,regout99[7:0],regout100[7:0],regout101[7:0],regout111[7:0],regout112[7:0],regout113[7:0],regout123[7:0],regout124[7:0],regout125[7:0],regin[83]);
    sobel sobel84(threshold,regout100[7:0],regout101[7:0],regout102[7:0],regout112[7:0],regout113[7:0],regout114[7:0],regout124[7:0],regout125[7:0],regout126[7:0],regin[84]);
    sobel sobel85(threshold,regout101[7:0],regout102[7:0],regout103[7:0],regout113[7:0],regout114[7:0],regout115[7:0],regout125[7:0],regout126[7:0],regout127[7:0],regin[85]);
    sobel sobel86(threshold,regout102[7:0],regout103[7:0],regout104[7:0],regout114[7:0],regout115[7:0],regout116[7:0],regout126[7:0],regout127[7:0],regout128[7:0],regin[86]);
    sobel sobel87(threshold,regout103[7:0],regout104[7:0],regout105[7:0],regout115[7:0],regout116[7:0],regout117[7:0],regout127[7:0],regout128[7:0],regout129[7:0],regin[87]);
    sobel sobel88(threshold,regout104[7:0],regout105[7:0],regout106[7:0],regout116[7:0],regout117[7:0],regout118[7:0],regout128[7:0],regout129[7:0],regout130[7:0],regin[88]);
    sobel sobel89(threshold,regout105[7:0],regout106[7:0],regout107[7:0],regout117[7:0],regout118[7:0],regout119[7:0],regout129[7:0],regout130[7:0],regout131[7:0],regin[89]);
    sobel sobel90(threshold,regout108[7:0],regout109[7:0],regout110[7:0],regout120[7:0],regout121[7:0],regout122[7:0],regout132[7:0],regout133[7:0],regout134[7:0],regin[90]);
    sobel sobel91(threshold,regout109[7:0],regout110[7:0],regout111[7:0],regout121[7:0],regout122[7:0],regout123[7:0],regout133[7:0],regout134[7:0],regout135[7:0],regin[91]);
    sobel sobel92(threshold,regout110[7:0],regout111[7:0],regout112[7:0],regout122[7:0],regout123[7:0],regout124[7:0],regout134[7:0],regout135[7:0],regout136[7:0],regin[92]);
    sobel sobel93(threshold,regout111[7:0],regout112[7:0],regout113[7:0],regout123[7:0],regout124[7:0],regout125[7:0],regout135[7:0],regout136[7:0],regout137[7:0],regin[93]);
    sobel sobel94(threshold,regout112[7:0],regout113[7:0],regout114[7:0],regout124[7:0],regout125[7:0],regout126[7:0],regout136[7:0],regout137[7:0],regout138[7:0],regin[94]);
    sobel sobel95(threshold,regout113[7:0],regout114[7:0],regout115[7:0],regout125[7:0],regout126[7:0],regout127[7:0],regout137[7:0],regout138[7:0],regout139[7:0],regin[95]);
    sobel sobel96(threshold,regout114[7:0],regout115[7:0],regout116[7:0],regout126[7:0],regout127[7:0],regout128[7:0],regout138[7:0],regout139[7:0],regout140[7:0],regin[96]);
    sobel sobel97(threshold,regout115[7:0],regout116[7:0],regout117[7:0],regout127[7:0],regout128[7:0],regout129[7:0],regout139[7:0],regout140[7:0],regout141[7:0],regin[97]);
    sobel sobel98(threshold,regout116[7:0],regout117[7:0],regout118[7:0],regout128[7:0],regout129[7:0],regout130[7:0],regout140[7:0],regout141[7:0],regout142[7:0],regin[98]);
    sobel sobel99(threshold,regout117[7:0],regout118[7:0],regout119[7:0],regout129[7:0],regout130[7:0],regout131[7:0],regout141[7:0],regout142[7:0],regout143[7:0],regin[99]);
    
    
    
    assign data_out = {31'b0, regin[ctout]};
    
    
endmodule
