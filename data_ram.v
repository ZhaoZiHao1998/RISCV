`include "define.v"
module data_ram (
    input wire clk,
    input wire ce,
    input wire [`REGBUS]waddr,
    input wire [`REGBUS]raddr,
    input wire [`REGBUS]data_i,
    input wire [7:0]sel,
    input wire r_ena,
    input wire w_ena,

    output reg [`REGBUS]data_o
);
    reg [7:0]data_mem0[0:`DATAMEMNUM-1];    
    reg [7:0]data_mem1[0:`DATAMEMNUM-1];
    reg [7:0]data_mem2[0:`DATAMEMNUM-1];
    reg [7:0]data_mem3[0:`DATAMEMNUM-1];    
    reg [7:0]data_mem4[0:`DATAMEMNUM-1];
    reg [7:0]data_mem5[0:`DATAMEMNUM-1];
    reg [7:0]data_mem6[0:`DATAMEMNUM-1];    
    reg [7:0]data_mem7[0:`DATAMEMNUM-1];
    
    //read
    always@(*)begin
        if(ce == `CHIP_DISABLE) begin
            data_o <= `ZERO_64;
        end else if(r_ena == 1'b1) begin
            data_o <=  {data_mem7[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem6[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem5[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem4[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem3[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem2[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem1[raddr[`DATAMEMNUMLOG2+1:3]],
                        data_mem0[raddr[`DATAMEMNUMLOG2+1:3]]
                        };
        end else begin
            data_o <= `ZERO_64;
        end
    end

    //write 
    always @(posedge clk ) begin
        if(ce == `CHIP_DISABLE)
            data_o <= `ZERO_64;
        else if (w_ena == 1'b1)begin
            if(sel[7] == 1'b1)
                data_mem7[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[63:56];
            if(sel[6] == 1'b1)
                data_mem6[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[55:48]; 
            if(sel[5] == 1'b1)
                data_mem5[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[47:40];
            if(sel[4] == 1'b1)
                data_mem4[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[39:32];
            if(sel[3] == 1'b1)
                data_mem3[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[31:24];
            if(sel[2] == 1'b1)
                data_mem2[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[23:16];
            if(sel[1] == 1'b1)
                data_mem1[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[15:8];
            if(sel[0] == 1'b1)
                data_mem0[waddr[`DATAMEMNUMLOG2+1:3]] <=data_i[7:0];
        end
    end
endmodule