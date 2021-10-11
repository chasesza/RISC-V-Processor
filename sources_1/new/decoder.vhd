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
           a : out STD_LOGIC_VECTOR (31 downto 0);
           b : out STD_LOGIC_VECTOR (31 downto 0);
           x_pc : out STD_LOGIC_VECTOR (31 downto 0);
           y_pc : out STD_LOGIC_VECTOR (31 downto 0);
           fadd : out STD_LOGIC;
           fsub : out STD_LOGIC;
           fsr : out STD_LOGIC;
           fsrarith : out STD_LOGIC;
           fsl : out STD_LOGIC;
           fe : out STD_LOGIC;
           fne : out STD_LOGIC;
           fg : out STD_LOGIC;
           fl : out STD_LOGIC;
           fand : out STD_LOGIC;
           f_or : out STD_LOGIC;
           fxor : out STD_LOGIC);
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

begin
    
    a_rs <= NOT i(2);
    a_pc <= i(2) AND (NOT ((NOT i(6)) AND i(5)));
    
    b_rs <= i(5) AND (NOT i(2)) AND (i(6) OR i(4));
    imm_i <= (NOT b_rs) AND (NOT i(6)) AND (NOT i(5));
    imm_s <= (NOT b_rs) AND (NOT i(6)) AND i(5) AND (NOT i(4));
    imm_b <= i(6) AND i(5) AND (NOT i(2));
    imm_u <= (NOT b_rs) AND i(4) AND (NOT i(3)) AND i(2);
    imm_j <= (NOT b_rs) AND i(2) AND i(5) AND i(3);
    jal <= (NOT b_rs) AND i(3) AND i(2);
    

end RTL;
