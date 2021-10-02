----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2021 09:16:00 PM
-- Design Name: 
-- Module Name: barrel_shift_left - RTL
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

entity barrel_shift_left is
    Generic(n: integer := 32;
            shift_n : integer := 5);
    Port ( d : in STD_LOGIC_VECTOR (n-1 downto 0);
           sft : in STD_LOGIC_VECTOR (shift_n-1 downto 0);
           z : out STD_LOGIC_VECTOR (n-1 downto 0));
end barrel_shift_left;

architecture RTL of barrel_shift_left is 

    type bus_array is array(shift_n - 2 downto 0) of STD_LOGIC_VECTOR(n-1 downto 0);
    signal shift_busses : bus_array;
    
    component shift_left_amt is
        Generic(n : integer :=32;
                amt : integer := 1);
        Port ( d : in STD_LOGIC_VECTOR (n-1 downto 0);
               sft : in STD_LOGIC;
               z : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;
    
begin

    sft_first: shift_left_amt
    Generic map(n=>n, amt=>1)
    Port map(
        d => d,
        sft => sft(0),
        z => shift_busses(0)
    );

    gen_barrel: 
        for i in 1 to shift_n - 2 generate
            sft_amt: shift_left_amt
            Generic map(n => n, amt => 2**i)
            Port map(
                d => shift_busses(i-1),
                sft => sft(i),
                z => shift_busses(i)
                );
    end generate gen_barrel;
    
    last: if shift_n > 1 generate
        sft_last: shift_left_amt
        Generic map(n=>n, amt=>2**(shift_n-1))
        Port map(
            d => shift_busses(shift_n-2),
            sft => sft(shift_n-1),
            z => z
        );
    end generate last;

end RTL;
