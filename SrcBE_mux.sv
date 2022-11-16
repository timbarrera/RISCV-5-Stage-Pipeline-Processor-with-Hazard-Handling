`timescale 1ns / 1ps

module SrcBE_mux(
    input           [31:0]  RD2E,
    input           [31:0]  ResultW,
    input           [31:0]  ALUResultM,
    input           [1:0]   ForwardBE,
    output  logic   [31:0]  SrcBE
    );
    
    always_comb begin
        case(ForwardBE)
            2'b00: begin    SrcBE <= RD2E;          end  
            2'b01: begin    SrcBE <= ResultW;       end
            2'b10: begin    SrcBE <= ALUResultM;    end
            default: begin  SrcBE <= RD2E;          end
        endcase
    end
    
endmodule
