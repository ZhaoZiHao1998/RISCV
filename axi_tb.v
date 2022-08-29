module axi_tb;

    parameter ADDR_WIDTH = 64;
     parameter         DATA_WIDTH = 32; 

    reg                      aclk;
    reg                      rst_n;

    reg                      M0_en_w;
    reg                      M0_en_r;
    reg [ADDR_WIDTH-1:0]     M0_addr_start_w;
    reg [ADDR_WIDTH-1:0]     M0_addr_start_r;
    reg [DATA_WIDTH-1:0]     M0_data_w;
    wire [DATA_WIDTH-1:0]     M0_data_r;

    reg                      M1_en_w;
    reg                      M1_en_r;
    reg [ADDR_WIDTH-1:0]     M1_addr_start_w;
    reg [ADDR_WIDTH-1:0]     M1_addr_start_r;
    reg [DATA_WIDTH-1:0]     M1_data_w;
    wire [DATA_WIDTH-1:0]     M1_data_r;
    
    reg                      M2_en_w;
    reg                      M2_en_r;
    reg [ADDR_WIDTH-1:0]     M2_addr_start_w;
    reg [ADDR_WIDTH-1:0]     M2_addr_start_r;
    reg [DATA_WIDTH-1:0]     M2_data_w;
    wire [DATA_WIDTH-1:0]     M2_data_r;

always #5 aclk = !aclk;
initial begin
    aclk  = 1'b0;
    rst_n = 1'b0;
    #26
    rst_n = 1'b1;
    
    M1_en_w = 1'b1;
    M1_addr_start_w = 'd1;
    M1_data_w = 'd1;

    #10
    M1_data_w = 'd2;
    M1_en_r   = 1'b1;
    M1_addr_start_r = 'd1;
    #10
    M1_data_w = 'd3;
    M1_addr_start_r = 'd1;
    
end

axi 
 u_axi (
    .aclk                    ( aclk              ),
    .rst_n                   ( rst_n             ),
    .M0_en_w                 ( M0_en_w           ),
    .M0_en_r                 ( M0_en_r           ),
    .M0_addr_start_w         ( M0_addr_start_w   ),
    .M0_addr_start_r         ( M0_addr_start_r   ),
    .M0_data_w               ( M0_data_w         ),
    .M1_en_w                 ( M1_en_w           ),
    .M1_en_r                 ( M1_en_r           ),
    .M1_addr_start_w         ( M1_addr_start_w   ),
    .M1_addr_start_r         ( M1_addr_start_r   ),
    .M1_data_w               ( M1_data_w         ),
    .M2_en_w                 ( M2_en_w           ),
    .M2_en_r                 ( M2_en_r           ),
    .M2_addr_start_w         ( M2_addr_start_w   ),
    .M2_addr_start_r         ( M2_addr_start_r   ),
    .M2_data_w               ( M2_data_w         ),

    .M0_data_r               ( M0_data_r         ),
    .M1_data_r               ( M1_data_r         ),
    .M2_data_r               ( M2_data_r         )
);


/*        
        parameter ADDR_WIDTH = 32;
        parameter      DATA_WIDTH = 64;
    reg              aclk;
    reg              rst_n;

    //  Write address
    wire                      AWREADY;
    wire [ADDR_WIDTH-1:0]     AWADDR;
    wire                      AWLEN;
    wire                      AWVALID;

    //  Write data
    wire                      WREADY;
    wire [DATA_WIDTH-1:0]     WDATA;
    wire                      WLAST;
    wire                      WVALID;

    //  Write back
    wire                      BVALID;
    wire                      BREADY;

    //  Read address
    wire                      ARREADY;
    wire [ADDR_WIDTH-1:0]     ARADDR;
    wire                      ARLEN;
    wire                      ARVALID;

    //  Read data
    wire [DATA_WIDTH-1:0]     RDATA;
    wire                      RLAST;
    wire                      RVALID;
    wire                      RREADY;

    //  interface
    reg                      en_w;
    reg                      en_r;
    reg                      awlen;
    reg                      arlen;
    reg [ADDR_WIDTH-1:0]     addr_start_w;
    reg [ADDR_WIDTH-1:0]     addr_start_r;
    reg [DATA_WIDTH-1:0]     data_w;
    wire [DATA_WIDTH-1:0]     data_r  ;

    always #10 aclk <= !aclk;
    
    
    initial begin
        aclk = 1'b0;
        rst_n = 1'b0;
        #50 rst_n = 1'b1;
            en_w = 1'b1;
            en_r = 1'b0;
            addr_start_w = 32'd1;
            data_w    = 64'd5;
        #20
            addr_start_w = 32'd2;
            data_w =64'd6;
        #20 
            en_r = 1'b1;
            addr_start_r = 32'd1;
             
    end


axi_master axi_master0(
                .aclk(aclk),
                .rst_n(rst_n),

    //  Write address
                        .AWREADY(AWREADY),
                        .AWADDR(AWADDR),
                        .AWLEN(AWLEN),
                        .AWVALID(AWVALID),

    //  Write data
                        .WREADY(WREADY),
                         .WDATA(WDATA),
                          .WLAST(WLAST),
                          .WVALID(WVALID),

    //  Write back
                        .BVALID(BVALID),
                          .BREADY(BREADY),

    //  Read address
                        .ARREADY(ARREADY),
                        . ARADDR(ARADDR),
                          .ARLEN(ARLEN),
                          .ARVALID(ARVALID),

    //  Read data
                        . RDATA(RDATA),
                        .RLAST(RLAST),
                        .RVALID(RVALID),
                          .RREADY(RREADY),

    //  interface
                        .en_w(en_w),
                        .en_r(en_r),
                        .awlen(awlen),
                        .arlen(arlen),
                        .addr_start_w(addr_start_w),
                        .addr_start_r(addr_start_r),
                        .data_w(data_w),
                        .data_r(data_r)  
);

axi_slave axi_slave0(
                          .aclk(aclk),
                          .rst_n(rst_n),
    // Write address
                          .AWADDR(AWADDR),
                          .AWLEN(AWLEN),
                          .AWVALID(AWVALID),
                          .AWREADY(AWREADY),
    // Write data
                          .WVALID(WVALID),
                          .WLAST(WLAST),
                         .WDATA(WDATA),
                          .WREADY(WREADY),
    // Write respones
                          .BREADY(BREADY),
                          .BVALID(BVALID),
    // Read addrsess
                         .ARADDR(ARADDR),
                          .ARVALID(ARVALID),
                          .ARREADY(ARREADY),
    // Read data
                          .RREADY(RREADY),
                          .RLAST(RLAST),
                          .RVALID(RVALID),
                         .RDATA(RDATA)
);
*/






endmodule