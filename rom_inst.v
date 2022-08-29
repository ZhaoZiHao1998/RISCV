`include "define.v"

module rom_inst (
    input wire ce,
    input wire [`REGBUS]inst_addr,

    // inst + pc addr
    output wire [`REGBUS]inst_pc
);
    reg [`INSTBUS] addr;
    reg [`INSTBUS] inst;
    reg [`INSTBUS] inst_mem [0:`INSTMEMNUM-1];
    //initial instreg from inst_rom.data
    initial $readmemh("./data/addi.data",inst_mem);

    always @(*)
    begin
    if(ce == `INST_ENA_DOWN)
        inst <= `ZERO_32;
    else
        inst <= inst_mem[inst_addr[`INSTMEMNUMLOG2+1:2]];    
    end

    always @(*) begin
        if(ce == `INST_ENA_DOWN)
            addr <= `ZERO_32;
        else
            addr <= inst_addr[31:0];
    end

    assign inst_pc = {addr,inst};

endmodule