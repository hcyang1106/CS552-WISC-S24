module ForwardingUnit(
    input [3:0] EX_MEM_RegWd,
    input [3:0] MEM_WB_RegWd,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    input [3:0] ID_EX_RegRd1,
    input [3:0] ID_EX_RegRd2,
    input [3:0] EX_MEM_RegRd2,
    output [1:0] ForwardA,
    output [1:0] ForwardB,
    output [1:0] ForwardC, // for half bit mask
    output [1:0] ForwardD, // for mem stage
    input ALUsrc
);

assign ForwardA = (EX_MEM_RegWrite & (EX_MEM_RegWd == ID_EX_RegRd1)) ? 2'b01 :
                  (MEM_WB_RegWrite & (MEM_WB_RegWd == ID_EX_RegRd1)) ? 2'b10 :
                  2'b00;

assign ForwardB = (ALUsrc == 0) ? ((EX_MEM_RegWrite & (EX_MEM_RegWd == ID_EX_RegRd2)) ? 2'b01 :
                  (MEM_WB_RegWrite & (MEM_WB_RegWd == ID_EX_RegRd2)) ? 2'b10 :
                  2'b00) : 2'b00;

assign ForwardC = (EX_MEM_RegWrite & (EX_MEM_RegWd == ID_EX_RegRd2)) ? 2'b01 :
                  (MEM_WB_RegWrite & (MEM_WB_RegWd == ID_EX_RegRd2)) ? 2'b10 :
                  2'b00;

assign ForwardD = (MEM_WB_RegWrite & (MEM_WB_RegWd == EX_MEM_RegRd2)) ? 2'b01 :
                  2'b00;

endmodule
