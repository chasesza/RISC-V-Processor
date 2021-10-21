`timescale 1ns / 1ps

module cpu_to_mem_tb();

    reg clk;
    reg n_rst;
    reg [3:0] btn;
    reg [3:0] sw;
    
    wire [3:0] led;
    
    
    cpu_to_mem #(32,5,15) cpu_to_mem_test(
        .clk(clk),
        .n_rst(n_rst),
        .sw(sw),
        .btn(btn),
        .led(led)
    );
    
    initial 
    begin
        clk = 1'b0;
        n_rst = 1'b1;
        btn = 4'b0;
        sw = 4'b0;
                
         #2;
        n_rst = 1'b0;
        
         #2;
        n_rst = 1'b1;
        
    end
    
    always #1 clk = ~ clk;
    
endmodule
