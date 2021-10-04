----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2021 10:30:28 AM
-- Design Name: 
-- Module Name: comparator_1_bit - RTL
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

entity comparator_1_bit is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           g : out STD_LOGIC;
           e : out STD_LOGIC;
           l : out STD_LOGIC);
end comparator_1_bit;

architecture RTL of comparator_1_bit is

begin

     g <= a AND NOT b;
     l <= NOT a AND b;
     e <= NOT a AND NOT b OR a AND b;

end RTL;
