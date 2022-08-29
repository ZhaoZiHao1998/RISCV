`include "define.v"

module pc_id (
    input wire clk,
    input wire rst,
    input wire [`REGBUS]pc_pc, //inst addr from PC
    input wire [`INSTBUS]pc_instreg_inst,//inst from inst reg
    input wire [5:0]stall,
    
    output reg [`REGBUS]id_pc,
    output reg [`INSTBUS]id_inst  //inst from instreg to ID
);
always @(posedge clk)
begin
    if (rst == `RSTENABLE)
        begin
            id_inst <= `ZERO_32;
            id_pc   <= `ZERO_64;
        end
    else if(stall[1] == `STOP && stall[2] == `NOSTOP)
    //else if(stall[1] == `STOP)
        begin
            id_inst <= `ZERO_32;
            id_pc   <= `ZERO_64;
        end
    else if(stall[1] == `NOSTOP)
        begin
            id_inst <= pc_instreg_inst;
            id_pc   <= pc_pc;
        end
end
endmodule