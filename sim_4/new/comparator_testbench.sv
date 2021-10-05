`timescale 1ns / 1ps

module comparator_testbench();

    reg [15:0] a;
    reg [15:0] b;
    reg signed_Not_unsigned;
    wire g, l, e;
    
    comparator_n_bit #(16) comp(
        .a(a),
        .b(b),
        .sign_n_unsign(signed_Not_unsigned),
        .g(g),
        .l(l),
        .e(e)
    );
    
    initial 
    begin
        a = 16'b0;
        b=16'b0;
        signed_Not_unsigned=1'b0;
    end
    
    always #1 a = a+1;
    always #2 b = b+1;
    always #64 signed_Not_unsigned = ~ signed_Not_unsigned;
    
endmodule
