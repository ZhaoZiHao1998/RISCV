module axi_master_mux 
#(
    parameter ADDR_WIDTH = 64,
              DATA_WIDTH = 64,
              ADDR_SEL   = 8 
)
(
    //  Gobal signal
    input wire              aclk,
    input wire              rst_n,
    //  (M0 M1 M2) - MUX - S **************************************
    //  Master 0 -------------------------------------
    //  Write address
    input wire [ADDR_WIDTH-1:0]     M0_AWADDR,
    input wire                      M0_AWLEN,
    input wire                      M0_AWVALID,
    //  Write data
    input wire [DATA_WIDTH-1:0]     M0_WDATA,
    input wire                      M0_WLAST,
    input wire                      M0_WVALID,
    input wire [ADDR_SEL-1:0]       M0_WSTRB, 
    //  Write back
    input wire                      M0_BREADY,
    //  Read address
    input wire [ADDR_WIDTH-1:0]     M0_ARADDR,
    input wire                      M0_ARLEN,
    input wire                      M0_ARVALID,
    //  Read data
    input wire                      M0_RREADY,   

    //  Master 1 --------------------------------------
    //  Write address
    input wire [ADDR_WIDTH-1:0]     M1_AWADDR,
    input wire                      M1_AWLEN,
    input wire                      M1_AWVALID,
    //  Write data
    input wire [DATA_WIDTH-1:0]     M1_WDATA,
    input wire                      M1_WLAST,
    input wire                      M1_WVALID,
    input wire [ADDR_SEL-1:0]       M1_WSTRB,
    //  Write back
    input wire                      M1_BREADY,
    //  Read address
    input wire [ADDR_WIDTH-1:0]     M1_ARADDR,
    input wire                      M1_ARLEN,
    input wire                      M1_ARVALID,
    //  Read data
    input wire                      M1_RREADY, 

    //  Master 2 ----------------------------------------
    //  Write address
    input wire [ADDR_WIDTH-1:0]     M2_AWADDR,
    input wire                      M2_AWLEN,
    input wire                      M2_AWVALID,
    //  Write data
    input wire [DATA_WIDTH-1:0]     M2_WDATA,
    input wire                      M2_WLAST,
    input wire                      M2_WVALID,
    input wire [ADDR_SEL-1:0]       M2_WSTRB,
    //  Write back
    input wire                      M2_BREADY,
    //  Read address
    input wire [ADDR_WIDTH-1:0]     M2_ARADDR,
    input wire                      M2_ARLEN,
    input wire                      M2_ARVALID,
    //  Read data
    input wire                      M2_RREADY, 

    //  Slave --------------------------------------------
    //  Write address
    output reg [ADDR_WIDTH-1:0]     S_AWADDR,
    output reg                      S_AWLEN,
    output reg                      S_AWVALID,
    //  Write data
    output reg [DATA_WIDTH-1:0]     S_WDATA,
    output reg                      S_WLAST,
    output reg                      S_WVALID,
    output reg [ADDR_SEL-1:0]       S_WSTRB,
    //  Write back
    output reg                      S_BREADY,
    //  Read address
    output reg [ADDR_WIDTH-1:0]     S_ARADDR,
    output reg                      S_ARLEN,
    output reg                      S_ARVALID,
    //  Read data
    output reg                      S_RREADY,
    // Slave0 -------------------------------------------
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
    // ****************************************************************
    // S - router - (M0 M1 M2)-----------------------

    // Master input signal from slave--------------
    //  Write address
    input wire                      M_AWREADY,
    //  Write data
    input wire                      M_WREADY,
    //  Write back
    input wire                      M_BVALID,
    //  Read address
    input wire                      M_ARREADY,
    //  Read data
    input wire [DATA_WIDTH-1:0]     M_RDATA,
    input wire                      M_RLAST,
    input wire                      M_RVALID,
    // Master 0 --------------------------------
    input wire                      m0_AWREADY,
    input wire                      m0_WREADY,
    input wire                      m0_BVALID,
    input wire                      m0_ARREADY,
    input wire [DATA_WIDTH-1:0]     m0_RDATA,
    input wire                      m0_RLAST,
    input wire                      m0_RVALID,

    // Master 0  -------------------------------
    output wire                      M0_AWREADY,
    output wire                      M0_WREADY,
    output wire                      M0_BVALID,
    output wire                      M0_ARREADY,
    output wire [DATA_WIDTH-1:0]     M0_RDATA,
    output wire                      M0_RLAST,
    output wire                      M0_RVALID,
    // Master 1  --------------------------------
    output reg                      M1_AWREADY,
    output reg                      M1_WREADY,
    output reg                      M1_BVALID,
    output reg                      M1_ARREADY,
    output reg [DATA_WIDTH-1:0]     M1_RDATA,
    output reg                      M1_RLAST,
    output reg                      M1_RVALID,
    // Master 2 --------------------------------
    output reg                      M2_AWREADY,
    output reg                      M2_WREADY,
    output reg                      M2_BVALID,
    output reg                      M2_ARREADY,
    output reg [DATA_WIDTH-1:0]     M2_RDATA,
    output reg                      M2_RLAST,
    output reg                      M2_RVALID,
    

    //  sel ena
    //input wire                      m0_grant_w,
    input wire                      m1_grant_w,
    input wire                      m2_grant_w,

   // input wire                      m0_grant_r,
    input wire                      m1_grant_r,
    input wire                      m2_grant_r
);
 
    assign  S0_AWADDR   =  M0_AWADDR;
    assign  S0_AWLEN    =  M0_AWLEN;
    assign  S0_AWVALID  =  M0_AWVALID;
    assign  S0_WDATA    =  M0_WDATA;
    assign  S0_WLAST    =  M0_WLAST;
    assign  S0_WVALID   =  M0_WVALID;
    assign  S0_WSTRB    =  M0_WSTRB;
    assign  S0_BREADY   =  M0_BREADY;
    assign  S0_ARADDR   =  M0_ARADDR;
    assign  S0_ARLEN    =  M0_ARLEN;
    assign  S0_ARVALID  =  M0_ARVALID;
    assign  S0_RREADY   =  M0_RREADY;

    assign  M0_AWREADY  =  m0_AWREADY  ;    
    assign  M0_WREADY   =  m0_WREADY   ;    
    assign  M0_BVALID   =  m0_BVALID   ;    
    assign  M0_ARREADY  =  m0_ARREADY  ;    
    assign  M0_RDATA    =  m0_RDATA    ;    
    assign  M0_RLAST    =  m0_RLAST    ;    
    assign  M0_RVALID   =  m0_RVALID   ;    

    //  Write mux
    always @(*) begin
        if(!rst_n) begin
            S_AWADDR    = 'd0;
            S_AWLEN     = 'd0;
            S_AWVALID   = 'd0;
            S_WDATA     = 'd0;
            S_WLAST     = 'd0;
            S_WVALID    = 'd0;
            S_BREADY    = 'd0;
            S_WSTRB     = 'd0;
        end else begin
            //case ({m0_grant_w,m1_grant_w,m2_grant_w})
            case ({m1_grant_w,m2_grant_w})
               /* 3'b100:begin
                    S_AWADDR    = M0_AWADDR;
                    S_AWLEN     = M0_AWLEN;
                    S_AWVALID   = M0_AWVALID;
                    S_WDATA     = M0_WDATA;
                    S_WLAST     = M0_WLAST;
                    S_WVALID    = M0_WVALID;
                    S_BREADY    = M0_BREADY;
                end */
                2'b10:begin
                    S_AWADDR    = M1_AWADDR;
                    S_AWLEN     = M1_AWLEN;
                    S_AWVALID   = M1_AWVALID;
                    S_WDATA     = M1_WDATA;
                    S_WLAST     = M1_WLAST;
                    S_WVALID    = M1_WVALID;
                    S_WSTRB     = M1_WSTRB;
                    S_BREADY    = M1_BREADY;
                end
                2'b01:begin
                    S_AWADDR    = M2_AWADDR;
                    S_AWLEN     = M2_AWLEN;
                    S_AWVALID   = M2_AWVALID;
                    S_WDATA     = M2_WDATA;
                    S_WLAST     = M2_WLAST;
                    S_WVALID    = M2_WVALID;
                    S_WSTRB     = M2_WSTRB;
                    S_BREADY    = M2_BREADY;
                end
                default: begin
                    S_AWADDR    = 'd0;
                    S_AWLEN     = 'd0;
                    S_AWVALID   = 'd0;
                    S_WDATA     = 'd0;
                    S_WLAST     = 'd0;
                    S_WVALID    = 'd0;
                    S_WSTRB     = 'd0;
                    S_BREADY    = 'd0;
                end
            endcase
        end
    end

    //  Read mux
    always @(*) begin
        if(!rst_n) begin
            S_ARADDR    = 'd0;
            S_ARLEN     = 'd0;
            S_ARVALID   = 'd0;
            S_RREADY    = 'd0;
        end else begin
            //case ({m0_grant_r,m1_grant_r,m2_grant_r})
            case ({m1_grant_r,m2_grant_r})
                /*3'b100:begin
                    S_ARADDR    = M0_ARADDR;
                    S_ARLEN     = M0_ARLEN;
                    S_ARVALID   = M0_ARVALID;
                    S_RREADY    = M0_RREADY;
                end */
                2'b10:begin
                    S_ARADDR    = M1_ARADDR;
                    S_ARLEN     = M1_ARLEN;
                    S_ARVALID   = M1_ARVALID;
                    S_RREADY    = M1_RREADY;
                end
                2'b01:begin
                    S_ARADDR    = M2_ARADDR;
                    S_ARLEN     = M2_ARLEN;
                    S_ARVALID   = M2_ARVALID;
                    S_RREADY    = M2_RREADY;
                end
                default: begin
                    S_ARADDR    = 'd0;
                    S_ARLEN     = 'd0;
                    S_ARVALID   = 'd0;
                    S_RREADY    = 'd0;
                end
            endcase
        end
    end

    /*
    reg m0_grant_w1, m1_grant_w1, m2_grant_w1;
    always @(posedge aclk or negedge rst_n) begin
        if(!rst_n)begin
            m0_grant_w1 <= 'd0;
            m1_grant_w1 <= 'd0;
            m2_grant_w1 <= 'd0;
        end else begin
            m0_grant_w1 <= m0_grant_w;
            m1_grant_w1 <= m1_grant_w;
            m2_grant_w1 <= m2_grant_w;
        end
    end  */
    // router awready
    always @(*) begin
        if(!rst_n)begin
            //M0_AWREADY  = 'd0;
            M1_AWREADY  = 'd0;
            M2_AWREADY  = 'd0;
        end else begin
            //case ({m0_grant_w1,m1_grant_w1,m2_grant_w1})
            case ({m1_grant_w,m2_grant_w})
                /*3'b100:begin
                    M0_AWREADY  = M_AWREADY;
                    M1_AWREADY  = 'd0;
                    M2_AWREADY  = 'd0;
                end*/ 
                2'b10:begin
                  //  M0_AWREADY  = 'd0;
                    M1_AWREADY  = M_AWREADY;
                    M2_AWREADY  = 'd0;
                end
                2'b01:begin
                    //M0_AWREADY  = 'd0;
                    M1_AWREADY  = 'd0;
                    M2_AWREADY  = M_AWREADY;
                end
                default: begin
                    //M0_AWREADY  = 'd0;
                    M1_AWREADY  = 'd0;
                    M2_AWREADY  = 'd0;
                end
            endcase
        end
    end
    // router wready
    always @(*) begin
        if(!rst_n)begin
            //M0_WREADY  = 'd0;
            M1_WREADY  = 'd0;
            M2_WREADY  = 'd0;
        end else begin
            //case ({m0_grant_w1,m1_grant_w1,m2_grant_w1})
            case ({m1_grant_w,m2_grant_w})
              /*  3'b100:begin
                    M0_WREADY  = M_WREADY;
                    M1_WREADY  = 'd0;
                    M2_WREADY  = 'd0;
                end */
                2'b10:begin
                   // M0_WREADY  = 'd0;
                    M1_WREADY  = M_WREADY;
                    M2_WREADY  = 'd0;
                end
                2'b01:begin
                  //  M0_WREADY  = 'd0;
                    M1_WREADY  = 'd0;
                    M2_WREADY  = M_WREADY;
                end
                default: begin
                    //M0_WREADY  = 'd0;
                    M1_WREADY  = 'd0;
                    M2_WREADY  = 'd0;
                end
            endcase
        end
    end
    // ROUTER bvalid
    always @(*) begin
        if(!rst_n)begin
            //M0_BVALID  = 'd0;
            M1_BVALID  = 'd0;
            M2_BVALID  = 'd0;
        end else begin
            //case ({m0_grant_w1,m1_grant_w1,m2_grant_w1})
            case ({m1_grant_w,m2_grant_w})
               /* 3'b100:begin
                    M0_BVALID  = M_BVALID;
                    M1_BVALID  = 'd0;
                    M2_BVALID  = 'd0;
                end */
                2'b10:begin
                  //  M0_BVALID  = 'd0;
                    M1_BVALID  = M_BVALID;
                    M2_BVALID  = 'd0;
                end
                2'b01:begin
                  //  M0_BVALID  = 'd0;
                    M1_BVALID  = 'd0;
                    M2_BVALID  = M_BVALID;
                end
                default: begin
                    //M0_BVALID  = 'd0;
                    M1_BVALID  = 'd0;
                    M2_BVALID  = 'd0;
                end
            endcase
        end
    end
    
    // router aready
    always @(*) begin
        if(!rst_n)begin
            //M0_ARREADY  = 'd0;
            M1_ARREADY  = 'd0;
            M2_ARREADY  = 'd0;
        end else begin
            //case ({m0_grant_r,m1_grant_r,m2_grant_r})
            case ({m1_grant_r,m2_grant_r})
               /* 3'b100:begin
                    M0_ARREADY  = M_ARREADY;
                    M1_ARREADY  = 'd0;
                    M2_ARREADY  = 'd0;
                end */
                2'b10:begin
                  //  M0_ARREADY  = 'd0;
                    M1_ARREADY  = M_ARREADY;
                    M2_ARREADY  = 'd0;
                end
                2'b01:begin
                  //  M0_ARREADY  = 'd0;
                    M1_ARREADY  = 'd0;
                    M2_ARREADY  = M_ARREADY;
                end
                default: begin
                    //M0_ARREADY  = 'd0;
                    M1_ARREADY  = 'd0;
                    M2_ARREADY  = 'd0;
                end
            endcase
        end
    end
    // router rdata
    always @(*) begin
        if(!rst_n)begin
            //M0_RDATA  = 'd0;
            M1_RDATA  = 'd0;
            M2_RDATA  = 'd0;
        end else begin
            //case ({m0_grant_r,m1_grant_r,m2_grant_r})
            case ({m1_grant_r,m2_grant_r})
              /*  3'b100:begin
                    M0_RDATA  = M_RDATA;
                    M1_RDATA  = 'd0;
                    M2_RDATA  = 'd0;
                end */
                2'b10:begin
                  //  M0_RDATA  = 'd0;
                    M1_RDATA  = M_RDATA;
                    M2_RDATA  = 'd0;
                end
                2'b01:begin
                  //  M0_RDATA  = 'd0;
                    M1_RDATA  = 'd0;
                    M2_RDATA  = M_RDATA;
                end
                default: begin
                    //M0_RDATA  = 'd0;
                    M1_RDATA  = 'd0;
                    M2_RDATA  = 'd0;
                end
            endcase
        end
    end
    // router rlast
    always @(*) begin
        if(!rst_n)begin
           // M0_RLAST  = 'd0;
            M1_RLAST  = 'd0;
            M2_RLAST  = 'd0;
        end else begin
            //case ({m0_grant_r,m1_grant_r,m2_grant_r})
            case ({m1_grant_r,m2_grant_r})
               /* 3'b100:begin
                    M0_RLAST  = M_RLAST;
                    M1_RLAST  = 'd0;
                    M2_RLAST  = 'd0;
                end */
                2'b10:begin
                   // M0_RLAST  = 'd0;
                    M1_RLAST  = M_RLAST;
                    M2_RLAST  = 'd0;
                end
                2'b01:begin
                   // M0_RLAST  = 'd0;
                    M1_RLAST  = 'd0;
                    M2_RLAST  = M_RLAST;
                end
                default: begin
                    //M0_RLAST  = 'd0;
                    M1_RLAST  = 'd0;
                    M2_RLAST  = 'd0;
                end
            endcase
        end
    end

    // router rvalid
    always @(*) begin
        if(!rst_n)begin
           // M0_RVALID  = 'd0;
            M1_RVALID  = 'd0;
            M2_RVALID  = 'd0;
        end else begin
            //case ({m0_grant_r,m1_grant_r,m2_grant_r})
            case ({m1_grant_r,m2_grant_r})
               /* 3'b100:begin
                    M0_RVALID  = M_RVALID;
                    M1_RVALID  = 'd0;
                    M2_RVALID  = 'd0;
                end */
                2'b10:begin
                   // M0_RVALID  = 'd0;
                    M1_RVALID  = M_RVALID;
                    M2_RVALID  = 'd0;
                end
                2'b01:begin
                   // M0_RVALID  = 'd0;
                    M1_RVALID  = 'd0;
                    M2_RVALID  = M_RVALID;
                end
                default: begin
                   // M0_RVALID  = 'd0;
                    M1_RVALID  = 'd0;
                    M2_RVALID  = 'd0;
                end
            endcase
        end
    end

endmodule