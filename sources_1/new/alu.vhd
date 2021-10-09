----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/06/2021 10:00:55 PM
-- Design Name: 
-- Module Name: alu - RTL
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

entity alu is
    Generic(n: integer := 32;
            shift_n : integer := 5);
    Port ( r1 : in STD_LOGIC_VECTOR (n-1 downto 0);
           r2 : in STD_LOGIC_VECTOR (n-1 downto 0);
           pc : in STD_LOGIC_VECTOR (n-1 downto 0);
           i : in STD_LOGIC_VECTOR (n-1 downto 0); --instruction
           q : out STD_LOGIC_VECTOR (n-1 downto 0));
end alu;

architecture RTL of alu is

    signal a : STD_LOGIC_VECTOR (n-1 downto 0);
    signal b : STD_LOGIC_VECTOR (n-1 downto 0);

    signal b_eq_rs2: STD_LOGIC;

    component adder_n_bit is
        Generic (n: integer := 32);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               sub : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal adder_out : STD_LOGIC_VECTOR(n-1 downto 0);

    component and_bus is
        Generic (n: integer := 32);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               q : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal and_out : STD_LOGIC_VECTOR(n-1 downto 0);

    component or_bus is
        Generic (n: integer := 32);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               q : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal or_out : STD_LOGIC_VECTOR(n-1 downto 0);

    component xor_bus is
        Generic (n: integer := 32);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               q : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal xor_out : STD_LOGIC_VECTOR(n-1 downto 0);

    component barrel_shift_right is
        Generic(n: integer := 32;
                shift_n : integer := 5);
        Port ( d : in STD_LOGIC_VECTOR (n-1 downto 0);
               sft : in STD_LOGIC_VECTOR (shift_n-1 downto 0);
               arith : in STD_LOGIC;
               z : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal sr_out : STD_LOGIC_VECTOR(n-1 downto 0);

    component barrel_shift_left is
        Generic(n: integer := 32;
                shift_n : integer := 5);
        Port ( d : in STD_LOGIC_VECTOR (n-1 downto 0);
               sft : in STD_LOGIC_VECTOR (shift_n-1 downto 0);
               z : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal sl_out : STD_LOGIC_VECTOR(n-1 downto 0);

    component comparator_n_bit is
        Generic (n: integer := 32);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               sign_n_unsign : in STD_LOGIC;
               g : out STD_LOGIC;
               e : out STD_LOGIC;
               l : out STD_LOGIC);
    end component;
    
    signal comp_g : STD_LOGIC;
    signal comp_e : STD_LOGIC;
    signal comp_l : STD_LOGIC;

begin

    gen_a: 
    for j in 0 to n-1 generate
        a(j) <= (r1(j) AND NOT i(2)) OR (pc(j) AND NOT (NOT i(6) AND i(5)));
                                                -- NOT LUI 
    end generate;


    b_eq_rs2 <= i(5) AND NOT i(2) AND (i(6) OR i(4));

    gen_b_31_21:
    for j in 31 to 20 generate
        b(j) <= (r2(j) AND b_eq_rs2) OR (i(j) AND i(4) AND NOT i(3) AND i(2)) OR i(31) AND NOT b_eq_rs2;
                --r2                                               --LUI AUIPC                           --Sign extend
    end generate; 

    for j in 19 to 12 generate
        b(j) <= (r2(j) AND b_eq_rs2) OR (i(j) AND i(4) AND NOT i(3) AND i(2)) OR i(2) AND i(3) AND i(j) OR i(31) AND NOT b_eq_rs2;
            --r2                                               --LUI AUIPC                                   --JAL                        --Sign extend
    end generate; 

    --Not setup yet
    add_sub: adder_n_bit
        Generic map(n=>n)
        Port Map(
            a => l_not,
            b => l_bus(0),
            sel => invert,
            q => l
        );

end RTL;
