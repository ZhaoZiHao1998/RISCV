`include "define.v"
module ctrl(
    input wire rst,
    input wire [1:0]stallreq_from_id, //stop from id
    input wire [1:0]stallreq_from_id1,
    input wire stallreq_from_exe,//stop from exe

    input wire stallreq_from_cache,
    //input wire stallstop,

    output reg [5:0]stall 
);
    always@(*)
    begin
        if(rst == `RSTENABLE)
            stall <= 6'b000000;
        else if(stallreq_from_id1 == 2'b10)
            stall <= 6'b000011;
        else if(stallreq_from_id == 2'b01)
            stall <= 6'b000010;
        
        else if(stallreq_from_exe == `STOP)
            stall <= 6'b001111;
        else if(stallreq_from_cache == `STOP)
            stall <= 6'b011111;
        else
            stall <= 6'b000000;
    end

endmodule