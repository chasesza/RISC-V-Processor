library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_regs is
    Generic (n : integer := 32);
    Port(
        r1 : in STD_LOGIC_VECTOR(4 downto 0);
        r2 : in STD_LOGIC_VECTOR(4 downto 0);
        rd : in STD_LOGIC_VECTOR(4 downto 0);
        d : in STD_LOGIC_VECTOR(n-1 downto 0);
        stall_pipeline : in STD_LOGIC;
        n_rst : in STD_LOGIC;
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
            n_rst : in STD_LOGIC;
            clk : in STD_LOGIC;
            q : out STD_LOGIC_VECTOR(n-1 downto 0)
        );
    end component;
        
   component equal_n_bit is
        Generic(n: integer := 5);
        Port ( 
            a : in STD_LOGIC_VECTOR (n-1 downto 0);
            b : in STD_LOGIC_VECTOR (n-1 downto 0);
            q : out STD_LOGIC
            );
    end component;

    type array_of_std_logic_vec is array(n-1 downto 1) of STD_LOGIC_VECTOR(n-1 downto 0);
    signal q_arr : array_of_std_logic_vec;

    signal en_vec : STD_LOGIC_VECTOR (n-1 downto 1);
    signal en_vec_with_stall : STD_LOGIC_VECTOR (n-1 downto 1);
    signal s1_vec : STD_LOGIC_VECTOR (n-1 downto 1);
    signal s2_vec : STD_LOGIC_VECTOR (n-1 downto 1);
    

begin

    gen_en_vec:
    for i in n-1 downto 1 generate 
        gen_eq:
        equal_n_bit
        Generic Map (n => 5)
        Port Map (
            a => rd,
            b => STD_LOGIC_VECTOR(to_unsigned(i,5)),
            q => en_vec(i)
        );
    end generate;
    
    gen_s1_vec:
    for i in n-1 downto 1 generate 
        gen_eq:
        equal_n_bit
        Generic Map (n => 5)
        Port Map (
            a => r1,
            b => STD_LOGIC_VECTOR(to_unsigned(i,5)),
            q => s1_vec(i)
        );
    end generate;

    gen_s2_vec:
    for i in n-1 downto 1 generate 
        gen_eq:
        equal_n_bit
        Generic Map (n => 5)
        Port Map (
            a => r2,
            b => STD_LOGIC_VECTOR(to_unsigned(i,5)),
            q => s2_vec(i)
        );
    end generate;
    
    gen_en_vec_with_stall:
    for i in 1 to n-1 generate
        en_vec_with_stall(i) <= (NOT stall_pipeline) AND en_vec(i);
    end generate;

    gen_n_bit_regs:
    for i in n-1 downto 1 generate
        gen_reg_n_bit:
        reg_n_bit 
        Generic Map(n=>n)
        Port Map (
            d => d,
            en => en_vec_with_stall(i),
            n_rst => n_rst,
            clk => clk,
            q => q_arr(i)
        );
    end generate;

    --need one more loop to generate outputs
    gen_q_level_1:
    for j in 0 to 31 generate
        q1(j) <= ( s1_vec(1) AND q_arr(1)(j) ) OR ( s1_vec(2) AND q_arr(2)(j) ) OR ( s1_vec(3) AND q_arr(3)(j) ) OR ( s1_vec(4) AND q_arr(4)(j) ) OR ( s1_vec(5) AND q_arr(5)(j) ) OR ( s1_vec(6) AND q_arr(6)(j) ) OR ( s1_vec(7) AND q_arr(7)(j) ) OR ( s1_vec(8) AND q_arr(8)(j) ) OR ( s1_vec(9) AND q_arr(9)(j) ) OR ( s1_vec(10) AND q_arr(10)(j) ) OR ( s1_vec(11) AND q_arr(11)(j) ) OR ( s1_vec(12) AND q_arr(12)(j) ) OR ( s1_vec(13) AND q_arr(13)(j) ) OR ( s1_vec(14) AND q_arr(14)(j) ) OR ( s1_vec(15) AND q_arr(15)(j) ) OR ( s1_vec(16) AND q_arr(16)(j) ) OR ( s1_vec(17) AND q_arr(17)(j) ) OR ( s1_vec(18) AND q_arr(18)(j) ) OR ( s1_vec(19) AND q_arr(19)(j) ) OR ( s1_vec(20) AND q_arr(20)(j) ) OR ( s1_vec(21) AND q_arr(21)(j) ) OR ( s1_vec(22) AND q_arr(22)(j) ) OR ( s1_vec(23) AND q_arr(23)(j) ) OR ( s1_vec(24) AND q_arr(24)(j) ) OR ( s1_vec(25) AND q_arr(25)(j) ) OR ( s1_vec(26) AND q_arr(26)(j) ) OR ( s1_vec(27) AND q_arr(27)(j) ) OR ( s1_vec(28) AND q_arr(28)(j) ) OR ( s1_vec(29) AND q_arr(29)(j) ) OR ( s1_vec(30) AND q_arr(30)(j) ) OR ( s1_vec(31) AND q_arr(31)(j) );
        q2(j) <= ( s2_vec(1) AND q_arr(1)(j) ) OR ( s2_vec(2) AND q_arr(2)(j) ) OR ( s2_vec(3) AND q_arr(3)(j) ) OR ( s2_vec(4) AND q_arr(4)(j) ) OR ( s2_vec(5) AND q_arr(5)(j) ) OR ( s2_vec(6) AND q_arr(6)(j) ) OR ( s2_vec(7) AND q_arr(7)(j) ) OR ( s2_vec(8) AND q_arr(8)(j) ) OR ( s2_vec(9) AND q_arr(9)(j) ) OR ( s2_vec(10) AND q_arr(10)(j) ) OR ( s2_vec(11) AND q_arr(11)(j) ) OR ( s2_vec(12) AND q_arr(12)(j) ) OR ( s2_vec(13) AND q_arr(13)(j) ) OR ( s2_vec(14) AND q_arr(14)(j) ) OR ( s2_vec(15) AND q_arr(15)(j) ) OR ( s2_vec(16) AND q_arr(16)(j) ) OR ( s2_vec(17) AND q_arr(17)(j) ) OR ( s2_vec(18) AND q_arr(18)(j) ) OR ( s2_vec(19) AND q_arr(19)(j) ) OR ( s2_vec(20) AND q_arr(20)(j) ) OR ( s2_vec(21) AND q_arr(21)(j) ) OR ( s2_vec(22) AND q_arr(22)(j) ) OR ( s2_vec(23) AND q_arr(23)(j) ) OR ( s2_vec(24) AND q_arr(24)(j) ) OR ( s2_vec(25) AND q_arr(25)(j) ) OR ( s2_vec(26) AND q_arr(26)(j) ) OR ( s2_vec(27) AND q_arr(27)(j) ) OR ( s2_vec(28) AND q_arr(28)(j) ) OR ( s2_vec(29) AND q_arr(29)(j) ) OR ( s2_vec(30) AND q_arr(30)(j) ) OR ( s2_vec(31) AND q_arr(31)(j) );
    end generate;

end RTL;