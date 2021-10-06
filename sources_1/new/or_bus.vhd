----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2021 11:09:55 PM
-- Design Name: 
-- Module Name: or_bus - RTL
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

entity or_bus is
    Generic (n: integer := 32);
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           q : out STD_LOGIC_VECTOR (n-1 downto 0));
end or_bus;

architecture RTL of or_bus is

begin

    gen_and:
       for i in 0 to n-1 generate
        q(i) <= a(i) OR b(i);
       end generate;


end RTL;
