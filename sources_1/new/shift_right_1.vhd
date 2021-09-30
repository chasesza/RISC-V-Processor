----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/29/2021 10:00:38 PM
-- Design Name: 
-- Module Name: shift_right_n - RTL
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

entity shift_right_amt is
    Generic(n : integer :=32;
            amt : integer := 1);
    Port ( d : in STD_LOGIC_VECTOR (n-1 downto 0);
           arith : in STD_LOGIC;
           sft : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (n-1 downto 0));
end shift_right_amt;

architecture RTL of shift_right_amt is

    component mux_2_1 is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           sel : in STD_LOGIC;
           q : out STD_LOGIC);
    end component;

    signal arith_bit : STD_LOGIC;

begin
    
    gen_shift: for i in 0 to n-1-amt generate
           m0: mux_2_1 Port Map(
               a => d(i+amt),
               b => d(i),
               sel => sft,
               q => z(i)
           );
   end generate gen_shift;
    
   gen_drop: for i in n-amt to n-1 generate
       m0: mux_2_1 Port Map(
           a => arith,
           b => d(i),
           sel => sft,
           q => z(i)
       );
   end generate gen_drop;

end RTL;
