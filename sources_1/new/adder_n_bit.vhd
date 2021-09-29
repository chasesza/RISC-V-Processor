----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2021 08:59:46 PM
-- Design Name: 
-- Module Name: adder_n_bit - RTL
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

entity adder_n_bit is
    Generic (n: integer := 32);
    Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
           b : in STD_LOGIC_VECTOR (n-1 downto 0);
           add_one : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (n-1 downto 0));
end adder_n_bit;

architecture RTL of adder_n_bit is

    signal c : STD_LOGIC_VECTOR (n-1 downto 0);
    
    component full_adder_1_bit is
            Port(
                a, b, cin: in STD_LOGIC;
                q, cout: out STD_LOGIC
            );
        end component;
    
begin
    
    fa0: full_adder_1_bit 
    PORT MAP(
        a => a(0),
        b => b(0),
        cin => add_one,
        q => q(0),
        cout => c(0));
    
    gen_fa:
        for i in 1 to n-1 generate
            fa: full_adder_1_bit
            PORT MAP(
                a=>a(i),
                b=>b(i),
                cin=>c(i-1),
                q=>q(i),
                cout=>c(i));
            
        end generate gen_fa;

end RTL;
