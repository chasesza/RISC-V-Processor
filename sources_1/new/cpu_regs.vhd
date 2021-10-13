library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_regs is
    Generic (n : integer := 32);
    Port(
        r1 : in STD_LOGIC_VECTOR(n-1 downto 0);
        r2 : in STD_LOGIC_VECTOR(n-1 downto 0);
        rd : in STD_LOGIC_VECTOR(n-1 downto 0);
        d : in STD_LOGIC_VECTOR(n-1 downto 0);
        clk : in STD_LOGIC;
        q1 : out STD_LOGIC_VECTOR(n-1 downto 0);
        q2 : out STD_LOGIC_VECTOR(n-1 downto 0)
    );
end cpu_regs;

architecture RTL of cpu_regs is

    component reg_n_bit is
        Generic (n : integer := 32);
        Port(
            d : in STD_LOGIC_VECTOR(n-1 downto 0);
            en : in STD_LOGIC;
            clk : in STD_LOGIC;
            q : out STD_LOGIC_VECTOR(n-1 downto 0)
        );
    end component;

    type array_of_std_logic_vec is array(n-1 downto 0) of STD_LOGIC_VECTOR(n-1 downto 0);
    signal q_arr : array_of_std_logic_vec;

    signal en_vec : STD_LOGIC_VECTOR (n-1 downto 0);
    signal s1_vec : STD_LOGIC_VECTOR (n-1 downto 0);
    signal s2_vec : STD_LOGIC_VECTOR (n-1 downto 0);

begin

    gen_en_vec:
    for i in n-1 to 1 generate 
        gen_eq:
        equal_n_bit Port Map (
            a => rd,
            b => STD_LOGIC_VECTOR(to_unsigned(i,n)),
            q => en_vec(i)
        );
    end generate;

    gen_s1_vec:
    for i in n-1 to 1 generate 
        gen_eq:
        equal_n_bit Port Map (
            a => r1,
            b => STD_LOGIC_VECTOR(to_unsigned(i,n)),
            q => en_vec(i)
        );
    end generate;

    gen_s2_vec:
    for i in n-1 to 1 generate 
        gen_eq:
        equal_n_bit Port Map (
            a => r2,
            b => STD_LOGIC_VECTOR(to_unsigned(i,n)),
            q => en_vec(i)
        );
    end generate;

    gen_n_bit_regs:
    for i in n-1 to 1 generate
        gen_reg_n_bit:
        reg_n_bit Port Map (
            d => d,
            en => en_vec(i),
            clk => clk,
            q => q_arr(i)
        );
    end generate;

    --need one more loop to generate outputs

end RTL;