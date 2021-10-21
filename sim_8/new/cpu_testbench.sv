`timescale 1ns / 1ps

module cpu_testbench();

    reg[31:0] inst;
    reg clk;
    reg n_rst;
    reg stall;
    
    wire [31:0] pc;
    wire [31:0] d;
    wire [31:0] address;
    wire store;
    wire load;
    
    cpu #(32, 5) cpu_tst(
        .clk(clk),
       .n_rst(n_rst),
       .inst(inst),
       .stall(stall),
       .pc(pc),
       .d(d),
       .address(address),
       .store(store),
       .load(load)
    );
    
    
    initial 
    begin
        clk = 1'b0;
        n_rst = 1'b1;
        stall = 1'b0;
        
        inst = 32'b0;
        
         #2;
        n_rst = 1'b0;
        
         #2;
        n_rst = 1'b1;
        
    end
    
    always #1 clk = ~ clk;
    
    
endmodule
