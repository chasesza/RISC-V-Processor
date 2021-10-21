library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_ctl is
    Generic (n : integer := 32);
    Port ( x_pc : in STD_LOGIC_VECTOR (n-1 downto 0); --pc input x
           y_pc : in STD_LOGIC_VECTOR (n-1 downto 0); --alternate pc input y (default is 4)
           clk : in STD_LOGIC;
           n_rst : in STD_LOGIC;
           stall_pipeline : in STD_LOGIC;
           be : in STD_LOGIC;
           bne : in STD_LOGIC;
           bl : in STD_LOGIC;
           bg : in STD_LOGIC;
           e : in STD_LOGIC;
           g : in STD_LOGIC;
           l : in STD_LOGIC;
           jal_or_jalr : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (n-1 downto 0);
           new_pc : out STD_LOGIC_VECTOR (n-1 downto 0)
        );
end pc_ctl;

architecture RTL of pc_ctl is

    signal alt_y : STD_LOGIC;

    signal update_pc : STD_LOGIC;

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


    signal y_to_adder : STD_LOGIC_VECTOR (n-1 downto 0);

    component adder_n_bit is
        Generic (n: integer := 32);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               sub : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    signal q_adder : STD_LOGIC_VECTOR (n-1 downto 0);
    signal prev_pc : STD_LOGIC_VECTOR (n-1 downto 0);

begin

    alt_y <= (be AND e) OR (bne AND (NOT e)) OR (bg AND g) OR (bl AND l) OR jal_or_jalr;

    gen_y_to_adder_0_1:
    for i in 0 to 1 generate
        y_to_adder(i) <= alt_y AND y_pc(i);
    end generate;

    --y_to_adder(2) <= (alt_y AND y_pc(i)) OR (NOT alt_y);
    y_to_adder(2) <= y_pc(2) OR (NOT alt_y);

    gen_y_to_adder_3_31:
    for i in 3 to n-1 generate
        y_to_adder(i) <= alt_y AND y_pc(i);
    end generate;

    add_sub: adder_n_bit
    Generic map(n=>n)
    Port Map(
        a => x_pc,
        b => y_to_adder,
        sub => '0',
        q => q_adder
    );

    update_pc <= (NOT stall_pipeline) AND n_rst;
    
    gen_new_pc:
    for i in 0 to n-1 generate
        new_pc(i) <= (update_pc AND q_adder(i)) OR (prev_pc(i) AND (NOT update_pc));
    end generate;
    
    q <= prev_pc;
    
    pc_reg: reg_n_bit
    Generic Map (n => n)
    Port Map(
        d => q_adder,
        en => update_pc,
        n_rst => n_rst,
        clk => clk,
        q => prev_pc
    );

end RTL;