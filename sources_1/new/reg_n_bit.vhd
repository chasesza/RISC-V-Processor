library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_n_bit is
    Generic (n : integer := 32);
    Port(
        d : in STD_LOGIC_VECTOR(n-1 downto 0);
        en : in STD_LOGIC;
        clk : in STD_LOGIC;
        q : out STD_LOGIC_VECTOR(n-1 downto 0)
    );
end reg_n_bit;

architecture RTL of reg_n_bit is

    component reg_1_bit is
        Port(
            d : in STD_LOGIC;
            en : in STD_LOGIC;
            clk : in STD_LOGIC;
            q : out STD_LOGIC
        );
    end component;

begin

    gen_reg_n_bit:
    for i in n-1 to 0 generate
        gen_reg_1_bit:
        reg_1_bit Port Map (
            d => d(i),
            en => en,
            clk => clk,
            q => q(i)
        );
    end generate;

end RTL;