`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2021 09:26:30 PM
// Design Name: 
// Module Name: adder_32_bit_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_32_bit_testbench();

    reg [63:0] a;
    reg [63:0] b;
    reg [63:0] q;
    reg sub;
    
    adder_n_bit #(64) add_32(
        .a(a),
        .b(b),
        .sub(sub),
        .q(q)
    );
    
    initial 
    begin
        a = 64'b0;
        b=64'b0;
        sub = 1'b0;
    end
    
    always #1 a = a+1;
    always #2 b = b+1;
    always #10 sub = ~sub;
    
endmodule
