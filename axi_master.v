module axi_master 
#(
    parameter ADDR_WIDTH = 64,
              DATA_WIDTH = 64,
              ADDR_SEL   = 8 
)
(
    //  Gobal signal
    input wire              aclk,
    input wire              rst_n,

    //  Write address
    input wire                      AWREADY,
    output reg [ADDR_WIDTH-1:0]     AWADDR,
    output reg                      AWLEN,
    output reg                      AWVALID,

    //  Write data
    input wire                      WREADY,
    output reg [DATA_WIDTH-1:0]     WDATA,
    output reg                      WLAST,
    output reg                      WVALID,
    output reg [ADDR_SEL-1:0]       WSTRB,

    //  Write back
    input wire                      BVALID,
    output reg                      BREADY,

    //  Read address
    input wire                      ARREADY,
    output reg [ADDR_WIDTH-1:0]     ARADDR,
    output reg                      ARLEN,
    output reg                      ARVALID,

    //  Read data
    input wire [DATA_WIDTH-1:0]     RDATA,
    input wire                      RLAST,
    input wire                      RVALID,
    output reg                      RREADY,

    // stall
    input wire                      stall,

    //  interface
    input wire                      en_w,
    input wire                      en_r,
    input wire                      awlen,
    input wire                      arlen,
    input wire [ADDR_WIDTH-1:0]     addr_start_w,
    input wire [ADDR_SEL-1:0]       sel_w,
    input wire [ADDR_WIDTH-1:0]     addr_start_r,
    input wire [DATA_WIDTH-1:0]     data_w,
    output reg [DATA_WIDTH-1:0]     data_r,
    output reg                      r_valid            
);
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)begin
            r_valid <= 1'b0;
        end else begin
            r_valid <= ARREADY;
        end
    end
    reg stall1;

    //assign data_r = RDATA;
    always @(posedge aclk  or negedge rst_n ) begin
        if(!rst_n)begin
            stall1 <= 1'd0;
            //stall2 <= 1'd0;
        end else  begin
            stall1 <= stall;
            //stall2 <= stall1;
        end
    end
    always @(*) begin
        if(stall) begin
            data_r = 'd0;
        end else if(stall1)
            data_r = 'd0;
        else 
            data_r = RDATA;
    end        
    // 先写单数据传输，之后完善FIXED INCR WRAP

    reg en_w1;
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)
            en_w1 <= 1'b0;
        else
            en_w1 <= en_w;
    end
    //  Write address ------------------------------------
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            AWVALID <= 1'b0;
        end else begin
            if(en_w) begin
                AWVALID <= 1'b1;
            end else if(AWVALID && AWREADY) begin
                if(en_w1)
                    AWVALID <= 1'b1;
                else
                    AWVALID <= 1'b0;
            end else begin
                AWVALID <= AWVALID;
            end
        end
    end //always

    /*
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            AWLEN <= 'd0;
        end else begin
            if(en_w) begin
                AWLEN <= awlen;
            //end else if(AWVALID && AWREADY) begin
            //    AWLEN <= 'd0;
            end else begin
                AWLEN <= AWLEN;
            end
        end
    end // always
    */
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            AWADDR <= 'd0;
        end else begin
            if(en_w) begin
                AWADDR <= addr_start_w;
            end else if(AWVALID && AWREADY) begin
                AWADDR <= 'd0;
            end else begin
                AWADDR <= AWADDR;
            end
        end
    end

    //  Write data ------------------------------------------------
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            WVALID <= 1'b0;
        end else begin
            if(en_w) begin
                WVALID <= 1'b1;
            end else if(WVALID && WREADY ) begin
                if(en_w1)
                    WVALID <= 1'b1;
                else
                    WVALID <= 1'b0;
            end else begin
                WVALID <= WVALID;
            end
        end
    end
    // WLAST之后再处理
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            WLAST <= 1'b0;
        end 
    end

    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            WDATA <= 'd0;
        end else begin
            if(en_w) begin
                WDATA <= data_w;
            end else if(WVALID && WREADY )begin
                WDATA <= 'd0;
            end else begin
                WDATA <= WDATA;
            end
        end
    end
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            WSTRB <= 'd0;
        end else begin
            if(en_w) begin
                WSTRB <= sel_w;
            end else if(WVALID && WREADY )begin
                WSTRB <= 'd0;
            end else begin
                WSTRB <= WSTRB;
            end
        end
    end
    //  Write response ------------------------------------
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            BREADY <= 'd0;
        end else begin
            if(AWVALID) begin
                BREADY <= 1'b1;
            end else if(BVALID && BREADY ) begin
                BREADY <= 1'b0;
            end else begin
                BREADY <= BREADY;
            end
        end
    end

    //  Read address -----------------------------------------
    reg en_r1;
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)
            en_r1 <= 1'b0;
        else
            en_r1 <= en_r;
    end

    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            ARVALID <= 1'b0;
        end else begin
            if(en_r) begin
                ARVALID <= 1'b1;
            end else if(ARVALID && ARREADY) begin
                if(en_r1)
                    ARVALID <= 1'b1;
                else
                    ARVALID <= 1'b0;
            end else begin
                ARVALID <= ARVALID;
            end
        end
    end //always
    /*
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            ARLEN <= 'd0;
        end else begin
            if(en_r) begin
                ARLEN <= arlen;
            end else if(ARVALID && ARREADY) begin
                ARLEN <= 'd0;
            end else begin
                ARLEN <= ARLEN;
            end
        end
    end // always
    */
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            ARADDR <= 'd0;
        end else begin
            if(en_r) begin
                ARADDR <= addr_start_r;
            end else if(ARVALID && ARREADY) begin
                ARADDR <= 'd0;
            end else begin
                ARADDR <= ARADDR;
            end
        end
    end
    //  Read data -----------------------------------------------
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            RREADY <= 1'b0;
        end else begin
            if(ARVALID) begin
                RREADY <= 1'b1;
            end else if(RVALID && RREADY ) begin
                RREADY <= 1'b0;
            end else begin
                RREADY <= RREADY;
            end
        end
    end

    

endmodule