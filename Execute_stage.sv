`timescale 1ns / 1ps


module Execute_stage(
    input                   clk,
    input                   nrst,
    input           [31:0]  RD1D,
    input           [31:0]  RD2D,
    input           [31:0]  PCD,
    input           [4:0]   Rs1D,
    input           [4:0]   Rs2D,
    input           [4:0]   RdD,
    input           [31:0]  ImmExtD,
    input           [31:0]  PCPlus4D,
    input           [11:0]  CtrlD,
    input                   clr,
    output logic    [31:0]  RD1E,
    output logic    [31:0]  RD2E,
    output logic    [31:0]  PCE,
    output logic    [4:0]   Rs1E,
    output logic    [4:0]   Rs2E,
    output logic    [4:0]   RdE,
    output logic    [31:0]  ImmExtE,
    output logic    [31:0]  PCPlus4E,
    output logic    [9:0]   CtrlE 
    );
    
    wire [9:0] control_line;
    assign control_line = CtrlD[11:2];
    
    always_ff@(posedge clk or negedge nrst) begin
        if(!nrst) begin
            RD1E        <=  32'b0;
            RD2E        <=  32'b0;
            PCE         <=  32'b0;
            Rs1E        <=  5'b0;
            Rs2E        <=  5'b0;
            RdE         <=  5'b0;
            ImmExtE     <=  32'b0;
            PCPlus4E    <=  32'b0;
            CtrlE       <=  10'b0;
        end
        else begin
            if(clr) begin //flush
                RD1E        <=  32'b0;               
                RD2E        <=  32'b0;           
                PCE         <=  32'b0;           
                Rs1E        <=  5'b0;            
                Rs2E        <=  5'b0;            
                RdE         <=  5'b0;            
                ImmExtE     <=  32'b0;           
                PCPlus4E    <=  32'b0;           
                CtrlE       <=  10'b0; 
            end
            else begin
                RD1E        <=  RD1D;      
                RD2E        <=  RD2D;
                PCE         <=  PCD;
                Rs1E        <=  Rs1D;
                Rs2E        <=  Rs2D;
                RdE         <=  RdD;
                ImmExtE     <=  ImmExtD;
                PCPlus4E    <=  PCPlus4D;
                CtrlE       <=  control_line;
            end
        end     
    end
    
    
endmodule
