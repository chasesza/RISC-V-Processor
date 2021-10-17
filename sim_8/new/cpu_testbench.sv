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
        
        
        //lui x31, 0xF
         #2;
         inst = 32'b00000000000000001111111110110111;
        
        //addi x30, x31, 0x7FF
         #2; 
         inst = 32'b01111111111111111000111100010011;
         
         //add x29, x30, x31
         #2
         inst = 32'b00000001111111110000111010110011;
         
         //sw x31, x30, 0xABFF
         #2;
         inst = 32'b00000001111011111010000010100011;
         
         #2;
         inst = 32'b00000001000000000000000011101111;
        
    end
    
    always #1 clk = ~ clk;
    
endmodule
