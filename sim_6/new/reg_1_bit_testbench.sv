`timescale 1ns / 1ps

module reg_1_bit_testbench();

    reg d;
    reg en;
    reg n_rst;
    reg clk;
    wire q;
    
    reg_1_bit reg1(
        .d(d),
        .en(en),
        .n_rst(n_rst),
        .clk(clk),
        .q(q)
    );
    
    initial 
    begin
        clk = 1'b0;
        d = 1'b0;
        n_rst = 1'b1;
        en = 1'b0;
    end
    
    always #1 clk = ~ clk;
    always #2 if (n_rst) begin n_rst = ~n_rst; end 
endmodule
