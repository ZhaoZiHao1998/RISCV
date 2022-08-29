`include "define.v"
`define TEST_PROG 1

module openriscv_rom_sopc_tb;
    reg clk;
    reg rst;

    always  #10 clk = ~clk;
    wire [`REGBUS]x3 = openriscv_rom_sopc0.openriscv0.regfile0.regs[3];
    wire [`REGBUS]x26= openriscv_rom_sopc0.openriscv0.regfile0.regs[26];
    wire [`REGBUS]x27= openriscv_rom_sopc0.openriscv0.regfile0.regs[27];

    integer r;
    initial begin
        clk = 0;
        rst = `RSTENABLE;

        $display("test running...");
        #40
        rst = `RSTUNABLE;
        #200
`ifdef TEST_PROG
        wait(x26 == 64'h1)
        #100
        if (x27 == 64'b1) begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
            $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
            $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        end else begin
            $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
            $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
            $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
            $display("fail testnum = %2d", x3);
            for (r = 0; r < 32; r = r + 1)
                $display("x%2d = 0x%x", r, openriscv_rom_sopc0.openriscv0.regfile0.regs[r]);
        end
`endif
        $finish;
    end
    initial begin
        #50000000
        $display("Time Out.");
        $finish;
    end

/*
    initial 
    begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    initial 
    begin
        rst = 1'b1;
        #195 rst = 1'b0;
        #10000000 $stop;
    end
*/
    openriscv_rom_sopc openriscv_rom_sopc0(
        .clk(clk),
        .rst(rst)
    );

endmodule