`timescale 1ns / 1ps


module HAZARD_control(
    input           [4:0]   Rs1D,
    input           [4:0]   Rs2D,
    input           [4:0]   Rs1E,
    input           [4:0]   Rs2E,
    input           [4:0]   RdE,
    input                   PCSrcE,
    input                   ResultSrcE0,
    input           [4:0]   RdM,
    input                   RegWriteM,
    input           [4:0]   RdW,
    input                   RegWriteW,
    output logic            StallF,
    output logic            StallD,
    output logic            FlushD,
    output logic            FlushE,
    output logic    [1:0]   ForwardAE,
    output logic    [1:0]   ForwardBE
    );
    
    wire lwStall;
    
    //stalling, stalling in love again
    assign lwStall = ((ResultSrcE0 == 1'b1) & (((Rs1D == RdE)&(Rs1D != 5'b0)) | ((Rs2D == RdE) & (Rs2D != 5'b0))));
    assign StallF = lwStall;
    assign StallD = lwStall;
    
    //royal flush                                                             
    assign FlushD = PCSrcE;          
    assign FlushE = (lwStall | PCSrcE);

    //Src1 Forwarding 
    always_comb begin
        if(((Rs1E == RdM)& RegWriteM)& (Rs1E != 5'b0)) begin
            ForwardAE <= 2'b10;
        end
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 5'b0)) begin
            ForwardAE <= 2'b01;
        end
        else begin
            ForwardAE <= 2'b00;
        end
    end

    //Src2 Forwarding
    always_comb begin
        if(((Rs2E == RdM)& RegWriteM)& (Rs2E != 5'b0)) begin
            ForwardBE <= 2'b10;
        end
        else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 5'b0)) begin
            ForwardBE <= 2'b01;
        end
        else begin
            ForwardBE <= 2'b00;
        end
    end    
    
    
    
    
    
    
    
 
 
 
 
    
    
    
    
endmodule
