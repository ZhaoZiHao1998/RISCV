`include "define.v"
module csr_reg (
    input wire clk,
    input wire rst,
    //from id
    input wire [11:0]csr_raddr_i,
    //from ex
    input wire [11:0]csr_w_addr_i,
    input wire [`REGBUS]csr_w_data_i,
    input wire csr_w_ena_i,

    //output reg [`REGBUS]cycle_o,
    //output reg [`REGBUS]mtvec_o,
    //output reg [`REGBUS]mepc_o,
    //output reg [`REGBUS]mstatus_o,


    output reg [`REGBUS]csr_rdata_o
);
    reg [`REGBUS]cycle;
    reg [`REGBUS]mtvec;
    reg [`REGBUS]mepc;
    reg [`REGBUS]mstatus;
    reg [`REGBUS]mcause;
    reg [`REGBUS]mie;
    reg [`REGBUS]mscratch;

    //assign cycle_o = cycle;
    always @(*) begin
        if(rst == `RSTENABLE)
            cycle = `ZERO_64;
        else
            cycle = cycle + 1'b1; 
    end

    // write 
    always @(posedge clk ) begin
        if(rst == `RSTENABLE) begin
            mtvec       <= `ZERO_64;
            mepc        <= `ZERO_64;
            mstatus     <= `ZERO_64;
            mcause      <= `ZERO_64;
            mie         <= `ZERO_64;
            mscratch    <= `ZERO_64;
        end else begin
            if( csr_w_ena_i == `ENA_ENABLE ) begin
                case ( csr_w_addr_i )
                    `CSR_MTVEC     :     mtvec     <= csr_w_data_i;
                    `CSR_MEPC      :     mepc      <= csr_w_data_i;
                    `CSR_MSTATUS   :     mstatus   <= csr_w_data_i;
                    `CSR_MCAUSE    :     mcause    <= csr_w_data_i;
                    `CSR_MIE       :     mie       <= csr_w_data_i;
                    `CSR_MSCRATCH  :     mscratch  <= csr_w_data_i;
                    default:begin
                        
                    end 
                endcase
            end
        end //else
    end  //always

    always @(*) begin
        if( rst == `RSTENABLE)
            csr_rdata_o     <= `ZERO_64;
        else if( (csr_raddr_i == csr_w_addr_i) && (csr_w_addr_i == 1'b1) ) 
            csr_rdata_o     <= csr_w_data_i;
        else begin
            case (csr_raddr_i)
                `CSR_CYCLE     :     csr_rdata_o  <= cycle;
                `CSR_MTVEC     :     csr_rdata_o  <= mtvec;
                `CSR_MEPC      :     csr_rdata_o  <= mepc;
                `CSR_MSTATUS   :     csr_rdata_o  <= mstatus;
                `CSR_MCAUSE    :     csr_rdata_o  <= mcause;
                `CSR_MIE       :     csr_rdata_o  <= mie;
                `CSR_MSCRATCH  :     csr_rdata_o  <= mscratch; 
                default:begin
                    
                end 
            endcase
        end     
    end //always

endmodule