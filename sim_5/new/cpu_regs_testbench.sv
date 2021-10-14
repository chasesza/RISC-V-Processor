`timescale 1ns / 1ps

module cpu_regs_testbench();

    reg [4:0] r1;
    reg [4:0] r2;
    reg [4:0] rd;
    reg [31:0] d;
    reg clk;
    reg n_rst;
    
    wire [31:0] q1;
    wire [31:0] q2;
    
    cpu_regs #(32) rg(
        .r1(r1),
        .r2(r2),
        .rd(rd),
        .d(d),
        .n_rst(n_rst),
        .clk(clk),
        .q1(q1),
         .q2(q2)
    );
    
    initial 
    begin
        clk = 1'b0;
        r1 = 5'b0;
        r2 = 5'b0;
        rd = 5'b0;
        d = 32'b0;
        n_rst = 1'b1;
        
         #2;
        n_rst = 1'b0;
        
         #2;
        n_rst = 1'b1;
        
        d = 32'hAF;
        rd = 5'd7;
        r1 = 5'd7;
        r2 = 5'd7;
        
         #2;
        d = 32'hFF;
        rd = 5'd15;
        r2 = 5'd15;
        
         #2;
        rd = 5'd0;
        
    end
    
    always #1 clk = ~ clk;
    
endmodule
