`include "define.v"

module pc (
    input wire clk,
    input wire rst,
    input wire [5:0]stall,
    
    input wire branch_flag_i,
    input wire [`REGBUS]branch_target_address_i,

    output reg axi_stall,
    
    output reg [`REGBUS]pc_o,//instructions address
    output reg ce_o       //inst reg enable signal
);

always@(posedge clk)
begin
    if (rst == `RSTENABLE) 
        begin
            ce_o <= `INST_ENA_DOWN;
        end 
    else 
        begin
            ce_o <= `INST_ENA_UP;
        end
end

always @(posedge clk) 
begin
    if(ce_o == `INST_ENA_DOWN) begin
        pc_o <= `ZERO_64;
        axi_stall <= 1'b0;
    end   
    else if(stall[0] == `NOSTOP) begin
        if(branch_flag_i == 1'b1)begin
            pc_o <= branch_target_address_i; 
            axi_stall <= 1'b1;   
        end
        else begin
            pc_o <= pc_o + 4'h4; 
            axi_stall <= 1'b0;
        end      
    end
    /*else if(branch_flag_i == 1'b1)
        pc_o <= branch_target_address_i;
    else if(stall[0] == `NOSTOP)
        pc_o <= pc_o + 4'h4;
    */
end
    
endmodule