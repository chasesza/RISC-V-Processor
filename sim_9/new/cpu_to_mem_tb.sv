`timescale 1ns / 1ps

module cpu_to_mem_tb();

    reg clk;
    reg n_rst;
    reg [3:0] btn;
    reg [3:0] sw;
    
    wire [3:0] led;
    
    reg clka;
    reg [11:0] addra;
    wire [31:0] douta; 
    
    cpu_to_mem #(32,5,15) cpu_to_mem_test(
        .clk(clk),
        .n_rst(n_rst),
        .sw(sw),
        .btn(btn),
        .led(led)
    );
    
        blk_mem_gen_pgm_mem standalone_pmem (
      .clka(clka),    // input wire clka
      .addra(addra),  // input wire [11 : 0] addra
      .douta(douta)  // output wire [31 : 0] douta
    );
    
    initial 
    begin
        clk = 1'b0;
        clka = 1'b0;
        n_rst = 1'b1;
        btn = 4'b0;
        sw = 4'b0;
        addra = 12'b0;
                
         #2;
        n_rst = 1'b0;
        
         #102;
        n_rst = 1'b1;
        
        #10;
        btn = 4'b1010;
        sw = 4'b0101;
        
        #11;
        btn = 4'b1111;
        sw = 4'b0000;
        
    end
    
    always #1 clk = ~ clk;
    always #1 clka = ~clka;
    always #2 addra = addra + 1;
    
endmodule
