`include "define.v"

module mem (
    //input wire clk,
    input wire rst,
    input wire [5:0]rd_addr_i,
    input wire rd_w_ena_i,
    input wire [`REGBUS]wdata_i,

    input wire [`REGBUS]mem_addr_i,
    input wire [`REGBUS]mem_data_i,
    input wire [`REGBUS]mem_data_i_ram,
    input wire [3:0]inst_type_i,
    input wire [4:0]exe_type_i,

    input wire [11:0]mem_csr_w_addr_i,
    input wire mem_csr_w_ena_i,
    input wire [`REGBUS]mem_csr_wdata_i,

    output reg [11:0]mem_csr_w_addr_o,
    output reg mem_csr_w_ena_o,
    output reg [`REGBUS]mem_csr_wdata_o,
    
    output reg [5:0]rd_addr_o,//write addr
    output reg rd_w_ena_o,
    output reg [`REGBUS]wdata_o,

    //output reg inst_is_load_o,

    output reg [`REGBUS]mem_waddr_o,
    output reg [`REGBUS]mem_raddr_o,
    output reg [`REGBUS]mem_data_o,
    output reg [7:0]mem_sel_o,
    output reg mem_r_ena_o,
    output reg ce_ram
);
always@(*)
begin
    if(rst == `RSTENABLE)
        begin
            rd_addr_o <= 6'h0;
            rd_w_ena_o<= 1'h0;
            wdata_o   <= `ZERO_64;
            mem_csr_w_addr_o <= 12'h0;
            mem_csr_w_ena_o  <= 1'h0;
            mem_csr_wdata_o  <= `ZERO_64;
        end
    else
        begin
            mem_waddr_o <= `ZERO_64;
            mem_raddr_o <= `ZERO_64;
            mem_data_o <= `ZERO_64;
            mem_r_ena_o<= `ENA_UNABLE;
            
            rd_addr_o  <= rd_addr_i;
            rd_w_ena_o <= rd_w_ena_i;
            wdata_o    <= wdata_i;
            ce_ram         <= `CHIP_DISABLE;

            mem_csr_w_addr_o <= mem_csr_w_addr_i;
            mem_csr_w_ena_o  <= mem_csr_w_ena_i;
            mem_csr_wdata_o  <= mem_csr_wdata_i;
        end
    if(inst_type_i == `L_TYPE_LOGI)
        begin    
            case (exe_type_i)
                `LB:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= {{56{mem_data_i_ram[7]}},mem_data_i_ram[7:0]};
                    mem_sel_o  <= 8'b0000_0001;
                end 
                `LBU:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= {{56{1'b0}},mem_data_i_ram[7:0]};
                    mem_sel_o  <= 8'b0000_0001;
                end
                `LD:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= mem_data_i_ram;
                    mem_sel_o  <= 8'b1111_1111;
                end
                `LH:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= {{48{mem_data_i_ram[15]}},mem_data_i_ram[15:0]};
                    mem_sel_o  <= 8'b0000_0011;
                end
                `LHU:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= {{48{1'b0}},mem_data_i_ram[15:0]};
                    mem_sel_o  <= 8'b0000_0011;
                end
                `LW:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= {{32{mem_data_i_ram[31]}},mem_data_i_ram[31:0]};
                    mem_sel_o  <= 8'b0000_1111;
                end
                `LWU:begin
                    ce_ram         <= `CHIP_ABLE;
                    mem_raddr_o <= {{3'b001},mem_addr_i[60:0]};
                    mem_r_ena_o<= `ENA_ENABLE;
                    wdata_o    <= {{32{1'b0}},mem_data_i_ram[31:0]};
                    mem_sel_o  <= 8'b0000_1111;
                end
                //default: 
            endcase
        end
    if(inst_type_i == `S_TYPE_LOGI)
                begin
                    case (exe_type_i)
                        `SB:begin
                            ce_ram     <= `CHIP_ABLE;
                            mem_waddr_o <= {{3'b001},mem_addr_i[60:0]};
                            mem_data_o <= mem_data_i;
                            mem_r_ena_o<= `ENA_UNABLE;
                            wdata_o    <= `ZERO_64;
                            mem_sel_o  <= 8'b0000_0001;
                        end
                        `SD:begin
                            ce_ram     <= `CHIP_ABLE;
                            mem_waddr_o <= {{3'b001},mem_addr_i[60:0]};
                            mem_data_o <= mem_data_i;
                            mem_r_ena_o<= `ENA_UNABLE;
                            wdata_o    <= `ZERO_64;
                            mem_sel_o  <= 8'b1111_1111;
                        end 
                        `SH:begin
                            ce_ram     <= `CHIP_ABLE;
                            mem_waddr_o <= {{3'b001},mem_addr_i[60:0]};
                            mem_data_o <= mem_data_i;
                            mem_r_ena_o<= `ENA_UNABLE;
                            wdata_o    <= `ZERO_64;
                            mem_sel_o  <= 8'b0000_0011;
                        end
                        `SW:begin
                            ce_ram     <= `CHIP_ABLE;
                            mem_waddr_o <= {{3'b001},mem_addr_i[60:0]};
                            mem_data_o <= mem_data_i;
                            mem_r_ena_o<= `ENA_UNABLE;
                            wdata_o    <= `ZERO_64;
                            mem_sel_o  <= 8'b0000_1111;
                        end
                        //default: 
                    endcase
                end
        //end

end
    
endmodule