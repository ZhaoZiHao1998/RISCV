`include "define.v"

module id (
    input wire rst,
    input wire [`REGBUS]id_pc_i,
    input wire [`INSTBUS]id_inst_i, //inst from PC_ID
    input wire [`REGBUS]reg1_data_i,
    input wire [`REGBUS]reg2_data_i, 

    //the output of ex
    input wire [5:0]ex_rd_addr_i,
    input wire ex_rd_w_ena_i,
    input wire [`REGBUS]ex_wdata_i,

    //the mem output
    input wire [5:0]mem_rd_addr_i,
    input wire mem_rd_w_ena_i,
    input wire [`REGBUS]mem_wdata_i,
    input wire inst_is_load_i,
    
    //from csr_reg
    //input wire [`REGBUS]csr_rdata_i,

    output reg [3:0]inst_type_o,
    output reg [4:0]exe_type_o,
    output reg [`INSTBUS]id_inst_o,
    //output reg [11:0]Imm_o,
    
    output reg rs1_r_ena_o,
    output reg [5:0]rs1_addr_o,
    
    output reg rs2_r_ena_o,
    output reg [5:0]rs2_addr_o,

    output reg rd_w_ena_o,
    output reg [5:0]rd_addr_o,
    output reg [`REGBUS]reg1_data_o,
    output reg [`REGBUS]reg2_data_o,

    output reg [1:0]stallreg_id,
    output reg [1:0]stallreg_id1,

    //transfer isa
    //output reg [5:0]link_addr_o,
    output reg branch_flag_o,
    output reg [`REGBUS]branch_target_address_o,
    
    //to csr_reg
    output reg [11:0]csr_raddr_o,
    //to id_ex
    //output reg [`REGBUS]csr_rdata_o,
    output reg csr_w_ena_o,
    output reg [11:0]csr_w_addr_o
);
//transfer instctions to temp 
wire [6:0] op         = id_inst_i[6:0];
wire [5:0]rd          = id_inst_i[11:7];
wire [2:0]func3       = id_inst_i[14:12];
wire [5:0]rs1         = id_inst_i[19:15];
wire [11:0]imm        = id_inst_i[31:20];
wire [5:0]rs2         = id_inst_i[24:20];
wire [6:0]func7       = id_inst_i[31:25];
wire [5:0]shamt       = id_inst_i[25:20];
wire [19:0]u_imm      = id_inst_i[31:12];

wire [11:0]l_offset   = id_inst_i[31:20];


wire [20:0]jal_offset = {id_inst_i[31],id_inst_i[19:12],id_inst_i[20],id_inst_i[30:21],1'b0};
wire [12:0]b_offset   = {id_inst_i[31],id_inst_i[7],id_inst_i[30:25],id_inst_i[11:8],1'b0};
wire [4:0]zimm        = id_inst_i[19:15];

reg jump_reg1_relate_load;
reg jump_reg2_relate_load;
//reg [`REGBUS]reg1;
//reg [`REGBUS]reg2;
reg [`REGBUS]Imm;
reg instvalid;
//inst_type deal
always @(*) begin
    if(jump_reg1_relate_load || jump_reg2_relate_load == 1'b1)
        stallreg_id1 <= 2'b10;
    else begin
        stallreg_id1 <= 2'd0;
    end
end

always @(*)
begin
    if(rst == `RSTENABLE)
        begin
            inst_type_o <= 4'h0;
            exe_type_o  <= 5'h0;
            Imm         <= `ZERO_64;
            rs1_r_ena_o <= `ENA_UNABLE;
            rs1_addr_o  <= 6'h0;
            rd_w_ena_o  <= `ENA_UNABLE;
            rd_addr_o   <= 6'h0;
            rs2_r_ena_o <= `ENA_UNABLE;
            rs2_addr_o  <= 6'h0;
            instvalid   <= `INSTINVALID;
            id_inst_o   <= `ZERO_32;

            //link_addr_o <= 6'h0;
            branch_flag_o <= 1'b0;
            branch_target_address_o <= `ZERO_32;

            csr_raddr_o  <= 12'h0;
            //csr_rdata_o  <= `ZERO_64;
            csr_w_addr_o <= 12'h0;
            csr_w_ena_o  <= 1'b0;
        end
    else 
        begin
            //reg1        <= `ZERO_64;
            //reg2        <= `ZERO_64;
            rs1_r_ena_o <= `ENA_UNABLE;
            rs1_addr_o  <= rs1;
            rd_w_ena_o  <= `ENA_UNABLE;
            rd_addr_o   <= rd;
            rs2_r_ena_o <= `ENA_UNABLE;
            rs2_addr_o  <= rs2;
            id_inst_o <= id_inst_i;
            stallreg_id <= 2'b00;

            //link_addr_o <= 6'h0; 
            branch_flag_o  <= 1'b0;
            branch_target_address_o <= `ZERO_32;

            csr_raddr_o  <= imm;
            //csr_rdata_o  <= csr_rdata_i;
            csr_w_addr_o <= 12'h0;
            csr_w_ena_o  <= 1'b0;
            //Imm         <= {{52{0}},imm};
        end 
    //By judge op to get R,I,S   

        case(op)
            7'b0010011:begin
                inst_type_o <= `I_TYPE_LOGI;    
            end
            7'b0110011:begin
                inst_type_o <= `R_TYPE_LOGI;
            end
            7'b0110111:begin
                inst_type_o <= `U_TYPE_LOGI;
                exe_type_o  <= `LUI;
            end
            7'b0010111:begin
                inst_type_o <= `U_TYPE_LOGI;
                exe_type_o  <= `AUIPC;
            end
            7'b1101111:begin
                inst_type_o <= `J_TYPE_LOGI;
                exe_type_o  <= `JAL;
            end
            7'b1100111:begin
                inst_type_o <= `J_TYPE_LOGI;
                exe_type_o  <= `JALR;
            end
            7'b1100011:begin
                inst_type_o <= `B_TYPE_LOGI;
            end
            7'b0000011:begin
                inst_type_o <= `L_TYPE_LOGI;
            end
            7'b0100011:begin
                inst_type_o <= `S_TYPE_LOGI;
            end
            7'b0011011:begin
                inst_type_o <= `IW_TYPE_LOGI;
                //exe_type_o  <= `ADDIW;
            end
            7'b1110011:begin
                inst_type_o <= `CSR_TYPE_LOGI;
            end
            default  :begin
                inst_type_o <= 4'h0;
            end
        endcase
    //exe_type_o deal
        if (inst_type_o == `I_TYPE_LOGI)
            begin
                case(func3)
                    3'b000:begin
                        //I_type addi
                        //Imm_o      <= imm;
                        exe_type_o <= `ADDI;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{imm[11]}},imm};
                    end
                    3'b001:begin
                        if (func7[6:1] == 6'b000000)begin
                            //I_type slli
                            //Imm_o      <= imm;
                            exe_type_o <= `SLLI;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_UNABLE;
                            rd_w_ena_o <= `INSTVALID;
                            //reg1       <= reg1_data_i;
                            Imm        <= {{48{1'b0}},shamt};   
                        end
                        // sd
                    end
                    3'b010:begin
                        //I_type slti
                        //Imm_o      <= imm;
                        exe_type_o <= `SLTI;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{imm[11]}},imm};
                    end
                    3'b011:begin
                        //I_type sltiu
                        //Imm_o      <= imm;
                        exe_type_o <= `SLTIU;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{imm[11]}},imm};
                    end
                    3'b100:begin
                        //I_type xori
                        //Imm_o      <= imm;
                        exe_type_o <= `XORI;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{imm[11]}},imm};
                    end
                    3'b101:begin
                        if (func7 == 7'b0000000) begin
                            //I_type srli
                            //Imm_o      <= imm;
                            exe_type_o <= `SRLI;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_UNABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            instvalid  <= `INSTVALID;
                            //reg1       <= reg1_data_i;
                            Imm        <= {{58{1'b0}},shamt};
                        end else if(func7 == 7'b0100000)begin
                            //I_type srai
                            //Imm_o      <= imm;
                            exe_type_o <= `SRAI;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_UNABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            instvalid  <= `INSTVALID;
                            //reg1       <= reg1_data_i;
                            Imm        <= {{58{1'b0}},shamt};
                        end
                    end
                    3'b110:begin
                        //I_type ori
                        //Imm_o      <= imm;
                        exe_type_o <= `ORI;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{imm[11]}},imm};
                    end
                    3'b111:begin
                        //I_type andi
                        //Imm_o      <= imm;
                        exe_type_o <= `ANDI;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{imm[11]}},imm};
                    end
                    
                    default:begin
                        //Imm_o      <= 12'h0;
                        exe_type_o <= 4'h0;
                        Imm        <= `ZERO_64;
                        instvalid  <= `INSTINVALID;
                    end
                endcase
            end
        else if(inst_type_o == `CSR_TYPE_LOGI)
            begin
                case (func3)
                    3'b011:begin
                        exe_type_o <= `CSRRC;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        csr_w_ena_o<= `ENA_ENABLE;
                        csr_w_addr_o<= imm;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                    end
                    3'b111:begin
                        exe_type_o <= `CSRRCI;
                        rs1_r_ena_o<= `ENA_UNABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        csr_w_ena_o<= `ENA_ENABLE;
                        csr_w_addr_o<= imm;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{59{1'b0}},zimm};
                    end
                    3'b010:begin
                        exe_type_o <= `CSRRS;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        csr_w_ena_o<= `ENA_ENABLE;
                        csr_w_addr_o<= imm;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        //Imm        <= imm;
                    end
                    3'b110:begin
                        exe_type_o <= `CSRRSI;
                        rs1_r_ena_o<= `ENA_UNABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        csr_w_ena_o<= `ENA_ENABLE;
                        csr_w_addr_o<= imm;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{59{1'b0}},zimm};
                    end
                    3'b001:begin
                        exe_type_o <= `CSRRW;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        csr_w_ena_o<= `ENA_ENABLE;
                        csr_w_addr_o<= imm;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        //Imm        <= imm;
                    end
                    3'b101: begin
                        exe_type_o <= `CSRRWI;
                        rs1_r_ena_o<= `ENA_UNABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        csr_w_ena_o<= `ENA_ENABLE;
                        csr_w_addr_o<= imm;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{59{1'b0}},zimm};
                    end
                    default:begin
                        exe_type_o <= 4'h0;
                        Imm        <= `ZERO_64;
                        instvalid  <= `INSTINVALID;
                    end 
                endcase
            end
        else if(inst_type_o == `R_TYPE_LOGI)
            begin
                case(func3)
                    3'b000:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `ADD;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        else if(func7 == 7'b0000001)begin
                            exe_type_o <= `MUL;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        else if(func7 == 7'b0100000)begin
                            exe_type_o <= `SUB;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        else begin
                            instvalid  <= `INSTINVALID;
                            exe_type_o <= 4'h0;
                        end            
                    end
                    3'b001:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `SLL;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end else if(func7 == 7'b0000001)begin
                            exe_type_o <= `MULH;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                    end
                    3'b010:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `SLT;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end else if(func7 == 7'b0000001)begin
                            exe_type_o <= `MULHSU;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        
                    end
                    3'b011:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `SLTU;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end else if(func7 == 7'b0000001)begin
                            exe_type_o <= `MULHU;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        
                    end
                    3'b100:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `XOR;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;    
                        end else if(func7 == 7'b0000001) begin
                            exe_type_o <= `DIV;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        
                    end
                    3'b101:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `SRL;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end  
                        else if(func7 == 7'b0100000)begin
                            exe_type_o <= `SRA;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        else if(func7 == 7'b0000001)begin
                            exe_type_o <= `DIVU;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        else begin
                            exe_type_o <= 4'h0;
                            instvalid  <= `INSTINVALID;
                        end
                    end
                    3'b110:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `OR;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end else if(func7 == 7'b0000001)begin
                            exe_type_o <= `REM;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        
                    end
                    3'b111:begin
                        if(func7 == 7'b0000000)begin
                            exe_type_o <= `AND;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end else if(func7 == 7'b0000001)begin
                            exe_type_o <= `REMU;
                            rs1_r_ena_o<= `ENA_ENABLE;
                            rs2_r_ena_o<= `ENA_ENABLE;
                            rd_w_ena_o <= `ENA_ENABLE;
                            //reg1       <= reg1_data_i;
                            //reg2       <= reg2_data_i;
                            instvalid  <= `INSTVALID;
                        end
                        
                    end
                    default:begin
                        exe_type_o <= 4'h0;
                        instvalid  <= `INSTINVALID;
                    end
                endcase
            end

        else if(inst_type_o == `U_TYPE_LOGI && exe_type_o == `LUI)
            begin
                rs1_r_ena_o<= `ENA_UNABLE;
                rs2_r_ena_o<= `ENA_UNABLE;
                rd_w_ena_o <= `ENA_ENABLE;
                instvalid  <= `INSTVALID;
                Imm        <= {{32{u_imm[19]}},u_imm,{12'h0}};
            end
        else if(inst_type_o == `U_TYPE_LOGI && exe_type_o == `AUIPC)
            begin
                rs1_r_ena_o<= `ENA_UNABLE;
                rs2_r_ena_o<= `ENA_UNABLE;
                rd_w_ena_o <= `ENA_ENABLE;
                instvalid  <= `INSTVALID;
                Imm        <= {{32{u_imm[19]}},u_imm,{12'h0}} + id_pc_i;
            end
        else if(inst_type_o == `J_TYPE_LOGI && exe_type_o == `JAL)
            begin
                rs1_r_ena_o             <= `ENA_UNABLE;
                rs2_r_ena_o             <= `ENA_UNABLE;
                rd_w_ena_o              <= `ENA_ENABLE;
                //link_addr_o             <= 6'h5; //link x5 register
                instvalid               <= `INSTVALID;
                Imm                     <= id_pc_i + 4'h4;
                branch_flag_o           <= 1'b1;
                branch_target_address_o <= id_pc_i + {{43{jal_offset[20]}},jal_offset}; 
                stallreg_id             <= 2'b01;    
            end
        else if(inst_type_o == `J_TYPE_LOGI && exe_type_o == `JALR)
            begin
                rs1_r_ena_o             <= `ENA_ENABLE;
                rs2_r_ena_o             <= `ENA_UNABLE;
                rd_w_ena_o              <= `ENA_ENABLE;
                instvalid               <= `INSTVALID;
                //reg1                    <= reg1_data_i;
                Imm                     <= id_pc_i + 4'h4;
                branch_flag_o           <= 1'b1;
                branch_target_address_o <= (reg1_data_o + {{52{imm[11]}},imm}) & (~64'h1);
                stallreg_id             <= 2'b01;
            end
        else if(inst_type_o == `B_TYPE_LOGI)
            begin
                case (func3)
                    3'b000:begin
                        exe_type_o <= `BEQ;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        //reg1       <= reg1_data_i;
                        //reg2       <= reg2_data_i;
                        instvalid  <= `INSTVALID;
                        if(reg1_data_o == reg2_data_o)begin
                            branch_flag_o <= 1'b1;
                            branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                            stallreg_id  <= 2'b01;
                        end else begin
                            branch_flag_o <= 1'b0;
                            branch_target_address_o <= `ZERO_64;
                        end
                    end 
                    3'b001:begin
                        exe_type_o <= `BNE;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        //reg1       <= reg1_data_i;
                        //reg2       <= reg2_data_i;
                        instvalid  <= `INSTVALID;
                        if(reg1_data_o != reg2_data_o)begin
                            branch_flag_o <= 1'b1;
                            branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                            stallreg_id  <= 2'b01;
                        end else begin
                            branch_flag_o <= 1'b0;
                            branch_target_address_o <= `ZERO_64;
                        end
                    end
                    3'b101:begin
                        exe_type_o <= `BGE;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        //reg1       <= reg1_data_i;
                        //reg2       <= reg2_data_i;
                        instvalid  <= `INSTVALID;
                        if( (reg1_data_o[63] == 1'b0) && (reg2_data_o[63] == 'b1) )
                            begin
                                branch_flag_o <= 1'b1;
                                branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                                stallreg_id  <= 2'b01;
                            end
                        else if( (reg1_data_o[63] == 1'b0) && (reg2_data_o[63] == 1'b0) )
                            if(reg1_data_o >= reg2_data_o) begin
                                branch_flag_o <= 1'b1;
                                branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                                stallreg_id  <= 2'b01;
                            end else begin
                                branch_flag_o <= 1'b0;
                                branch_target_address_o <= `ZERO_64;
                            end
                        else if( (reg1_data_o[63] == 1'b1) && (reg2_data_o[63] == 1'b1))
                            if ( ({reg1_data_o[63],~reg1_data_o[62:0]}+1'b1) <= ({reg2_data_o[63],~reg2_data_o[62:0]}+1'b1) ) begin
                                branch_flag_o <= 1'b1;
                                branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                                stallreg_id  <= 2'b01;
                            end else begin
                                branch_flag_o <= 1'b0;
                                branch_target_address_o <= `ZERO_64;
                            end
                        else begin
                            branch_flag_o <= 1'b0;
                            branch_target_address_o <= `ZERO_64;
                        end
                    end
                    3'b111:begin
                        exe_type_o <= `BGEU;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        //reg1       <= reg1_data_i;
                        //reg2       <= reg2_data_i;
                        instvalid  <= `INSTVALID;
                        if(reg1_data_o >= reg2_data_o)begin
                            branch_flag_o <= 1'b1;
                            branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                            stallreg_id <= 2'b01;
                        end else begin
                            branch_flag_o <= 1'b0;
                            branch_target_address_o <= `ZERO_64;
                        end
                    end
                    3'b100:begin
                        exe_type_o <= `BLT;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        //reg1       <= reg1_data_i;
                        //reg2       <= reg2_data_i;
                        instvalid  <= `INSTVALID;
                        if( (reg1_data_o[63] == 1'b1) && (reg2_data_o[63] == 'b0) )
                            begin
                                branch_flag_o <= 1'b1;
                                branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                                stallreg_id  <= 2'b01;
                            end
                        else if( (reg1_data_o[63] == 1'b0) && (reg2_data_o[63] == 1'b0) )
                            if(reg1_data_o < reg2_data_o) begin
                                branch_flag_o <= 1'b1;
                                branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                                stallreg_id  <= 2'b01;
                            end else begin
                                branch_flag_o <= 1'b0;
                                branch_target_address_o <= `ZERO_64;
                            end
                        else if( (reg1_data_o[63] == 1'b1) && (reg2_data_o[63] == 1'b1))
                            if ( ({reg1_data_o[63],~reg1_data_o[62:0]}+1'b1) > ({reg2_data_o[63],~reg2_data_o[62:0]}+1'b1) ) begin
                                branch_flag_o <= 1'b1;
                                branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                                stallreg_id  <= 2'b01;
                            end else begin
                                branch_flag_o <= 1'b0;
                                branch_target_address_o <= `ZERO_64;
                            end
                        else begin
                            branch_flag_o <= 1'b0;
                            branch_target_address_o <= `ZERO_64;
                        end
                    end
                    3'b110:begin
                        exe_type_o <= `BLTU;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        //reg1       <= reg1_data_i;
                        //reg2       <= reg2_data_i;
                        instvalid  <= `INSTVALID;
                        if(reg1_data_o <= reg2_data_o)begin
                            branch_flag_o <= 1'b1;
                            branch_target_address_o <= (id_pc_i + {{51{b_offset[12]}},b_offset});
                            stallreg_id  <= 2'b01;
                        end else begin
                            branch_flag_o <= 1'b0;
                            branch_target_address_o <= `ZERO_64;
                        end
                    end
                    default:begin
                        exe_type_o <= 4'h0;
                        instvalid  <= `INSTINVALID;
                        branch_flag_o <= 1'b0;
                        branch_target_address_o <= `ZERO_64; 
                    end
                    
                endcase
            end
        else if(inst_type_o == `L_TYPE_LOGI)
            begin
                case (func3)
                    3'b000:begin
                        exe_type_o <= `LB;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end 
                    3'b100:begin
                        exe_type_o <= `LBU;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        //reg1       <= reg1_data_i;
                        instvalid  <= `INSTVALID;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end
                    3'b011:begin
                        exe_type_o <= `LD;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        //reg1       <= reg1_data_i;
                        instvalid  <= `INSTVALID;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end
                    3'b001:begin
                        exe_type_o <= `LH;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        //reg1       <= reg1_data_i;
                        instvalid  <= `INSTVALID;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end
                    3'b101:begin
                        exe_type_o <= `LHU;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        //reg1       <= reg1_data_i;
                        instvalid  <= `INSTVALID;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end
                    3'b010:begin
                        exe_type_o <= `LW;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        //reg1       <= reg1_data_i;
                        instvalid  <= `INSTVALID;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end
                    3'b110:begin
                        exe_type_o <= `LWU;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        //reg1       <= reg1_data_i;
                        instvalid  <= `INSTVALID;
                        Imm        <= {{52{l_offset[11]}},l_offset};
                    end
                    //default: 
                endcase
            end
        else if(inst_type_o == `S_TYPE_LOGI)
            begin
                case (func3)
                    3'b000:begin
                        exe_type_o <= `SB;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i + {{52{s_offset[11]}},s_offset};
                        //reg2       <= reg2_data_i;
                    end 
                    3'b011:begin
                        exe_type_o <= `SD;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i + {{52{s_offset[11]}},s_offset};
                        //reg2       <= reg2_data_i;
                    end
                    3'b001:begin
                        exe_type_o <= `SH;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i + {{52{s_offset[11]}},s_offset};
                        //reg2       <= reg2_data_i;
                    end
                    3'b010:begin
                        exe_type_o <= `SW;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_ENABLE;
                        rd_w_ena_o <= `ENA_UNABLE;
                        instvalid  <= `INSTVALID;
                        //reg1       <= reg1_data_i + {{52{s_offset[11]}},s_offset};
                        //reg2       <= reg2_data_i;
                    end
                    //default: 
                endcase
            end
        else if(inst_type_o == `IW_TYPE_LOGI)
            begin
                case (func3)
                    3'b000:begin
                        exe_type_o <= `ADDIW;
                        rs1_r_ena_o<= `ENA_ENABLE;
                        rs2_r_ena_o<= `ENA_UNABLE;
                        rd_w_ena_o <= `ENA_ENABLE;
                        Imm        <= {{52{imm[11]}},imm};
                        instvalid  <= `INSTVALID;
                    end 
                    //default: 
                endcase
            end
        else
            instvalid  <= `INSTINVALID;
    end
//rdata1
always @(*) 
begin
    jump_reg1_relate_load <= 1'b0;
    if(rst == `RSTENABLE)
        reg1_data_o <= `ZERO_64;
    else if( (rs1_r_ena_o == `ENA_ENABLE) && (inst_is_load_i == 1'b1) && (ex_rd_addr_i == rs1_addr_o) && (inst_type_o == `B_TYPE_LOGI) )
        jump_reg1_relate_load <= 1'b1;
    else if( (rs1_r_ena_o == `ENA_ENABLE) && (ex_rd_w_ena_i == `ENA_ENABLE) && (ex_rd_addr_i == rs1_addr_o))
        reg1_data_o <= ex_wdata_i;
    else if( (rs1_r_ena_o == `ENA_ENABLE) && (mem_rd_w_ena_i == `ENA_ENABLE) && (mem_rd_addr_i == rs1_addr_o))
        reg1_data_o <= mem_wdata_i;
    else if(rs1_r_ena_o == `ENA_ENABLE)
        reg1_data_o <= reg1_data_i;
    else
        reg1_data_o <= `ZERO_64;
end
//rdata2
always @(*) 
begin
    jump_reg2_relate_load <= 1'b0;
    if(rst == `RSTENABLE)
        reg2_data_o <= `ZERO_64;
    else if( (rs2_r_ena_o == `ENA_ENABLE) && (inst_is_load_i == 1'b1) && (ex_rd_addr_i == rs2_addr_o) && (inst_type_o == `B_TYPE_LOGI)  )
        jump_reg2_relate_load <= 1'b1;
    else if( (rs2_r_ena_o == `ENA_ENABLE) && (ex_rd_w_ena_i == `ENA_ENABLE) && (ex_rd_addr_i == rs2_addr_o))
        reg2_data_o <= ex_wdata_i;
    else if( (rs2_r_ena_o == `ENA_ENABLE) && (mem_rd_w_ena_i == `ENA_ENABLE) && (mem_rd_addr_i == rs2_addr_o))
        reg2_data_o <= mem_wdata_i;
    else if(rs2_r_ena_o == `ENA_ENABLE)
        reg2_data_o <= reg2_data_i;
    else if(rs2_r_ena_o == `ENA_UNABLE)
        reg2_data_o <= Imm;
    else
        reg2_data_o <= `ZERO_64;
end
    
endmodule