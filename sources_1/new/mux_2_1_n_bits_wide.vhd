library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--q is a when sel is 1, and b when sel is 0
entity mux_2_1_n_bits_wide is
    Generic (n : integer := 32);
    Port ( a : in STD_LOGIC_VECTOR(n-1 downto 0);
           b : in STD_LOGIC_VECTOR(n-1 downto 0);
           sel : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR(n-1 downto 0));
end mux_2_1_n_bits_wide;

architecture RTL of mux_2_1_n_bits_wide is

    component mux_2_1 is
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               sel : in STD_LOGIC;
               q : out STD_LOGIC);
    end component;
    
begin
    
    gen_2_1_mux_n_bit:
    for i in 0 to n-1 generate
        gen_2_1_mux_1_bit:
        mux_2_1 m0
        Port Map(
            a => a(i),
            b => b(i),
            sel => sel,
            q => q(i)
        );
    end generate;

end RTL;
