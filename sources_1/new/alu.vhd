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
    Port ( a : in STD_LOGIC_VECTOR (0 downto 0);
           b : in STD_LOGIC_VECTOR (0 downto 0);
           arith : in STD_LOGIC;
           add_n_sub : in STD_LOGIC;
           adder : out STD_LOGIC_VECTOR (0 downto 0);
           s_r : out STD_LOGIC_VECTOR (0 downto 0);
           s_l : out STD_LOGIC_VECTOR (0 downto 0);
           e : out STD_LOGIC;
           g : out STD_LOGIC;
           l : out STD_LOGIC;
           and : out STD_LOGIC_VECTOR (0 downto 0);
           or : out STD_LOGIC_VECTOR (0 downto 0);
           xor : out STD_LOGIC_VECTOR (0 downto 0));
end alu;

architecture RTL of alu is

begin


end RTL;
