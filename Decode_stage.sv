`timescale 1ns / 1ps

module Decode_stage(
    input                   clk,
    input                   nrst,
    input           [31:0]  imem_data,
    input           [31:0]  PCF,
    input           [31:0]  PCPlus4F,
    input                   dis,
    input                   clr,
    output logic    [31:0]  InstD,
    output logic    [31:0]  PCD,
    output logic    [31:0]  PCPlus4D
    );
    
    always_ff@(posedge clk , negedge nrst) begin
        if(!nrst) begin
            InstD       <=  32'b0;
            PCD         <=  32'b0;
            PCPlus4D    <=  32'b0;
        end
        else begin
            if(clr) begin //flush 
                InstD       <=  32'b0;
                PCD         <=  32'b0;
                PCPlus4D    <=  32'b0;
            end
            else begin
                if(!dis) begin
                    InstD       <=  imem_data;
                    PCD         <=  PCF;
                    PCPlus4D    <=  PCPlus4F;
                end        
            end
        end
    end
    
endmodule
