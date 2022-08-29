`include "define.v"
//rready 和rdata一起返回，讲其加入并插入暂停信号
module cache (
    input wire              clk,
    input wire              rst,
    input wire [`REGBUS]    waddr_in,
    input wire [`REGBUS]    raddr_in,
    input wire [`REGBUS]    wdata_in,
    // mem to cache
    input wire [`REGBUS]    rdata_in,
    
    input wire [7:0]        sel_in,
    input wire              r_ena_in, // 1 is read , 0 is write
    input wire              ce_ram_in,  
    // read valid from axibus
    input wire              axi_r_valid,          
    // cache to mem
    //output reg [`REGBUS]   hit_rdata_out, // read hit return data
    //output reg             hit_wvalid,     // write hit
    //output reg             hit_rvalid,     // read hit
    
    output reg [`REGBUS]   mem_rdata_out,

    // cache to bus to ram
    output reg [`REGBUS]   mem_waddr_out,
    output reg [`REGBUS]   mem_wdata_out,
    output reg             mem_w_ena_out,
    output reg [`REGBUS]   mem_raddr_out,
    output reg             mem_r_ena_out,

    // cache to ctrl
    output reg             stall_cache
);
    // cache 512 blocks ,each block have 64bits
    // tag | index | offset
    //  52      9      3 
    //{v,tag[51:0],data[63:0]} = 117 bits
    reg [116:0] caches [0:511];
    reg         hit;
    
    wire [8:0]index;
    wire [51:0]tag;
    assign index = r_ena_in ? raddr_in[11:3] : waddr_in[11:3];
    assign tag   = r_ena_in ? raddr_in[63:12] : waddr_in[63:12];

    //  hit ? 
    always@( * )begin
        if(rst) begin
            hit <= 1'b0;
        end else if(ce_ram_in == 1'b1 && caches[index][115:64] == tag ) begin // address hit
            hit <= 1'b1;
        end else begin
            hit <= 1'b0;
        end 
    end

    reg [`REGBUS]wdata;
    always @(*) begin
        case(sel_in)
            8'b0000_0001: wdata = {{56{1'b0}},wdata_in[7:0]}; 
            8'b0000_0011: wdata = {{48{1'b0}},wdata_in[15:0]};
            8'b0000_1111: wdata = {{32{1'b0}},wdata_in[31:0]};
            8'b1111_1111: wdata = waddr_in;
            default     : wdata = wdata;
        endcase
    end

    // write
    always @(posedge clk) begin
        if(hit && !r_ena_in)begin  // hit 
            mem_w_ena_out       <=  'd0 ;
            mem_waddr_out       <=  'd0 ;
            mem_wdata_out       <=  'd0;
            caches[index][63:0] <=  wdata;
        end else if(ce_ram_in == 1'b1 && !r_ena_in) begin // no hit
            if(caches[index][116] == 1'b1) begin
                mem_w_ena_out       <= 1'b1 ;
                mem_waddr_out       <= {caches[index][115:64],index,3'b000} ;
                mem_wdata_out       <= caches[index][63:0];
                caches[index]       <= {1'b1,tag,wdata};
            end else begin
                mem_w_ena_out       <=  'd0 ;
                mem_waddr_out       <=  'd0 ;
                mem_wdata_out       <=  'd0;
                caches[index]       <= {1'b1,tag,wdata}; 
            end
        end else begin
            mem_w_ena_out       <=  'd0 ;
            mem_waddr_out       <=  'd0 ;
            mem_wdata_out       <=  'd0;
        end
    end

    reg send;
    // read
    always @(*) begin
        if(rst)begin
            send <= 1'b0;
        end

        if(hit && r_ena_in)begin  // hit 
            if(caches[index][116] == 1'b1)begin
                mem_r_ena_out       <=  'd0 ;
                mem_raddr_out       <=  'd0 ;
                mem_rdata_out       <=  caches[index][63:0];
            end else begin
                if(axi_r_valid == 1'b0 && send == 1'b0) begin // if don't get mem data, send w and r to mem and stall
                    mem_r_ena_out       <=  1'b1 ;
                    mem_raddr_out       <=  raddr_in;
                    send                <= 1'b1;
                    stall_cache         <= 1'b1;
                end else if(axi_r_valid == 1'b1) begin  // if get mem data
                    stall_cache   <= 1'b0;
                    caches[index] <= {1'b1,tag,rdata_in};
                    mem_rdata_out <= raddr_in;
                    send          <= 1'b0;
                end else begin                          // wait mem data
                    mem_r_ena_out   <= 1'b0;
                end
            end      
        end else if(ce_ram_in == 1'b1 && r_ena_in) begin // no hit
            if(caches[index][116] == 1'b1) begin        // if caches have other data
                if(axi_r_valid == 1'b0 && send == 1'b0) begin // if don't get mem data, send w and r to mem and stall
                    mem_w_ena_out       <= 1'b1 ;
                    mem_waddr_out       <= {caches[index][115:64],index,3'b000} ;
                    mem_wdata_out       <= caches[index][63:0];
                    mem_r_ena_out       <=  1'b1 ;
                    mem_raddr_out       <=  raddr_in;
                    send                <= 1'b1;
                    stall_cache         <= 1'b1;
                end else if(axi_r_valid == 1'b1) begin  // if get mem data
                    stall_cache   <= 1'b0;
                    caches[index] <= {1'b1,tag,rdata_in};
                    mem_rdata_out <= raddr_in;
                    send          <= 1'b0;
                end else begin                          // wait mem data
                    mem_w_ena_out   <= 1'b0;
                    mem_r_ena_out   <= 1'b0;
                end
            end else begin                          // if caches have no other data
                if(axi_r_valid == 1'b0 && send == 1'b0) begin // if don't get mem data, send w and r to mem and stall
                    mem_r_ena_out       <=  1'b1 ;
                    mem_raddr_out       <=  raddr_in;
                    send                <= 1'b1;
                    stall_cache         <= 1'b1;
                end else if(axi_r_valid == 1'b1) begin  // if get mem data
                    stall_cache   <= 1'b0;
                    caches[index] <= {1'b1,tag,rdata_in};
                    mem_rdata_out <= raddr_in;
                    send          <= 1'b0;
                end else begin                          // wait mem data
                    mem_r_ena_out   <= 1'b0;
                end
            end
        end else begin
            mem_r_ena_out       <=  'd0 ;
            mem_raddr_out       <=  'd0 ;
            mem_rdata_out       <=  'd0;
        end
    end

endmodule