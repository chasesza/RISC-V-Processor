`timescale 1ns / 1ps

module cpu_testbench();

    reg[31:0] inst;
    reg clk;
    reg n_rst;
    
    wire [31:0] pc;
    wire [31:0] d;
    wire [31:0] address;
    wire read_n_write;
    
    
    cpu #(32, 5) cpu_tst(
        .clk(clk),
       .n_rst(n_rst),
       .inst(inst),
       .pc(pc),
       .d(d),
       .address(address),
       .read_n_write(read_n_write)
    );
    
    initial 
    begin
        clk = 1'b0;
        n_rst = 1'b1;
        
        inst = 32'b0;
        
         #2;
        n_rst = 1'b0;
        
         #2;
        n_rst = 1'b1;
        
        
         #2;
         inst = 32'b00000000000000001111111110110111;
        
         #2; 
         inst = 32'b01111111111111111000111100010011;
         
         #2;
         inst = 32'b10101011111111111010010100100011;
         
         #2;
         inst = 32'b00000001000000000000000011101111;
        
    end
    
    always #1 clk = ~ clk;
    
endmodule
