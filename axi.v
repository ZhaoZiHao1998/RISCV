module axi #(
    parameter ADDR_WIDTH = 64,
              DATA_WIDTH = 64,
              ADDR_SEL   = 8 
) (
    input wire                      aclk,
    input wire                      rst_n,

    input wire                      M0_stall,
    input wire                      M0_en_w,
    input wire                      M0_en_r,
    input wire [ADDR_WIDTH-1:0]     M0_addr_start_w,
    input wire [ADDR_WIDTH-1:0]     M0_addr_start_r,
    input wire [DATA_WIDTH-1:0]     M0_data_w,
    input wire [ADDR_SEL-1:0]       M0_sel_w,
    output wire [DATA_WIDTH-1:0]     M0_data_r,
    output wire                      M0_r_valid,

    input wire                      M1_stall,
    input wire                      M1_en_w,
    input wire                      M1_en_r,
    input wire [ADDR_WIDTH-1:0]     M1_addr_start_w,
    input wire [ADDR_WIDTH-1:0]     M1_addr_start_r,
    input wire [DATA_WIDTH-1:0]     M1_data_w,
    input wire [ADDR_SEL-1:0]       M1_sel_w,
    output wire [DATA_WIDTH-1:0]     M1_data_r,
    output wire                      M1_r_valid,
    
    input wire                      M2_stall,
    input wire                      M2_en_w,
    input wire                      M2_en_r,
    input wire [ADDR_WIDTH-1:0]     M2_addr_start_w,
    input wire [ADDR_WIDTH-1:0]     M2_addr_start_r,
    input wire [DATA_WIDTH-1:0]     M2_data_w,
    input wire [ADDR_SEL-1:0]       M2_sel_w,
    output wire [DATA_WIDTH-1:0]     M2_data_r ,
    output wire                      M2_r_valid,

    output wire [ADDR_WIDTH-1:0]    S0_Waddr,
    output wire [DATA_WIDTH-1:0]    S0_Wdata,
    output wire                     S0_Wena,
    output wire [ADDR_SEL-1:0]      S0_Wsel,
    output wire [ADDR_WIDTH-1:0]    S0_Raddr,
    output wire                     S0_Rena,
    input wire [DATA_WIDTH-1:0]     S0_Rdata,

    output wire [ADDR_WIDTH-1:0]    S1_Waddr,
    output wire [DATA_WIDTH-1:0]    S1_Wdata,
    output wire                     S1_Wena,
    output wire [ADDR_SEL-1:0]      S1_Wsel,
    output wire [ADDR_WIDTH-1:0]    S1_Raddr,
    output wire                     S1_Rena,
    input wire [DATA_WIDTH-1:0]     S1_Rdata,

    output wire [ADDR_WIDTH-1:0]    S2_Waddr,
    output wire [DATA_WIDTH-1:0]    S2_Wdata,
    output wire                     S2_Wena,
    output wire [ADDR_SEL-1:0]      S2_Wsel,
    output wire [ADDR_WIDTH-1:0]    S2_Raddr,
    output wire                     S2_Rena,
    input wire [DATA_WIDTH-1:0]     S2_Rdata,

    output wire [ADDR_WIDTH-1:0]    S3_Waddr,
    output wire [DATA_WIDTH-1:0]    S3_Wdata,
    output wire                     S3_Wena,
    output wire [ADDR_SEL-1:0]      S3_Wsel,
    output wire [ADDR_WIDTH-1:0]    S3_Raddr,
    output wire                     S3_Rena,
    input wire [DATA_WIDTH-1:0]     S3_Rdata,        

    output wire [ADDR_WIDTH-1:0]    S4_Waddr,
    output wire [DATA_WIDTH-1:0]    S4_Wdata,
    output wire                     S4_Wena,
    output wire [ADDR_SEL-1:0]      S4_Wsel,
    output wire [ADDR_WIDTH-1:0]    S4_Raddr,
    output wire                     S4_Rena,
    input wire [DATA_WIDTH-1:0]     S4_Rdata,

    output wire [ADDR_WIDTH-1:0]    S5_Waddr,
    output wire [DATA_WIDTH-1:0]    S5_Wdata,
    output wire                     S5_Wena,
    output wire [ADDR_SEL-1:0]      S5_Wsel,
    output wire [ADDR_WIDTH-1:0]    S5_Raddr,
    output wire                     S5_Rena,
    input wire [DATA_WIDTH-1:0]     S5_Rdata,

    output wire [ADDR_WIDTH-1:0]    S6_Waddr,
    output wire [DATA_WIDTH-1:0]    S6_Wdata,
    output wire                     S6_Wena,
    output wire [ADDR_SEL-1:0]      S6_Wsel,
    output wire [ADDR_WIDTH-1:0]    S6_Raddr,
    output wire                     S6_Rena,
    input wire [DATA_WIDTH-1:0]     S6_Rdata,

    output wire [ADDR_WIDTH-1:0]    S7_Waddr,
    output wire [DATA_WIDTH-1:0]    S7_Wdata,
    output wire                     S7_Wena,
    output wire [ADDR_SEL-1:0]      S7_Wsel,
    output wire [ADDR_WIDTH-1:0]    S7_Raddr,
    output wire                     S7_Rena,
    input wire [DATA_WIDTH-1:0]     S7_Rdata

);
//  Master 0 *******************************************
    // master mux  ->  Master 0 input---------
    wire                      M0_WREADY;
    wire                      M0_AWREADY;
    wire                      M0_BVALID;
    wire                      M0_ARREADY;
    wire [DATA_WIDTH-1:0]     M0_RDATA;
    wire                      M0_RLAST; 
    wire                      M0_RVALID; 
    // Master 0 output  ->  master mux---------       
    wire [ADDR_WIDTH-1:0]     M0_AWADDR;
    wire                      M0_AWLEN;
    wire                      M0_AWVALID;
    wire [DATA_WIDTH-1:0]     M0_WDATA;
    wire                      M0_WLAST;
    wire                      M0_WVALID; 
    wire [ADDR_SEL-1:0]       M0_WSTRB;   
    wire                      M0_BREADY; 
    wire [ADDR_WIDTH-1:0]     M0_ARADDR;
    wire                      M0_ARLEN;
    wire                      M0_ARVALID;
    wire                      M0_RREADY;
//  Master 1 **************************************
    // master mux  ->  Master 1 input---------
    wire                      M1_WREADY;
    wire                      M1_AWREADY;
    wire                      M1_BVALID;
    wire                      M1_ARREADY;
    wire [DATA_WIDTH-1:0]     M1_RDATA;
    wire                      M1_RLAST; 
    wire                      M1_RVALID; 
    // Master 1 output  ->  master mux---------       
    wire [ADDR_WIDTH-1:0]     M1_AWADDR;
    wire                      M1_AWLEN;
    wire                      M1_AWVALID;
    wire [DATA_WIDTH-1:0]     M1_WDATA;
    wire                      M1_WLAST;
    wire                      M1_WVALID;
    wire [ADDR_SEL-1:0]       M1_WSTRB;    
    wire                      M1_BREADY; 
    wire [ADDR_WIDTH-1:0]     M1_ARADDR;
    wire                      M1_ARLEN;
    wire                      M1_ARVALID;
    wire                      M1_RREADY;
//  Master 2 *************************************
    // master mux  ->  Master 2 input---------
    wire                      M2_WREADY;
    wire                      M2_AWREADY;
    wire                      M2_BVALID;
    wire                      M2_ARREADY;
    wire [DATA_WIDTH-1:0]     M2_RDATA;
    wire                      M2_RLAST; 
    wire                      M2_RVALID; 
    // Master 2 output  ->  master mux---------       
    wire [ADDR_WIDTH-1:0]     M2_AWADDR;
    wire                      M2_AWLEN;
    wire                      M2_AWVALID;
    wire [DATA_WIDTH-1:0]     M2_WDATA;
    wire                      M2_WLAST;
    wire                      M2_WVALID;
    wire [ADDR_SEL-1:0]       M2_WSTRB;    
    wire                      M2_BREADY; 
    wire [ADDR_WIDTH-1:0]     M2_ARADDR;
    wire                      M2_ARLEN;
    wire                      M2_ARVALID;
    wire                      M2_RREADY;
// Master mux output  -> Slave mux input
    wire [ADDR_WIDTH-1:0]     S_AWADDR;
    wire                      S_AWLEN;
    wire                      S_AWVALID;
    wire [DATA_WIDTH-1:0]     S_WDATA;
    wire                      S_WLAST;
    wire                      S_WVALID;
    wire [ADDR_SEL-1:0]       S_WSTRB;
    wire                      S_BREADY;
    wire [ADDR_WIDTH-1:0]     S_ARADDR;
    wire                      S_ARLEN;
    wire                      S_ARVALID;
    wire                      S_RREADY; 
// Master mux output  -> Slave mux input  (S0)
    wire [ADDR_WIDTH-1:0]     s0_AWADDR;
    wire                      s0_AWLEN;
    wire                      s0_AWVALID;
    wire [DATA_WIDTH-1:0]     s0_WDATA;
    wire                      s0_WLAST;
    wire                      s0_WVALID;
    wire [ADDR_SEL-1:0]       s0_WSTRB;
    wire                      s0_BREADY;
    wire [ADDR_WIDTH-1:0]     s0_ARADDR;
    wire                      s0_ARLEN;
    wire                      s0_ARVALID;
    wire                      s0_RREADY; 
// Slave mux output -> Master mux input
    wire                      M_AWREADY;
    wire                      M_WREADY;
    wire                      M_BVALID;
    wire                      M_ARREADY;
    wire [DATA_WIDTH-1:0]     M_RDATA;
    wire                      M_RLAST;
    wire                      M_RVALID;  

// Slave mux output -> Master mux input (M0)
    wire                      m0_AWREADY;
    wire                      m0_WREADY;
    wire                      m0_BVALID;
    wire                      m0_ARREADY;
    wire [DATA_WIDTH-1:0]     m0_RDATA;
    wire                      m0_RLAST;
    wire                      m0_RVALID; 

// arbiter -> master mux
    wire                      m0_grant_w;
    wire                      m1_grant_w;
    wire                      m2_grant_w;
    wire                      m0_grant_r;
    wire                      m1_grant_r;
    wire                      m2_grant_r;
//  Slave 0 -> Slave mux
    wire                      S0_AWREADY;
    wire                      S0_WREADY;
    wire                      S0_BVALID;
    wire                      S0_ARREADY;
    wire                      S0_RLAST;
    wire                      S0_RVALID;
    wire [DATA_WIDTH-1:0]     S0_RDATA;
//  Slave 1 -> Slave mux
    wire                      S1_AWREADY;
    wire                      S1_WREADY;
    wire                      S1_BVALID;
    wire                      S1_ARREADY;
    wire                      S1_RLAST;
    wire                      S1_RVALID;
    wire [DATA_WIDTH-1:0]     S1_RDATA;
//  Slave 2 -> Slave mux
    wire                      S2_AWREADY;
    wire                      S2_WREADY;
    wire                      S2_BVALID;
    wire                      S2_ARREADY;
    wire                      S2_RLAST;
    wire                      S2_RVALID;
    wire [DATA_WIDTH-1:0]     S2_RDATA;
//  Slave 3 -> Slave mux
    wire                      S3_AWREADY;
    wire                      S3_WREADY;
    wire                      S3_BVALID;
    wire                      S3_ARREADY;
    wire                      S3_RLAST;
    wire                      S3_RVALID;
    wire [DATA_WIDTH-1:0]     S3_RDATA;
//  Slave 4 -> Slave mux
    wire                      S4_AWREADY;
    wire                      S4_WREADY;
    wire                      S4_BVALID;
    wire                      S4_ARREADY;
    wire                      S4_RLAST;
    wire                      S4_RVALID;
    wire [DATA_WIDTH-1:0]     S4_RDATA;
//  Slave 5 -> Slave mux
    wire                      S5_AWREADY;
    wire                      S5_WREADY;
    wire                      S5_BVALID;
    wire                      S5_ARREADY;
    wire                      S5_RLAST;
    wire                      S5_RVALID;
    wire [DATA_WIDTH-1:0]     S5_RDATA;
//  Slave 6 -> Slave mux
    wire                      S6_AWREADY;
    wire                      S6_WREADY;
    wire                      S6_BVALID;
    wire                      S6_ARREADY;
    wire                      S6_RLAST;
    wire                      S6_RVALID;
    wire [DATA_WIDTH-1:0]     S6_RDATA;
//  Slave 7 -> Slave mux
    wire                      S7_AWREADY;
    wire                      S7_WREADY;
    wire                      S7_BVALID;
    wire                      S7_ARREADY;
    wire                      S7_RLAST;
    wire                      S7_RVALID;
    wire [DATA_WIDTH-1:0]     S7_RDATA; 
//  Slave mux -> Slave 0
    wire [ADDR_WIDTH-1:0]     S0_AWADDR;
    wire                      S0_AWLEN;
    wire                      S0_AWVALID;
    wire [DATA_WIDTH-1:0]     S0_WDATA;
    wire                      S0_WLAST;
    wire                      S0_WVALID;
    wire [ADDR_SEL-1:0]       S0_WSTRB;
    wire                      S0_BREADY;
    wire [ADDR_WIDTH-1:0]     S0_ARADDR;
    wire                      S0_ARLEN;
    wire                      S0_ARVALID;
    wire                      S0_RREADY;
//  Slave mux -> Slave 1
    wire [ADDR_WIDTH-1:0]     S1_AWADDR;
    wire                      S1_AWLEN;
    wire                      S1_AWVALID;
    wire [DATA_WIDTH-1:0]     S1_WDATA;
    wire                      S1_WLAST;
    wire                      S1_WVALID;
    wire [ADDR_SEL-1:0]       S1_WSTRB;
    wire                      S1_BREADY;
    wire [ADDR_WIDTH-1:0]     S1_ARADDR;
    wire                      S1_ARLEN;
    wire                      S1_ARVALID;
    wire                      S1_RREADY;
// Slave mux -> Slave 2
    wire [ADDR_WIDTH-1:0]     S2_AWADDR;
    wire                      S2_AWLEN;
    wire                      S2_AWVALID;
    wire [DATA_WIDTH-1:0]     S2_WDATA;
    wire                      S2_WLAST;
    wire                      S2_WVALID;
    wire [ADDR_SEL-1:0]       S2_WSTRB;
    wire                      S2_BREADY;
    wire [ADDR_WIDTH-1:0]     S2_ARADDR;
    wire                      S2_ARLEN;
    wire                      S2_ARVALID;
    wire                      S2_RREADY;
//  Slave mux -> Slave 3
    wire [ADDR_WIDTH-1:0]     S3_AWADDR;
    wire                      S3_AWLEN;
    wire                      S3_AWVALID;
    wire [DATA_WIDTH-1:0]     S3_WDATA;
    wire                      S3_WLAST;
    wire                      S3_WVALID;
    wire [ADDR_SEL-1:0]       S3_WSTRB;
    wire                      S3_BREADY;
    wire [ADDR_WIDTH-1:0]     S3_ARADDR;
    wire                      S3_ARLEN;
    wire                      S3_ARVALID;
    wire                      S3_RREADY;
//  Slave mux -> Slave 4
    wire [ADDR_WIDTH-1:0]     S4_AWADDR;
    wire                      S4_AWLEN;
    wire                      S4_AWVALID;
    wire [DATA_WIDTH-1:0]     S4_WDATA;
    wire                      S4_WLAST;
    wire                      S4_WVALID;
    wire [ADDR_SEL-1:0]       S4_WSTRB;
    wire                      S4_BREADY;
    wire [ADDR_WIDTH-1:0]     S4_ARADDR;
    wire                      S4_ARLEN;
    wire                      S4_ARVALID;
    wire                      S4_RREADY;
// Slave mux -> Slave 5
    wire [ADDR_WIDTH-1:0]     S5_AWADDR;
    wire                      S5_AWLEN;
    wire                      S5_AWVALID;
    wire [DATA_WIDTH-1:0]     S5_WDATA;
    wire                      S5_WLAST;
    wire                      S5_WVALID;
    wire [ADDR_SEL-1:0]       S5_WSTRB;
    wire                      S5_BREADY;
    wire [ADDR_WIDTH-1:0]     S5_ARADDR;
    wire                      S5_ARLEN;
    wire                      S5_ARVALID;
    wire                      S5_RREADY;
//  Slave mux -> Slave 6
    wire [ADDR_WIDTH-1:0]     S6_AWADDR;
    wire                      S6_AWLEN;
    wire                      S6_AWVALID;
    wire [DATA_WIDTH-1:0]     S6_WDATA;
    wire                      S6_WLAST;
    wire                      S6_WVALID;
    wire [ADDR_SEL-1:0]       S6_WSTRB;
    wire                      S6_BREADY;
    wire [ADDR_WIDTH-1:0]     S6_ARADDR;
    wire                      S6_ARLEN;
    wire                      S6_ARVALID;
    wire                      S6_RREADY;
//  Slave mux -> Slave 7
    wire [ADDR_WIDTH-1:0]     S7_AWADDR;
    wire                      S7_AWLEN;
    wire                      S7_AWVALID;
    wire [DATA_WIDTH-1:0]     S7_WDATA;
    wire                      S7_WLAST;
    wire                      S7_WVALID;
    wire [ADDR_SEL-1:0]       S7_WSTRB;
    wire                      S7_BREADY;
    wire [ADDR_WIDTH-1:0]     S7_ARADDR;
    wire                      S7_ARLEN;
    wire                      S7_ARVALID;
    wire                      S7_RREADY;
 
axi_master  
 u_axi_master0 (
    .aclk                    ( aclk           ),
    .rst_n                   ( rst_n          ),
    .AWREADY                 ( M0_AWREADY        ),
    .WREADY                  ( M0_WREADY         ),
    .BVALID                  ( M0_BVALID         ),
    .ARREADY                 ( M0_ARREADY        ),
    .RDATA                   ( M0_RDATA          ),
    .RLAST                   ( M0_RLAST          ),
    .RVALID                  ( M0_RVALID         ),
    .stall                   ( M0_stall          ),
    .en_w                    ( M0_en_w           ),
    .en_r                    ( M0_en_r           ),
    .awlen                   (                   ),
    .arlen                   (                   ),
    .addr_start_w            ( M0_addr_start_w   ),
    .addr_start_r            ( M0_addr_start_r   ),
    .sel_w                   ( M0_sel_w          ),
    .data_w                  ( M0_data_w         ),

    .AWADDR                  ( M0_AWADDR         ),
    .AWLEN                   ( M0_AWLEN          ),
    .AWVALID                 ( M0_AWVALID        ),
    .WDATA                   ( M0_WDATA          ),
    .WLAST                   ( M0_WLAST          ),
    .WVALID                  ( M0_WVALID         ),
    .WSTRB                   ( M0_WSTRB          ),
    .BREADY                  ( M0_BREADY         ),
    .ARADDR                  ( M0_ARADDR         ),
    .ARLEN                   ( M0_ARLEN          ),
    .ARVALID                 ( M0_ARVALID        ),
    .RREADY                  ( M0_RREADY         ),
    .data_r                  ( M0_data_r         ),
    .r_valid                 ( M0_r_valid        )
);
axi_master  
 u_axi_master1 (
    .aclk                    ( aclk           ),
    .rst_n                   ( rst_n          ),
    .AWREADY                 ( M1_AWREADY        ),
    .WREADY                  ( M1_WREADY         ),
    .BVALID                  ( M1_BVALID         ),
    .ARREADY                 ( M1_ARREADY        ),
    .RDATA                   ( M1_RDATA          ),
    .RLAST                   ( M1_RLAST          ),
    .RVALID                  ( M1_RVALID         ),
    .stall                   ( M0_stall          ),
    .en_w                    ( M1_en_w           ),
    .en_r                    ( M1_en_r           ),
    .awlen                   (                   ),
    .arlen                   (                   ),
    .addr_start_w            ( M1_addr_start_w   ),
    .addr_start_r            ( M1_addr_start_r   ),
    .data_w                  ( M1_data_w         ),
    .sel_w                   ( M1_sel_w          ),

    .AWADDR                  ( M1_AWADDR         ),
    .AWLEN                   ( M1_AWLEN          ),
    .AWVALID                 ( M1_AWVALID        ),
    .WDATA                   ( M1_WDATA          ),
    .WLAST                   ( M1_WLAST          ),
    .WVALID                  ( M1_WVALID         ),
    .WSTRB                   ( M1_WSTRB          ),
    .BREADY                  ( M1_BREADY         ),
    .ARADDR                  ( M1_ARADDR         ),
    .ARLEN                   ( M1_ARLEN          ),
    .ARVALID                 ( M1_ARVALID        ),
    .RREADY                  ( M1_RREADY         ),
    .data_r                  ( M1_data_r         ),
    .r_valid                 ( M1_r_valid        )
);  

axi_master  
 u_axi_master2 (
    .aclk                    ( aclk           ),
    .rst_n                   ( rst_n          ),
    .AWREADY                 ( M2_AWREADY        ),
    .WREADY                  ( M2_WREADY         ),
    .BVALID                  ( M2_BVALID         ),
    .ARREADY                 ( M2_ARREADY        ),
    .RDATA                   ( M2_RDATA          ),
    .RLAST                   ( M2_RLAST          ),
    .RVALID                  ( M2_RVALID         ),
    .stall                   ( M0_stall          ),
    .en_w                    ( M2_en_w           ),
    .en_r                    ( M2_en_r           ),
    .awlen                   (                   ),
    .arlen                   (                   ),
    .addr_start_w            ( M2_addr_start_w   ),
    .addr_start_r            ( M2_addr_start_r   ),
    .data_w                  ( M2_data_w         ),
    .sel_w                   ( M2_sel_w          ),

    .AWADDR                  ( M2_AWADDR         ),
    .AWLEN                   ( M2_AWLEN          ),
    .AWVALID                 ( M2_AWVALID        ),
    .WDATA                   ( M2_WDATA          ),
    .WLAST                   ( M2_WLAST          ),
    .WVALID                  ( M2_WVALID         ),
    .WSTRB                   ( M2_sel_w          ),
    .BREADY                  ( M2_BREADY         ),
    .ARADDR                  ( M2_ARADDR         ),
    .ARLEN                   ( M2_ARLEN          ),
    .ARVALID                 ( M2_ARVALID        ),
    .RREADY                  ( M2_RREADY         ),
    .data_r                  ( M2_data_r         ),
    .r_valid                 ( M2_r_valid        )
    
);

axi_arbiter 
 u_axi_arbiter (
    .aclk                    ( aclk         ),
    .rst_n                   ( rst_n        ),
    //.M0_AWVALID              ( M0_AWVALID   ),
    //.M0_WVALID               ( M0_WVALID    ),
    //.M0_BREADY               ( M0_BREADY    ),
    .M1_AWVALID              ( M1_AWVALID   ),
    .M1_WVALID               ( M1_WVALID    ),
    .M1_BREADY               ( M1_BREADY    ),
    .M2_AWVALID              ( M2_AWVALID   ),
    .M2_WVALID               ( M2_WVALID    ),
    .M2_BREADY               ( M2_BREADY    ),
    .M_AWREADY               ( M_AWREADY    ),
    .M_WREADY                ( M_WREADY     ),
    .M_BVALID                ( M_BVALID     ),
    //.M0_ARVALID              ( M0_ARVALID   ),
    //.M0_RREADY               ( M0_RREADY    ),
    .M1_ARVALID              ( M1_ARVALID   ),
    .M1_RREADY               ( M1_RREADY    ),
    .M2_ARVALID              ( M2_ARVALID   ),
    .M2_RREADY               ( M2_RREADY    ),
    .M_ARREADY               ( M_ARREADY    ),
    .M_RVALID                ( M_RVALID     ),

    //.m0_grant_w              ( m0_grant_w   ),
    .m1_grant_w              ( m1_grant_w   ),
    .m2_grant_w              ( m2_grant_w   ),
    //.m0_grant_r              ( m0_grant_r   ),
    .m1_grant_r              ( m1_grant_r   ),
    .m2_grant_r              ( m2_grant_r   )
);

axi_master_mux 
 u_axi_master_mux (
    .aclk                    ( aclk         ),
    .rst_n                   ( rst_n        ),
    .M0_AWADDR               ( M0_AWADDR    ),
    .M0_AWLEN                ( M0_AWLEN     ),
    .M0_AWVALID              ( M0_AWVALID   ),
    .M0_WDATA                ( M0_WDATA     ),
    .M0_WLAST                ( M0_WLAST     ),
    .M0_WVALID               ( M0_WVALID    ),
    .M0_WSTRB                ( M0_WSTRB     ),
    .M0_BREADY               ( M0_BREADY    ),
    .M0_ARADDR               ( M0_ARADDR    ),
    .M0_ARLEN                ( M0_ARLEN     ),
    .M0_ARVALID              ( M0_ARVALID   ),
    .M0_RREADY               ( M0_RREADY    ),
    .M1_AWADDR               ( M1_AWADDR    ),
    .M1_AWLEN                ( M1_AWLEN     ),
    .M1_AWVALID              ( M1_AWVALID   ),
    .M1_WDATA                ( M1_WDATA     ),
    .M1_WLAST                ( M1_WLAST     ),
    .M1_WVALID               ( M1_WVALID    ),
    .M1_WSTRB                ( M1_WSTRB     ),
    .M1_BREADY               ( M1_BREADY    ),
    .M1_ARADDR               ( M1_ARADDR    ),
    .M1_ARLEN                ( M1_ARLEN     ),
    .M1_ARVALID              ( M1_ARVALID   ),
    .M1_RREADY               ( M1_RREADY    ),
    .M2_AWADDR               ( M2_AWADDR    ),
    .M2_AWLEN                ( M2_AWLEN     ),
    .M2_AWVALID              ( M2_AWVALID   ),
    .M2_WDATA                ( M2_WDATA     ),
    .M2_WLAST                ( M2_WLAST     ),
    .M2_WVALID               ( M2_WVALID    ),
    .M2_WSTRB                ( M2_WSTRB     ),
    .M2_BREADY               ( M2_BREADY    ),
    .M2_ARADDR               ( M2_ARADDR    ),
    .M2_ARLEN                ( M2_ARLEN     ),
    .M2_ARVALID              ( M2_ARVALID   ),
    .M2_RREADY               ( M2_RREADY    ),
    .M_AWREADY               ( M_AWREADY    ),
    .M_WREADY                ( M_WREADY     ),
    .M_BVALID                ( M_BVALID     ),
    .M_ARREADY               ( M_ARREADY    ),
    .M_RDATA                 ( M_RDATA      ),
    .M_RLAST                 ( M_RLAST      ),
    .M_RVALID                ( M_RVALID     ),
    .m0_AWREADY              ( m0_AWREADY   ),
    .m0_WREADY               ( m0_WREADY    ),
    .m0_BVALID               ( m0_BVALID    ),
    .m0_ARREADY              ( m0_ARREADY   ),
    .m0_RDATA                ( m0_RDATA     ),
    .m0_RLAST                ( m0_RLAST     ),
    .m0_RVALID               ( m0_RVALID    ),
    .m1_grant_w              ( m1_grant_w   ),
    .m2_grant_w              ( m2_grant_w   ),
    .m1_grant_r              ( m1_grant_r   ),
    .m2_grant_r              ( m2_grant_r   ),

    .S_AWADDR                ( S_AWADDR     ),
    .S_AWLEN                 ( S_AWLEN      ),
    .S_AWVALID               ( S_AWVALID    ),
    .S_WDATA                 ( S_WDATA      ),
    .S_WLAST                 ( S_WLAST      ),
    .S_WVALID                ( S_WVALID     ),
    .S_WSTRB                 ( S_WSTRB      ),
    .S_BREADY                ( S_BREADY     ),
    .S_ARADDR                ( S_ARADDR     ),
    .S_ARLEN                 ( S_ARLEN      ),
    .S_ARVALID               ( S_ARVALID    ),
    .S_RREADY                ( S_RREADY     ),
    .S0_AWADDR               ( s0_AWADDR    ),
    .S0_AWLEN                ( s0_AWLEN     ),
    .S0_AWVALID              ( s0_AWVALID   ),
    .S0_WDATA                ( s0_WDATA     ),
    .S0_WLAST                ( s0_WLAST     ),
    .S0_WVALID               ( s0_WVALID    ),
    .S0_WSTRB                ( s0_WSTRB     ),
    .S0_BREADY               ( s0_BREADY    ),
    .S0_ARADDR               ( s0_ARADDR    ),
    .S0_ARLEN                ( s0_ARLEN     ),
    .S0_ARVALID              ( s0_ARVALID   ),
    .S0_RREADY               ( s0_RREADY    ),
    .M0_AWREADY              ( M0_AWREADY   ),
    .M0_WREADY               ( M0_WREADY    ),
    .M0_BVALID               ( M0_BVALID    ),
    .M0_ARREADY              ( M0_ARREADY   ),
    .M0_RDATA                ( M0_RDATA     ),
    .M0_RLAST                ( M0_RLAST     ),
    .M0_RVALID               ( M0_RVALID    ),
    .M1_AWREADY              ( M1_AWREADY   ),
    .M1_WREADY               ( M1_WREADY    ),
    .M1_BVALID               ( M1_BVALID    ),
    .M1_ARREADY              ( M1_ARREADY   ),
    .M1_RDATA                ( M1_RDATA     ),
    .M1_RLAST                ( M1_RLAST     ),
    .M1_RVALID               ( M1_RVALID    ),
    .M2_AWREADY              ( M2_AWREADY   ),
    .M2_WREADY               ( M2_WREADY    ),
    .M2_BVALID               ( M2_BVALID    ),
    .M2_ARREADY              ( M2_ARREADY   ),
    .M2_RDATA                ( M2_RDATA     ),
    .M2_RLAST                ( M2_RLAST     ),
    .M2_RVALID               ( M2_RVALID    )
);

axi_slave_mux 
 u_axi_slave_mux (
    .aclk                    ( aclk         ),
    .rst_n                   ( rst_n        ),
    .S0_AWREADY              ( S0_AWREADY   ),
    .S0_WREADY               ( S0_WREADY    ),
    .S0_BVALID               ( S0_BVALID    ),
    .S0_ARREADY              ( S0_ARREADY   ),
    .S0_RLAST                ( S0_RLAST     ),
    .S0_RVALID               ( S0_RVALID    ),
    .S0_RDATA                ( S0_RDATA     ),
    .S1_AWREADY              ( S1_AWREADY   ),
    .S1_WREADY               ( S1_WREADY    ),
    .S1_BVALID               ( S1_BVALID    ),
    .S1_ARREADY              ( S1_ARREADY   ),
    .S1_RLAST                ( S1_RLAST     ),
    .S1_RVALID               ( S1_RVALID    ),
    .S1_RDATA                ( S1_RDATA     ),
    .S2_AWREADY              ( S2_AWREADY   ),
    .S2_WREADY               ( S2_WREADY    ),
    .S2_BVALID               ( S2_BVALID    ),
    .S2_ARREADY              ( S2_ARREADY   ),
    .S2_RLAST                ( S2_RLAST     ),
    .S2_RVALID               ( S2_RVALID    ),
    .S2_RDATA                ( S2_RDATA     ),
    .S3_AWREADY              ( S3_AWREADY   ),
    .S3_WREADY               ( S3_WREADY    ),
    .S3_BVALID               ( S3_BVALID    ),
    .S3_ARREADY              ( S3_ARREADY   ),
    .S3_RLAST                ( S3_RLAST     ),
    .S3_RVALID               ( S3_RVALID    ),
    .S3_RDATA                ( S3_RDATA     ),
    .S4_AWREADY              ( S4_AWREADY   ),
    .S4_WREADY               ( S4_WREADY    ),
    .S4_BVALID               ( S4_BVALID    ),
    .S4_ARREADY              ( S4_ARREADY   ),
    .S4_RLAST                ( S4_RLAST     ),
    .S4_RVALID               ( S4_RVALID    ),
    .S4_RDATA                ( S4_RDATA     ),
    .S5_AWREADY              ( S5_AWREADY   ),
    .S5_WREADY               ( S5_WREADY    ),
    .S5_BVALID               ( S5_BVALID    ),
    .S5_ARREADY              ( S5_ARREADY   ),
    .S5_RLAST                ( S5_RLAST     ),
    .S5_RVALID               ( S5_RVALID    ),
    .S5_RDATA                ( S5_RDATA     ),
    .S6_AWREADY              ( S6_AWREADY   ),
    .S6_WREADY               ( S6_WREADY    ),
    .S6_BVALID               ( S6_BVALID    ),
    .S6_ARREADY              ( S6_ARREADY   ),
    .S6_RLAST                ( S6_RLAST     ),
    .S6_RVALID               ( S6_RVALID    ),
    .S6_RDATA                ( S6_RDATA     ),
    .S7_AWREADY              ( S7_AWREADY   ),
    .S7_WREADY               ( S7_WREADY    ),
    .S7_BVALID               ( S7_BVALID    ),
    .S7_ARREADY              ( S7_ARREADY   ),
    .S7_RLAST                ( S7_RLAST     ),
    .S7_RVALID               ( S7_RVALID    ),
    .S7_RDATA                ( S7_RDATA     ),
    .S_AWADDR                ( S_AWADDR     ),
    .S_AWLEN                 ( S_AWLEN      ),
    .S_AWVALID               ( S_AWVALID    ),
    .S_WDATA                 ( S_WDATA      ),
    .S_WLAST                 ( S_WLAST      ),
    .S_WVALID                ( S_WVALID     ),
    .S_WSTRB                 ( S_WSTRB      ),
    .S_BREADY                ( S_BREADY     ),
    .S_ARADDR                ( S_ARADDR     ),
    .S_ARLEN                 ( S_ARLEN      ),
    .S_ARVALID               ( S_ARVALID    ),
    .S_RREADY                ( S_RREADY     ),
    .s0_AWADDR               ( s0_AWADDR    ),
    .s0_AWLEN                ( s0_AWLEN     ),
    .s0_AWVALID              ( s0_AWVALID   ),
    .s0_WDATA                ( s0_WDATA     ),
    .s0_WLAST                ( s0_WLAST     ),
    .s0_WVALID               ( s0_WVALID    ),
    .s0_WSTRB                ( s0_WSTRB     ),
    .s0_BREADY               ( s0_BREADY    ),
    .s0_ARADDR               ( s0_ARADDR    ),
    .s0_ARLEN                ( s0_ARLEN     ),
    .s0_ARVALID              ( s0_ARVALID   ),
    .s0_RREADY               ( s0_RREADY    ),

    .M_AWREADY               ( M_AWREADY    ),
    .M_WREADY                ( M_WREADY     ),
    .M_BVALID                ( M_BVALID     ),
    .M_ARREADY               ( M_ARREADY    ),
    .M_RLAST                 ( M_RLAST      ),
    .M_RVALID                ( M_RVALID     ),
    .M_RDATA                 ( M_RDATA      ),
    .M0_AWREADY              ( m0_AWREADY   ),
    .M0_WREADY               ( m0_WREADY    ),
    .M0_BVALID               ( m0_BVALID    ),
    .M0_ARREADY              ( m0_ARREADY   ),
    .M0_RLAST                ( m0_RLAST     ),
    .M0_RVALID               ( m0_RVALID    ),
    .M0_RDATA                ( m0_RDATA     ),
    .S0_AWADDR               ( S0_AWADDR    ),
    .S0_AWLEN                ( S0_AWLEN     ),
    .S0_AWVALID              ( S0_AWVALID   ),
    .S0_WDATA                ( S0_WDATA     ),
    .S0_WLAST                ( S0_WLAST     ),
    .S0_WVALID               ( S0_WVALID    ),
    .S0_WSTRB                ( S0_WSTRB     ),
    .S0_BREADY               ( S0_BREADY    ),
    .S0_ARADDR               ( S0_ARADDR    ),
    .S0_ARLEN                ( S0_ARLEN     ),
    .S0_ARVALID              ( S0_ARVALID   ),
    .S0_RREADY               ( S0_RREADY    ),
    .S1_AWADDR               ( S1_AWADDR    ),
    .S1_AWLEN                ( S1_AWLEN     ),
    .S1_AWVALID              ( S1_AWVALID   ),
    .S1_WDATA                ( S1_WDATA     ),
    .S1_WLAST                ( S1_WLAST     ),
    .S1_WVALID               ( S1_WVALID    ),
    .S1_WSTRB                ( S1_WSTRB     ),
    .S1_BREADY               ( S1_BREADY    ),
    .S1_ARADDR               ( S1_ARADDR    ),
    .S1_ARLEN                ( S1_ARLEN     ),
    .S1_ARVALID              ( S1_ARVALID   ),
    .S1_RREADY               ( S1_RREADY    ),
    .S2_AWADDR               ( S2_AWADDR    ),
    .S2_AWLEN                ( S2_AWLEN     ),
    .S2_AWVALID              ( S2_AWVALID   ),
    .S2_WDATA                ( S2_WDATA     ),
    .S2_WLAST                ( S2_WLAST     ),
    .S2_WVALID               ( S2_WVALID    ),
    .S2_WSTRB                ( S2_WSTRB     ),
    .S2_BREADY               ( S2_BREADY    ),
    .S2_ARADDR               ( S2_ARADDR    ),
    .S2_ARLEN                ( S2_ARLEN     ),
    .S2_ARVALID              ( S2_ARVALID   ),
    .S2_RREADY               ( S2_RREADY    ),
    .S3_AWADDR               ( S3_AWADDR    ),
    .S3_AWLEN                ( S3_AWLEN     ),
    .S3_AWVALID              ( S3_AWVALID   ),
    .S3_WDATA                ( S3_WDATA     ),
    .S3_WLAST                ( S3_WLAST     ),
    .S3_WVALID               ( S3_WVALID    ),
    .S3_WSTRB                ( S3_WSTRB     ),
    .S3_BREADY               ( S3_BREADY    ),
    .S3_ARADDR               ( S3_ARADDR    ),
    .S3_ARLEN                ( S3_ARLEN     ),
    .S3_ARVALID              ( S3_ARVALID   ),
    .S3_RREADY               ( S3_RREADY    ),
    .S4_AWADDR               ( S4_AWADDR    ),
    .S4_AWLEN                ( S4_AWLEN     ),
    .S4_AWVALID              ( S4_AWVALID   ),
    .S4_WDATA                ( S4_WDATA     ),
    .S4_WLAST                ( S4_WLAST     ),
    .S4_WVALID               ( S4_WVALID    ),
    .S4_WSTRB                ( S4_WSTRB     ),
    .S4_BREADY               ( S4_BREADY    ),
    .S4_ARADDR               ( S4_ARADDR    ),
    .S4_ARLEN                ( S4_ARLEN     ),
    .S4_ARVALID              ( S4_ARVALID   ),
    .S4_RREADY               ( S4_RREADY    ),
    .S5_AWADDR               ( S5_AWADDR    ),
    .S5_AWLEN                ( S5_AWLEN     ),
    .S5_AWVALID              ( S5_AWVALID   ),
    .S5_WDATA                ( S5_WDATA     ),
    .S5_WLAST                ( S5_WLAST     ),
    .S5_WVALID               ( S5_WVALID    ),
    .S5_WSTRB                ( S5_WSTRB     ),
    .S5_BREADY               ( S5_BREADY    ),
    .S5_ARADDR               ( S5_ARADDR    ),
    .S5_ARLEN                ( S5_ARLEN     ),
    .S5_ARVALID              ( S5_ARVALID   ),
    .S5_RREADY               ( S5_RREADY    ),
    .S6_AWADDR               ( S6_AWADDR    ),
    .S6_AWLEN                ( S6_AWLEN     ),
    .S6_AWVALID              ( S6_AWVALID   ),
    .S6_WDATA                ( S6_WDATA     ),
    .S6_WLAST                ( S6_WLAST     ),
    .S6_WVALID               ( S6_WVALID    ),
    .S6_WSTRB                ( S6_WSTRB     ),
    .S6_BREADY               ( S6_BREADY    ),
    .S6_ARADDR               ( S6_ARADDR    ),
    .S6_ARLEN                ( S6_ARLEN     ),
    .S6_ARVALID              ( S6_ARVALID   ),
    .S6_RREADY               ( S6_RREADY    ),
    .S7_AWADDR               ( S7_AWADDR    ),
    .S7_AWLEN                ( S7_AWLEN     ),
    .S7_AWVALID              ( S7_AWVALID   ),
    .S7_WDATA                ( S7_WDATA     ),
    .S7_WLAST                ( S7_WLAST     ),
    .S7_WVALID               ( S7_WVALID    ),
    .S7_WSTRB                ( S7_WSTRB     ),
    .S7_BREADY               ( S7_BREADY    ),
    .S7_ARADDR               ( S7_ARADDR    ),
    .S7_ARLEN                ( S7_ARLEN     ),
    .S7_ARVALID              ( S7_ARVALID   ),
    .S7_RREADY               ( S7_RREADY    )
);

axi_slave 
 u_axi_slave0 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S0_AWADDR    ),
    .AWLEN                   ( S0_AWLEN     ),
    .AWVALID                 ( S0_AWVALID   ),
    .WVALID                  ( S0_WVALID    ),
    .WLAST                   ( S0_WLAST     ),
    .WDATA                   ( S0_WDATA     ),
    .WSTRB                   ( S0_WSTRB     ),
    .BREADY                  ( S0_BREADY    ),
    .ARADDR                  ( S0_ARADDR    ),
    .ARVALID                 ( S0_ARVALID   ),
    .RREADY                  ( S0_RREADY    ),

    .AWREADY                 ( S0_AWREADY   ),
    .WREADY                  ( S0_WREADY    ),
    .BVALID                  ( S0_BVALID    ),
    .ARREADY                 ( S0_ARREADY   ),
    .RLAST                   ( S0_RLAST     ),
    .RVALID                  ( S0_RVALID    ),
    .RDATA                   ( S0_RDATA     ),

    .Waddr                   (S0_Waddr),
    .Wdata                   (S0_Wdata),
    .Wena                    (S0_Wena),
    .Wsel                    (S0_Wsel),
    .Raddr                   (S0_Raddr),
    .Rena                    (S0_Rena),
    .Rdata                   (S0_Rdata)
);
axi_slave 
 u_axi_slave1 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S1_AWADDR    ),
    .AWLEN                   ( S1_AWLEN     ),
    .AWVALID                 ( S1_AWVALID   ),
    .WVALID                  ( S1_WVALID    ),
    .WLAST                   ( S1_WLAST     ),
    .WDATA                   ( S1_WDATA     ),
    .WSTRB                   ( S1_WSTRB     ),
    .BREADY                  ( S1_BREADY    ),
    .ARADDR                  ( S1_ARADDR    ),
    .ARVALID                 ( S1_ARVALID   ),
    .RREADY                  ( S1_RREADY    ),

    .AWREADY                 ( S1_AWREADY   ),
    .WREADY                  ( S1_WREADY    ),
    .BVALID                  ( S1_BVALID    ),
    .ARREADY                 ( S1_ARREADY   ),
    .RLAST                   ( S1_RLAST     ),
    .RVALID                  ( S1_RVALID    ),
    .RDATA                   ( S1_RDATA     ),

    .Waddr                   (S1_Waddr),
    .Wdata                   (S1_Wdata),
    .Wena                    (S1_Wena),
    .Wsel                    (S1_Wsel),
    .Raddr                   (S1_Raddr),
    .Rena                    (S1_Rena),
    .Rdata                   (S1_Rdata)
);

axi_slave 
 u_axi_slave2 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S2_AWADDR    ),
    .AWLEN                   ( S2_AWLEN     ),
    .AWVALID                 ( S2_AWVALID   ),
    .WVALID                  ( S2_WVALID    ),
    .WLAST                   ( S2_WLAST     ),
    .WDATA                   ( S2_WDATA     ),
    .WSTRB                   ( S2_WSTRB     ),
    .BREADY                  ( S2_BREADY    ),
    .ARADDR                  ( S2_ARADDR    ),
    .ARVALID                 ( S2_ARVALID   ),
    .RREADY                  ( S2_RREADY    ),

    .AWREADY                 ( S2_AWREADY   ),
    .WREADY                  ( S2_WREADY    ),
    .BVALID                  ( S2_BVALID    ),
    .ARREADY                 ( S2_ARREADY   ),
    .RLAST                   ( S2_RLAST     ),
    .RVALID                  ( S2_RVALID    ),
    .RDATA                   ( S2_RDATA     ),

    .Waddr                   (S2_Waddr),
    .Wdata                   (S2_Wdata),
    .Wena                    (S2_Wena),
    .Wsel                    (S2_Wsel),
    .Raddr                   (S2_Raddr),
    .Rena                    (S2_Rena),
    .Rdata                   (S2_Rdata)
);

axi_slave 
 u_axi_slave3 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S3_AWADDR    ),
    .AWLEN                   ( S3_AWLEN     ),
    .AWVALID                 ( S3_AWVALID   ),
    .WVALID                  ( S3_WVALID    ),
    .WLAST                   ( S3_WLAST     ),
    .WDATA                   ( S3_WDATA     ),
    .WSTRB                   ( S3_WSTRB     ),
    .BREADY                  ( S3_BREADY    ),
    .ARADDR                  ( S3_ARADDR    ),
    .ARVALID                 ( S3_ARVALID   ),
    .RREADY                  ( S3_RREADY    ),

    .AWREADY                 ( S3_AWREADY   ),
    .WREADY                  ( S3_WREADY    ),
    .BVALID                  ( S3_BVALID    ),
    .ARREADY                 ( S3_ARREADY   ),
    .RLAST                   ( S3_RLAST     ),
    .RVALID                  ( S3_RVALID    ),
    .RDATA                   ( S3_RDATA     ),

    .Waddr                   (S3_Waddr),
    .Wdata                   (S3_Wdata),
    .Wena                    (S3_Wena),
    .Wsel                    (S3_Wsel),
    .Raddr                   (S3_Raddr),
    .Rena                    (S3_Rena),
    .Rdata                   (S3_Rdata)
);

axi_slave 
 u_axi_slave4 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S4_AWADDR    ),
    .AWLEN                   ( S4_AWLEN     ),
    .AWVALID                 ( S4_AWVALID   ),
    .WVALID                  ( S4_WVALID    ),
    .WLAST                   ( S4_WLAST     ),
    .WDATA                   ( S4_WDATA     ),
    .WSTRB                   ( S4_WSTRB     ),
    .BREADY                  ( S4_BREADY    ),
    .ARADDR                  ( S4_ARADDR    ),
    .ARVALID                 ( S4_ARVALID   ),
    .RREADY                  ( S4_RREADY    ),

    .AWREADY                 ( S4_AWREADY   ),
    .WREADY                  ( S4_WREADY    ),
    .BVALID                  ( S4_BVALID    ),
    .ARREADY                 ( S4_ARREADY   ),
    .RLAST                   ( S4_RLAST     ),
    .RVALID                  ( S4_RVALID    ),
    .RDATA                   ( S4_RDATA     ),

    .Waddr                   (S4_Waddr),
    .Wdata                   (S4_Wdata),
    .Wena                    (S4_Wena),
    .Wsel                    (S4_Wsel),
    .Raddr                   (S4_Raddr),
    .Rena                    (S4_Rena),
    .Rdata                   (S4_Rdata)
);

axi_slave 
 u_axi_slave5 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S5_AWADDR    ),
    .AWLEN                   ( S5_AWLEN     ),
    .AWVALID                 ( S5_AWVALID   ),
    .WVALID                  ( S5_WVALID    ),
    .WLAST                   ( S5_WLAST     ),
    .WDATA                   ( S5_WDATA     ),
    .WSTRB                   ( S5_WSTRB     ),
    .BREADY                  ( S5_BREADY    ),
    .ARADDR                  ( S5_ARADDR    ),
    .ARVALID                 ( S5_ARVALID   ),
    .RREADY                  ( S5_RREADY    ),

    .AWREADY                 ( S5_AWREADY   ),
    .WREADY                  ( S5_WREADY    ),
    .BVALID                  ( S5_BVALID    ),
    .ARREADY                 ( S5_ARREADY   ),
    .RLAST                   ( S5_RLAST     ),
    .RVALID                  ( S5_RVALID    ),
    .RDATA                   ( S5_RDATA     ),

    .Waddr                   (S5_Waddr),
    .Wdata                   (S5_Wdata),
    .Wena                    (S5_Wena),
    .Wsel                    (S5_Wsel),
    .Raddr                   (S5_Raddr),
    .Rena                    (S5_Rena),
    .Rdata                   (S5_Rdata)
);

axi_slave 
 u_axi_slave6 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S6_AWADDR    ),
    .AWLEN                   ( S6_AWLEN     ),
    .AWVALID                 ( S6_AWVALID   ),
    .WVALID                  ( S6_WVALID    ),
    .WLAST                   ( S6_WLAST     ),
    .WDATA                   ( S6_WDATA     ),
    .WSTRB                   ( S6_WSTRB     ),
    .BREADY                  ( S6_BREADY    ),
    .ARADDR                  ( S6_ARADDR    ),
    .ARVALID                 ( S6_ARVALID   ),
    .RREADY                  ( S6_RREADY    ),

    .AWREADY                 ( S6_AWREADY   ),
    .WREADY                  ( S6_WREADY    ),
    .BVALID                  ( S6_BVALID    ),
    .ARREADY                 ( S6_ARREADY   ),
    .RLAST                   ( S6_RLAST     ),
    .RVALID                  ( S6_RVALID    ),
    .RDATA                   ( S6_RDATA     ),

    .Waddr                   (S6_Waddr),
    .Wdata                   (S6_Wdata),
    .Wena                    (S6_Wena),
    .Wsel                    (S6_Wsel),
    .Raddr                   (S6_Raddr),
    .Rena                    (S6_Rena),
    .Rdata                   (S6_Rdata)
);

axi_slave 
 u_axi_slave7 (
    .aclk                    ( aclk      ),
    .rst_n                   ( rst_n     ),
    .AWADDR                  ( S7_AWADDR    ),
    .AWLEN                   ( S7_AWLEN     ),
    .AWVALID                 ( S7_AWVALID   ),
    .WVALID                  ( S7_WVALID    ),
    .WLAST                   ( S7_WLAST     ),
    .WDATA                   ( S7_WDATA     ),
    .WSTRB                   ( S7_WSTRB     ),
    .BREADY                  ( S7_BREADY    ),
    .ARADDR                  ( S7_ARADDR    ),
    .ARVALID                 ( S7_ARVALID   ),
    .RREADY                  ( S7_RREADY    ),

    .AWREADY                 ( S7_AWREADY   ),
    .WREADY                  ( S7_WREADY    ),
    .BVALID                  ( S7_BVALID    ),
    .ARREADY                 ( S7_ARREADY   ),
    .RLAST                   ( S7_RLAST     ),
    .RVALID                  ( S7_RVALID    ),
    .RDATA                   ( S7_RDATA     ),

    .Waddr                   (S7_Waddr),
    .Wdata                   (S7_Wdata),
    .Wena                    (S7_Wena),
    .Wsel                    (S7_Wsel),
    .Raddr                   (S7_Raddr),
    .Rena                    (S7_Rena),
    .Rdata                   (S7_Rdata)
);

endmodule