`include "define.v"

module ex_mem (
    input wire rst,
    input wire clk,
    input wire [5:0]ex_rd_addr,
    input wire ex_rd_w_ena,
    input wire [`REGBUS]ex_wdata,
    
    input wire [`REGBUS]ex_mem_addr,
    input wire [`REGBUS]ex_mem_data,
    input wire [3:0]ex_inst_type,
    input wire [4:0]ex_exe_type,

    input wire [5:0]stall,//crtl
    
    input wire [11:0]ex_csr_w_addr,
    input wire ex_csr_w_ena,
    input wire [`REGBUS]ex_csr_wdata,

    output reg [5:0]mem_rd_addr,
    output reg mem_rd_w_ena,
    output reg [`REGBUS]mem_wdata,

    output reg [`REGBUS]mem_mem_addr,
    output reg [`REGBUS]mem_mem_data,
    output reg [3:0]mem_inst_type,
    output reg [4:0]mem_exe_type,

    output reg [11:0]mem_csr_w_addr,
    output reg mem_csr_w_ena,
    output reg [`REGBUS]mem_csr_wdata
);
always @(posedge clk )
begin
    if(rst == `RSTENABLE)
        begin
            mem_rd_addr  <= 6'h0;
            mem_rd_w_ena <= 1'h0;
            mem_wdata    <= `ZERO_64;
            mem_mem_addr <= `ZERO_64;
            mem_mem_data <= `ZERO_64;
            mem_inst_type<= 4'h0;
            mem_exe_type <= 5'h0;
            mem_csr_w_addr <= 12'h0;
            mem_csr_w_ena  <= 1'b0;
            mem_csr_wdata  <= `ZERO_64;
        end    
    else if(stall[3] == `STOP && stall[4] == `NOSTOP)
        begin
            mem_rd_addr <= 6'h0;
            mem_rd_w_ena <= 1'h0;
            mem_wdata   <= `ZERO_64;
            mem_mem_addr <= `ZERO_64;
            mem_mem_data <= `ZERO_64;
            mem_inst_type<= 4'h0;
            mem_exe_type <= 5'h0;
            mem_csr_w_addr <= 12'h0;
            mem_csr_w_ena  <= 1'b0;
            mem_csr_wdata  <= `ZERO_64;
        end
    else if(stall[3] == `NOSTOP)
        begin
            mem_rd_addr <= ex_rd_addr;
            mem_rd_w_ena<= ex_rd_w_ena;
            mem_wdata   <= ex_wdata;
            mem_mem_addr <= ex_mem_addr;
            mem_mem_data <= ex_mem_data;
            mem_inst_type<= ex_inst_type;
            mem_exe_type <= ex_exe_type;
            mem_csr_w_addr <= ex_csr_w_addr;
            mem_csr_w_ena  <= ex_csr_w_ena;
            mem_csr_wdata  <= ex_csr_wdata;
        end
end
endmodule