module axi_slave_mux 
#(
    parameter ADDR_WIDTH = 64,
              DATA_WIDTH = 64 ,
              ADDR_SEL   = 8
)
(
    // Gobal 
    input wire                      aclk,
    input wire                      rst_n,
    // (slave0 slave1 slave2 slave3 slave4 slave5 slave6) - mux - master
    // Slave 0 ----------------------------------
    // Write address
    input wire                      S0_AWREADY,
    // Write data
    input wire                      S0_WREADY,
    // Write respones
    input wire                      S0_BVALID,
    // Read addrsess
    input wire                      S0_ARREADY,
    // Read data
    input wire                      S0_RLAST,
    input wire                      S0_RVALID,
    input wire [DATA_WIDTH-1:0]     S0_RDATA,
    // Slave 1 -----------------------------------
    // Write address
    input wire                      S1_AWREADY,
    // Write data
    input wire                      S1_WREADY,
    // Write respones
    input wire                      S1_BVALID,
    // Read addrsess
    input wire                      S1_ARREADY,
    // Read data
    input wire                      S1_RLAST,
    input wire                      S1_RVALID,
    input wire [DATA_WIDTH-1:0]     S1_RDATA,
    // Slave 2 -----------------------------------
    // Write address
    input wire                      S2_AWREADY,
    // Write data
    input wire                      S2_WREADY,
    // Write respones
    input wire                      S2_BVALID,
    // Read addrsess
    input wire                      S2_ARREADY,
    // Read data
    input wire                      S2_RLAST,
    input wire                      S2_RVALID,
    input wire [DATA_WIDTH-1:0]     S2_RDATA,
    // Slave 3 ---------------------------------
    // Write address
    input wire                      S3_AWREADY,
    // Write data
    input wire                      S3_WREADY,
    // Write respones
    input wire                      S3_BVALID,
    // Read addrsess
    input wire                      S3_ARREADY,
    // Read data
    input wire                      S3_RLAST,
    input wire                      S3_RVALID,
    input wire [DATA_WIDTH-1:0]     S3_RDATA,
    // Slave 4 -----------------------------------
    // Write address
    input wire                      S4_AWREADY,
    // Write data
    input wire                      S4_WREADY,
    // Write respones
    input wire                      S4_BVALID,
    // Read addrsess
    input wire                      S4_ARREADY,
    // Read data
    input wire                      S4_RLAST,
    input wire                      S4_RVALID,
    input wire [DATA_WIDTH-1:0]     S4_RDATA,
    // Slave 5 -------------------------------
    // Write address
    input wire                      S5_AWREADY,
    // Write data
    input wire                      S5_WREADY,
    // Write respones
    input wire                      S5_BVALID,
    // Read addrsess
    input wire                      S5_ARREADY,
    // Read data
    input wire                      S5_RLAST,
    input wire                      S5_RVALID,
    input wire [DATA_WIDTH-1:0]     S5_RDATA,
    // Slave 6 -------------------------------
    // Write address
    input wire                      S6_AWREADY,
    // Write data
    input wire                      S6_WREADY,
    // Write respones
    input wire                      S6_BVALID,
    // Read addrsess
    input wire                      S6_ARREADY,
    // Read data
    input wire                      S6_RLAST,
    input wire                      S6_RVALID,
    input wire [DATA_WIDTH-1:0]     S6_RDATA,
    // Slave 7 -------------------------------
    // Write address
    input wire                      S7_AWREADY,
    // Write data
    input wire                      S7_WREADY,
    // Write respones
    input wire                      S7_BVALID,
    // Read addrsess
    input wire                      S7_ARREADY,
    // Read data
    input wire                      S7_RLAST,
    input wire                      S7_RVALID,
    input wire [DATA_WIDTH-1:0]     S7_RDATA,

    // Master -----------------------------------
    // Write address
    output reg                      M_AWREADY,
    // Write data
    output reg                      M_WREADY,
    // Write respones
    output reg                      M_BVALID,
    // Read addrsess
    output reg                      M_ARREADY,
    // Read data
    output reg                      M_RLAST,
    output reg                      M_RVALID,
    output reg [DATA_WIDTH-1:0]     M_RDATA,

    // Master 0 ---------------------------------
    output wire                      M0_AWREADY,
    // Write data
    output wire                      M0_WREADY,
    // Write respones
    output wire                      M0_BVALID,
    // Read addrsess
    output wire                      M0_ARREADY,
    // Read data
    output wire                      M0_RLAST,
    output wire                      M0_RVALID,
    output wire [DATA_WIDTH-1:0]     M0_RDATA,

    // Slave ----------------------------------
    //  Write address
    input wire [ADDR_WIDTH-1:0]     S_AWADDR,
    input wire                      S_AWLEN,
    input wire                      S_AWVALID,
    //  Write data
    input wire [DATA_WIDTH-1:0]     S_WDATA,
    input wire                      S_WLAST,
    input wire                      S_WVALID,
    input wire [ADDR_SEL-1:0]       S_WSTRB,
    //  Write back
    input wire                      S_BREADY,
    //  Read address
    input wire [ADDR_WIDTH-1:0]     S_ARADDR,
    input wire                      S_ARLEN,
    input wire                      S_ARVALID,
    //  Read data
    input wire                      S_RREADY, 

    // Slave 0 ----------------------------------
    input wire [ADDR_WIDTH-1:0]     s0_AWADDR,
    input wire                      s0_AWLEN,
    input wire                      s0_AWVALID,
    //  Write data
    input wire [DATA_WIDTH-1:0]     s0_WDATA,
    input wire                      s0_WLAST,
    input wire                      s0_WVALID,
    input wire [ADDR_SEL-1:0]       s0_WSTRB,
    //  Write back
    input wire                      s0_BREADY,
    //  Read address
    input wire [ADDR_WIDTH-1:0]     s0_ARADDR,
    input wire                      s0_ARLEN,
    input wire                      s0_ARVALID,
    //  Read data
    input wire                      s0_RREADY,    

    // Slave 0 ----------------------------------
    //  Write address
    output wire [ADDR_WIDTH-1:0]     S0_AWADDR,
    output wire                      S0_AWLEN,
    output wire                      S0_AWVALID,
    //  Write data
    output wire [DATA_WIDTH-1:0]     S0_WDATA,
    output wire                      S0_WLAST,
    output wire                      S0_WVALID,
    output wire [ADDR_SEL-1:0]       S0_WSTRB,
    //  Write back
    output wire                      S0_BREADY,
    //  Read address
    output wire [ADDR_WIDTH-1:0]     S0_ARADDR,
    output wire                      S0_ARLEN,
    output wire                      S0_ARVALID,
    //  Read data
    output wire                      S0_RREADY,
    // Slave 1 -----------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S1_AWADDR,
    output reg                      S1_AWLEN,
    output reg                      S1_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S1_WDATA,
    output reg                      S1_WLAST,
    output reg                      S1_WVALID,
    output reg [ADDR_SEL-1:0]      S1_WSTRB,
    //  Write back
    output reg                      S1_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S1_ARADDR,
    output reg                      S1_ARLEN,
    output reg                      S1_ARVALID,
    //  Read data
    output reg                      S1_RREADY,
    // Slave 2 ----------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S2_AWADDR,
    output reg                      S2_AWLEN,
    output reg                      S2_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S2_WDATA,
    output reg                      S2_WLAST,
    output reg                      S2_WVALID,
    output reg [ADDR_SEL-1:0]      S2_WSTRB,
    //  Write back
    output reg                      S2_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S2_ARADDR,
    output reg                      S2_ARLEN,
    output reg                      S2_ARVALID,
    //  Read data
    output reg                      S2_RREADY,
    // Slave 3 ----------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S3_AWADDR,
    output reg                      S3_AWLEN,
    output reg                      S3_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S3_WDATA,
    output reg                      S3_WLAST,
    output reg                      S3_WVALID,
    output reg [ADDR_SEL-1:0]      S3_WSTRB,
    //  Write back
    output reg                      S3_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S3_ARADDR,
    output reg                      S3_ARLEN,
    output reg                      S3_ARVALID,
    //  Read data
    output reg                      S3_RREADY,
    // Slave 4 ----------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S4_AWADDR,
    output reg                      S4_AWLEN,
    output reg                      S4_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S4_WDATA,
    output reg                      S4_WLAST,
    output reg                      S4_WVALID,
    output reg [ADDR_SEL-1:0]      S4_WSTRB,
    //  Write back
    output reg                      S4_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S4_ARADDR,
    output reg                      S4_ARLEN,
    output reg                      S4_ARVALID,
    //  Read data
    output reg                      S4_RREADY,
    // Slave 5 -----------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S5_AWADDR,
    output reg                      S5_AWLEN,
    output reg                      S5_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S5_WDATA,
    output reg                      S5_WLAST,
    output reg                      S5_WVALID,
    output reg [ADDR_SEL-1:0]       S5_WSTRB,
    //  Write back
    output reg                      S5_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S5_ARADDR,
    output reg                      S5_ARLEN,
    output reg                      S5_ARVALID,
    //  Read data
    output reg                      S5_RREADY,
    // Slave 6 --------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S6_AWADDR,
    output reg                      S6_AWLEN,
    output reg                      S6_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S6_WDATA,
    output reg                      S6_WLAST,
    output reg                      S6_WVALID,
    output reg [ADDR_SEL-1:0]       S6_WSTRB,
    //  Write back
    output reg                      S6_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S6_ARADDR,
    output reg                      S6_ARLEN,
    output reg                      S6_ARVALID,
    //  Read data
    output reg                      S6_RREADY,
    // Slave 7 --------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S7_AWADDR,
    output reg                      S7_AWLEN,
    output reg                      S7_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S7_WDATA,
    output reg                      S7_WLAST,
    output reg                      S7_WVALID,
    output reg [ADDR_SEL-1:0]       S7_WSTRB,
    //  Write back
    output reg                      S7_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S7_ARADDR,
    output reg                      S7_ARLEN,
    output reg                      S7_ARVALID,
    //  Read data
    output reg                      S7_RREADY
);


    assign  S0_AWADDR   =  s0_AWADDR;
    assign  S0_AWLEN    =  s0_AWLEN;
    assign  S0_AWVALID  =  s0_AWVALID;
    assign  S0_WDATA    =  s0_WDATA;
    assign  S0_WLAST    =  s0_WLAST;
    assign  S0_WVALID   =  s0_WVALID;
    assign  S0_WSTRB    =  s0_WSTRB;
    assign  S0_BREADY   =  s0_BREADY;
    assign  S0_ARADDR   =  s0_ARADDR;
    assign  S0_ARLEN    =  s0_ARLEN;
    assign  S0_ARVALID  =  s0_ARVALID;
    assign  S0_RREADY   =  s0_RREADY;

    assign  M0_AWREADY  =   S0_AWREADY;
    assign  M0_WREADY   =   S0_WREADY;
    assign  M0_BVALID   =   S0_BVALID;
    assign  M0_ARREADY  =   S0_ARREADY;
    assign  M0_RLAST    =   S0_RLAST;
    assign  M0_RVALID   =   S0_RVALID;
    assign  M0_RDATA    =   S0_RDATA;

    reg [ADDR_WIDTH-1:0] awaddr;
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)begin
            awaddr <= 'd0;
        end else if(S_AWVALID) begin
            awaddr <= S_AWADDR;
        end else begin
            awaddr <= awaddr;
        end
    end
    // Write
    always @(*) begin
        case (awaddr[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                M_AWREADY   = S0_AWREADY;
                M_WREADY    = S0_WREADY;
                M_BVALID    = S0_BVALID;
            end */
            3'b001:begin
                M_AWREADY   = S1_AWREADY;
                M_WREADY    = S1_WREADY;
                M_BVALID    = S1_BVALID;
            end
            3'b010:begin
                M_AWREADY   = S2_AWREADY;
                M_WREADY    = S2_WREADY;
                M_BVALID    = S2_BVALID;
            end
            3'b011:begin
                M_AWREADY   = S3_AWREADY;
                M_WREADY    = S3_WREADY;
                M_BVALID    = S3_BVALID;
            end
            3'b100:begin
                M_AWREADY   = S4_AWREADY;
                M_WREADY    = S4_WREADY;
                M_BVALID    = S4_BVALID;
            end
            3'b101:begin
                M_AWREADY   = S5_AWREADY;
                M_WREADY    = S5_WREADY;
                M_BVALID    = S5_BVALID;
            end
            3'b110:begin
                M_AWREADY   = S6_AWREADY;
                M_WREADY    = S6_WREADY;
                M_BVALID    = S6_BVALID;
            end
            3'b111:begin
                M_AWREADY   = S7_AWREADY;
                M_WREADY    = S7_WREADY;
                M_BVALID    = S7_BVALID;
            end
            default:begin
                M_AWREADY   = 'd0;
                M_WREADY    = 'd0;
                M_BVALID    = 'd0;
            end 
        endcase  
    end

    // Read
    reg [ADDR_WIDTH-1:0] araddr;
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)begin
            araddr <= 'd0;
        end else if(S_ARVALID) begin
            araddr <= S_ARADDR;
        end else begin
            araddr <= araddr;
        end
    end

    always @(*) begin
        case (araddr[(ADDR_WIDTH-1)-:3])
          /*  3'b000:begin
                M_ARREADY   = S0_ARREADY;
                M_RVALID    = S0_RVALID;
                M_RLAST     = S0_RLAST;
                M_RDATA     = S0_RDATA;
            end */
            3'b001:begin
                M_ARREADY   = S1_ARREADY;
                M_RVALID    = S1_RVALID;
                M_RLAST     = S1_RLAST;
                M_RDATA     = S1_RDATA;
            end
            3'b010:begin
                M_ARREADY   = S2_ARREADY;
                M_RVALID    = S2_RVALID;
                M_RLAST     = S2_RLAST;
                M_RDATA     = S2_RDATA;
            end
            3'b011:begin
                M_ARREADY   = S3_ARREADY;
                M_RVALID    = S3_RVALID;
                M_RLAST     = S3_RLAST;
                M_RDATA     = S3_RDATA;
            end
            3'b100:begin
                M_ARREADY   = S4_ARREADY;
                M_RVALID    = S4_RVALID;
                M_RLAST     = S4_RLAST;
                M_RDATA     = S4_RDATA;
            end
            3'b101:begin
                M_ARREADY   = S5_ARREADY;
                M_RVALID    = S5_RVALID;
                M_RLAST     = S5_RLAST;
                M_RDATA     = S5_RDATA;
            end
            3'b110:begin
                M_ARREADY   = S6_ARREADY;
                M_RVALID    = S6_RVALID;
                M_RLAST     = S6_RLAST;
                M_RDATA     = S6_RDATA;
            end
            3'b111:begin
                M_ARREADY   = S7_ARREADY;
                M_RVALID    = S7_RVALID;
                M_RLAST     = S7_RLAST;
                M_RDATA     = S7_RDATA;
            end
            default:begin
                M_ARREADY   = 'd0;
                M_RVALID    = 'd0;
                M_RLAST     = 'd0;
                M_RDATA     = 'd0;
            end 
        endcase 
    end


    always @(*) begin
        case (S_AWADDR[(ADDR_WIDTH-1)-:3])
           /* 3'b000:begin
                S0_AWADDR = S_AWADDR;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end */ 
            3'b001:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = S_AWADDR;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end
            3'b010:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = S_AWADDR;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end
            3'b011:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = S_AWADDR;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end
            3'b100:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = S_AWADDR;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end
            3'b101:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = S_AWADDR;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end
            3'b110:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = S_AWADDR;
                S7_AWADDR = 'd0;
            end
            3'b111:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = S_AWADDR;
            end
            default:begin
                //S0_AWADDR = 'd0;
                S1_AWADDR = 'd0;
                S2_AWADDR = 'd0;
                S3_AWADDR = 'd0;
                S4_AWADDR = 'd0;
                S5_AWADDR = 'd0;
                S6_AWADDR = 'd0;
                S7_AWADDR = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_AWADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_AWVALID = S_AWVALID;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end */
            3'b001:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = S_AWVALID;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end
            3'b010:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = S_AWVALID;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end
            3'b011:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = S_AWVALID;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end
            3'b100:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = S_AWVALID;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end
            3'b101:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = S_AWVALID;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end
            3'b110:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = S_AWVALID;
                S7_AWVALID = 'd0;
            end
            3'b111:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = S_AWVALID;
            end
            default:begin
                //S0_AWVALID = 'd0;
                S1_AWVALID = 'd0;
                S2_AWVALID = 'd0;
                S3_AWVALID = 'd0;
                S4_AWVALID = 'd0;
                S5_AWVALID = 'd0;
                S6_AWVALID = 'd0;
                S7_AWVALID = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_AWADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_WVALID = S_WVALID;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end */
            3'b001:begin
                //S0_WVALID = 'd0;
                S1_WVALID = S_WVALID;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end
            3'b010:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = S_WVALID;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end
            3'b011:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = S_WVALID;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end
            3'b100:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = S_WVALID;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end
            3'b101:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = S_WVALID;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end
            3'b110:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = S_WVALID;
                S7_WVALID = 'd0;
            end
            3'b111:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = S_WVALID;
            end
            default:begin
                //S0_WVALID = 'd0;
                S1_WVALID = 'd0;
                S2_WVALID = 'd0;
                S3_WVALID = 'd0;
                S4_WVALID = 'd0;
                S5_WVALID = 'd0;
                S6_WVALID = 'd0;
                S7_WVALID = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_AWADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_WDATA = S_WDATA;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end */
            3'b001:begin
                //S0_WDATA = 'd0;
                S1_WDATA = S_WDATA;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end
            3'b010:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = S_WDATA;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end
            3'b011:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = S_WDATA;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end
            3'b100:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = S_WDATA;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end
            3'b101:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = S_WDATA;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end
            3'b110:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = S_WDATA;
                S7_WDATA = 'd0;
            end
            3'b111:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = S_WDATA;
            end
            default:begin
                //S0_WDATA = 'd0;
                S1_WDATA = 'd0;
                S2_WDATA = 'd0;
                S3_WDATA = 'd0;
                S4_WDATA = 'd0;
                S5_WDATA = 'd0;
                S6_WDATA = 'd0;
                S7_WDATA = 'd0;
            end 
        endcase
    end
    always @(*) begin
        case (S_AWADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_WSTRB = S_WSTRB;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end */
            3'b001:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = S_WSTRB;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end
            3'b010:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = S_WSTRB;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end
            3'b011:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = S_WSTRB;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end
            3'b100:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = S_WSTRB;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end
            3'b101:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = S_WSTRB;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end
            3'b110:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = S_WSTRB;
                S7_WSTRB = 'd0;
            end
            3'b111:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = S_WSTRB;
            end
            default:begin
                //S0_WSTRB = 'd0;
                S1_WSTRB = 'd0;
                S2_WSTRB = 'd0;
                S3_WSTRB = 'd0;
                S4_WSTRB = 'd0;
                S5_WSTRB = 'd0;
                S6_WSTRB = 'd0;
                S7_WSTRB = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_AWADDR[(ADDR_WIDTH-1)-:3])
           /* 3'b000:begin
                S0_BREADY = S_BREADY;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end */
            3'b001:begin
                //S0_BREADY = 'd0;
                S1_BREADY = S_BREADY;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end
            3'b010:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = S_BREADY;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end
            3'b011:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = S_BREADY;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end
            3'b100:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = S_BREADY;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end
            3'b101:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = S_BREADY;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end
            3'b110:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = S_BREADY;
                S7_BREADY = 'd0;
            end
            3'b111:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = S_BREADY;
            end
            default:begin
                //S0_BREADY = 'd0;
                S1_BREADY = 'd0;
                S2_BREADY = 'd0;
                S3_BREADY = 'd0;
                S4_BREADY = 'd0;
                S5_BREADY = 'd0;
                S6_BREADY = 'd0;
                S7_BREADY = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_ARADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_ARADDR = S_ARADDR;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end */
            3'b001:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = S_ARADDR;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end
            3'b010:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = S_ARADDR;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end
            3'b011:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = S_ARADDR;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end
            3'b100:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = S_ARADDR;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end
            3'b101:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = S_ARADDR;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end
            3'b110:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = S_ARADDR;
                S7_ARADDR = 'd0;
            end
            3'b111:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = S_ARADDR;
            end
            default:begin
                //S0_ARADDR = 'd0;
                S1_ARADDR = 'd0;
                S2_ARADDR = 'd0;
                S3_ARADDR = 'd0;
                S4_ARADDR = 'd0;
                S5_ARADDR = 'd0;
                S6_ARADDR = 'd0;
                S7_ARADDR = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_ARADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_ARVALID = S_ARVALID;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end */
            3'b001:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = S_ARVALID;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end
            3'b010:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = S_ARVALID;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end
            3'b011:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = S_ARVALID;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end
            3'b100:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = S_ARVALID;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end
            3'b101:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = S_ARVALID;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end
            3'b110:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = S_ARVALID;
                S7_ARVALID = 'd0;
            end
            3'b111:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = S_ARVALID;
            end
            default:begin
                //S0_ARVALID = 'd0;
                S1_ARVALID = 'd0;
                S2_ARVALID = 'd0;
                S3_ARVALID = 'd0;
                S4_ARVALID = 'd0;
                S5_ARVALID = 'd0;
                S6_ARVALID = 'd0;
                S7_ARVALID = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_ARADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_RREADY = S_RREADY;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end */
            3'b001:begin
                //S0_RREADY = 'd0;
                S1_RREADY = S_RREADY;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end
            3'b010:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = S_RREADY;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end
            3'b011:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = S_RREADY;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end
            3'b100:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = S_RREADY;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end
            3'b101:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = S_RREADY;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end
            3'b110:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = S_RREADY;
                S7_RREADY = 'd0;
            end
            3'b111:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = S_RREADY;
            end
            default:begin
                //S0_RREADY = 'd0;
                S1_RREADY = 'd0;
                S2_RREADY = 'd0;
                S3_RREADY = 'd0;
                S4_RREADY = 'd0;
                S5_RREADY = 'd0;
                S6_RREADY = 'd0;
                S7_RREADY = 'd0;
            end 
        endcase
    end

    always @(*) begin
        case (S_ARADDR[(ADDR_WIDTH-1)-:3])
            /*3'b000:begin
                S0_ARLEN = S_ARLEN;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end */
            3'b001:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = S_ARLEN;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end
            3'b010:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = S_ARLEN;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end
            3'b011:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = S_ARLEN;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end
            3'b100:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = S_ARLEN;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end
            3'b101:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = S_ARLEN;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end
            3'b110:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = S_ARLEN;
                S7_ARLEN = 'd0;
            end
            3'b111:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = S_ARLEN;
            end
            default:begin
                //S0_ARLEN = 'd0;
                S1_ARLEN = 'd0;
                S2_ARLEN = 'd0;
                S3_ARLEN = 'd0;
                S4_ARLEN = 'd0;
                S5_ARLEN = 'd0;
                S6_ARLEN = 'd0;
                S7_ARLEN = 'd0;
            end 
        endcase
    end

endmodule