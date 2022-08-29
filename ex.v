`include "define.v"
//add interrface output reg [`REGBUS]mem_addr_o,output reg [3:0]inst_type_o,output reg [4:0]exe_type_o,
module ex (
    input wire clk,
    input wire rst,
    input wire [3:0]inst_type_i,
    input wire [4:0]exe_type_i,
    //input wire [11:0]Imm_i,
    input wire rd_w_ena_i,
    input wire [5:0]rd_addr_i,
    input wire [`REGBUS]rdata1_i,
    input wire [`REGBUS]rdata2_i,
    input wire [`INSTBUS]inst,

    //input wire [5:0]link_addr_i,

    //div input
    input wire [127:0]div_result_i,
    input wire div_ready_i,

    //
    input wire [`REGBUS]csr_rdata_i,
    input wire [11:0]csr_raddr_i,
    input wire csr_w_ena_i,
    input wire [11:0]csr_w_addr_i,

    //mem csr
    input wire [11:0]mem_csr_w_addr_i,
    input wire mem_csr_w_ena_i,
    input wire [`REGBUS]mem_csr_wdata_i,

    //wb csr
    input wire [11:0]wb_csr_w_addr_i,
    input wire wb_csr_w_ena_i,
    input wire [`REGBUS]wb_csr_wdata_i,
    //div output
    output reg [63:0] div_opdata1_o,
    output reg [63:0] div_opdata2_o,
    output reg        div_start_o,
    output reg        signed_div_o,
    
    output reg [5:0]rd_addr_o,
    output reg rd_w_ena_o,
    output reg [`REGBUS]wdata_o,
    output reg [`REGBUS]mem_addr_o,
    output reg [`REGBUS]mem_data_o,
    output reg [3:0]inst_type_o,
    output reg [4:0]exe_type_o,

    output wire inst_is_load_o,
    //output wire [`REGBUS]temp_rd_addr,

    //output reg stallstop_trans,
    output reg stallreg_ex,
    //to csr_reg
    output wire [11:0]csr_raddr_o,
    output reg [11:0]csr_w_addr_o,
    output reg csr_w_ena_o,
    output reg [`REGBUS]csr_wdata_o
);
reg [127:0]mul_temp;
reg [127:0]mul_temp_invert;
reg [`REGBUS]c_rdata1_i;
reg [`REGBUS]c_rdata2_i;
reg [`REGBUS]sum_data1_data2;
reg [`REGBUS]csr_rdata;

wire [11:0]s_offset   = {inst[31:25],inst[11:7]};
//wire [4:0]zimm        = inst[19:15];
reg stallreg_for_div;

reg inst_is_load_o0,inst_is_load_o1,inst_is_load_o2;
always @(posedge clk) begin
    if(rst)begin
        //inst_is_load_o0 <= 1'b0;
        inst_is_load_o1 <= 1'b0;
        inst_is_load_o2 <= 1'b0;
    end else begin
        //inst_is_load_o0 <= inst_is_load_o;
        inst_is_load_o1 <= inst_is_load_o0; 
        inst_is_load_o2 <= inst_is_load_o1; 
    end
end


assign inst_is_load_o = (inst_is_load_o0 || inst_is_load_o1 || inst_is_load_o2);
assign csr_raddr_o = csr_raddr_i;
always @(*) begin
    if( rst == `RSTENABLE)
        csr_rdata <= `ZERO_64;
    else if((csr_raddr_o == mem_csr_w_addr_i) && (mem_csr_w_ena_i == 1'b1) )
        csr_rdata <= mem_csr_wdata_i;
    else if((csr_raddr_o == wb_csr_w_addr_i) && (wb_csr_w_ena_i == 1'b1))
        csr_rdata <= wb_csr_wdata_i;
    else
        csr_rdata <= csr_rdata_i;
end

always @(*) begin
    stallreg_ex <= stallreg_for_div;
end
always @(*) begin
    if(rst == `RSTENABLE)
        begin
            c_rdata1_i <= 128'h0;
            c_rdata2_i <= 128'h0;
            sum_data1_data2 <= `ZERO_64;
        end
    else if(exe_type_i == `MULH || exe_type_i == `MULHSU)
        begin
            //2'code
            //c_rdata1_i = rdata1_i[63] ? {rdata1_i[63],{{~rdata1_i[62:0]}+1'b1}} : rdata1_i;
            c_rdata1_i = rdata1_i[63] ? ~rdata1_i + 1'b1 : rdata1_i;
            c_rdata2_i = rdata2_i[63] ? ~rdata2_i + 1'b1 : rdata2_i;
        end
    else
        begin
            c_rdata1_i <= 128'h0;
            c_rdata2_i <= 128'h0;
            sum_data1_data2 <= rdata1_i + rdata2_i;
        end
        
end
always @(*) 
begin
    if(rst == `RSTENABLE)
        begin
            rd_w_ena_o <= 1'b0;
            rd_addr_o  <= 6'h0;
            inst_type_o<= 4'h0;
            exe_type_o <= 5'h0;
            csr_w_ena_o<= 1'b1;
            csr_w_addr_o<= 12'h0;
        end 
    else
        begin
            rd_w_ena_o <= rd_w_ena_i;
            rd_addr_o  <= rd_addr_i;
            inst_type_o<= inst_type_i;
            exe_type_o <= exe_type_i;
            csr_w_ena_o<= csr_w_ena_i;
            csr_w_addr_o<= csr_w_addr_i;
        end   
end
always@(*)
begin
    if(rst == `RSTENABLE)
        begin
            wdata_o          <= `ZERO_64;
            stallreg_for_div <= `NOSTOP;
            div_opdata1_o    <= `ZERO_64;
            div_opdata2_o    <= `ZERO_64;
            div_start_o      <= `DIVSTOP;
            signed_div_o     <= 1'b0;
            mul_temp   <= 128'h0;
            mul_temp_invert <= 128'h0;
        end
    else begin   
        if(rd_addr_i == `ZERO_64)
            wdata_o <= `ZERO_64;
        else begin
            wdata_o          <= `ZERO_64;
            stallreg_for_div <= `NOSTOP;
            div_opdata1_o    <= `ZERO_64;
            div_opdata2_o    <= `ZERO_64;
            div_start_o      <= `DIVSTOP;
            signed_div_o     <= 1'b0;
            mem_addr_o       <= `ZERO_64;
            mem_data_o       <= `ZERO_64;
            inst_is_load_o0  <= 1'b0;
            mul_temp   <= 128'h0;
            mul_temp_invert <= 128'h0;
        end
        case({inst_type_i,exe_type_i})

            {`I_TYPE_LOGI,`ADDI}:begin
                wdata_o    <= rdata1_i + rdata2_i;
            end
            {`I_TYPE_LOGI,`SLLI}:begin
                wdata_o    <= rdata1_i << rdata2_i[5:0];
            end
            {`I_TYPE_LOGI,`SLTI}:begin
                if (rdata1_i[63] ^~ rdata2_i[63])
                    wdata_o <= (rdata1_i < rdata2_i) ? 64'h1 : 64'h0;
                else if(rdata2_i[63] == 1'h0)
                    wdata_o <= 64'h1;
                else
                    wdata_o <= 64'h0; 
            end
            {`I_TYPE_LOGI,`SLTIU}:begin
                wdata_o    <= (rdata1_i < rdata2_i) ? 64'h1 : 64'h0;
            end
            {`I_TYPE_LOGI,`XORI}:begin
                wdata_o    <= rdata1_i ^ rdata2_i;
            end
            {`I_TYPE_LOGI,`SRLI}:begin
                wdata_o    <= rdata1_i >> rdata2_i[5:0];
            end
            {`I_TYPE_LOGI,`SRAI}:begin
                wdata_o    <= ({64{rdata1_i[63]}}<<(7'd64 - {1'b0,rdata2_i[5:0]})) | (rdata1_i >> rdata2_i[5:0]);
            end
            {`I_TYPE_LOGI,`ORI}:begin
                wdata_o    <= rdata1_i | rdata2_i;
            end
            {`I_TYPE_LOGI,`ANDI}:begin
                wdata_o    <= rdata1_i & rdata2_i;
            end
            {`IW_TYPE_LOGI,`ADDIW}:begin
                wdata_o    <= {{32{sum_data1_data2[31]}},sum_data1_data2[31:0]};
            end
            {`CSR_TYPE_LOGI,`CSRRC}:begin
                wdata_o    <= csr_rdata;
                csr_wdata_o<= csr_rdata & (~ rdata1_i);
            end
            {`CSR_TYPE_LOGI,`CSRRCI}:begin
                wdata_o    <= csr_rdata;
                csr_wdata_o<= csr_rdata & (~ rdata2_i);
            end
            {`CSR_TYPE_LOGI,`CSRRS}:begin
                wdata_o    <= csr_rdata;
                csr_wdata_o<= csr_rdata | ( rdata1_i);
            end
            {`CSR_TYPE_LOGI,`CSRRSI}:begin
                wdata_o    <= csr_rdata;
                csr_wdata_o<= csr_rdata | ( rdata2_i);
            end
            {`CSR_TYPE_LOGI,`CSRRW}:begin
                wdata_o    <= csr_rdata;
                csr_wdata_o<= rdata1_i;
            end
            {`CSR_TYPE_LOGI,`CSRRWI}:begin
                wdata_o    <= csr_rdata;
                csr_wdata_o<= rdata2_i;
            end
            {`R_TYPE_LOGI,`ADD}:begin
                wdata_o    <= rdata1_i + rdata2_i;
            end
            {`R_TYPE_LOGI,`MUL}:begin
                wdata_o    <= rdata1_i * rdata2_i;
            end
            {`R_TYPE_LOGI,`SUB}:begin
                wdata_o    <= rdata1_i - rdata2_i;
            end
            {`R_TYPE_LOGI,`SLL}:begin
                wdata_o    <= rdata1_i << rdata2_i[5:0];
            end
            {`R_TYPE_LOGI,`MULH}:begin
                mul_temp   <= c_rdata1_i * c_rdata2_i;
                wdata_o    <= mul_temp[127:64];
            end
            {`R_TYPE_LOGI,`SLT}:begin
                if (rdata1_i[63] ^~ rdata2_i[63])
                    wdata_o <= (rdata1_i < rdata2_i) ? 64'h1 : 64'h0;
                else if(rdata2_i[63] == 1'h0)
                    wdata_o <= 64'h1;
                else
                    wdata_o <= 64'h0;
            end
            {`R_TYPE_LOGI,`MULHSU}:begin
                mul_temp   <= c_rdata1_i * rdata2_i;
                mul_temp_invert <= ~ mul_temp + 1'b1;
                wdata_o    <= rdata1_i[63] ? mul_temp_invert[127:64] : mul_temp[127:64];
            end
            {`R_TYPE_LOGI,`SLTU}:begin
                wdata_o    <= (rdata1_i < rdata2_i) ? 32'h1 : 32'h0;
            end
            {`R_TYPE_LOGI,`MULHU}:begin
                mul_temp   <= rdata1_i * rdata2_i;
                wdata_o    <= mul_temp[127:64];
            end
            {`R_TYPE_LOGI,`SRA}:begin
                wdata_o    <= ({64{rdata1_i[63]}}<<(7'd64 - {1'b0,rdata2_i[5:0]})) | (rdata1_i >> rdata2_i[5:0]) ;
            end
            {`R_TYPE_LOGI,`XOR}:begin
                wdata_o    <= rdata1_i ^ rdata2_i;
            end
            {`R_TYPE_LOGI,`DIV}:begin
                if(div_ready_i == `DIVRESULTNOTREADY) begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTART;
                    signed_div_o    <=  1'b1;
                    stallreg_for_div<=  `STOP;
                end else if(div_ready_i == `DIVRESULTREADY)begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b1;
                    stallreg_for_div<= `NOSTOP;
                    wdata_o         <= div_result_i[63:0];
                end else begin
                    div_opdata1_o   <=  `ZERO_64;
                    div_opdata2_o   <=  `ZERO_64;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<=  `NOSTOP;
                end
            end
            {`R_TYPE_LOGI,`DIVU}:begin
                if(div_ready_i == `DIVRESULTNOTREADY) begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTART;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<=  `STOP;
                end else if(div_ready_i == `DIVRESULTREADY)begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<= `NOSTOP;
                    wdata_o         <= div_result_i[63:0];
                end else begin
                    div_opdata1_o   <=  `ZERO_64;
                    div_opdata2_o   <=  `ZERO_64;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<=  `NOSTOP;
                end
            end
            {`R_TYPE_LOGI,`REM}:begin
                if(div_ready_i == `DIVRESULTNOTREADY) begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTART;
                    signed_div_o    <=  1'b1;
                    stallreg_for_div<=  `STOP;
                end else if(div_ready_i == `DIVRESULTREADY)begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b1;
                    stallreg_for_div<= `NOSTOP;
                    wdata_o         <= div_result_i[127:64];
                end else begin
                    div_opdata1_o   <=  `ZERO_64;
                    div_opdata2_o   <=  `ZERO_64;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<=  `NOSTOP;
                end
            end
            {`R_TYPE_LOGI,`REMU}:begin
                if(div_ready_i == `DIVRESULTNOTREADY) begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTART;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<=  `STOP;
                end else if(div_ready_i == `DIVRESULTREADY)begin
                    div_opdata1_o   <=  rdata1_i;
                    div_opdata2_o   <=  rdata2_i;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<= `NOSTOP;
                    wdata_o         <= div_result_i[127:64];
                end else begin
                    div_opdata1_o   <=  `ZERO_64;
                    div_opdata2_o   <=  `ZERO_64;
                    div_start_o     <=  `DIVSTOP;
                    signed_div_o    <=  1'b0;
                    stallreg_for_div<=  `NOSTOP;
                end
            end
            {`R_TYPE_LOGI,`SRL}:begin
                wdata_o    <= rdata1_i >> rdata2_i[5:0];
            end
            {`R_TYPE_LOGI,`OR}:begin
                wdata_o    <= rdata1_i | rdata2_i;
            end
            {`R_TYPE_LOGI,`AND}:begin
                wdata_o    <= rdata1_i & rdata2_i;
            end

            {`U_TYPE_LOGI,`LUI}:begin
                wdata_o    <= rdata2_i;
            end
            {`U_TYPE_LOGI,`AUIPC}:begin
                wdata_o    <= rdata2_i;
            end
            
            {`J_TYPE_LOGI,`JAL}:begin
                wdata_o    <= rdata2_i;
                //stallstop_trans  <= 1'b1;
            end
            {`J_TYPE_LOGI,`JALR}:begin
                wdata_o    <= rdata2_i;
            end
            {`L_TYPE_LOGI,`LB}:begin
                mem_addr_o <= sum_data1_data2;
                inst_is_load_o0 <= 1'b1;
            end
            {`L_TYPE_LOGI,`LBU}:begin
                mem_addr_o <= sum_data1_data2;
                inst_is_load_o0 <= 1'b1;
            end
            {`L_TYPE_LOGI,`LD}:begin
                mem_addr_o <= sum_data1_data2; 
                inst_is_load_o0 <= 1'b1;
            end
            {`L_TYPE_LOGI,`LH}:begin
                mem_addr_o <= sum_data1_data2;
                inst_is_load_o0 <= 1'b1;
            end
            {`L_TYPE_LOGI,`LHU}:begin
                mem_addr_o <= sum_data1_data2;
                inst_is_load_o0 <= 1'b1;
            end
            {`L_TYPE_LOGI,`LW}:begin
                mem_addr_o <= sum_data1_data2;
                inst_is_load_o0 <= 1'b1;
            end
            {`S_TYPE_LOGI,`SB}:begin
                mem_addr_o <= rdata1_i + {{52{s_offset[11]}},s_offset};
                mem_data_o <= rdata2_i;
            end
            {`S_TYPE_LOGI,`SD}:begin
                mem_addr_o <= rdata1_i + {{52{s_offset[11]}},s_offset};
                mem_data_o <= rdata2_i;
            end
            {`S_TYPE_LOGI,`SH}:begin
                mem_addr_o <= rdata1_i + {{52{s_offset[11]}},s_offset};
                mem_data_o <= rdata2_i;
            end
            {`S_TYPE_LOGI,`SW}:begin
                mem_addr_o <= rdata1_i + {{52{s_offset[11]}},s_offset};
                mem_data_o <= rdata2_i;
            end
        endcase
            //end
                
        end
end
    
endmodule