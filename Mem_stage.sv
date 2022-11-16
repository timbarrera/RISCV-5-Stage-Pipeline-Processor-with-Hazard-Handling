`timescale 1ns / 1ps

module Mem_stage(
    input                   clk,
    input                   nrst,
    input           [31:0]  ALUResultE,
    input           [31:0]  WriteDataE,
    input           [4:0]   RdE,
    input           [31:0]  PCPlus4E,
    input           [9:0]   CtrlE,
    output logic    [31:0]  ALUResultM,
    output logic    [31:0]  WriteDataM,
    output logic    [4:0]   RdM,
    output logic    [31:0]  PCPlus4M,
    output logic    [3:0]   CtrlM
    );
    
    wire [3:0] control_line;
    assign control_line = CtrlE[9:6];
    
    always_ff@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            ALUResultM  <=  32'b0;
            WriteDataM  <=  32'b0;
            RdM         <=  5'b0;
            PCPlus4M    <=  32'b0;
            CtrlM       <=  4'b0;
        end   
        else begin
            ALUResultM  <=  ALUResultE;
            WriteDataM  <=  WriteDataE;
            RdM         <=  RdE; 
            PCPlus4M    <=  PCPlus4E;
            CtrlM       <=  control_line;
        end 
    end
    
    
endmodule
