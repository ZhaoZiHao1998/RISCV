`include "define.v"
module div (
    input wire clk,
    input wire rst,

    input wire signed_div_i, //sign or unsign   div or divu
    input wire [63:0]opdata1_i,
    input wire [63:0]opdata2_i,

    input wire start_i,
    input wire annul_i,

    output reg [127:0]result_o, //div result
    output reg ready_o   //end?
);
    wire [64:0] div_temp;
    reg  [6:0]  cnt; //div count
    reg  [128:0]dividend;  //{subed number + dived number}
    reg  [1:0]  state;
    reg  [63:0] divisor; //{div number}
    reg  [63:0] temp_op1;
    reg  [63:0] temp_op2;

    assign div_temp = {1'b0,dividend[127:64]} - {1'b0,divisor};
    always @(*) begin
        if(start_i == `DIVSTART && annul_i == 1'b0)begin
            //2' code
            if(signed_div_i == 1'b1 && opdata1_i[63] == 1'b1)
                temp_op1 <= ~opdata1_i + 1;
            else
                temp_op1 <= opdata1_i;
            if(signed_div_i == 1'b1 && opdata2_i[63] == 1'b1)
                temp_op2 <= ~opdata2_i + 1;
                else
            temp_op2 <= opdata2_i;
        end
    end
    always @(posedge clk ) 
    begin
        if(rst == `RSTENABLE)
            begin
                state   <= `DIVFREE;
                ready_o <= `DIVRESULTNOTREADY;
                result_o<= {`ZERO_64,`ZERO_64};
            end
        else
            begin
                case (state)
                    `DIVFREE:begin
                        if(start_i == `DIVSTART && annul_i == 1'b0)begin
                            if(opdata2_i == `ZERO_64)
                                state <= `DIVBYZERO;
                            else begin
                                state <= `DIVON;
                                cnt   <= 7'h0;
                                
                                
                                dividend       <= 129'h0;
                                dividend[64:1] <= temp_op1;
                                divisor        <= temp_op2;
                            end
                        end else begin
                            ready_o <= `DIVRESULTNOTREADY;
                            result_o<= {`ZERO_64,`ZERO_64};
                        end
                    end 

                    `DIVBYZERO: begin
                        dividend <= ~{129'h0};
                        state    <= `DIVEND;
                    end

                    `DIVON: begin
                        if(annul_i == 1'b0) begin
                            if(cnt != 7'b1000000)begin
                                if(div_temp[63] == 1'b1)begin
                                    dividend <= {dividend[127:0],1'b0};
                                end else begin
                                    dividend <= {div_temp[63:0],dividend[63:0],1'b1};
                                end
                                cnt <= cnt + 1;
                            end else begin
                                if( (signed_div_i == 1'b1) && ( (opdata1_i[63]^opdata2_i[63]) == 1'b1 ) )
                                    dividend[63:0] <= ~dividend[63:0] + 1;
                                if( (signed_div_i == 1'b1) && ( (opdata1_i[63]^dividend[128]) == 1'b1 ) )
                                    dividend[128:65] <= ~dividend[128:65] + 1;
                                
                                state <= `DIVEND;
                                cnt   <= 7'h0;
                            end
                            
                        end else begin
                            state <= `DIVFREE;
                        end
                    end

                    `DIVEND: begin
                        result_o <= {dividend[128:65],dividend[63:0]};
                        ready_o  <= `DIVRESULTREADY;
                        if(start_i == `DIVSTOP)begin
                            state   <= `DIVFREE;
                            ready_o <= `DIVRESULTNOTREADY;
                            result_o<= {`ZERO_64,`ZERO_64};
                        end
                    end
                endcase
            end
    end
endmodule