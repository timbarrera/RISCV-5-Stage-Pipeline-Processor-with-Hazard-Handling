`timescale 1ns / 1ps


module Inst_slicer(
    input           [31:0]  inst,
    output          [6:0]   opcode,
    output          [2:0]   funct3,
    output          [6:0]   funct7,
    output          [4:0]   Rs1D,
    output  logic   [4:0]   Rs2D,
    output          [4:0]   RdD
    );
    
    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];
    assign Rs1D = inst[19:15];
    //assign Rs2D = inst[24:20];
    assign RdD = inst[11:7];
    
    always_comb begin
        if(opcode == 7'b0010011 || opcode == 7'b0000011) begin //if i type or lw, ignore rs2
            Rs2D = 5'b0;               
        end
        else begin
            Rs2D = inst[24:20];
        end
    end

endmodule
