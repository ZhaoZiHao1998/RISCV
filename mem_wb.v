`include "define.v"

module mem_wb (
    input wire clk,
    input wire rst,
    input wire [5:0]mem_rd_addr,
    input wire mem_rd_w_ena,
    input wire [`REGBUS]mem_wdata,

    input wire [5:0]stall,//crtl

    input wire [11:0]mem_csr_w_addr,
    input wire mem_csr_w_ena,
    input wire [`REGBUS]mem_csr_wdata,

    output reg [11:0]wb_csr_w_addr,
    output reg wb_csr_w_ena,
    output reg [`REGBUS]wb_csr_wdata,
    
    output reg [5:0]wb_rd_addr,
    output reg wb_rd_w_ena,
    output reg [`REGBUS]wb_wdata
);
always @(posedge clk ) 
begin
    if(rst == `RSTENABLE)
        begin
            wb_rd_addr <= 6'h0;
            wb_rd_w_ena<= 1'h0;
            wb_wdata   <= `ZERO_64;
            wb_csr_w_addr <= 12'h0;
            wb_csr_w_ena  <= 1'h0;
            wb_csr_wdata  <= `ZERO_64;
        end   
    else if(stall[4] == `STOP && stall[5] == `NOSTOP)
        begin
            wb_rd_addr <= 6'h0;
            wb_rd_w_ena<= 1'h0;
            wb_wdata   <= `ZERO_64;
            wb_csr_w_addr <= 12'h0;
            wb_csr_w_ena  <= 1'h0;
            wb_csr_wdata  <= `ZERO_64;
        end 
    else if(stall[4] == `NOSTOP)
        begin
            wb_rd_addr <= mem_rd_addr;
            wb_rd_w_ena<= mem_rd_w_ena;
            wb_wdata   <= mem_wdata;
            wb_csr_w_addr <= mem_csr_w_addr;
            wb_csr_w_ena  <= mem_csr_w_ena;
            wb_csr_wdata  <= mem_csr_wdata;
        end
end
    
endmodule