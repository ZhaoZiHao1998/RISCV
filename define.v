`define ZERO_64   64'h0000_0000_0000_0000
`define ZERO_32   32'h0000_0000
`define INST_ENA_UP   1'b1
`define INST_ENA_DOWN   1'b0
`define RSTENABLE   1'b1
`define RSTUNABLE   1'b0
`define ENA_UNABLE   1'b0
`define ENA_ENABLE   1'b1
`define CHIP_ABLE    1'b1
`define CHIP_DISABLE 1'b0

`define STOP         1'b1
`define NOSTOP       1'b0
//inst_valid
`define INSTVALID 1'b1
`define INSTINVALID 1'b0
//inst_type
`define R_TYPE_LOGI   4'd1
`define I_TYPE_LOGI   4'd2
`define S_TYPE_LOGI   4'd3
`define B_TYPE_LOGI   4'd4
`define U_TYPE_LOGI   4'd5
`define J_TYPE_LOGI   4'd6
`define L_TYPE_LOGI   4'd7
`define IW_TYPE_LOGI   4'd8
`define CSR_TYPE_LOGI 4'd9

//I_TYPE_LOGI type
`define ADDI   5'd1
`define SLTI   5'd2
`define SLTIU  5'd3
`define XORI   5'd4
`define ORI    5'd5
`define ANDI   5'd6
`define SLLI   5'd7
`define SRLI   5'd8
`define SRAI   5'd9
`define JAL    5'd10
`define JALR   5'd11
`define ADDIW  5'd12

//R_TYPE_LOGI type
`define ADD    5'd1
`define MUL    5'd2
`define SUB    5'd3
`define SLL    5'd4
`define MULH   5'd5
`define SLT    5'd6
`define MULHSU 5'd7
`define SLTU   5'd8
`define MULHU  5'd9
`define XOR    5'd10
`define DIV    5'd11
`define SRL    5'd12
`define DIVU   5'd13
`define SRA    5'd14
`define OR     5'd15
`define REM    5'd16
`define AND    5'd17
`define REMU   5'd18
//U_TYPE_LOGI type
`define LUI    5'd1
`define AUIPC  5'd2
//B_TYPE_LOGI type
`define BEQ    5'd1
`define BNE    5'd2
`define BGE    5'd3
`define BGEU   5'd4
`define BLT    5'd5
`define BLTU   5'd6
//L_TYPE_LOGI type
`define LB     5'd1
`define LBU    5'd2
`define LD     5'd3
`define LH     5'd4
`define LHU    5'd5
`define LW     5'd6
`define LWU    5'd7
//S_TYPE_LOGI type
`define SB     5'd1
`define SD     5'd2
`define SH     5'd3
`define SW     5'd4
//csr type logi type
`define CSRRC  4'd1
`define CSRRCI 4'd2
`define CSRRS  4'd3
`define CSRRSI 4'd4
`define CSRRW  4'd5
`define CSRRWI 4'd6
//reg num
`define REGBUS   63:0
`define REGNUM   32
//inst bus
`define INSTBUS         31:0
`define INSTMEMNUM      131071
`define INSTMEMNUMLOG2  17

`define DATAMEMNUM      131071
`define DATAMEMNUMLOG2  17

//div
`define DIVFREE     2'b00
`define DIVBYZERO   2'b01
`define DIVON       2'b10
`define DIVEND      2'b11
`define DIVRESULTREADY 1'b1
`define DIVRESULTNOTREADY 1'b0
`define DIVSTART    1'b1
`define DIVSTOP     1'b0

// CSR reg addr
`define CSR_CYCLE   12'hc00
`define CSR_CYCLEH  12'hc80
`define CSR_MTVEC   12'h305
`define CSR_MCAUSE  12'h342
`define CSR_MEPC    12'h341
`define CSR_MIE     12'h304
`define CSR_MSTATUS 12'h300
`define CSR_MSCRATCH 12'h340