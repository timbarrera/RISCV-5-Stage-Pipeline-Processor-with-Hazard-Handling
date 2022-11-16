`timescale 1ns / 1ps


module ResultW_mux(
    input           [31:0]  ALUResultW,
    input           [31:0]  ReadDataW,
    input           [31:0]  PCPlus4W,
    input           [1:0]   ResultSrcW,
    output logic    [31:0]  ResultW
    );
    
    always_comb begin
        case(ResultSrcW)
            2'b00:  begin   ResultW <= ALUResultW;  end
            2'b01:  begin   ResultW <= ReadDataW;   end
            2'b10:  begin   ResultW <= PCPlus4W;    end
            default: begin  ResultW <= 32'dx;       end   
        endcase
    end
    
    
endmodule
