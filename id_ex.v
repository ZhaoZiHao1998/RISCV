`include "define.v"

module id_ex (
    input wire clk,
    input wire rst,
    input wire [3:0]id_inst_type,
    input wire [4:0]id_exe_type,
    //input wire [11:0]id_Imm,
    input wire id_rd_w_ena,
    input wire [5:0]id_rd_addr,
    input wire [`REGBUS]id_rdata1,
    input wire [`REGBUS]id_rdata2,
    input wire [`INSTBUS]id_inst,

    input wire [5:0]stall, // crtl

    //from id
    input wire [11:0]id_csr_raddr_i,
    input wire id_csr_w_ena_i,
    input wire [11:0]id_csr_w_addr_i, 

    //trans isa
    //input wire [5:0]id_link_addr,
    
    output reg [`INSTBUS]ex_inst,
    output reg [3:0]ex_inst_type,
    output reg [4:0]ex_exe_type,
    //output reg [11:0]ex_Imm,
    output reg ex_rd_w_ena,
    output reg [5:0]ex_rd_addr,
    output reg [`REGBUS]ex_rdata1,
    output reg [`REGBUS]ex_rdata2, 
    
    //to ex
    output reg [11:0]ex_csr_raddr_o,
    output reg ex_csr_w_ena_o,
    output reg [11:0]ex_csr_w_addr_o
    //output reg [5:0]ex_link_addr
);
always @(posedge clk )
begin
    if(rst == `RSTENABLE)
        begin
            ex_inst_type <= 4'h0;
            ex_exe_type  <= 5'h0;
            //ex_Imm       <= 12'h0;
            ex_rd_w_ena  <= 1'h0;
            ex_rd_addr   <= 1'h0;
            ex_rdata1    <= `ZERO_64;
            ex_rdata2    <= `ZERO_64;
            ex_inst      <= `ZERO_32;
            ex_csr_raddr_o<= 12'h0;
            ex_csr_w_ena_o<= `ZERO_64;
            ex_csr_w_addr_o<= 12'h0;

            //ex_link_addr <= 6'h0;
        end  
    else if(stall[2] == `STOP && stall[3] == `NOSTOP)
    //else if(stall[2] == `STOP )
        begin
            ex_inst_type <= 4'h0;
            ex_exe_type  <= 5'h0;
            ex_rd_w_ena  <= 1'h0;
            ex_rd_addr   <= 1'h0;
            ex_rdata1    <= `ZERO_64;
            ex_rdata2    <= `ZERO_64; 
            ex_inst      <= `ZERO_32;
            ex_csr_raddr_o<= 12'h0;
            ex_csr_w_ena_o<= `ZERO_64;
            ex_csr_w_addr_o<= 12'h0;

            //ex_link_addr <= 6'h0;
        end  
    else if(stall[2] == `NOSTOP)
        begin
            ex_inst_type <= id_inst_type;
            ex_exe_type  <= id_exe_type;
            //ex_Imm       <= id_Imm;
            ex_rd_w_ena  <= id_rd_w_ena;
            ex_rd_addr   <= id_rd_addr;
            ex_rdata1    <= id_rdata1;
            ex_rdata2    <= id_rdata2;
            ex_inst      <= id_inst;
            ex_csr_raddr_o<= id_csr_raddr_i;
            ex_csr_w_ena_o<= id_csr_w_ena_i;
            ex_csr_w_addr_o<= id_csr_w_addr_i;
            //ex_link_addr <= id_link_addr;
        end
end
    
endmodule