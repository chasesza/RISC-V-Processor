library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_1_bit is
    Port(
        d : in STD_LOGIC;
        en : in STD_LOGIC;
        clk : in STD_LOGIC;
        n_rst : in STD_LOGIC;
        q : out STD_LOGIC
    );
end reg_1_bit;

architecture RTL of reg_1_bit is

    signal q_int : STD_LOGIC;

begin

    q <= q_int;

    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
                q_int <= n_rst AND ((d AND en) OR (q_int AND (NOT en)));
        end if;
    end process clk_proc;

end RTL;