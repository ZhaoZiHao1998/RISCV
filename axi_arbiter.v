module axi_arbiter 
(
    // Gobal signal
    input wire          aclk,
    input wire          rst_n,
    // Write arbiter ---------------------
    // Master 0  write
    //input wire          M0_AWVALID,
    //input wire          M0_WVALID,
    //input wire          M0_BREADY,
    // Master 1 write 
    input wire          M1_AWVALID,
    input wire          M1_WVALID,
    input wire          M1_BREADY,
    // Master 2 write 
    input wire          M2_AWVALID,
    input wire          M2_WVALID,
    input wire          M2_BREADY,

    input wire          M_AWREADY,
    input wire          M_WREADY,
    input wire          M_BVALID,

    //output wire          m0_grant_w,
    output wire          m1_grant_w,
    output wire          m2_grant_w,
    // Read arbiter ------------------------
    // Master 0 read
    //input wire          M0_ARVALID,
    //input wire          M0_RREADY,
    // Master 1 read 
    input wire          M1_ARVALID,
    input wire          M1_RREADY,
    // Master 2 read
    input wire          M2_ARVALID,
    input wire          M2_RREADY,

    input wire          M_ARREADY,
    input wire          M_RVALID,

    //output wire          m0_grant_r,
    output wire          m1_grant_r,
    output wire          m2_grant_r
);
    //parameter W_AXI_MASTER0 = 2'b00;
    parameter W_AXI_MASTER1 = 2'b00;
    parameter W_AXI_MASTER2 = 2'b01;

    reg [1:0]   state_w, next_state_w;

    //parameter READY         = 2'b00  ;
    //parameter R_AXI_MASTER0 = 2'b00;
    parameter R_AXI_MASTER1 = 2'b00;
    parameter R_AXI_MASTER2 = 2'b01;
    
    reg [1:0]   state_r, next_state_r;
    
    // Write--------------------------------------------------------------------
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)begin
            state_w <= 2'd0;
        end else begin
            state_w <= next_state_w;
        end
    end

    always @(*) begin
        case (state_w)
        /*
            READY        :begin
                if(M0_AWVALID)begin
                    next_state_w = W_AXI_MASTER0;
                end else if(M1_AWVALID)begin
                    next_state_w = W_AXI_MASTER1;
                end else if(M2_AWVALID)begin
                    next_state_w = W_AXI_MASTER2;
                end else
                    next_state_w = READY;
            end
           
            W_AXI_MASTER0:begin    // 0>1>2
                if(M0_AWVALID)begin
                    next_state_w = W_AXI_MASTER0;
                end else if(M0_AWVALID || M_AWREADY)begin
                    next_state_w = W_AXI_MASTER0;
                end else if(M0_WVALID || M_WREADY)begin  // master 0 还在写数据
                    next_state_w = W_AXI_MASTER0;
                end else if(M0_BREADY && M_BVALID) begin
                    next_state_w = W_AXI_MASTER1;
                end else if(M1_AWVALID) begin
                    next_state_w = W_AXI_MASTER1;
                end else if(M2_AWVALID)begin
                    next_state_w = W_AXI_MASTER2;
                end else begin
                    next_state_w = W_AXI_MASTER0;
                end
            end
             */ 
            W_AXI_MASTER1:begin   // 1>2
                if(M1_AWVALID)begin    
                    next_state_w = W_AXI_MASTER1;
                end else if(M1_AWVALID || M_AWREADY)begin
                    next_state_w = W_AXI_MASTER1;
                end else if(M1_WVALID || M_WREADY)begin  // master 0 还在写数据
                    next_state_w = W_AXI_MASTER1;
                end else if(M1_BREADY && M_BVALID) begin  // have problem
                    next_state_w = W_AXI_MASTER2;
                end else if(M2_AWVALID) begin
                    next_state_w = W_AXI_MASTER2;
                //end else if(M0_AWVALID)begin
                   // next_state_w = W_AXI_MASTER0;
                end else begin
                    next_state_w = W_AXI_MASTER1;
                end
            end
            W_AXI_MASTER2:begin   // 2>0>1
                if(M2_AWVALID)begin    
                    next_state_w = W_AXI_MASTER2;
                end else if(M2_AWVALID || M_AWREADY)begin
                    next_state_w = W_AXI_MASTER2;
                end else if(M2_WVALID || M_WREADY)begin  // master 0 还在写数据
                    next_state_w = W_AXI_MASTER2;
                end else if(M2_BREADY && M_BVALID) begin
                    next_state_w = W_AXI_MASTER1;
                    //next_state_w = W_AXI_MASTER0;
                //end else if(M0_AWVALID) begin
                    //next_state_w = W_AXI_MASTER0;
                end else if(M1_AWVALID)begin
                    next_state_w = W_AXI_MASTER1;
                end else begin
                    next_state_w = W_AXI_MASTER2;
                end
            end
            default: begin
                //next_state_w = W_AXI_MASTER0;
                next_state_w = W_AXI_MASTER1;
            end
        endcase
    end

    //assign m0_grant_w = (next_state_w == W_AXI_MASTER0) ? 1'b1 : 1'b0;
    assign m1_grant_w = (next_state_w == W_AXI_MASTER1) ? 1'b1 : 1'b0;
    assign m2_grant_w = (next_state_w == W_AXI_MASTER2) ? 1'b1 : 1'b0;

    // Read ---------------------------------------------------------------
    always @(posedge aclk or negedge rst_n ) begin
        if(!rst_n)begin
            state_r <= 2'd0;
        end else begin
            state_r <= next_state_r;
        end
    end

    always @(*) begin
        case (state_r)
            /*
            R_AXI_MASTER0:begin    // 0>1>2
                if(M0_ARVALID)begin
                    next_state_r = R_AXI_MASTER0;
                end else if(M0_ARVALID || M_ARREADY)begin
                    next_state_r = R_AXI_MASTER0;
                end else if(M0_RREADY)begin  // master 0 还在写数据
                    next_state_r = R_AXI_MASTER0;
                end else if(M_RVALID) begin
                    next_state_r = R_AXI_MASTER1;
                end else if(M1_ARVALID) begin
                    next_state_r = R_AXI_MASTER1;
                end else if(M2_ARVALID)begin
                    next_state_r = R_AXI_MASTER2;
                end else begin
                    next_state_r = R_AXI_MASTER0;
                end
            end 
            */
            R_AXI_MASTER1:begin    // 1>2>0
                if(M1_ARVALID)begin
                    next_state_r = R_AXI_MASTER1;
                end else if(M1_ARVALID || M_ARREADY)begin
                    next_state_r = R_AXI_MASTER1;
                end else if(M1_RREADY)begin  // master 0 还在写数据
                    next_state_r = R_AXI_MASTER1;
                end else if(M_RVALID) begin
                    next_state_r = R_AXI_MASTER2;
                end else if(M2_ARVALID) begin
                    next_state_r = R_AXI_MASTER2;
                //end else if(M0_ARVALID)begin
                    //next_state_r = R_AXI_MASTER0;
                end else begin
                    next_state_r = R_AXI_MASTER1;
                end
            end
            R_AXI_MASTER2:begin    // 2>0>1
                if(M1_ARVALID)begin
                    next_state_r = R_AXI_MASTER2;
                end else if(M2_ARVALID || M_ARREADY)begin
                    next_state_r = R_AXI_MASTER2;
                end else if(M2_RREADY)begin  // master 0 还在写数据
                    next_state_r = R_AXI_MASTER2;
                end else if(M_RVALID) begin
                    next_state_r = R_AXI_MASTER1;
                    //next_state_r = R_AXI_MASTER0;
                //end else if(M0_ARVALID) begin
                    //next_state_r = R_AXI_MASTER0;
                end else if(M1_ARVALID)begin
                    next_state_r = R_AXI_MASTER1;
                end else begin
                    next_state_r = R_AXI_MASTER2;
                end
            end
            default: begin
                //next_state_r = R_AXI_MASTER0;
                next_state_r = R_AXI_MASTER1;
            end
        endcase
    end

    //assign m0_grant_r = (next_state_r == R_AXI_MASTER0) ? 1'b1 : 1'b0;
    assign m1_grant_r = (next_state_r == R_AXI_MASTER1) ? 1'b1 : 1'b0;
    assign m2_grant_r = (next_state_r == R_AXI_MASTER2) ? 1'b1 : 1'b0;

endmodule