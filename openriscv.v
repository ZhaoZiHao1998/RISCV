`include "define.v"

module openriscv (
    input wire clk,
    input wire rst,
    input wire [`INSTBUS]rom_data_i,//inst from rom
    input wire [`REGBUS]rom_addr_i,
    input wire [`REGBUS]ram_data_i,

    input wire          axi_r_valid_in,

    output wire [`REGBUS]rom_addr_o,//addr
    output wire rom_ce_o,
    output wire axi_stall,

    output wire [`REGBUS]ram_waddr_o,
    output wire [`REGBUS]ram_raddr_o,
    output wire [`REGBUS]ram_data_o,
    output wire [7:0]ram_sel_o,
    output wire ram_r_ena_o,
    output wire ram_w_ena_o,
    output wire ce_ram
);
//PC.V - PC_ID.V
wire [`REGBUS]PC;
//PC_ID.V - ID.V
wire [`INSTBUS]id_inst_i;
wire [`REGBUS]id_pc_i;
//ID.V - ID_EX.V
wire [3:0]inst_type_i;
wire [4:0]exe_type_i;
//wire [11:0]Imm_i;
wire rd_w_ena_i;
wire [5:0]rd_addr_i;
wire [`REGBUS]id_rdata1_i;
wire [`REGBUS]id_rdata2_i;
//ID.V - regfile.V
wire [5:0]rs1_addr_i;
wire rs1_r_ena_i;
wire [5:0]rs2_addr_i;
wire rs2_r_ena_i;
wire [`INSTBUS]id_inst;

wire [11:0]id_csr_addr_o;
wire id_csr_w_ena_o;
wire [11:0]id_csr_w_addr_o;
//regfile.v - ID.V
wire [`REGBUS]rdata1_i;
wire [`REGBUS]rdata2_i;
//ID_EX.V - EX.V
wire [3:0]ex_inst_type_i;
wire [4:0]ex_exe_type_i;
wire [`INSTBUS]ex_inst;
wire inst_is_load;

wire [11:0]ex_csr_raddr_o;
wire ex_csr_w_ena_o;
wire [11:0]ex_csr_w_addr_o;
//wire [11:0]ex_Imm_i;
wire ex_rd_w_ena_i;
wire [5:0]ex_rd_addr_i;
wire [`REGBUS]ex_rdata1_i;
wire [`REGBUS]ex_rdata2_i;
//ex.v - ex_mem.v
wire [5:0]ex_rd_addr_o;
wire ex_rd_w_ena_o;
wire [`REGBUS]ex_wdata_o;
wire [`REGBUS]ex_mem_addr_o;
wire [`REGBUS]ex_mem_data_o;
wire [3:0]ex_inst_type_o;
wire [4:0]ex_exe_type_o;

wire [11:0]ex_csr_w_addr_i;
wire ex_csr_w_ena_i;
wire [`REGBUS]ex_csr_wdata_i;
//ex_mem.v - mem.v
wire [5:0]mem_rd_addr_i;
wire mem_rd_w_ena_i;
wire [`REGBUS]mem_wdata_i;

wire [`REGBUS]mem_mem_addr_i;
wire [`REGBUS]mem_mem_data_i;
wire [3:0]mem_inst_type_i;
wire [4:0]mem_exe_type_i;

wire [11:0]mem_csr_w_addr_i;
wire mem_csr_w_ena_i;
wire [`REGBUS]mem_csr_wdata_i;
//mem.v - mem_wb.v
wire [5:0]mem_rd_addr_o;
wire mem_rd_w_ena_o;
wire [`REGBUS]mem_wdata_o;

wire [11:0]wb_csr_w_addr_i;
wire wb_csr_w_ena_i;
wire [`REGBUS]wb_csr_wdata_i;
//mem_wb.v - regfile.v
wire [5:0]wb_rd_addr_i;
wire wb_rd_w_ena_i;
wire [`REGBUS]wb_wdata_i;

//ctrl.v - pc.v
wire [1:0]stallreq_from_id;
wire [1:0]stallreq_from_id1;
wire stallreq_from_exe;
wire [5:0] stall_ctrl;
//wire stallstop;

//ex.v - div.v
wire div_signed_div_i;
wire [63:0]div_opdata1_i;
wire [63:0]div_opdata2_i;
wire div_start_i;
wire div_annul_i;
wire [127:0]div_result_o;
wire div_ready_o;
//id.v-pc.v  transfer isa
wire branch_flag;
wire [`REGBUS]branch_target_address;
//ex.v - csr_reg.v
wire [`REGBUS]csr_reg_rdata_i;
wire [11:0]csr_reg_raddr_o;
//mem_wb - csr_reg.v
wire [11:0]csrreg_csr_w_addr_i;
wire csrreg_csr_w_ena_i;
wire [`REGBUS]csrreg_csr_wdata_i;
// mem.v - cache.v
wire [`REGBUS]cache_waddr;
wire [`REGBUS]cache_raddr;
wire [`REGBUS]cache_wdata;
wire [`REGBUS]cache_rdata;
wire [7:0]    cache_sel;
wire          cache_r_ena;
wire          cache_ce_ram;
// axi - cache
wire          cache_axi_r_valid;
// cache - mem
wire [`REGBUS]cache_hit_rdata;
//cache - crtl
wire          stallreq_from_cache;

assign ce_ram = ram_r_ena_o || ram_w_ena_o;
assign cache_axi_r_valid = axi_r_valid_in;
//instantiation cache.v
cache cache0(
    .clk            (clk),
    .rst            (rst),
    .waddr_in       (cache_waddr),
    .raddr_in       (cache_raddr),
    .wdata_in       (cache_wdata),
    
    .rdata_in       (cache_rdata),
    
    .sel_in         (cache_sel),
    .r_ena_in       (cache_r_ena), 
    .ce_ram_in      (cache_ce_ram),  
    .axi_r_valid    (cache_axi_r_valid),          
    //.hit_rdata_out  (cache_hit_rdata), 

    .mem_rdata_out  (cache_hit_rdata),

    .mem_waddr_out  (ram_waddr_o),
    .mem_wdata_out  (ram_data_o),
    .mem_w_ena_out  (ram_w_ena_o),
    .mem_raddr_out  (ram_raddr_o),
    .mem_r_ena_out  (ram_r_ena_o),
    .stall_cache    (stallreq_from_cache)
);

//instantiation div.v
div div0(
    .clk(clk),
    .rst(rst),
    .signed_div_i(div_signed_div_i),
    .opdata1_i(div_opdata1_i),
    .opdata2_i(div_opdata2_i),
    .start_i(div_start_i),
    .annul_i(1'b0),

    .result_o(div_result_o),
    .ready_o(div_ready_o)
);

//instantiation ctrl.v
ctrl ctrl0(
    .rst(rst),
    .stallreq_from_id(stallreq_from_id), //stop from id
    .stallreq_from_id1(stallreq_from_id1),
    .stallreq_from_exe(stallreq_from_exe),//stop from exe
    //.stallstop(stallstop),
    .stallreq_from_cache(stallreq_from_cache),
    .stall(stall_ctrl)
);
//instantiation PC.V
pc pc0(
    .clk(clk),
    .rst(rst),
    .stall(stall_ctrl),
    .branch_flag_i(branch_flag),
    .branch_target_address_i(branch_target_address),

    .axi_stall(axi_stall),
    .pc_o(rom_addr_o),
    .ce_o(rom_ce_o)
);
//instantiation PC_ID.V
pc_id pc_id0(
    .clk(clk),
    .rst(rst),
    .pc_pc(rom_addr_i),
    .pc_instreg_inst(rom_data_i),
    .stall(stall_ctrl),

    .id_pc(id_pc_i),
    .id_inst(id_inst_i)
);
//instantiation ID.V
id id0(
    .rst(rst),
    .id_pc_i(id_pc_i),
    .id_inst_i(id_inst_i),
    .reg1_data_i(rdata1_i),
    .reg2_data_i(rdata2_i),

    .ex_rd_addr_i(ex_rd_addr_o),
    .ex_rd_w_ena_i(ex_rd_w_ena_o),
    .ex_wdata_i(ex_wdata_o),

    .mem_rd_addr_i(mem_rd_addr_o),
    .mem_rd_w_ena_i(mem_rd_w_ena_o),
    .mem_wdata_i(mem_wdata_o),
    .inst_is_load_i(inst_is_load),
    
    .id_inst_o(id_inst),
    .inst_type_o(inst_type_i),
    .exe_type_o(exe_type_i),
    //.Imm_o(Imm_i),
    .rs1_r_ena_o(rs1_r_ena_i),
    .rs1_addr_o(rs1_addr_i),
    .rs2_r_ena_o(rs2_r_ena_i),
    .rs2_addr_o(rs2_addr_i),
    .rd_w_ena_o(rd_w_ena_i),
    .rd_addr_o(rd_addr_i),
    .reg1_data_o(id_rdata1_i),
    .reg2_data_o(id_rdata2_i),

    .stallreg_id(stallreq_from_id),
    .stallreg_id1(stallreq_from_id1),

    .branch_flag_o(branch_flag),
    .branch_target_address_o(branch_target_address),

    .csr_raddr_o(id_csr_addr_o),
    .csr_w_ena_o(id_csr_w_ena_o),
    .csr_w_addr_o(id_csr_w_addr_o)
);
regfile regfile0(
   .clk(clk),
   .rst(rst),
   .rs1_addr(rs1_addr_i),
   .rs1_ena_r(rs1_r_ena_i),
   .rs2_addr(rs2_addr_i),
   .rs2_ena_r(rs2_r_ena_i),
   .wdata_addr(wb_rd_addr_i),
   .wdata(wb_wdata_i),
   .wdata_ena(wb_rd_w_ena_i),

   .rdata1(rdata1_i),
   .rdata2(rdata2_i) 
);
id_ex id_ex0(
    .clk(clk),
    .rst(rst),
    .id_inst(id_inst),
    .id_inst_type(inst_type_i),
    .id_exe_type(exe_type_i),
    //.id_Imm(Imm_i),
    .id_rd_w_ena(rd_w_ena_i),
    .id_rd_addr(rd_addr_i),
    .id_rdata1(id_rdata1_i),
    .id_rdata2(id_rdata2_i),

    .stall(stall_ctrl),

    .id_csr_raddr_i(id_csr_addr_o),
    .id_csr_w_ena_i(id_csr_w_ena_o),
    .id_csr_w_addr_i(id_csr_w_addr_o),

    .ex_csr_raddr_o(ex_csr_raddr_o),
    .ex_csr_w_ena_o(ex_csr_w_ena_o),
    .ex_csr_w_addr_o(ex_csr_w_addr_o),

    .ex_inst(ex_inst),
    .ex_inst_type(ex_inst_type_i),
    .ex_exe_type(ex_exe_type_i),
    //.ex_Imm(ex_Imm_i),
    .ex_rd_w_ena(ex_rd_w_ena_i),
    .ex_rd_addr(ex_rd_addr_i),
    .ex_rdata1(ex_rdata1_i),
    .ex_rdata2(ex_rdata2_i)
);
ex ex0(
    .clk(clk),
    .rst(rst),
    .inst(ex_inst),
    .inst_type_i(ex_inst_type_i),
    .exe_type_i(ex_exe_type_i),
    //.Imm_i(ex_Imm_i),
    .rd_w_ena_i(ex_rd_w_ena_i),
    .rd_addr_i(ex_rd_addr_i),
    .rdata1_i(ex_rdata1_i),
    .rdata2_i(ex_rdata2_i),
    //div input
    .div_result_i(div_result_o),
    .div_ready_i(div_ready_o),

    .csr_rdata_i(csr_reg_rdata_i),
    .csr_raddr_i(ex_csr_raddr_o),
    .csr_w_ena_i(ex_csr_w_ena_o),
    .csr_w_addr_i(ex_csr_w_addr_o),

    .mem_csr_w_addr_i(wb_csr_w_addr_i),
    .mem_csr_w_ena_i(wb_csr_w_ena_i),
    .mem_csr_wdata_i(wb_csr_wdata_i),

    .wb_csr_w_addr_i(csrreg_csr_w_addr_i),
    .wb_csr_w_ena_i(csrreg_csr_w_ena_i),
    .wb_csr_wdata_i(csrreg_csr_wdata_i),

    .csr_raddr_o(csr_reg_raddr_o),
    .csr_w_addr_o(ex_csr_w_addr_i),
    .csr_w_ena_o(ex_csr_w_ena_i),
    .csr_wdata_o(ex_csr_wdata_i),

    //div output
    .div_opdata1_o(div_opdata1_i),
    .div_opdata2_o(div_opdata2_i),
    .div_start_o(div_start_i),
    .signed_div_o(div_signed_div_i),

    .rd_addr_o(ex_rd_addr_o),
    .rd_w_ena_o(ex_rd_w_ena_o),
    .wdata_o(ex_wdata_o),
    .mem_addr_o(ex_mem_addr_o),
    .mem_data_o(ex_mem_data_o),
    .inst_type_o(ex_inst_type_o),
    .exe_type_o(ex_exe_type_o),
    .inst_is_load_o(inst_is_load),

    .stallreg_ex(stallreq_from_exe)
    //.stallstop_trans(stallstop)
);
ex_mem ex_mem0(
    .clk(clk),
    .rst(rst),
    .ex_rd_addr(ex_rd_addr_o),
    .ex_rd_w_ena(ex_rd_w_ena_o),
    .ex_wdata(ex_wdata_o),

    .ex_mem_addr(ex_mem_addr_o),
    .ex_mem_data(ex_mem_data_o),
    .ex_inst_type(ex_inst_type_o),
    .ex_exe_type(ex_exe_type_o),

    .stall(stall_ctrl),

    .ex_csr_w_addr(ex_csr_w_addr_i),
    .ex_csr_w_ena(ex_csr_w_ena_i),
    .ex_csr_wdata(ex_csr_wdata_i),

    .mem_csr_w_addr(mem_csr_w_addr_i),
    .mem_csr_w_ena(mem_csr_w_ena_i),
    .mem_csr_wdata(mem_csr_wdata_i),

    .mem_mem_addr(mem_mem_addr_i),
    .mem_mem_data(mem_mem_data_i),
    .mem_inst_type(mem_inst_type_i),
    .mem_exe_type(mem_exe_type_i),

    .mem_rd_addr(mem_rd_addr_i),
    .mem_rd_w_ena(mem_rd_w_ena_i),
    .mem_wdata(mem_wdata_i)
);
mem mem0(
    .rst(rst),
    .rd_addr_i(mem_rd_addr_i),
    .rd_w_ena_i(mem_rd_w_ena_i),
    .wdata_i(mem_wdata_i),

    .mem_addr_i(mem_mem_addr_i),
    .mem_data_i(mem_mem_data_i),
    .mem_data_i_ram(cache_hit_rdata),
    .inst_type_i(mem_inst_type_i),
    .exe_type_i(mem_exe_type_i),

    .mem_csr_w_addr_i(mem_csr_w_addr_i),
    .mem_csr_w_ena_i(mem_csr_w_ena_i),
    .mem_csr_wdata_i(mem_csr_wdata_i),

    .mem_csr_w_addr_o(wb_csr_w_addr_i),
    .mem_csr_w_ena_o(wb_csr_w_ena_i),
    .mem_csr_wdata_o(wb_csr_wdata_i),

    .mem_waddr_o(cache_waddr),
    .mem_raddr_o(cache_raddr),
    .mem_data_o(cache_wdata),
    .mem_r_ena_o(cache_r_ena),
    .mem_sel_o(cache_sel),
    .ce_ram(cache_ce_ram),

    .rd_addr_o(mem_rd_addr_o),
    .rd_w_ena_o(mem_rd_w_ena_o),
    .wdata_o(mem_wdata_o)
);
mem_wb mem_wb0(
    .clk(clk),
    .rst(rst),
    .mem_rd_addr(mem_rd_addr_o),
    .mem_rd_w_ena(mem_rd_w_ena_o),
    .mem_wdata(mem_wdata_o),

    .stall(stall_ctrl),

    .mem_csr_w_addr(wb_csr_w_addr_i),
    .mem_csr_w_ena(wb_csr_w_ena_i),
    .mem_csr_wdata(wb_csr_wdata_i),

    .wb_csr_w_addr(csrreg_csr_w_addr_i),
    .wb_csr_w_ena(csrreg_csr_w_ena_i),
    .wb_csr_wdata(csrreg_csr_wdata_i),

    .wb_rd_addr(wb_rd_addr_i),
    .wb_rd_w_ena(wb_rd_w_ena_i),
    .wb_wdata(wb_wdata_i)

);
csr_reg csr_reg0(
    .clk(clk),
    .rst(rst),

    .csr_raddr_i(csr_reg_raddr_o),
    .csr_w_addr_i(csrreg_csr_w_addr_i),
    .csr_w_data_i(csrreg_csr_wdata_i),
    .csr_w_ena_i(csrreg_csr_w_ena_i),

    .csr_rdata_o(csr_reg_rdata_i)
);

assign ram_w_ena_o = ~ram_r_ena_o;

assign rom_addr_o = PC;
endmodule