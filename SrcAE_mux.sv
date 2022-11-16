`timescale 1ns / 1ps

module SrcAE_mux(
    input           [31:0]  RD1E,
    input           [31:0]  ResultW,
    input           [31:0]  ALUResultM,
    input           [1:0]   ForwardAE,
    output  logic   [31:0]  SrcAE
    );
    
    always_comb begin
        case(ForwardAE)
            2'b00: begin    SrcAE <= RD1E;          end  
            2'b01: begin    SrcAE <= ResultW;       end
            2'b10: begin    SrcAE <= ALUResultM;    end
            default: begin  SrcAE <= RD1E;          end
        endcase
    end
    
endmodule
