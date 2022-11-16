`timescale 1ns / 1ps


module PCSrcE_logic(
    input           JumpE,
    input           BranchE,
    input           ZeroE,
    output logic    PCSrcE
    );
    
    always_comb begin
        PCSrcE <= (ZeroE & BranchE) | JumpE;
    end
    
endmodule
