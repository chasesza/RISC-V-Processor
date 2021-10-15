----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2021 10:09:07 AM
-- Design Name: 
-- Module Name: decoder - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( i : in STD_LOGIC_VECTOR (31 downto 0);
           pc : in STD_LOGIC_VECTOR (31 downto 0);
           r1 : in STD_LOGIC_VECTOR (31 downto 0);
           r2 : in STD_LOGIC_VECTOR (31 downto 0);
           a : out STD_LOGIC_VECTOR (31 downto 0);
           b : out STD_LOGIC_VECTOR (31 downto 0);
           x_pc : out STD_LOGIC_VECTOR (31 downto 0); --pc input x
           y_pc : out STD_LOGIC_VECTOR (31 downto 0); --alternate pc input y (default is 4)
           fadd : out STD_LOGIC;
           sub_bit : out STD_LOGIC;
           fsr : out STD_LOGIC;
           arith_bit : out STD_LOGIC;
           fsl : out STD_LOGIC;
           be : out STD_LOGIC;
           bne : out STD_LOGIC;
           bl : out STD_LOGIC;
           bg : out STD_LOGIC;
           fl : out STD_LOGIC;
           comp_signed: out STD_LOGIC;
           fand : out STD_LOGIC;
           f_or : out STD_LOGIC;
           fxor : out STD_LOGIC;
           rd : out STD_LOGIC_VECTOR(4 downto 0);
           load_dest : out STD_LOGIC_VECTOR(4 downto 0);
           jal_or_jalr : out STD_LOGIC
        );
end decoder;

architecture RTL of decoder is

    signal a_rs : STD_LOGIC;
    signal a_pc : STD_LOGIC;
    
    signal b_rs : STD_LOGIC;
    signal imm_i : STD_LOGIC;
    signal imm_s : STD_LOGIC;
    signal imm_b : STD_LOGIC;
    signal imm_u : STD_LOGIC;
    signal imm_j : STD_LOGIC;
    signal jal  : STD_LOGIC;


    signal comp_b : STD_LOGIC;
    signal comp_ir : STD_LOGIC;

    signal jalr : STD_LOGIC;
begin
    
    --ALU input a
    a_rs <= NOT i(2);
    a_pc <= i(2) AND (NOT ((NOT i(6)) AND i(5)));

    gen_alu_a: 
    for j in 0 to 31 generate
        a(j) <= (a_rs AND r1(j)) OR (a_pc AND pc(j));
    end generate; 

    --ALU input b
    b_rs <= i(5) AND (NOT i(2)) AND (i(6) OR i(4));
    imm_i <= (NOT b_rs) AND (NOT i(6)) AND (NOT i(5)); --all I-type except for JALR
    imm_s <= (NOT b_rs) AND (NOT i(6)) AND i(5) AND (NOT i(4));
    imm_b <= i(6) AND i(5) AND (NOT i(2));
    imm_u <= (NOT b_rs) AND i(4) AND (NOT i(3)) AND i(2);
    imm_j <= (NOT b_rs) AND i(2) AND i(5) AND i(3);
    jal <= i(3) AND i(2);

    gen_alu_b_31_12:
    for j in 31 downto 12 generate
        b(j) <= (b_rs AND r2(j)) OR (i(j) AND imm_u) OR (i(31) AND (imm_i OR imm_s));
    end generate;

    gen_alu_b_11_5:
    for j in 11 downto 5 generate
        b(j) <= (b_rs AND r2(j)) OR (i(j+20) AND (imm_i OR imm_s));
    end generate;
    
    b(4) <= (b_rs AND r2(4)) OR (i(4+20) AND imm_i) OR (i(4+7) AND imm_s);

    b(3) <= (b_rs AND r2(3)) OR (i(3+20) AND imm_i) OR (i(3+7) AND imm_s) OR (i(6) AND i(2));
                                                                        --for pc+4 in jal/jalr

    gen_alu_b_2_0:
    for j in 2 downto 0 generate
        b(j) <= (b_rs AND r2(j)) OR (i(j+20) AND imm_i) OR (i(j+7) AND imm_s);
    end generate;

    --ALU function
    fadd <= i(2) OR (i(4) AND (NOT i(14)) AND (NOT i(13)) AND (NOT i(12))) OR ((NOT i(6)) AND (NOT i(4)));
      --LUI/AUIPC/JAL(R)   --ADD(I)/SUB                                            --Load/Store
    sub_bit <= b_rs AND i(30);
    fsr <= i(4) AND (NOT i(2)) AND i(14) AND (NOT i(13)) AND i(12); --shift right
    arith_bit <= i(30); --arithmetic shift
    fsl <= i(4) AND (NOT i(2)) AND (NOT i(14)) AND (NOT i(13)) AND i(12); --shift left
    comp_b <= i(6) AND i(5) AND (NOT i(2)); --comparator branch instructions
    comp_ir <= i(4) AND (NOT i(2)) AND (NOT i(14)) AND i(13); --comparator register and immediate instructions - (only less than)
    fl <= comp_ir;
    be <= comp_b AND (NOT i(14)) AND (NOT i(12)); --equal
    bne <= comp_b AND (NOT i(14)) AND i(12); --not equal
    bg <= comp_b AND i(14) AND i(12); --greater than or equal to
    bl <= comp_b AND i(14) AND (NOT i(12));
    comp_signed <= NOT ((comp_b AND i(13)) OR (comp_ir AND i(12))); --signed greater than/less than comparison
    fand <= i(4) AND (NOT i(2)) AND i(14) AND i(13) AND i(12); --and
    f_or <= i(4) AND (NOT i(2)) AND i(14) AND i(13) AND (NOT i(12)); --or
    fxor <= i(4) AND (NOT i(2)) AND i(14) AND (NOT i(13)) AND (NOT i(12)); --xor

    --PC adder inputs
    jalr <= (NOT i(4)) AND (NOT i(3)) AND i(2);
    gen_pc_x:
    for j in 31 downto 0 generate
        x_pc(j) <= (jalr AND r1(j)) OR ((NOT jalr) and pc(j));
    end generate;

    gen_pc_y_31_20:
    for j in 31 downto 20 generate
        y_pc(j) <= i(31) AND (jalr OR imm_b OR imm_j);
    end generate;

    gen_pc_y_19_12:
    for j in 19 downto 12 generate
        y_pc(j) <= (i(31) AND (jalr OR imm_b)) OR (imm_j AND i(j));
    end generate;

    y_pc(11) <= (i(31) AND jalr) OR (imm_b AND i(7)) OR (imm_j AND i(20));
    
    gen_pc_y_10_5:
    for j in 10 downto 5 generate
        y_pc(j) <= (imm_j OR jalr OR imm_b) AND i(j+20);
    end generate;
    
    gen_pc_y_4_1:
    for j in 4 downto 1 generate
        y_pc(j) <= ((imm_j OR jalr) AND i(j+20)) OR (imm_b AND i(j+7));
    end generate;
    
    y_pc(0) <= jalr AND i(20);

    jal_or_jalr <= jal OR jalr;

    gen_rd:
    for j in 4 downto 0 generate
        rd(j) <= i(j+7) AND ((NOT i(5)) OR i(4) OR i(3) OR i(2)) AND (i(5) OR i(4));
        load_dest(j) <= i(j+7) AND ((NOT i(5)) OR i(4) OR i(3) OR i(2)) AND (NOT (i(5) OR i(4)));
    end generate;

end RTL;
