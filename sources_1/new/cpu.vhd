library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu is
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
end cpu;

architecture RTL of cpu is

    component decoder is
        Port ( i : in STD_LOGIC_VECTOR (31 downto 0);
               pc : in STD_LOGIC_VECTOR (31 downto 0);
               r1 : in STD_LOGIC_VECTOR (31 downto 0);
               r2 : in STD_LOGIC_VECTOR (31 downto 0);
               a : out STD_LOGIC_VECTOR (31 downto 0);
               b : out STD_LOGIC_VECTOR (31 downto 0);
               x_pc : out STD_LOGIC_VECTOR (31 downto 0); --pc adder input x
               y_pc : out STD_LOGIC_VECTOR (31 downto 0); --alternate pc adder input y (default is 4)
               fadd : out STD_LOGIC;
               sub_bit : out STD_LOGIC;
               fsr : out STD_LOGIC;
               arith_bit : out STD_LOGIC;
               fsl : out STD_LOGIC;
               be : out STD_LOGIC;
               bne : out STD_LOGIC;
               bl : out STD_LOGIC;
               bg : out STD_LOGIC;
               fl : out STD_LOGIC;
               comp_signed: out STD_LOGIC;
               fand : out STD_LOGIC;
               f_or : out STD_LOGIC;
               fxor : out STD_LOGIC;
               rd : out STD_LOGIC_VECTOR(4 downto 0);
               load_dest : out STD_LOGIC_VECTOR(4 downto 0);
               store_inst: out STD_LOGIC;
               load_inst: out STD_LOGIC;
               jal_or_jalr : out STD_LOGIC
               );
    end component;

    signal stall : STD_LOGIC;

    --Decoder output signals
    signal load_inst : STD_LOGIC;
    signal decoder_a : STD_LOGIC_VECTOR (31 downto 0);
    signal decoder_b : STD_LOGIC_VECTOR (31 downto 0);
    signal decoder_x_pc : STD_LOGIC_VECTOR (31 downto 0);
    signal decoder_y_pc : STD_LOGIC_VECTOR (31 downto 0);
    signal decoder_fadd : STD_LOGIC;
    signal decoder_sub_bit : STD_LOGIC;
    signal decoder_fsr : STD_LOGIC;
    signal decoder_arith_bit : STD_LOGIC;
    signal decoder_fsl : STD_LOGIC;
    signal decoder_be : STD_LOGIC;
    signal decoder_bne : STD_LOGIC;
    signal decoder_bl : STD_LOGIC;
    signal decoder_bg : STD_LOGIC;
    signal decoder_fl : STD_LOGIC;
    signal decoder_comp_signed: STD_LOGIC;
    signal decoder_fand : STD_LOGIC;
    signal decoder_f_or : STD_LOGIC;
    signal decoder_fxor : STD_LOGIC;
    signal decoder_rd : STD_LOGIC_VECTOR(4 downto 0);
    signal decoder_load_dest : STD_LOGIC_VECTOR(4 downto 0);
    signal decoder_jal_or_jalr : STD_LOGIC;


    component alu is
        Generic(n: integer := 32;
                shift_n : integer := 5);
        Port ( a : in STD_LOGIC_VECTOR (n-1 downto 0);
               b : in STD_LOGIC_VECTOR (n-1 downto 0);
               fadd : in STD_LOGIC;
               sub_bit : in STD_LOGIC;
               fsr : in STD_LOGIC;
               arith_bit : in STD_LOGIC;
               fsl : in STD_LOGIC;
               fl : in STD_LOGIC;
               comp_signed: in STD_LOGIC;
               fand : in STD_LOGIC;
               f_or : in STD_LOGIC;
               fxor : in STD_LOGIC;
               g : out STD_LOGIC;
               l : out STD_LOGIC;
               e : out STD_LOGIC;
               q : out STD_LOGIC_VECTOR (n-1 downto 0));
    end component;

    --ALU outputs
    signal alu_g : STD_LOGIC;
    signal alu_l : STD_LOGIC;
    signal alu_e : STD_LOGIC;
    signal alu_q : STD_LOGIC_VECTOR (n-1 downto 0);

    component mux_2_1_n_bits_wide is
        Generic (n : integer := 32);
        Port ( a : in STD_LOGIC_VECTOR(n-1 downto 0);
               b : in STD_LOGIC_VECTOR(n-1 downto 0);
               sel : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR(n-1 downto 0));
    end component;

    signal cpu_regs_d : STD_LOGIC_VECTOR(31 downto 0);

    component cpu_regs is
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
    end component;

    --CPU register outputs
    signal cpu_reg_q1 : STD_LOGIC_VECTOR(n-1 downto 0);
    signal cpu_reg_q2 : STD_LOGIC_VECTOR(n-1 downto 0);

    component pc_ctl is
        Generic (n : integer := 32);
        Port (
               x_pc : in STD_LOGIC_VECTOR (n-1 downto 0); --pc adder input x
               y_pc : in STD_LOGIC_VECTOR (n-1 downto 0); --alternate pc adder input y (default is 4)
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
               q : out STD_LOGIC_VECTOR (n-1 downto 0)
            );
    end component;

    signal pc_ctl_q : STD_LOGIC_VECTOR(n-1 downto 0);

begin

    stall <= load_inst AND (NOT resume);
    load <= load_inst;

    pc <= pc_ctl_q;
    d <= cpu_reg_q2;
    address <= alu_q;

    gen_decoder: decoder
        Port Map( 
            i => inst,
            pc => pc_ctl_q,
            r1 => cpu_reg_q1,
            r2 => cpu_reg_q2,
            a => decoder_a,
            b => decoder_b,
            x_pc => decoder_x_pc,
            y_pc => decoder_y_pc,
            fadd => decoder_fadd,
            sub_bit => decoder_sub_bit,
            fsr => decoder_fsr,
            arith_bit => decoder_arith_bit,
            fsl => decoder_fsl,
            be => decoder_be,
            bne => decoder_bne,
            bl => decoder_bl,
            bg => decoder_bg,
            fl => decoder_fl,
            comp_signed => decoder_comp_signed,
            fand => decoder_fand,
            f_or => decoder_f_or,
            fxor => decoder_fxor,
            rd => decoder_rd,
            load_dest => decoder_load_dest,
            store_inst => store,
            load_inst => load_inst,
            jal_or_jalr => decoder_jal_or_jalr
        );

    gen_alu: alu
        Generic Map(n => n, shift_n => shift_n)
        Port Map( 
            a => decoder_a,
            b => decoder_b,
            fadd => decoder_fadd,
            sub_bit => decoder_sub_bit,
            fsr => decoder_fsr,
            arith_bit => decoder_arith_bit,
            fsl => decoder_fsl,
            fl => decoder_fl,
            comp_signed => decoder_comp_signed,
            fand => decoder_fand,
            f_or => decoder_f_or,
            fxor => decoder_fxor,
            g  => alu_g,
            l  => alu_l,
            e  => alu_e,
            q  => alu_q
        );

        gen_cpu_reg_data_mux: mux_2_1_n_bits_wide
            Generic Map(n => n)
            Port ( a => mem_data,
                b => alu_q,
                sel => resume,
                q => cpu_regs_d
            );

        gen_cpu_reg: cpu_regs
            Generic Map (n => n)
            Port Map(
                r1  => inst(19 downto 15),
                r2  => inst(24 downto 20),
                rd  => decoder_rd,
                d  => cpu_regs_d,
                stall_pipeline => stall,
                n_rst => n_rst,
                clk => clk,
                q1 => cpu_reg_q1,
                q2 => cpu_reg_q2
        );

        gen_pc_ctl: pc_ctl
            Generic Map (n => n)
            Port Map ( 
                x_pc => decoder_x_pc,
                y_pc => decoder_y_pc,
                clk => clk,
                n_rst => n_rst,
                stall_pipeline => stall,
                be => decoder_be,
                bne => decoder_bne,
                bl => decoder_bl,
                bg => decoder_bg,
                e => alu_e,
                g => alu_g,
                l => alu_l,
                jal_or_jalr => decoder_jal_or_jalr,
                q => pc_ctl_q
            );

end RTL;
