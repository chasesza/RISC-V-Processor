library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mem_ctl is
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
        ram_addr : out STD_LOGIC_VECTOR(mem_bits-1 downto 0);
        mem_data : out STD_LOGIC_VECTOR(n-1 downto 0);
        write_data : out STD_LOGIC_VECTOR(n-1 downto 0);
        en_ram : out STD_LOGIC;
        write_en : out STD_LOGIC
    );
end mem_ctl;

architecture RTL of mem_ctl is

    component reg_1_bit is
        Port(
            d : in STD_LOGIC;
            en : in STD_LOGIC;
            clk : in STD_LOGIC;
            n_rst : in STD_LOGIC;
            q : out STD_LOGIC
        );
    end component;

    component reg_n_bit is
        Generic (n : integer := 32);
        Port(
            d : in STD_LOGIC_VECTOR(n-1 downto 0);
            en : in STD_LOGIC;
            clk : in STD_LOGIC;
            n_rst : in STD_LOGIC;
            q : out STD_LOGIC_VECTOR(n-1 downto 0)
        );
    end component;

    component equal_n_bit is
        Generic(n: integer := 5);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               q : out STD_LOGIC);
    end component;

    signal resume_int : STD_LOGIC;
    signal prev_load : STD_LOGIC;
    signal prev_resume : STD_LOGIC;

    signal sel_sw_btn : STD_LOGIC;
    signal sw_btn_out : STD_LOGIC_VECTOR(n-1 downto 0);

    signal led_address : STD_LOGIC;
    signal en_led : STD_LOGIC;

begin

    prev_load_reg: reg_1_bit
    Port Map(
        d => load,
        en => '1',
        clk => clk,
        n_rst => n_rst,
        q => prev_load
    );

    prev_resume_reg: reg_1_bit
    Port Map(
        d => resume_int,
        en => '1',
        clk => clk,
        n_rst => n_rst,
        q => prev_resume
    );

    resume <= resume_int;
    resume_int <= load AND ((prev_load AND (NOT prev_resume)) OR address(mem_bits));
    en_ram <= NOT address(mem_bits);
    write_en <= store AND (NOT address(mem_bits));
    write_data <= d;
    ram_addr <= address(mem_bits-1 downto 0);


    eq_sw_btn: equal_n_bit
        Generic Map(n => 16)
        Port Map(
            a => address(15 downto 0),
            b => "1000000000000001", --32769
            q => sel_sw_btn
        );

    sw_btn_out(7 downto 0) <= sw(3 downto 0) & btn(3 downto 0);
    sw_btn_out(n-1 downto 8) <= "000000000000000000000000";

    eq_le: equal_n_bit
        Generic Map(n => 16)
        Port Map(
            a => address(15 downto 0),
            b => "1100000000000001", --49153
            q => led_address
        );

    en_led <= led_address AND store;

    reg_led: reg_n_bit
        Generic Map(n => 4)
        Port Map(
            d => d(3 downto 0),
            en => en_led,
            clk => clk,
            n_rst => n_rst,
            q => led(3 downto 0)
        );

    gen_mem_data: 
    for i in 0 to n-1 generate
        mem_data(i) <= (ram_data(i) AND (NOT address(mem_bits)) ) OR (sw_btn_out(i) AND sel_sw_btn);
    end generate; 

end RTL;