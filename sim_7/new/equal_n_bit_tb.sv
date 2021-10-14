`timescale 1ns / 1ps

module equal_n_bit_tb();

    reg [4:0] a;
    reg [4:0] b;
    wire q;
    
    equal_n_bit #(5) eq_n(
        .a(a),
        .b(b),
        .q(q)
    );
    
    initial 
    begin
        a = 5'b0;
        b = 5'b0;
    end
    
    always #1 a = a + 1;
    always #2 b = b+2;
endmodule
