`include "define.v"
module openriscv_rom_sopc (
    input wire clk,
    input wire rst
);
wire [`REGBUS]rom_data_addr; // rom data + pc addr
wire [`REGBUS]rom_addr;
wire rom_ce;
wire [`INSTBUS]rom_data;
wire [`REGBUS]rom_pc;

assign rom_data = rom_data_addr[31:0];
assign rom_pc   = {{32{1'b0}},rom_data_addr[63:32]};

wire [`REGBUS]ram_data_i;
wire [`REGBUS]ram_data_o;
wire [`REGBUS]ram_waddr;
wire [`REGBUS]ram_raddr;
wire ram_r_ena;
wire [7:0]ram_sel;
wire ce_ram;

wire M0_stall;
wire r_valid;
openriscv openriscv0(
    .clk(clk),
    .rst(rst),
    .rom_data_i(rom_data),
    .rom_addr_i(rom_pc),
    .ram_data_i(ram_data_i),

    .axi_r_valid_in (r_valid),

    .axi_stall(M0_stall),

    .rom_addr_o(rom_addr),
    .rom_ce_o(rom_ce),
    .ram_waddr_o(ram_waddr),
    .ram_raddr_o(ram_raddr),
    .ram_data_o(ram_data_o),
    .ram_sel_o(ram_sel),
    .ram_r_ena_o(ram_r_ena),
    .ram_w_ena_o(ram_w_ena),
    .ce_ram(ce_ram)
);


wire                    s0_rena ;
wire [`REGBUS]          s0_raddr;
wire [`REGBUS]         s0_rdata;
rom_inst rom_inst0(
    .ce(s0_rena),
    .inst_addr(s0_raddr),
    .inst_pc(s0_rdata)
);

wire [`REGBUS]       s1_ram_waddr;
wire [`REGBUS]       s1_ram_raddr;
wire [7:0]           s1_ram_sel;
wire                 s1_ram_r_ena;
wire                 s1_ram_w_ena;
wire [`REGBUS]       s1_ram_data_o;
wire [`REGBUS]       s1_ram_data_i;   
data_ram data_ram(
    .clk(clk),
    .ce(s1_ram_r_ena || s1_ram_w_ena),
    .waddr({{3'b000},s1_ram_waddr[60:0]}),
    .raddr({{3'b000},s1_ram_raddr[60:0]}),
    .data_i(s1_ram_data_i),
    .sel(s1_ram_sel),
    .r_ena(s1_ram_r_ena),
    .w_ena(s1_ram_w_ena),

    .data_o(s1_ram_data_o)
);



axi 
 u_axi (
    .aclk                    ( clk   ),
    .rst_n                   ( !rst   ),

    .M0_stall                ( M0_stall ),
    .M0_en_w                 ( 1'b0  ),
    .M0_en_r                 ( rom_ce ),
    .M0_addr_start_w         ( 'd0   ),
    .M0_sel_w                ( 8'd0        ),
    .M0_addr_start_r         ( rom_addr   ),
    .M0_data_w               ( 'd0   ),
    .M0_r_valid              (      ),
    .M1_stall                (),
    .M1_en_w                 ( ce_ram && ram_w_ena   ),
    .M1_en_r                 ( ce_ram && ram_r_ena   ),
    .M1_addr_start_w         ( ram_waddr   ),
    .M1_addr_start_r         ( ram_raddr   ),
    .M1_sel_w                ( ram_sel),
    .M1_data_w               ( ram_data_o   ),
    .M1_r_valid              (   r_valid   ),
    .M2_stall                (),
    .M2_en_w                 (    ),
    .M2_en_r                 (    ),
    .M2_addr_start_w         (    ),
    .M2_sel_w                (),
    .M2_addr_start_r         (    ),
    .M2_data_w               (    ),
    .M2_r_valid              (      ),
    .M0_data_r               ( rom_data_addr   ),
    .M1_data_r               ( ram_data_i   ),
    .M2_data_r               (    ),

    .S0_Waddr                ( ),
    .S0_Wdata                ( ),
    .S0_Wena                 ( ),
    .S0_Wsel                 ( ),
    .S0_Raddr                ( s0_raddr),
    .S0_Rena                 ( s0_rena),
    .S0_Rdata                ( s0_rdata),

    .S1_Waddr                ( s1_ram_waddr),
    .S1_Wdata                ( s1_ram_data_i),
    .S1_Wena                 ( s1_ram_w_ena),
    .S1_Wsel                 ( s1_ram_sel),
    .S1_Raddr                ( s1_ram_raddr),
    .S1_Rena                 ( s1_ram_r_ena),
    .S1_Rdata                ( s1_ram_data_o),

    .S2_Waddr                (),
    .S2_Wdata                (),
    .S2_Wena                 (),
    .S2_Wsel                 (),
    .S2_Raddr                (),
    .S2_Rena                 (),
    .S2_Rdata                (),
    
    .S3_Waddr                (),
    .S3_Wdata                (),
    .S3_Wena                 (),
    .S3_Wsel                 (),
    .S3_Raddr                (),
    .S3_Rena                 (),
    .S3_Rdata                (),

    .S4_Waddr                (),
    .S4_Wdata                (),
    .S4_Wena                 (),
    .S4_Wsel                 (),
    .S4_Raddr                (),
    .S4_Rena                 (),
    .S4_Rdata                (),

    .S5_Waddr                (),
    .S5_Wdata                (),
    .S5_Wena                 (),
    .S5_Wsel                 (),
    .S5_Raddr                (),
    .S5_Rena                 (),
    .S5_Rdata                (),

    .S6_Waddr                (),
    .S6_Wdata                (),
    .S6_Wena                 (),
    .S6_Wsel                 (),
    .S6_Raddr                (),
    .S6_Rena                 (),
    .S6_Rdata                (),

    .S7_Waddr                (),
    .S7_Wdata                (),
    .S7_Wena                 (),
    .S7_Wsel                 (),
    .S7_Raddr                (),
    .S7_Rena                 (),
    .S7_Rdata                ()
);

endmodule