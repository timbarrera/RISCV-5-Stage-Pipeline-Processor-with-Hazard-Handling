`timescale 1ns / 1ps

module ALUSrc_mux(
    input        [31:0] WriteDataE,
    input        [31:0] ImmExtE,
    input               ALUSrcE,
    output logic [31:0] SrcBE
    );
    
    always_comb begin
        case(ALUSrcE)
            1'b0:   begin   SrcBE <= WriteDataE;  end
            1'b1:   begin   SrcBE <= ImmExtE;   end
            default: begin  SrcBE <= WriteDataE;  end
        endcase
    end
    
endmodule
