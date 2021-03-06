----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/04/2021 10:39:21 AM
-- Design Name: 
-- Module Name: comparator_n_bit - RTL
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

entity comparator_n_bit is
    Generic (n: integer := 32);
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           sign_n_unsign : in STD_LOGIC;
           g : out STD_LOGIC;
           e : out STD_LOGIC;
           l : out STD_LOGIC);
end comparator_n_bit;

architecture RTL of comparator_n_bit is
    
    component mux_2_1 is
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               sel : in STD_LOGIC;
               q : out STD_LOGIC);
    end component;
    
    --Declare busses
    signal g_bus : STD_LOGIC_VECTOR(n-1 downto 0);
    signal e_bus : STD_LOGIC_VECTOR(n-1 downto 0);
    signal l_bus : STD_LOGIC_VECTOR(n-1 downto 0);
    
    signal g_not : STD_LOGIC;
    signal l_not : STD_LOGIC;
    
    --Inversion bit
    signal invert : STD_LOGIC;

begin
    
    --MSB
    g_bus(n-1) <= a(n-1) AND NOT b(n-1);
    l_bus(n-1) <= NOT a(n-1) AND b(n-1);
    e_bus(n-1) <= ((NOT a(n-1)) AND (NOT b(n-1))) OR (a(n-1) AND b(n-1));
    
    invert <= sign_n_unsign AND NOT e_bus(0) AND ( (NOT a(n-1) AND b(n-1)) OR (a(n-1) AND NOT b(n-1)) ) ;
    g_not <= NOT g_bus(0);
    l_not <= NOT l_bus(0);
    
    gen_comp:
    for i in 0 to n-2 generate
        g_bus(i) <= g_bus(i+1) OR ((e_bus(i+1)) AND a(i) AND (NOT b(i)));
        l_bus(i) <= l_bus(i+1) OR ((e_bus(i+1) AND (NOT a(i)) AND b(i)));
        e_bus(i) <= e_bus(i+1) AND ((a(i) AND b(i)) OR ((NOT a(i)) AND (NOT b(i))));
    end generate;

    gen_mux_g: mux_2_1
    Port Map(
        a => g_not,
        b => g_bus(0),
        sel => invert,
        q => g
    );
    
    gen_mux_l: mux_2_1
        Port Map(
            a => l_not,
            b => l_bus(0),
            sel => invert,
            q => l
        );
        
    e <= e_bus(0);

end RTL;
