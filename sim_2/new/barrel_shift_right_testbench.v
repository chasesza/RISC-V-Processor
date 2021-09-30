`timescale 1ns / 1ps

module barrel_shift_right_testbench();

    reg [31:0] d;
    reg [4:0] sft;
    reg  arith;
    wire [31:0] z;
    
    barrel_shift_right #(32, 5) b_s_r_32_5(
        .d(d),
        .sft(sft),
        .arith(arith),
        .z(z)
    );
    
    initial 
    begin
        d = 32'h7AFAFAFA;
        sft=5'h0;
        arith = 1'b0;
    end
    
    always #1 sft = sft+1;
    always #10 arith = ~arith;
    
endmodule
