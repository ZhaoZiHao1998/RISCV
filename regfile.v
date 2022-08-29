`include "define.v"

module regfile (
    input wire clk,
    input wire rst,
    input wire [5:0]rs1_addr,
    input wire rs1_ena_r,
    input wire [5:0]rs2_addr,
    input wire rs2_ena_r,
    input wire [5:0]wdata_addr,
    input wire [`REGBUS]wdata,
    input wire wdata_ena,
    
    output reg [`REGBUS]rdata1,
    output reg [`REGBUS]rdata2
);
//define 32 regs
reg [`REGBUS]regs[0:`REGNUM-1];
/*always @(posedge clk ) 
begin
    if(rst == `RSTENABLE)
        begin
            reg[0] <= `ZERO_64;
            reg[1] <= `ZERO_64;
            reg[2] <= `ZERO_64;
            reg[3] <= `ZERO_64;
            reg[4] <= `ZERO_64;
            reg[5] <= `ZERO_64;
            reg[6] <= `ZERO_64;
            reg[7] <= `ZERO_64;
            reg[8] <= `ZERO_64;
            reg[9] <= `ZERO_64;
            reg[10] <= `ZERO_64;
            reg[11] <= `ZERO_64;
            reg[12]] <= `ZERO_64;
            reg[13] <= `ZERO_64;
            reg[14] <= `ZERO_64;
            reg[15] <= `ZERO_64;
            reg[16] <= `ZERO_64;
            reg[17] <= `ZERO_64;
            reg[18] <= `ZERO_64;
            reg[19] <= `ZERO_64;
            reg[20] <= `ZERO_64;
            reg[21] <= `ZERO_64;
            reg[22] <= `ZERO_64;
            reg[23] <= `ZERO_64;
            reg[24] <= `ZERO_64;
            reg[25] <= `ZERO_64;
            reg[26] <= `ZERO_64;
            reg[27] <= `ZERO_64;
            reg[28] <= `ZERO_64;
            reg[29] <= `ZERO_64;
            reg[30] <= `ZERO_64;
            reg[31] <= `ZERO_64;
        end    
end*/
//write
always@(posedge clk)
begin
    if(rst == `RSTENABLE)
        begin
            regs[0] <= `ZERO_64;
            regs[1] <= `ZERO_64;
            regs[2] <= `ZERO_64;
            regs[3] <= `ZERO_64;
            regs[4] <= `ZERO_64;
            regs[5] <= `ZERO_64;
            regs[6] <= `ZERO_64;
            regs[7] <= `ZERO_64;
            regs[8] <= `ZERO_64;
            regs[9] <= `ZERO_64;
            regs[10] <= `ZERO_64;
            regs[11] <= `ZERO_64;
            regs[12] <= `ZERO_64;
            regs[13] <= `ZERO_64;
            regs[14] <= `ZERO_64;
            regs[15] <= `ZERO_64;
            regs[16] <= `ZERO_64;
            regs[17] <= `ZERO_64;
            regs[18] <= `ZERO_64;
            regs[19] <= `ZERO_64;
            regs[20] <= `ZERO_64;
            regs[21] <= `ZERO_64;
            regs[22] <= `ZERO_64;
            regs[23] <= `ZERO_64;
            regs[24] <= `ZERO_64;
            regs[25] <= `ZERO_64;
            regs[26] <= `ZERO_64;
            regs[27] <= `ZERO_64;
            regs[28] <= `ZERO_64;
            regs[29] <= `ZERO_64;
            regs[30] <= `ZERO_64;
            regs[31] <= `ZERO_64;
        end     
    else
        if (wdata_ena == `ENA_ENABLE && wdata_addr != 32'h0)
            regs[wdata_addr] <= wdata;
        else if (wdata_ena == `ENA_ENABLE && wdata_addr == 32'h0)
            regs[wdata_addr] <= `ZERO_64;
end
//read 32 regs rdata1
always@(*)
begin
    if(rst == `RSTENABLE)
        rdata1 <= `ZERO_64;
    else
        if( (rs1_ena_r == `ENA_ENABLE) && (rs1_addr == wdata_addr) && (wdata_ena == `ENA_ENABLE) )
            rdata1 <= wdata;
        else if(rs1_ena_r == `ENA_ENABLE)
            rdata1 <= regs[rs1_addr];
        else
            rdata1 <= `ZERO_64;
end
//read 32 regs rdata2
always@(*)
begin
    if(rst == `RSTENABLE)
        rdata2 <= `ZERO_64;
    else
        if( (rs2_ena_r == `ENA_ENABLE) && (rs2_addr == wdata_addr) && (wdata_ena == `ENA_ENABLE) )
            rdata2 <= wdata;
        else if(rs2_ena_r == `ENA_ENABLE)
            rdata2 <= regs[rs2_addr];
        else
            rdata2 <= `ZERO_64;
end
    
endmodule
