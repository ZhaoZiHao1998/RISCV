module axi_slave #(
    parameter ADDR_WIDTH = 64,
              DATA_WIDTH = 64,
              ADDR_SEL   = 8
) (
    // Gobal signal
    input wire                      aclk,
    input wire                      rst_n,
    // Write address
    input wire [ADDR_WIDTH-1:0]     AWADDR,
    input wire                      AWLEN,
    input wire                      AWVALID,
    output reg                      AWREADY,
    // Write data
    input wire                      WVALID,
    input wire                      WLAST,
    input wire [DATA_WIDTH-1:0]     WDATA,
    input wire [ADDR_SEL-1:0]       WSTRB,
    output reg                      WREADY,
    // Write respones
    input wire                      BREADY,
    output reg                      BVALID,
    // Read addrsess
    input wire [ADDR_WIDTH-1:0]     ARADDR,
    input wire                      ARVALID,
    output reg                      ARREADY,
    // Read data
    input wire                      RREADY,
    output reg                      RLAST,
    output reg                      RVALID,
    output wire [DATA_WIDTH-1:0]     RDATA,

    output reg [ADDR_WIDTH-1:0]    Waddr,
    output wire [DATA_WIDTH-1:0]    Wdata,
    output wire                     Wena,
    output wire [ADDR_SEL-1:0]      Wsel,
    output reg [ADDR_WIDTH-1:0]    Raddr,
    output wire                     Rena,
    input wire [DATA_WIDTH-1:0]     Rdata
);



    // Write address
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            AWREADY <= 1'b0;
        end else begin
            //if(AWVALID && !AWREADY)begin
            if(AWVALID )begin
                AWREADY <= 1'b1;
            end else begin
                AWREADY <= 1'b0;
            end
        end
    end

    reg [ADDR_WIDTH-1:0]    addr_w;
    reg [DATA_WIDTH-1:0]    data_w;
    reg [ADDR_SEL-1:0]      sel_w;
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            addr_w <= 'd0;
            data_w <= 'd0;
            sel_w  <= 'd0;
        end else begin
            if(AWVALID)begin
                addr_w <= AWADDR;
                data_w <= WDATA;
                sel_w  <= WSTRB;
            end else begin
                addr_w <= addr_w;
                data_w <= data_w;
                sel_w  <= sel_w;
            end
        end
    end
    // awlen?
    // Write data
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            WREADY <= 1'b0;
        end else begin
            //if(WVALID && !WREADY)begin
            if(WVALID )begin
                WREADY <= 1'b1;
            end else begin
                WREADY <= 1'b0;
            end
        end
    end

    /*
    reg [63:0]rams[0:15];
    always @(posedge aclk or negedge rst_n ) begin
        if(WVALID && WREADY) begin
            rams[addr_w] <= data_w;
            //rams[AWADDR] <= WDATA;
        end
    end
    */

    // Write response
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            BVALID <= 1'b0;
        end else begin
            //if(BREADY && !BVALID)begin
            if(BREADY && WREADY)begin
                BVALID <= 1'b1;
            end else begin
                BVALID <= 1'b0;
            end
        end
    end

    // Read address
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            ARREADY <= 1'b0;
        end else begin
            if(ARVALID)begin
                ARREADY <= 1'b1;
            end else begin
                ARREADY <= 1'b0;
            end
        end
    end

    // Read data
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)begin
            RVALID <= 1'b0;
        end else begin
            if(ARVALID && ARREADY) begin
                RVALID <= 1'b1;
            end else begin
                RVALID <= 1'b0;
            end
        end
    end

    reg [ADDR_WIDTH-1:0]addr_r;
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n) begin
            addr_r <= 'd0;
        end else begin
            if(ARVALID)begin
                addr_r <= ARADDR;
            end else begin
                addr_r <= addr_r;
            end
        end
    end
    /*
    always @(posedge aclk or negedge rst_n ) begin
        if(ARVALID && ARREADY)
            RDATA <= rams[ARADDR];
    end 
    */
    always @(*) begin
        Waddr = addr_w;
    end
    //assign Waddr = addr_w;
    assign Wdata = data_w;
    assign Wena  = (WVALID && WREADY);
    assign Wsel  = sel_w;
    always @(*) begin
        Raddr = addr_r;
    end
    //assign Raddr = addr_r;
    assign RDATA = Rdata;
    /*
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)
            Rena <= 1'b0;
        else
            Rena <= (ARVALID && ARREADY);
    end */
    assign Rena  = (ARVALID && ARREADY);
endmodule