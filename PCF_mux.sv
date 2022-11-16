`timescale 1ns / 1ps

module PCF_mux(
    input           [31:0]  PCPlus4F,
    input           [31:0]  PCE,
    input           [31:0]  ImmExtE,
    input                   PCSrcE,
    output logic    [31:0]  PCFp
    );
    
    always_comb begin
        case(PCSrcE)
            1'b0:   begin   PCFp <=  PCPlus4F;                  end
            1'b1:   begin   PCFp <=  PCE + (ImmExtE << 1'b1);   end
            default: begin  PCFp <=  32'b0;                     end
        endcase
    end
    
endmodule
