----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2021 09:01:16 PM
-- Design Name: 
-- Module Name: shift_left_amt - RTL
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

entity shift_left_amt is
    Generic(n : integer :=32;
            amt : integer := 1);
    Port ( d : in STD_LOGIC_VECTOR (n-1 downto 0);
           sft : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (n-1 downto 0));
end shift_left_amt;

architecture RTL of shift_left_amt is

    component mux_2_1 is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           sel : in STD_LOGIC;
           q : out STD_LOGIC);
    end component;

begin

    gen_shift: for i in amt to n-1 generate
           m0: mux_2_1 Port Map(
               a => d(i-amt),
               b => d(i),
               sel => sft,
               q => z(i)
           );
   end generate gen_shift;
    
   gen_drop: for i in 0 to amt-1 generate
       z(i) <= d(i) AND (NOT sft);
   end generate gen_drop;

end RTL;
