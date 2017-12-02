`timescale 1ns / 1ps
`include <head.h>
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/09/06 14:46:16
// Design Name: 
// Module Name: sobel
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


module sobel(
    input [`F] threshold,
    input [7:0] z1, 
    input [7:0] z2, 
    input [7:0] z3, 
    input [7:0] z4, 
    input [7:0] z5, 
    input [7:0] z6, 
    input [7:0] z7, 
    input [7:0] z8, 
    input [7:0] z9,
    output  data_out
    );
    
    wire [`F] Gx, Gy, df;
    
    assign Gx = (z7+z8+z8+z9)-(z1+z2+z2+z3); 
    assign Gy = (z3+z6+z6+z9)-(z1+z4+z4+z7);
    
    assign df = Gx[30:0] + Gy[30:0];
    
    assign data_out = (df >= threshold) ? 1'b1 : 1'b0;
    
endmodule
