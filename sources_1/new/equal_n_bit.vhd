----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2021 09:29:28 PM
-- Design Name: 
-- Module Name: equal_n_bit - RTL
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

entity equal_n_bit is
    Generic(n: integer := 5);
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           q : out STD_LOGIC);
end equal_n_bit;

architecture RTL of equal_n_bit is

    signal e : STD_LOGIC_VECTOR (n-1 downto 0);

    component eq_1_bit is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c : in STD_LOGIC;
           q : out STD_LOGIC);
    end component;


begin

    e(0) <= (a(0) AND b(0)) OR ((NOT a(0)) AND (NOT b(0)));
    
    gen_eq:
    for i in 1 to n-1 generate
         eq_bit_i: eq_1_bit Port Map(
           a => a(i),
           b => b(i),
           c => e(i-1),
           q => e(i)
       );
    end generate;
    
    q <= e(n-1);

end RTL;
