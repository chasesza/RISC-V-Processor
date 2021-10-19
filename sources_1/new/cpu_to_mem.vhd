library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_to_mem is
    Generic(n: integer := 32;
            shift_n : integer := 5;
            mem_bits : integer := 15);
    Port ( 
        clk : in STD_LOGIC;
        n_rst : in STD_LOGIC;
        sw : in STD_LOGIC_VECTOR(3 downto 0);
        btn : in STD_LOGIC_VECTOR(3 downto 0);
        led : out STD_LOGIC_VECTOR(3 downto 0)
    );
end cpu_to_mem;

architecture RTL of cpu_to_mem is
   
    component cpu is
        Generic(n: integer := 32;
                shift_n : integer := 5);
        Port ( 
               clk : in STD_LOGIC;
               n_rst : in STD_LOGIC;
               resume : in STD_LOGIC;
               mem_data : in STD_LOGIC_VECTOR (n-1 downto 0);
               inst : in STD_LOGIC_VECTOR (n-1 downto 0);
               pc : out STD_LOGIC_VECTOR (n-1 downto 0);
               d : out STD_LOGIC_VECTOR (n-1 downto 0);
               address : out STD_LOGIC_VECTOR (n-1 downto 0);
               store : out STD_LOGIC;
               load : out STD_LOGIC
            );
    end component;

    --CPU output signals
    signal cpu_pc : STD_LOGIC_VECTOR (n-1 downto 0);
    signal cpu_d : STD_LOGIC_VECTOR (n-1 downto 0);
    signal cpu_address : STD_LOGIC_VECTOR (n-1 downto 0);
    signal cpu_store : STD_LOGIC;
    signal cpu_load : STD_LOGIC;

    component mem_ctl is
        Generic(
            n : integer := 32;
            mem_bits : integer := 15
        );
        Port(
            n_rst : in STD_LOGIC;
            clk : in STD_LOGIC;
            d : in STD_LOGIC_VECTOR(n-1 downto 0);
            ram_data : in STD_LOGIC_VECTOR(n-1 downto 0);
            address : in STD_LOGIC_VECTOR(n-1 downto 0);
            load : in STD_LOGIC;
            store : in STD_LOGIC;
            sw : in STD_LOGIC_VECTOR(3 downto 0);
            btn : in STD_LOGIC_VECTOR(3 downto 0);
            led : out STD_LOGIC_VECTOR(3 downto 0);
            resume: out STD_LOGIC;
            ram_r_addr : out STD_LOGIC_VECTOR(mem_bits-1 downto 0);
            ram_w_addr : out STD_LOGIC_VECTOR(mem_bits-1 downto 0);
            mem_data : out STD_LOGIC_VECTOR(n-1 downto 0);
            en_ram : out STD_LOGIC;
            write_en : out STD_LOGIC
        );
    end component;

    --Mem_ctl output signals
    signal mem_ctl_led : STD_LOGIC_VECTOR(3 downto 0);
    signal mem_ctl_resume: STD_LOGIC;
    signal mem_ctl_ram_r_addr : STD_LOGIC_VECTOR(mem_bits-1 downto 0);
    signal mem_ctl_ram_w_addr : STD_LOGIC_VECTOR(mem_bits-1 downto 0);
    signal mem_ctl_mem_data : STD_LOGIC_VECTOR(n-1 downto 0);
    signal mem_ctl_en_ram : STD_LOGIC;
    signal mem_ctl_write_en : STD_LOGIC;
begin

end RTL;
