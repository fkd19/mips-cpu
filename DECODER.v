`timescale 1ns / 1ps
`include <head.h>

module DECODER(input [31:0] IR,
               output lb,lbu,lh,lhu,lw,sb,sh,sw,
               output add,addu,sub,subu,
               output mult,multu,div,divu,
               output sll,srl,sra,sllv,srlv,srav,
               output _and,_or,_xor,_nor,
               output addi,addiu,andi,ori,xori,lui,
               output slt,slti,sltiu,sltu,
               output beq,bne,blez,bgtz,bltz,bgez,
               output j,jal,jalr,jr,
               output mfhi,mflo,mthi,mtlo,
               output mfc0, mtc0, eret,
               output Break, syscall, bgezal, bltzal);

   
   assign lb =(IR[`op] == 6'b100000)?1:0;
   assign lbu=(IR[`op] == 6'b100100)?1:0;
   assign lh =(IR[`op] == 6'b100001)?1:0;
   assign lhu=(IR[`op] == 6'b100101)?1:0;
   assign lw =(IR[`op] == 6'b100011)?1:0;
   assign sb =(IR[`op] == 6'b101000)?1:0;
   assign sh =(IR[`op] == 6'b101001)?1:0;
   assign sw =(IR[`op] == 6'b101011)?1:0;
   
   assign add =({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100000)?1:0;
   assign addu=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100001)?1:0;
   assign sub =({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100010)?1:0;
   assign subu=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100011)?1:0;

   assign mult =({IR[`op],IR[`rd],IR[`sa],IR[`func]} == 22'b000000_0000000000_011000)?1:0;
   assign multu=({IR[`op],IR[`rd],IR[`sa],IR[`func]} == 22'b000000_0000000000_011001)?1:0;
   assign div  =({IR[`op],IR[`rd],IR[`sa],IR[`func]} == 22'b000000_0000000000_011010)?1:0;
   assign divu =({IR[`op],IR[`rd],IR[`sa],IR[`func]} == 22'b000000_0000000000_011011)?1:0;
   
   assign sll =({IR[`op],IR[`rs],IR[`func]} == 17'b000000_00000_000000)?1:0;
   assign srl =({IR[`op],IR[`rs],IR[`func]} == 17'b000000_00000_000010)?1:0;
   assign sra =({IR[`op],IR[`rs],IR[`func]} == 17'b000000_00000_000011)?1:0;
   assign sllv=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_000100)?1:0;
   assign srlv=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_000110)?1:0;
   assign srav=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_000111)?1:0;
   
   assign _and=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100100)?1:0;
   assign _or =({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100101)?1:0;
   assign _xor=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100110)?1:0;
   assign _nor=({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_100111)?1:0;
   
   assign addi =(IR[`op] == 6'b001000)?1:0;
   assign addiu=(IR[`op] == 6'b001001)?1:0;
   assign andi =(IR[`op] == 6'b001100)?1:0;
   assign ori  =(IR[`op] == 6'b001101)?1:0;
   assign xori =(IR[`op] == 6'b001110)?1:0;
   assign lui  =({IR[`op],IR[`rs]} == 11'b001111_00000)?1:0;
   
   assign slt  =({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_101010)?1:0;
   assign slti =(IR[`op] == 6'b001010)?1:0;
   assign sltiu=(IR[`op] == 6'b001011)?1:0;
   assign sltu =({IR[`op],IR[`sa],IR[`func]} == 17'b000000_00000_101011)?1:0;
   
   assign beq =(IR[`op] == 6'b000100)?1:0;
   assign bne =(IR[`op] == 6'b000101)?1:0;
   assign blez=({IR[`op],IR[`rt]} == 11'b000110_00000)?1:0;
   assign bgtz=({IR[`op],IR[`rt]} == 11'b000111_00000)?1:0;
   assign bltz=({IR[`op], IR[`rt]} == 11'b000001_00000)?1:0;
   assign bgez=({IR[`op], IR[`rt]} == 11'b000001_00001)?1:0;
   
   assign j=(IR[`op] == 6'b000010)?1:0;
   assign jal=(IR[`op] == 6'b000011)?1:0;
   assign jr=({IR[`op],IR[`rt],IR[`rd],IR[`sa],IR[`func]} == 27'b000000_0000000000_00000_001000)?1:0;
   assign jalr=({IR[`op],IR[`rt],IR[`sa],IR[`func]} == 22'b000000_00000_00000_001001)?1:0;
   
   assign mfhi=({IR[`op],IR[`rs],IR[`rt],IR[`sa],IR[`func]} == 27'b000000_0000000000_00000_010000)?1:0;
   assign mflo=({IR[`op],IR[`rs],IR[`rt],IR[`sa],IR[`func]} == 27'b000000_0000000000_00000_010010)?1:0;
   assign mthi=({IR[`op],IR[`rt],IR[`rd],IR[`sa],IR[`func]} == 27'b000000_000000000000000_010001)?1:0;
   assign mtlo=({IR[`op],IR[`rt],IR[`rd],IR[`sa],IR[`func]} == 27'b000000_000000000000000_010011)?1:0;
   
   assign mfc0=({IR[`op], IR[`rs],IR[`mft]} == 19'b010000_00000_00000000)?1:0;
   assign mtc0=({IR[`op], IR[`rs],IR[`mft]} == 19'b010000_00100_00000000)?1:0;
   assign eret=(IR[`F] == 32'h4200_0018)?1:0;
   
   assign Break = ({IR[`op],IR[`func]} == 12'b000000_001101)?1'b1:1'b0;
   assign syscall = ({IR[`op],IR[`func]} == 12'b000000_001100)?1'b1:1'b0;
   assign bgezal = ({IR[`op],IR[`rt]} == 11'b000001_10001)?1'b1:1'b0;
   assign bltzal = ({IR[`op],IR[`rt]} == 11'b000001_10000)?1'b1:1'b0;
   
endmodule
