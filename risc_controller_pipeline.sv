`timescale 1ns / 1ps


module risc_pipeline_controller(
    input   [6:0]   opcode,
    input   [2:0]   funct3,
    input   [6:0]   funct7,
    output          RegWriteD,
    output          ALUSrcD,
    output  [2:0]   ALUControlD,
    output  [1:0]   ImmSrcD,
    output          MemWriteD,
    output  [1:0]   ResultSrcD,
    output          JumpD,
    output          BranchD           
    );
    
    logic [8:0] ctrl_line;
    logic [2:0] alu_sel;
               
    assign {RegWriteD, ALUSrcD, ImmSrcD, MemWriteD, ResultSrcD, JumpD, BranchD} = ctrl_line;
    assign ALUControlD = alu_sel;
    
    always_comb begin
        case(opcode)
            7'b0000011: ctrl_line <= 9'b110000100; //lw
            7'b0100011: ctrl_line <= 9'b010110000; //sw
            7'b0110011: ctrl_line <= 9'b100000000; //r
            7'b0010011: ctrl_line <= 9'b110000000; //i
            7'b1100011: ctrl_line <= 9'b001000001; //b
            7'b1101111: ctrl_line <= 9'b101101010; //j
            default: ctrl_line <= 9'b000000000; 
        endcase
    end

    always_comb begin
        if(opcode == 7'b0110011 || opcode == 7'b0010011) begin //i or r
            if(funct7==7'b0100000) begin
                alu_sel <= 3'b001; //sub
            end
            else begin
                case(funct3)
                    3'b000: begin     alu_sel <= 3'b000;    end //add
                    3'b111: begin     alu_sel <= 3'b010;    end //and
                    3'b110: begin     alu_sel <= 3'b011;    end //or
                    3'b001: begin     alu_sel <= 3'b100;    end //sll
                    3'b101: begin     alu_sel <= 3'b101;    end //srl
                    default: begin    alu_sel <= 3'b000;    end
                endcase
            end
         end   
         else if (opcode == 7'b1100011) begin
            alu_sel <= 3'b001;
         end
         else begin
            alu_sel <= 3'b000;
         end
    end       
     

endmodule
