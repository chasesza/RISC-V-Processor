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
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           fadd : in STD_LOGIC;
           sub_bit : in STD_LOGIC;
           fsr : in STD_LOGIC;
           arith_bit : in STD_LOGIC;
           fsl : in STD_LOGIC;
           fl : in STD_LOGIC;
           comp_signed: in STD_LOGIC;
           fand : in STD_LOGIC;
           f_or : in STD_LOGIC;
           fxor : in STD_LOGIC;
           g : out STD_LOGIC;
           l : out STD_LOGIC;
           e : out STD_LOGIC;
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
    --Not setup yet
    add_sub: adder_n_bit
        Generic map(n=>n)
        Port Map(
            a => a,
            b => b,
            sub => sub_bit,
            q => adder_out
        );

    and_op: and_bus
        Generic map(n => n)
        Port Map( 
            a => a,
            b => b,
            q => and_out
        );

    or_op: or_bus
    Generic map(n => n)
    Port Map( 
        a => a,
        b => b,
        q => or_out
    );

    xor_op: xor_bus
    Generic map(n => n)
    Port Map( 
        a => a,
        b => b,
        q => xor_out
    );

    bsr: barrel_shift_right
    Generic map(
        n => n,
        shift_n => shift_n)
    Port Map( 
        d => a,
        sft => b(shift_n-1 downto 0),
        arith => arith_bit,
        z => sr_out
    );

    bsl: barrel_shift_left
    Generic map(
        n => n,
        shift_n => shift_n)
    Port Map( 
        d => a,
        sft => b(shift_n-1 downto 0),
        z => sl_out
    );

    comp: comparator_n_bit is
    Generic Map (n => n)
    Port Map ( 
        a => a,
        b => b,
        sign_n_unsign => comp_signed,
        g => comp_g,
        e => comp_e,
        l => comp_l
    );

    gen_alu_out:
    for i in n-1 to 1 generate
        q(i) = (fadd AND adder_out(i)) OR (fsr AND sr_out(i)) OR (fsl AND sl_out(i)) OR (fand AND and_out(i)) OR (f_or AND or_out(i)) OR (fxor AND xor_out(i));
    end generate;
    q(0) = (fadd AND adder_out(0)) OR (fsr AND sr_out(0)) OR (fsl AND sl_out(0)) OR (fand AND and_out(0)) OR (f_or AND or_out(0)) OR (fxor AND xor_out(0)) OR (fl AND comp_l);

    g <= comp_g;
    l <= comp_l;
    e <= comp_e;

end RTL;
